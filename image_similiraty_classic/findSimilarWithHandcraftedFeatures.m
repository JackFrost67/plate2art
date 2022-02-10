function findSimilarWithHandcraftedFeatures(filename)
    load("searchers/searcher.mat");
    load("matlab1.mat");
    load("imds1.mat");
    %imageDir = "../img/";
    %imds = imageDatastore(imageDir);
    
    %%
    img = imread(filename);
    
    features = featureExtractor(img);
   
    idx = knnsearch(ex_searcher_trained, features, 'K', 3);
    
    %%
    img1 = readimage(imds, idx(1,1));
    img2 = readimage(imds, idx(1,2));
    img3 = readimage(imds, idx(1,3));
    
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

