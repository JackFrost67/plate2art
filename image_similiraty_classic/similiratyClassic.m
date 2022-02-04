function similarPaintings = similiratyClassic(plateImageFile, paintImageDir)
%SIMILIRATYCLASSIC using classic approach retrieve the value of the
%similarity between the image of the plate and the painting
% trying to implement a color based HOG similarity
    %%    
    similarPaintings = [];
    metricValue = [];
    
    plateImageFile = "pizza.jpg";
    paintImageDir = "/home/jackfrost67/Desktop/plate2art/img";
    
    plateImage = rgb2gray(imread(plateImageFile));
    points = detectSURFFeatures(plateImage).selectStrongest(25);
    HOGfeaturesPlate = extractHOGFeatures(plateImage, points);
        
    imagefiles = dir(paintImageDir + "/*.jpg");
    nfiles = length(imagefiles);

    %%
    for i = 1 : nfiles
        strcat(imagefiles(i).folder, "/", imagefiles(i).name)
        paintImage = rgb2gray(imread(strcat(imagefiles(i).folder, "/", imagefiles(i).name)));
        points = detectSURFFeatures(paintImage).selectStrongest(25);
        HOGfeaturesPaint = extractHOGFeatures(paintImage, points);
    end
    
    %%
    metricValue = [metricValue mean(pdist2(HOGfeaturesPlate, HOGfeaturesPaint))];
    value, index = min(metricValue);
    imshow(imread(strcat(imagefiles(index).folder, "/", imagefiles(index).name)))
end

