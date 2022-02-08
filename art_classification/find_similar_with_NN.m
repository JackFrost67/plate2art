function find_similar_with_NN(fn)
    %% load img    
    img = imread(fn);   
    %% load NN, searcher and dataset
    net = load("NASNet_randcrop-8-2.mat");
    net = net.NN;
    
    load("exaustive_searcher_NN.mat", Mdl);
    load('data/dataset.mat', imds);
    %% crop
    inputSize = size(img);
    targetSize = [224 224];
    
    %rect = randomWindow2d(inputSize,targetSize);
    rect = centerCropWindow2d(inputSize,targetSize);
    
    img_crop = imcrop(img,rect);
    %imshow(img_crop)
    
    %% extract features from crop
    features_img = activations(net,img_crop,net.Layers(end-3).Name,'OutputAs','rows');
    
    %% search knn
    
    idx = knnsearch(Mdl,features_img, 'K', 3);

    img1 = readimage(imds,idx(1,1));
    img2 = readimage(imds,idx(1,2));
    img3 = readimage(imds,idx(1,3));
    
    %% save images
    [pathstr,name,~] = fileparts(fn);
    
    filename = convertCharsToStrings(name) + '_sim_nn_1' + '.jpg';
    new_fn = fullfile(pathstr, filename);
    imwrite(img1, new_fn)

    filename = convertCharsToStrings(name) + '_sim_nn_2' + '.jpg';
    new_fn = fullfile(pathstr, filename);
    imwrite(img2, new_fn)

    filename = convertCharsToStrings(name) + '_sim_nn_3' + '.jpg';
    new_fn = fullfile(pathstr, filename);
    imwrite(img3, new_fn)
    
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