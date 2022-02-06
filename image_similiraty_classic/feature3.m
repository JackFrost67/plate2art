function [mean, angularDispersion, meanW, angularDispersionW] = feature3(H, S)
%FEATURE3 circular statistics on Hue
    
    % mean of HUE
    A = sum(cos(H), 'all', 'omitnan');
    B = sum(sin(H), 'all', 'omitnan');
    mean = atan(B ./ A);
    
    % saturation weighted mean of HUE
    As = sum(S .* cos(H), 'all', 'omitnan');
    Bs = sum(S .* sin(H), 'all', 'omitnan');
    meanW = atan(Bs ./ As);
    
    % angular dispersion of HUE 
    n = size(H, 1) + size(H, 2);
    angularDispersion = sqrt((A ^ 2) + (B ^ 2)) / n;
    
    % angular dispersion of HUE 
    angularDispersionW = sqrt((As ^ 2) + (Bs ^ 2)) / n;
end