function [hMean, sMean, lMean] = featureRuleOfThirds(image)
%featureRuleOfThirds Statistics of the inner rectangle formed dividing the
%image in thirds
    windowSize = [(size(image, 1) / 3) (size(image, 2) / 3)];
    window = centerCropWindow2d(size(image), windowSize);
    croppedImage = imgcrop(image, window);
    
    [H, S, L] = rgb2ihsl(croppedImage);
    
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
end