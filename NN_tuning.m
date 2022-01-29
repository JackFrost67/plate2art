% Fine tunning of the NN for art classification

net = alexnet;
analyzeNetwork(net);

%% Get the input size
% efficientnetb0 need image in format 224x224 
sz = net.Layers(1).InputSize;

%% Get the layer for cutting
layersTransfer = net.Layers(1 : end - 3);

% freezing of the weights
% layersTransfer = freezeWeights(layersTransfer);

%% replace layers
numClasses = 127;
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses, 'WeightLearnRateFactor', 20, 'BiasLearnRateFactor', 20)
    softmaxLayer
    classificationLayer];

%% data preparation
imds = imageDatastore('img/');
labels = [];
for ii = 1 : size(imds.Files, 1)
    name = imds.Files{ii, 1};
    [p, n, ex] = fileparts(name);
    class = floor(str2double(n) / 100);
    labels = [labels; class];
end

labels = categorical(labels);
imds = imageDatastore('img/', 'labels', labels);

%% divisione train-test

[imdsTrain, imdsTest] = splitEachLabel(imds, 0.7, 'randomized');

%% data augmentation

pixelRange = [-5 5];
scaleRange = [0.9 1.1];

imageAugmenter = imageDataAugmenter(...
    'RandXReflection', true, ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange, ...
    'RandScale', scaleRange); %<-- todo posso fare robe extra

augImdsTrain = augmentedImageDatastore(sz(1 : 2), imdsTrain, 'DataAugmentation', imageAugmenter);
augImdsTest = augmentedImageDatastore(sz(1 : 2), imdsTest);

%% configurazione fine tuning

options = trainingOptions('sgdm', ...
    'MiniBatchSize', 10, ...
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
acc = numel(find(lab_pred_te == imdsTest.Labels)) / numel(lab_pred_te);