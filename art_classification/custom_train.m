layers = [
    imageInputLayer([227 227 3],"Name","imageinput")
    convolution2dLayer([3 3],32,"Name","conv_1","Padding","same")
    leakyReluLayer(0.01,"Name","leakyrelu_1")
    maxPooling2dLayer([5 5],"Name","maxpool_1","Padding","same","Stride",[3 3])
    convolution2dLayer([3 3],32,"Name","conv_2","Padding","same")
    leakyReluLayer(0.01,"Name","leakyrelu_2")
    maxPooling2dLayer([5 5],"Name","maxpool_2","Padding","same","Stride",[3 3])
    flattenLayer("Name","flatten")
    fullyConnectedLayer(10,"Name","fc_1")
    leakyReluLayer(0.01,"Name","leakyrelu_3")
    fullyConnectedLayer(10,"Name","fc_2")
    leakyReluLayer(0.01,"Name","leakyrelu_4")
    classificationLayer("Name","classoutput")];


sz=[227 227 3];

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
[imdsTest, imdsVal] = splitEachLabel(imdsTest, 0.0001, 'randomized');
%% data augmentation

pixelRange = [-5 5];
scaleRange = [0.9 1.1];

imageAugmenter = imageDataAugmenter(...
    'RandXReflection', true, ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange, ...
    'RandScale',scaleRange);

augImdsTrain = augmentedImageDatastore(sz, imdsTrain, 'DataAugmentation', imageAugmenter);
augImdsVal = augmentedImageDatastore(sz, imdsVal);

%% configurazione fine tuning

options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs', 6, ...
    'InitialLearnRate', 1e-2, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', augImdsVal, ...
    'ValidationFrequency', 3, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%% training
netTransfer = trainNetwork(augImdsTrain, layers, options);

[lab_pred_te, scores] = classify(netTransfer, augImdsTest);
acc = numel(find(lab_pred_te == imdsTest.Labels))/numel(lab_pred_te);