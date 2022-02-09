function [numberOfLabel, imgLabel] = watershedSegmentation(image)

% watershed segmentation
grayImage = rgb2gray(image);
%compute gradient
gmag = imgradient(grayImage);
%morphological operations
se = strel('disk',3);
Ie = imerode(grayImage,se);
Iobr = imreconstruct(Ie,grayImage);

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);

se2 = strel(ones(3,3));
fgm = bwareaopen(imerode(imclose(imregionalmax(Iobrcbr), se2), se2), 3);

%watershed segmentation
bw = imbinarize(Iobrcbr);
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;

gmag2 = imimposemin(gmag, bgm | fgm);
imgLabel = watershed(gmag2);

label = unique(imgLabel);
numberOfLabel = label(end);
end

