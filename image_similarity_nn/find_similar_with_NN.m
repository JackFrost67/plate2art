function find_similar_with_NN(fn)
    %% load img    
    img = imread(fn);   
    %% load NN, searcher and dataset
    net = load('../art_classification/trained_models/NASNet_randcrop.mat');
    net = net.NN;
    
    load("searchers/searcher_randcrop.mat");
    load('../art_classification/data/dataset.mat');
    %% crop
    inputSize = size(img);
    targetSize = [224 224];
    
    %rect = randomWindow2d(inputSize,targetSize);
    rect = centerCropWindow2d(inputSize,targetSize);
    
    img_modified = imcrop(img,rect);

    %img_modified = imresize(img, targetSize);

    %imshow(img_crop)

    
    %% extract features from crop
    features_img = activations(net,img_modified,net.Layers(end-3).Name,'OutputAs','rows');
    
    %% search knn
    
    idx = knnsearch(ex_searcher_trained,features_img, 'K', 3);

    img1 = readimage(imds,idx(1,1));
    img2 = readimage(imds,idx(1,2));
    img3 = readimage(imds,idx(1,3));
    
    %% save images
%     [pathstr,name,~] = fileparts(fn);
%     
%     filename = convertCharsToStrings(name) + '_sim_nn_1' + '.jpg';
%     new_fn = fullfile(pathstr, filename);
%     imwrite(img1, new_fn)
% 
%     filename = convertCharsToStrings(name) + '_sim_nn_2' + '.jpg';
%     new_fn = fullfile(pathstr, filename);
%     imwrite(img2, new_fn)
% 
%     filename = convertCharsToStrings(name) + '_sim_nn_3' + '.jpg';
%     new_fn = fullfile(pathstr, filename);
%     imwrite(img3, new_fn)
    
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