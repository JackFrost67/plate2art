% Fine tunning of the NN for art classification

%choice for the neural network to use for fine tuning
% net = vgg19;
lgraph = layerGraph(resnet50);

%visualize the NN
%analyzeNetwork(net);

%% Get the input size
% efficientnetb0 need image in format 224x224 
% alexnet need image in format 227x227
% sz = net.Layers(1).InputSize;
sz = lgraph.Layers(1).InputSize;

%% Get the layer for cutting
%layersTransfer = net.Layers(1 : end - 3);

% freezing of the weights (uncomment this to freeze the layers weights before cutting, otherwise the full NN will be trained)
%layersTransfer = freezeWeights(layersTransfer);

%% Add layers after cutting for the wanted classification task
numClasses = 27;
% layers = [
%     layersTransfer
%     fullyConnectedLayer(numClasses, 'WeightLearnRateFactor', 20, 'BiasLearnRateFactor', 20)
%     softmaxLayer
%     classificationLayer];

layers = [
    fullyConnectedLayer(numClasses, 'Name', 'fcLayer', 'WeightLearnRateFactor', 20, 'BiasLearnRateFactor', 20)
    softmaxLayer('Name', 'fcLayerSoftmax')
    classificationLayer('Name', 'classificationLayer')];

lgraph = removeLayers(lgraph, 'fc1000_softmax');
lgraph = removeLayers(lgraph, 'ClassificationLayer_fc1000');
lgraph = replaceLayer(lgraph, 'fc1000', layers);
plot(lgraph)

%% Data preparation
imds = imageDatastore('img/');
labels = [];
for ii = 1 : size(imds.Files, 1)
    name = imds.Files{ii, 1};
    [p, n, ex] = fileparts(name);
    class = floor(str2double(split(n, "_")));
    labels = [labels; class(1)];
end

labels = categorical(labels);
imds = imageDatastore('img/', 'labels', labels);

%% train-test split
[imdsTrain, imdsTest] = splitEachLabel(imds, 0.7, 'randomized');

%% data augmentation
pixelRange = [-5 5];
scaleRange = [0.9 1.1];

imageAugmenter = imageDataAugmenter(...
    'RandXReflection', true, ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange, ...
    'RandScale', scaleRange);

augImdsTrain = augmentedImageDatastore(sz(1 : 2), imdsTrain, 'DataAugmentation', imageAugmenter);
augImdsTest = augmentedImageDatastore(sz(1 : 2), imdsTest);

%% fine tuning train config
options = trainingOptions('adam', ...
    'MiniBatchSize', 10, ...
    'MaxEpochs', 6, ...
    'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', augImdsTest, ...
    'ValidationFrequency', 25, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%% training
% netTransfer = trainNetwork(augImdsTrain, layers, options);
netTransfer = trainNetwork(augImdsTrain, lgraph, options);

%% test
[lab_pred_te, scores] = classify(netTransfer, augImdsTest);
acc = numel(find(lab_pred_te == imdsTest.Labels)) / numel(lab_pred_te);
