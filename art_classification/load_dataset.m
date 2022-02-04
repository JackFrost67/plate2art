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

[imdsTrain, imdsVal, imdsTest] = splitEachLabel(imds,0.7,0.1, 'randomized');

%% Data resize and augmentation

sz = [224; 224; 3];

pixelRange = [-5 5];
scaleRange = [0.9 1.1];

imageAugmenter = imageDataAugmenter(...
    'RandXReflection', true, ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange, ...
    'RandScale',scaleRange);

augImdsTrain = augmentedImageDatastore(sz, imdsTrain, 'DataAugmentation', imageAugmenter, 'OutputSizeMode','centercrop');
augImdsVal = augmentedImageDatastore(sz, imdsVal, 'OutputSizeMode','centercrop');
augImdsTest = augmentedImageDatastore(sz, imdsTest, 'OutputSizeMode','centercrop');