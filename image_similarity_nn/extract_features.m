%% load model
net = load("NASNet_centercrop-7-2.mat");
net = net.NN;

%% load imds
sz = [224, 224];
augImdsFull = augmentedImageDatastore(sz, imds, 'ColorPreprocessing','gray2rgb', ...
    'OutputSizeMode','randcrop');
%% extract features
features = activations(net,augImdsFull,net.Layers(end-3).Name,'OutputAs','rows');

%% create model for searching knn
Mdl = ExhaustiveSearcher(features, 'distance', 'cosine');