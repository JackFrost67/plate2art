function find_similar_with_NN(fn)
    %% load img    
    img = imread(fn);   
    %% load NN, searcher and dataset
    net = load('../art_classification/trained_models/NASNet_randcrop.mat');
    net = net.NN;
    
    load("../image_similarity_nn/searchers/searcher_randcrop.mat");
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
    filename = convertCharsToStrings(name) + '_sim_nn' + '.txt';
    new_fn = fullfile(pathstr, filename);
    fid = fopen(new_fn,'wt');
    fprintf(fid, txt);
    fclose(fid);

%     img1 = readimage(imds,idx(1,1));
%     img2 = readimage(imds,idx(1,2));
%     img3 = readimage(imds,idx(1,3));

    %figure(1)
    %imshow(img);
    
    %figure(2)
    %subplot(1,3,1);
    %imshow(img1);
    %subplot(1,3,2);
    %imshow(img2);
    %subplot(1,3,3);
    %imshow(img3);
end