function features = featuresWang(image)
%Computes fuzzy histogram features
features = zeros(29,1);

[rows, cols, ch] = size(image);
totalPixels = rows*cols;

grayimg = double(rgb2gray(image))./255;

labimg = rgb2lab(image);
labimg = reshape(labimg, [rows*cols, ch]);

U = fuzzyClustering(image, 10000);

image = reshape(rgb2lch(image, 'lab'), [rows*cols, ch]);

% Factor 1 (10)
[~, U] = max(U,[],2);
veryDark = (U == 1);
dark = (U == 2);
middle = (U == 3);
light = (U == 4);
veryLight = (U == 5);

warms = (image(:,3) >= 0 & image(:,3) < 140) | ...
        (image(:,3) >= 320 & image(:,3) < 360);
cool = image(:,3) >= 140 & image(:,3) < 320;

features(1) = sum(veryDark & warms);
features(2) = sum(veryDark & cool);
features(3) = sum(dark & warms);
features(4) = sum(dark & cool);
features(5) = sum(middle & warms);
features(6) = sum(middle & cool);
features(7) = sum(light & warms);
features(8) = sum(light & cool);
features(9) = sum(veryLight & warms);
features(10) = sum(veryLight & cool);

% Factor 2 (7)
areaS1 = image(:,2) < (10);
areaS2 = image(:,2) >= (20) & image(:,2) <= (27);
areaS3 = image(:,2) >= (10) & image(:,2) < (27);
areaS4 = image(:,2) >= (27) & image(:,2) < (51);
areaS5 = image(:,2) >= (27) & image(:,2) <= (51);
areaS6 = image(:,2) > (51);

LowS = areaS1 + areaS2 .* (27 - image(:,2)) ./ 17;
MiddleS = areaS3 .* (image(:,2) - 10) ./ 17 + areaS4 .* (51 - image(:,2)) ./ 24;
HighS = areaS5 .* (image(:,2) - 27) ./ 24 + areaS6;

features(11) = sum(warms & HighS);
features(12) = sum(cool & HighS);
features(13) = sum(warms & MiddleS);
features(14) = sum(cool & MiddleS);
features(15) = sum(warms & LowS);
features(16) = sum(cool & LowS);

meanLabImg = mean(labimg(:,2:3), 1);
meanLabImg = repmat(meanLabImg, [rows*cols, 1]);
lab_mean = sum(sum((double(labimg(:,2:3)) - meanLabImg).^2));
features(17) = sqrt(lab_mean / (rows*cols-1));

% Factor 3 (2)
features(18) = var(image(:,3)); % brightness contrast

sf = fspecial('sobel');
gih = double(imfilter(grayimg, sf));
giv = double(imfilter(grayimg, sf'));
edgeimg = sort(reshape(sqrt(giv.^2+gih.^2), [rows*cols 1]), 1, 'descend');
edgeimg = edgeimg(1:ceil(rows*cols*0.005)); % sample only top 0.5%
features(19) = mean(edgeimg); % sharpness

% Noramlize!
features(1:18) = features(1:18) ./ totalPixels;

% Area statistics
features(20) = sum(veryDark) / totalPixels;
features(21) = sum(dark) / totalPixels;
features(22) = sum(middle) / totalPixels;
features(23) = sum(light) / totalPixels;
features(24) = sum(veryLight) / totalPixels;
features(25) = sum(warms) / totalPixels;
features(26) = sum(cool) / totalPixels;
features(27) = sum(HighS) / totalPixels;
features(28) = sum(MiddleS) / totalPixels;
features(29) = sum(LowS) / totalPixels;


end