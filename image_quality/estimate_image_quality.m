function estimate_image_quality(fn)
    % open the sent image
    img = imread(fn);
    
    img_gray = rgb2gray(img);
    brightness = mean(img_gray,'all');

    txt = "";
    % brightness estimation
    if brightness > 200
        txt = txt + "Image brightness: too bright \n";
    elseif brightness < 50
        txt = txt + "Image brightness: too dark \n";
    else
        txt = txt + "Image brightness: ok \n";
    end

    % quality estimation

    piqe_score = piqe(img);

    if piqe_score <= 20
        txt = txt + "Excellent image quality";
    elseif piqe_score <= 35
        txt = txt + "Good image quality";
    elseif piqe_score <= 50
        txt = txt + "Fair image quality";
    elseif piqe_score <= 80
        txt = txt + "Poor image quality";
    elseif piqe_score <= 100
        txt = txt + "Bad image quality";
    else
        txt = txt + "Unexped piqe score";
    end

    [pathstr,name,~] = fileparts(fn);
    disp(name);
    filename = convertCharsToStrings(name) + '_quality' + '.txt';
    disp(txt);
    new_fn = fullfile(pathstr, filename);
    fid = fopen(new_fn,'wt');
    fprintf(fid, txt);
    fclose(fid);

end