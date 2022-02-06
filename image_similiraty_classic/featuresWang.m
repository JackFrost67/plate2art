function U = featuresWang(image,numberRegion)
%FEATURES_WANG
%compute segmentation with kmeans and L means for each segment
features = computeFeaturesRegion(image, numberRegion);

lchImage = rgb2lch(image);
chL = lchImage(:,:,1);

% centroid initialization 
c6 = max(max(chL));
c0 = min(min(chL));

c(1, :) = computeInitialCentroid(c0, c6, 1);
c(2, :) = computeInitialCentroid(c0, c6, 2);
c(3, :) = computeInitialCentroid(c0, c6, 3);
c(4, :) = computeInitialCentroid(c0, c6, 4);
c(5, :) = computeInitialCentroid(c0, c6, 5);

U = zeros(numberRegion, 5);
changed = true;
count = 0;

%compute U and update centroid
while(changed)
    U = zeros(numberRegion, 5);
    c_old = c;
    for i =1: numberRegion
        if features(i,1) <= c(1)
            U(i,1) = 1;
            U(i,2:5) = 0;
        elseif features(i,1) > c(5)
            U(i,5) = 1;
            U(i,1:4) = 0;
        end
        for j = 1:4
            if features(i,1) > c(j) && features(i) <= c(j+1)
                U(i,j) = (c(j+1)-features(i,1)) / (c(j+1)-c(j))  ;
                U(i,j+1) = 1-U(i,j);
            end
        end
    end

    c(1, :) = round(updateCentroid(U, features, 1) *100/100);
    c(2, :) = updateCentroid(U, features, 2);
    c(3, :) = updateCentroid(U, features, 3);  
    c(4, :) = updateCentroid(U, features, 4);
    c(5, :) = updateCentroid(U, features, 5);
    
    c = fix(c*1000)./1000;
    
    if (isequal(c,c_old))
        changed = false;
        
    end
    count = count +1;
end


end



function centroid = computeInitialCentroid(c0, c6, j)
    centroid = c0 + (j*(c0+c6)/6);
end

function centroid = updateCentroid(U, x, j)
    sumU = 0;
    sumUX = 0;
    for i = 1: size(U, 1)
        sumU = sumU + U(i,j);
        sumUX = sumUX  + U(i,j) * x(i,1);
    end
    centroid = sumUX/ sumU;
end

function features = computeFeaturesRegion(image, numberRegion)
    labImage  =rgb2lab(image);
    ab = labImage(:,:,2:3);
    ab = im2single(ab);
    % repeat the clustering 3 times to avoid local minima
    L2 = imsegkmeans(ab,numberRegion,'NumAttempts',3);
    
    lchImage = rgb2lch(image);
    chL = lchImage(:,:,1);
    chC = lchImage(:,:,2);
    features = [];
    
    for i = 1 : 6
        mask = L2 == i;
        features(i, 1) = mean(chL(mask));
        features(i, 2) = mean(chC(mask));
    end
   
    
end