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