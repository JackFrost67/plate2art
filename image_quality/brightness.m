imds = imageDatastore('./img_food', 'IncludeSubfolders',true);
imds = shuffle(imds);

bright = zeros(10000,1);

for i=1:10000
    img_orig = readimage(imds,i);
    img = rgb2gray(img_orig);
    bright(i) = mean(img,'all');
    if bright(i) > 210 || bright(i) < 30
        imshow(img_orig);
        pause(1);
        drawnow;
    end
end

histogram(bright);
