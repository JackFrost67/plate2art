function featureDynamicsVector = featureDynamics(image)
    %FEATUREDYNAMICS Dynamic feature extraction using Hough transform
    %%
    bwImage = im2gray(image);
    bwImage = edge(bwImage);
    
    %% applying Hough transform
    [SHT, theta, rho] = hough(bwImage);
    
    %% searching for Hough peaks
    houghPeaks = houghpeaks(SHT, 25, 'threshold', ceil(0.3 * max(SHT(:))));
    
    %% finding the hough line
    houghLines = houghlines(bwImage, theta, rho, houghPeaks);
    
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
    
    %% statistics about static lines
    len = [];
    staticTheta = [];
    for i = 1 : length(staticLines)
        len_ = norm(staticLines(i).point1 - staticLines(i).point2);
        len = [len len_];
        staticTheta = [staticTheta staticLines(i).theta];
    end
    
    if ~isempty(len)
        slopeStaticLines = sum((len ./ sum(len)) .* staticTheta);
        meanLenStaticLines = mean(len);
    else 
        slopeStaticLines = 0;
        meanLenStaticLines = 0;
    end
    
    %% statistics about dynamics lines
    len = [];
    dynamicTheta = [];
    for i = 1 : length(dynamicLines)
        len_ = norm(dynamicLines(i).point1 - dynamicLines(i).point2);
        len = [len len_];
        dynamicTheta = [dynamicTheta dynamicLines(i).theta];
    end
    
    if ~isempty(len)
        slopeDynamicLines = sum((len ./ sum(len)) .* dynamicTheta);
        meanLendynamicLines = mean(len);
    else 
        slopeDynamicLines = 0;
        meanLendynamicLines = 0;
    end
    
    featureDynamicsVector = [slopeStaticLines slopeDynamicLines ...
                            meanLenStaticLines meanLendynamicLines];
end

