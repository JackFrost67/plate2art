function find_similar_with_classic(fn) 
    %% load searcher and dataset    
    load("../image_similarity_classic/searchers/ex_searcher_trained_classic.mat");
    load('../art_classification/data/dataset.mat');
    addpath("../handcrafted_features_extractor/utils/");
    
    %%
    img = imread(fn);
    features = extract_features_classic(img);
    idx = knnsearch(ex_searcher_trained_classic, features, 'K', 3);
    
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

    %%
    %% save images
    [pathstr,name,~] = fileparts(fn);
 
     filename = convertCharsToStrings(name) + '_sim_classic_1' + '.jpg';
     new_fn = fullfile(pathstr, filename);
     imwrite(img1, new_fn)
    
     filename = convertCharsToStrings(name) + '_sim_classic_2' + '.jpg';
     new_fn = fullfile(pathstr, filename);
     imwrite(img2, new_fn)
    
     filename = convertCharsToStrings(name) + '_sim_classic_3' + '.jpg';
     new_fn = fullfile(pathstr, filename);
     imwrite(img3, new_fn)
end

