%% load data
load('../art_classification/data/dataset.mat')

%% Extract feature for the paintings dataset
addpath("../handcrafted_features_extractor");
addpath("../handcrafted_features_extractor/utils/");

nfiles = size(imds.Files, 1);
featuresVector = zeros(nfiles, 92, 'double');

delete(gcp('nocreate'));
p = parpool();
tic
parfor i = 1 : nfiles 
    %fprintf("img: %d\n", i);
    name = imds.Files{i, 1};
    image = imread(name);
    % extract features
    featuresVector(i, :) = extract_features_classic(image);
end
toc
%% create model for searching knn
ex_searcher_trained_classic = ExhaustiveSearcher(featuresVector, 'distance', 'cosine');
save('ex_searcher_trained_classic.mat', 'ex_searcher_trained_classic');
