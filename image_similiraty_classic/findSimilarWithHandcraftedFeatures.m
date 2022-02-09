function findSimilarWithHandcraftedFeatures(filename)
    addpath("handcrafted_features_extractor");
    
    imageDir = "../img/";
    imds = imageDatastore(imageDir);
    
    image = imread(filename);
    
    features = extractFeatures(image);
   
    idx = knnsearch(ex_searcher_trained, features, 'K', 3);
    
    img1 = readimage(imds,idx(1,1));
    img2 = readimage(imds,idx(1,2));
    img3 = readimage(imds,idx(1,3));
    
    figure(1)
    imshow(img);
    
    figure(2)
    subplot(1,3,1);
    imshow(img1);
    subplot(1,3,2);
    imshow(img2);
    subplot(1,3,3);
    imshow(img3);
end

