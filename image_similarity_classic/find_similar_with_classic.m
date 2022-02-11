function find_similar_with_classic(fn) 
    %% load searcher and dataset    
    load("../image_similarity_classic/ex_searcher_trained_classic.mat");
    load('../art_classification/data/dataset.mat');
    addpath("../handcrafted_features_extractor/");
    addpath("../handcrafted_features_extractor/utils/");
    
    %%
    img = imread(fn);
    features = extract_features_classic(img);
    idx = knnsearch(ex_searcher_trained_classic, features, 'K', 3);
    
    name1 = imds.Files{idx(1,1), 1};
    name2 = imds.Files{idx(1,2), 1};
    name3 = imds.Files{idx(1,3), 1};
    
    txt = "";
    txt = txt + name1 + "\n";
    txt = txt + name2 + "\n";
    txt = txt + name3 + "\n";
    
    %% save images
    [pathstr,name,~] = fileparts(fn);
    %disp(name);
    filename = convertCharsToStrings(name) + '_sim_classic' + '.txt';
    new_fn = fullfile(pathstr, filename);
    fid = fopen(new_fn,'wt');
    fprintf(fid, txt);
    fclose(fid);
    disp(filename)
    %%
%     img1 = readimage(imds, idx(1,1));
%     img2 = readimage(imds, idx(1,2));
%     img3 = readimage(imds, idx(1,3));
%     
%     figure(1)
%     imshow(img);
%     
%     figure(2)
%     subplot(1,3,1);
%     imshow(img1);
%     subplot(1,3,2);
%     imshow(img2);
%     subplot(1,3,3);
%     imshow(img3);
end

