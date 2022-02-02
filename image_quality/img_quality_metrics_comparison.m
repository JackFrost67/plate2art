imds = imageDatastore('./img_food', 'IncludeSubfolders',true);

index = randi([1 length(imds.Files)]);
img = readimage(imds,index);

%model_niqe = load("model_niqe.mat");

orig_metrics = zeros(1,3);
blurred_metrics = zeros(1,3);
noise_metrics = zeros(1,3);

orig_metrics(1,1) = niqe(img);
orig_metrics(1,2) = niqe(img, model_niqe);
orig_metrics(1,3) = piqe(img);

bar([orig_metrics; blurred_metrics; noise_metrics]);