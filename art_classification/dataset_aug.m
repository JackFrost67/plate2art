load('data/dataset.mat')

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