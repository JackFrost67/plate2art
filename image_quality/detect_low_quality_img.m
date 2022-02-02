img = imread('seppia.png');
img_gray = rgb2gray(img);

%% detect if image is blurry
blur_metric = blurMetric(im2double(img_gray));