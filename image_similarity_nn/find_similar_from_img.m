%% load img
img = imread('../img_food_google/spaghetti_seppia.png');

%% crop
inputSize = size(img);
targetSize = [224 224];

%rect = randomWindow2d(inputSize,targetSize);
rect = centerCropWindow2d(inputSize,targetSize);

img_crop = imcrop(img,rect);
imshow(img_crop)

%% extract features from crop
tic
features_img = activations(net,img_crop,net.Layers(end-3).Name,'OutputAs','rows');
toc

%% search knn
tic
idx = knnsearch(Mdl,features_img, 'K', 3);
toc

img1 = readimage(imds,idx(1,1));
img2 = readimage(imds,idx(1,2));
img3 = readimage(imds,idx(1,3));

subplot(1,4,1);
imshow(img);
subplot(1,4,2);
imshow(img1);
subplot(1,4,3);
imshow(img2);
subplot(1,4,4);
imshow(img3);