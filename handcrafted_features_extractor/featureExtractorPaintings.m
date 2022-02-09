%% Extract feature for the paintings dataset
paintImageDir = "../img/";
imds = imageDatastore(paintImageDir);

nfiles = size(imds.Files, 1);

featuresVector = [];
%%
for i = 1 : nfiles
    tic
    i
    name = imds.Files{i, 1};
    image = imread(name);
    
    %% extract features
    featuresVector = [featuresVector;
                      featureExtractor(image)];
    toc
end

save('HandCraftedFeaturesPaintings.mat', 'featuresVector');