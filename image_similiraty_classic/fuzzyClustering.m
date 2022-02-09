function U = fuzzyClustering(image, maxIter)
%fuzzyClustering
%compute the fuzzy clustering

image = imgaussfilt(image, 1.5);
x = rgb2lch(image, 'lab');
x = x(:,:,1);

[rows, cols] = size(x);
x = reshape(x, [rows*cols, 1]);

nRegion = length(x);

% centroid initialization 
c0 = min(x);

c = zeros(6,1);
c(6) = max(x);
for j = 1 : 5
    c(j) = c0 + j * (c(6) + c0) / 6;
end


U = zeros(nRegion, 5);
iter = 0;
%set tollerance
tol = 1e-5;
relerr = inf;
%compute U and update centroid
while(relerr >= tol && iter < maxIter)
    U = zeros(nRegion, 5);
    cOld = c;
    for i =1: nRegion
        if x(i,1) <= c(1)
            U(i,1) = 1;
            U(i,2:5) = 0;
        elseif x(i,1) > c(5)
            U(i,5) = 1;
            U(i,1:4) = 0;
        else
            for j = 1:4
                if x(i,1) > c(j) && x(i) <= c(j+1)

                    U(i,j) = (c(j+1)-x(i,1)) / (c(j+1)-c(j))  ;
                    U(i,j+1) = 1-U(i,j);
                    %U(i,j) = (c(j+1)-x(i,1)) / (c(j+1)-c(j))  ;
                end
            end
        end
    end

    % update centroid
    for j = 1 : 5
        c(j) = (U(:,j)' * x) / sum(U(:,j));
    end
    
    % compute error
    relerr = norm(c - cOld) / norm(c);
    
    % increase counter
    iter = iter + 1;
end


end

