function [sMean, lMean] = featureSaturationBrightness(s, l)
%FEATURE1 mean of saturation and brightness
    sMean = mean2(s);
    lMean = mean2(l);
end
