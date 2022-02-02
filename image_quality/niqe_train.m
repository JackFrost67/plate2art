imds = imageDatastore('./img_food', 'IncludeSubfolders',true);

nFiles = length(imds.Files);
RandIndices = randperm(nFiles);
nFilesToTake = 200;
indices = RandIndices(1:nFilesToTake);
subimds = subset(imds,indices); 

model_niqe = fitniqe(subimds);
