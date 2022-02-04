imds = imageDatastore('../img_food', 'IncludeSubfolders',true);
imds = shuffle(imds);

bright = zeros(10000,1);

for i=1:10000
    img_orig = readimage(imds,i);
    img = rgb2gray(img_orig);
    bright(i) = mean(img,'all');

    disp(bright(i))

    if bright(i) > 200
         imshow(img_orig);
         pause(1);
         drawnow;
    end
   
    if bright(i) < 50
         imshow(img_orig);
         pause(1);
         drawnow;
    end   
end

histogram(bright);
ylabel('Count')
title('Histogram of luminance')
xlabel('Luminance')
