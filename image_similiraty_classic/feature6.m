function contranstFeatureVector = feature6(image)
    %FEATURE6 Itten color contrast theory
    
    %% Finding regions with k-means (k = 10)
    hMean_ = [];
    sMean_ = [];
    lMean_ = [];
    
    [H_, S_, L_] = rgb2ihsl(image);
    numberOfK = 10;
    mask = imsegkmeans(image, numberOfK);
    
    %% mean of Hue, Saturation, Brightness of each region
    ittenHue = [0, 20, 32, 46, 56, 79, 158, 192, 208, 233, 278, 322];
    contrastOfBrightness = 0;
    contrastOfSaturation = 0;
    for i = 1 : numberOfK
        h_ = H_ .* uint8(mask == i);
        s_ = S_ .* uint8(mask == i);
        l_ = L_ .* uint8(mask == i);
               
        hMean_ = [hMean_, meanHue(h_(h_ > 0))];
        sMean_ = [sMean_, mean2(s_(s_ > 0))];
        lMean_ = [lMean_, mean2(l_(l_ > 0))];    
        
        contrastOfBrightness = contrastOfBrightness + ((1 / nnz(l_)) * std2(l_(l_ > 0)));
        contrastOfSaturation = contrastOfSaturation + ((1 / nnz(s_)) * std2(s_(s_ > 0)));
    end
    
    %% Mapping Hue mean of each region to Itten hues    
    for i = 1 : numberOfK
        hMean2hItten_ = ittenHue(ittenHue <= hMean_(i));
        hMean_(i) = hMean2hItten_(end);      
    end
    
    diff = abs(hMean_ - hMean_');
    diff360 = 360 - abs(hMean_ - hMean_');
    d = min(diff, diff360);
    
    contrastComplement = max(d(d <= 180));
    hueCount = length(unique(hMean_));
    contranstFeatureVector = [contrastOfBrightness, contrastOfSaturation, contrastComplement, hueCount];
end

function mean = meanHue(H)
    H = deg2rad(double(H));
    
    % mean of HUE
    A = sum(cos(H), 'all', 'omitnan');
    B = sum(sin(H), 'all', 'omitnan');
    mean_ = rad2deg(atan(B ./ A));
    
    if(mean_ >= 0)
        mean = mean_;
    else
        mean = 360 - mean_;
    end
end

