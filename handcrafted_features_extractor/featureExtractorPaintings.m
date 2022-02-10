%% Extract feature for the paintings dataset
delete(gcp('nocreate'));
p = parpool();
addpath("utils");
paintImageDir = "../img/";
imds = imageDatastore(paintImageDir);

nfiles = size(imds.Files, 1);

featuresVector = zeros(nfiles, 92, 'double');
%%
parfor i = 1 : nfiles 
    fprintf("img: %d\n", i);
    name = imds.Files{i, 1};
    image = imread(name);
    
    % extract features
    featuresVector(i, :) = featureExtractor(image);
end

%%
save('HandCraftedFeaturesPaintings1.mat', 'featuresVector');