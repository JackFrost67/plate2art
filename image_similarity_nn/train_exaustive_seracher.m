%% load model and data
net = load("../art_classification/trained_models/NASNet_randcrop.mat");
net = net.NN;

load('../art_classification/data/dataset.mat')
%% load imds
sz = [224, 224];
augImdsFull = augmentedImageDatastore(sz, imds, 'ColorPreprocessing','gray2rgb', ...
    'OutputSizeMode','randcrop');
%% extract features
tic
features = activations(net,augImdsFull,net.Layers(end-3).Name,'OutputAs','rows');
toc
%% create model for searching knn
ex_searcher_trained = ExhaustiveSearcher(features, 'distance', 'cosine');