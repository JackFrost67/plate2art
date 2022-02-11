function contranstFeatureVector = featureItten(image)
    %FEATURE6 Itten color contrast theory
    %resize the image for computional efficency reason
    [rows, cols, ~]=size(image);
    maxRowCol = max(rows, cols);
    image = imresize(image, 1/ceil(maxRowCol/500));
    
    [H, S, L] = rgb2hsl(image);
    
    %% Finding regions with watershedSegmentation
    hMean_ = [];
    sMean_ = [];
    lMean_ = [];
    
    [numberOfK, mask] = watershedSegmentation(image);
    
    %% mean of Hue, Saturation, Brightness of each region
    ittenHue = [0 20 32 46 56 79 158 192 208 233 278 322];
    contrastOfBrightness = 0;
    contrastOfSaturation = 0;
    for i = 1 : numberOfK
        h_ = H .* uint8(mask == i);
        s_ = S .* uint8(mask == i);
        l_ = L .* uint8(mask == i);
               
        hMean_ = [hMean_, meanHue(h_(h_ > 0))];
        sMean_ = [sMean_, mean2(s_(s_ > 0))];
        lMean_ = [lMean_, mean2(l_(l_ > 0))];    
        
        if nnz(l_)
            contrastOfBrightness = contrastOfBrightness + ((1 / nnz(l_)) * std2(l_(l_ > 0)));
        end
        
        if nnz(s_)
            contrastOfSaturation = contrastOfSaturation + ((1 / nnz(s_)) * std2(s_(s_ > 0)));
        end
    end
    
    %% Mapping Hue mean of each region to Itten hues    
    for i = 1 : numberOfK
        hMean2hItten_ = ittenHue(ittenHue <= hMean_(i));
        hMean_(i) = hMean2hItten_(end);      
    end
    
    diff = abs(hMean_ - hMean_');
    diff360 = 360 - abs(hMean_ - hMean_');
    d = min(diff, diff360);
    
    contrastComplement = max(d(d >= 154 & d <= 200));
    if(isempty(contrastComplement))
        contrastComplement = 0;
    end
   
    hueCount = length(unique(hMean_));
    contranstFeatureVector = [contrastOfBrightness, contrastOfSaturation, contrastComplement, hueCount];
end

function mean = meanHue(H)
    H = deg2rad(double(H));
    
    % mean of HUE
    A = sum(cos(H), 'all', 'omitnan');
    B = sum(sin(H), 'all', 'omitnan');
    mean_ = rad2deg(atan(B ./ A));
    
    if (isnan(mean_))
        mean_ = 0;
    else
        if(mean_ >= 0)
            mean = mean_;
        else
            mean = 360 + mean_;
        end
    end
end

