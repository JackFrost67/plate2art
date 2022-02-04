function [H, S, Y] = rgb2ihsl(rgb)
%RGB2IHSL Summary of this function goes here
%   Detailed explanation goes here
    R = im2double(rgb(:, :, 1));
    G = im2double(rgb(:, :, 2));
    B = im2double(rgb(:, :, 3));

    Y = 0.2126 * R + 0.7152 * G + 0.0722 * B;

    maxMatrix = max(max(R, G), B);
    minMatrix = min(min(R, G), B);
    S = maxMatrix - minMatrix;
    
    theta = deg2rad((R - (0.5 .* G) - (0.5 .* B)) ./ sqrt((R .^ 2) + (G .^ 2) + (B .^ 2) - (R .* G) - (R .* B) - (B .* G)));
    H_ = acos(theta);

    if B > G
        H = (2 * pi - H_);
    else
        H = H_;
    end
end

