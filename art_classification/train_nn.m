%% Train a nn exported from deepNetworkDesinger

%% load dataset and augment
dataset_aug;

%% load base model
load("data/NASNetMobile_base_to_train.mat");

%% set options for training
options = trainingOptions('sgdm', ...
    'MiniBatchSize',32, ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 1e-3, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', augImdsVal, ...
    'ValidationFrequency', 25, ...
    'Verbose', false, ...
    'Plots', 'training-progress', ...
    'OutputNetwork','best-validation-loss');

%% train NN
NN = trainNetwork(augImdsTrain, lgraph_1, options);