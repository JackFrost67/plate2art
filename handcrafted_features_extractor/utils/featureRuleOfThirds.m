function [hMean, sMean, lMean] = featureRuleOfThirds(image)
%featureRuleOfThirds Statistics of the inner rectangle formed dividing the
%image in thirds
    windowSize = [ceil(size(image, 1) / 3) ceil(size(image, 2) / 3)];
    window = centerCropWindow2d(size(image), windowSize);
    croppedImage = imcrop(image, window);
    
    [H, S, L] = rgb2hsl(croppedImage);
    
    hMean = meanHue(H);
    sMean = mean2(S);
    lMean = mean2(L);
end

function mean = meanHue(H)
    H = deg2rad(double(H));
    
    % mean of HUE
    A = sum(cos(H), 'all', 'omitnan');
    B = sum(sin(H), 'all', 'omitnan');
       
    mean = rad2deg(atan(B ./ A));
    
    if (isnan(mean))
      mean = 0;
    end
end