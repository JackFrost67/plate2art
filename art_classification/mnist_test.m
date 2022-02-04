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


labelCount = countEachLabel(imds);

sz = [300 300 3];
numTrainFiles = 300;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

numValFiles = 50;
[imdsValidation, imdsTest] = splitEachLabel(imdsValidation, numValFiles, 'randomized');
%% data augmentation

pixelRange = [-1 1];
scaleRange = [0.9 1.1];

imageAugmenter = imageDataAugmenter( ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange);

augImdsTrain = augmentedImageDatastore(sz, imdsTrain, 'DataAugmentation', imageAugmenter);
augImdsVal = augmentedImageDatastore(sz, imdsValidation);

%% cose
layers = [
    imageInputLayer(sz)
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(27)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augImdsVal, ...
    'ValidationFrequency',30, ...
    'Verbose',true, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(augImdsTrain,layers,options);
