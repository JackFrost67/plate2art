%% import alexnet con pesi trainati su imagenet 
net = alexnet;
analyzeNetwork(net);

sz=net.Layers(1).InputSize;

%%
layersTransfer = net.Layers(1:end-3);

%---> congelare pesi
layersTransfer = freezeWeights(layersTransfer); %<-- decidere se farlo o no

%% replace layers
numClasses = 27;

layers = [
    layersTransfer
    fullyConnectedLayer(numClasses, 'WeightLearnRateFactor',20, ...
    'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

%% Data preparation
imds = imageDatastore('../img/');
labels = [];
for ii = 1 : size(imds.Files, 1)
    name = imds.Files{ii, 1};
    [p, n, ex] = fileparts(name);
    class = floor(str2double(split(n, "_")));
    labels = [labels; class(1)];
end

labels = categorical(labels);
imds = imageDatastore('../img/', 'labels', labels);

%% divisione train-test

[imdsTrain, imdsTest] = splitEachLabel(imds, 0.05, 'randomized');

%% data augmentation

pixelRange = [-5 5];
scaleRange = [0.9 1.1];

imageAugmenter = imageDataAugmenter(...
    'RandXReflection', true, ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange, ...
    'RandScale',scaleRange);

augImdsTrain = augmentedImageDatastore(sz, imdsTrain, 'DataAugmentation', imageAugmenter);
augImdsTest = augmentedImageDatastore(sz, imdsTest);

%% configurazione fine tuning

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs', 6, ...
    'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', augImdsTest, ...
    'ValidationFrequency', 3, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%% training
netTransfer = trainNetwork(augImdsTrain, layers, options);

[lab_pred_te, scores] = classify(netTransfer, augImdsTest);
acc = numel(find(lab_pred_te == imdsTest.Labels))/numel(lab_pred_te);