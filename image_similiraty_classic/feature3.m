function [mean, angularDispersion, meanW, angularDispersionW] = feature3(H, S)
%FEATURE3 circular statistics on Hue
    H = deg2rad(double(H));
    S = double(S);
    
    %% mean of HUE
    A = sum(cos(H), 'all', 'omitnan');
    B = sum(sin(H), 'all', 'omitnan');
    mean = rad2deg(atan(B ./ A));
    
    %% saturation weighted mean of HUE
    As = sum(S .* cos(H), 'all', 'omitnan');
    Bs = sum(S .* sin(H), 'all', 'omitnan');
    meanW = rad2deg(atan(Bs ./ As));
    
    %% angular dispersion of HUE 
    n = size(H, 1) * size(H, 2);
    angularDispersion = rad2deg(sqrt((A ^ 2) + (B ^ 2)) / n);
    
    %% angular dispersion of HUE 
    angularDispersionW = rad2deg(sqrt((As ^ 2) + (Bs ^ 2)) / n);
end