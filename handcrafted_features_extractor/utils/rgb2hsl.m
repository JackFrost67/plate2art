function [H, S, L] = rgb2hsl(rgb)
%RGB2IHSL Summary of this function goes here
%   Detailed explanation goes here    
    R = double(rgb(:, :, 1));
    G = double(rgb(:, :, 2));
    B = double(rgb(:, :, 3));

    L = uint8(0.2126 .* R + 0.7152 .* G + 0.0722 .* B);

    maxMatrix = max(max(R, G), B);
    minMatrix = min(min(R, G), B);
    S = uint8(maxMatrix - minMatrix);
    
    theta = deg2rad((R - (0.5 .* G) - (0.5 .* B)) ./ sqrt((R .^ 2) + (G .^ 2) + (B .^ 2) - (R .* G) - (R .* B) - (B .* G)));
    H_ = uint8(rad2deg(acos(theta)));

    if B > G
        H = (360 - H_);
    else
        H = H_;
    end
end

