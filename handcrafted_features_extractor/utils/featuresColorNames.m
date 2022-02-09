function amountOfColors = featuresColorNames(image)
% load the word to color names matrix. The words are a 32x32x32 grid on the sRGB space. 
load('w2c.mat');

%resize the image for computional efficency reason
[rows, cols, ~]=size(image);
maxRowCol = max(rows, cols);
image = imresize(image, 1/ceil(maxRowCol/500));

%compute total pixels
[rows, cols, ~]=size(image);
totalPixels = rows * cols;

% first example
im = double(image);       % load test image
colorImage = uint8(im2c(im,w2c,-1));

% order of color names: black ,   blue   , brown       , grey       , green   , orange   , pink     , purple  , red     , white    , yellow
% color_values = {[0 0 0] , [0 0 1] , [.5 .4 .25] , [.5 .5 .5] , [0 1 0] , [1 .8 0] , [1 .5 1] , [1 0 1] , [1 0 0] , [1 1 1 ] , [ 1 1 0 ] };

amountOfColors = [];
blackPixels = colorImage(:,:,1) == 0 & colorImage(:,:,2) == 0 & colorImage(:,:,3) == 0;
amountOfColors(1) = sum(sum(blackPixels))/totalPixels;

bluePixels = colorImage(:,:,1) == 0 & colorImage(:,:,2) == 0 & colorImage(:,:,3) == 255;
amountOfColors(2) = sum(sum(bluePixels))/totalPixels;

brownPixels = colorImage(:,:,1) == 128 & colorImage(:,:,2) == 102 & colorImage(:,:,3) == 64;
amountOfColors(3) = sum(sum(brownPixels))/totalPixels;

greyPixels = colorImage(:,:,1) == 128 & colorImage(:,:,2) == 128 & colorImage(:,:,3) == 128;
amountOfColors(4) = sum(sum(greyPixels))/totalPixels;

greenPixels = colorImage(:,:,1) == 0 & colorImage(:,:,2) == 255 & colorImage(:,:,3) == 0;
amountOfColors(5) = sum(sum(greenPixels))/totalPixels;

orangePixels = colorImage(:,:,1) == 255 & colorImage(:,:,2) == 204 & colorImage(:,:,3) == 0;
amountOfColors(6) = sum(sum(orangePixels))/totalPixels;

pinkPixels = colorImage(:,:,1) == 255 & colorImage(:,:,2) == 128 & colorImage(:,:,3) == 255;
amountOfColors(7) = sum(sum(pinkPixels))/totalPixels;

purplePixels = colorImage(:,:,1) == 255 & colorImage(:,:,2) == 0 & colorImage(:,:,3) == 255;
amountOfColors(8) = sum(sum(purplePixels))/totalPixels;

redPixels = colorImage(:,:,1) == 255 & colorImage(:,:,2) == 0 & colorImage(:,:,3) == 0;
amountOfColors(9) = sum(sum(redPixels))/totalPixels;

whitePixels = colorImage(:,:,1) == 255 & colorImage(:,:,2) == 255 & colorImage(:,:,3) == 255;
amountOfColors(10) = sum(sum(whitePixels))/totalPixels;

yellowPixels = colorImage(:,:,1) == 255 & colorImage(:,:,2) == 255 & colorImage(:,:,3) == 0;
amountOfColors(11) = sum(sum(yellowPixels))/totalPixels;

end

