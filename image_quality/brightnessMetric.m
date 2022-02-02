function brightness = brightnessMetric(original)
    img_lab = rgb2lab(original);
    L=img_lab(:,:,3);
    L = L/max(L);
    brightness = mean(L,'all');
end