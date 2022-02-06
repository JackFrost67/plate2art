%% Data import
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

%% Data split

[imdsTrain, imdsTest] = splitEachLabel(imds,0.7, 'randomized');
[imdsVal, imdsTest] = splitEachLabel(imdsTest,0.5, 'randomized');
%% Data resize and augmentation

sz = [224, 224];

pixelRange = [-5 5];
scaleRange = [0.9 1.1];

imageAugmenter = imageDataAugmenter(...
    'RandXReflection', true, ...
    'RandXTranslation', pixelRange, ...
    'RandYTranslation', pixelRange, ...
    'RandScale',scaleRange);

augImdsTrain = augmentedImageDatastore(sz, imdsTrain, 'DataAugmentation', imageAugmenter, ...
    'ColorPreprocessing','gray2rgb', 'OutputSizeMode','centercrop');
augImdsTest = augmentedImageDatastore(sz, imdsTest, 'ColorPreprocessing','gray2rgb', ...
    'OutputSizeMode','centercrop');
augImdsVal = augmentedImageDatastore(sz, imdsVal, 'ColorPreprocessing','gray2rgb', ...
    'OutputSizeMode','centercrop');
