function featureDynamicsVector = featureDynamics(image)
    %FEATUREDYNAMICS Dynamic feature extraction using Hough transform
    %%
    bwImage = im2gray(image);
    bwImage = edge(bwImage);
    
    %% applying Hough transform
    [SHT, theta, rho] = hough(bwImage);
    
    %% searching for Hough peaks
    houghPeaks = houghpeaks(SHT, 25,'threshold',ceil(0.3 * max(SHT(:))));
    
    %% finding the hough line
    houghLines = houghlines(bwImage, theta ,rho, houghPeaks);
    
    %% classification for each line
    staticLines = [];
    dynamicLines = [];
    for i = 1 : length(houghLines)
        if houghLines(i).theta > -15 && houghLines(i).theta < 15 || houghLines(i).theta > 75 && houghLines(i).theta < 105
            staticLines = [staticLines houghLines(i)];
        else
            dynamicLines = [dynamicLines houghLines(i)];
        end
    end
    
    %%
    len = [];
    staticTheta = [];
    for i = 1 : length(staticLines)
        len_ = norm(staticLines(i).point1 - staticLines(i).point2);
        len = [len len_];
        staticTheta = [staticTheta staticLines(i).theta];
    end
    slopeStaticLines = sum((1 ./ len) .* staticTheta);
    meanLenStaticLines = mean(len);
    
    %%
    len = [];
    dynamicTheta = [];
    for i = 1 : length(dynamicLines)
        len_ = norm(dynamicLines(i).point1 - dynamicLines(i).point2);
        len = [len len_];
        dynamicTheta = [dynamicTheta staticLines(i).theta];
    end
    slopeDynamicLines = sum((1 ./ len) .* dynamicTheta);
    meanLendynamicLines = mean(len);
    
    featureDynamicsVector = [slopeStaticLines slopeDynamicLines meanLenStaticLines meanLendynamicLines];
end

