function EMD = feature4(rgbImage)
    %%
    [rows, cols] = size(rgbImage, 1, 2);
    rgbHist = zeros(4, 3);
    
    % get the number of pixels in the image
    numOfPixels = rows * cols;
    
    % hist with frequency for each bin of 1/64
    rgbHistTemplate = ones(4, 3) * ceil(numOfPixels / 64);
    
    
    for col = 1 : cols
      for row = 1 : rows
        % Get the RGB values of the image.
        R = double(rgbImage(row, col, 1));
        G = double(rgbImage(row, col, 2));
        B = double(rgbImage(row, col, 3));
        
        % Find out which of the 64 blocks they belong to.
        % Block numbers range from 1 to 4.
        if R > 0
            rBlock = ceil(R / 64); 
        else
            rBlock = 1;
        end
        
        if G > 0
            gBlock = ceil(G / 64); 
        else
            gBlock = 1; 
        end
        
        if B > 0 
            bBlock = ceil(B / 64); 
        else
            bBlock = 1; 
        end
        
        % Increment the histogram.
        rgbHist(rBlock, 1) = rgbHist(rBlock, 1) + 1;
        rgbHist(rBlock, 2) = rgbHist(gBlock, 2) + 1;
        rgbHist(rBlock, 3) = rgbHist(bBlock, 3) + 1;
      end
    end
    
    normalizedRgbHist = rgbHist / max(rgbHist, [], 'all');
    normalizedRgbHistTemplate = rgbHistTemplate / max(rgbHistTemplate, [], 'all');
    
    EMD1 = pdist2(normalizedRgbHist(:, 1)', normalizedRgbHistTemplate(:, 1)', 'emd');
    EMD2 = pdist2(normalizedRgbHist(:, 2)', normalizedRgbHistTemplate(:, 2)', 'emd');
    EMD3 = pdist2(normalizedRgbHist(:, 3)', normalizedRgbHistTemplate(:, 3)', 'emd');
    EMD = (EMD1 + EMD2 + EMD3) / 3;
end