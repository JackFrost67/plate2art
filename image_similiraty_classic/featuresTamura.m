function [Fcoarseness,Fcontrast,Fdirection] = featuresTamura(im)   
    %resize the image for computional efficency reason
    [rows, cols, ~]=size(im);
    maxRowCol = max(rows, cols);
    im = imresize(im, 1/ceil(maxRowCol/400));
    
    image = rgb2gray(im);%Converts RGB image to grayscale
    imDouble=double(image);

    % -------------------Coarseness-------------------
    Fcoarseness = computeCoarseness(imDouble);
    %-------------------Contrast-------------------
    Fcontrast = computeContrast(image);
    %-------------------Directionality-------------------
    Fdirection = computeDirection(imDouble);
end


function coarseness =  computeCoarseness(imDouble)
    
    [rows,cols] = size(imDouble);%size of array

    %initialization
    %Average of neighbouring pixels
    A1=zeros(rows,cols);A2=zeros(rows,cols);
    A3=zeros(rows,cols);A4=zeros(rows,cols);
    A5=zeros(rows,cols);A6=zeros(rows,cols);
    %Sbest for coarseness
    Sbest=zeros(rows,cols);
    %Subtracting for Horizontal and Vertical case
    E1h=zeros(rows,cols);E1v=zeros(rows,cols);
    E2h=zeros(rows,cols);E2v=zeros(rows,cols);
    E3h=zeros(rows,cols);E3v=zeros(rows,cols);
    E4h=zeros(rows,cols);E4v=zeros(rows,cols);
    E5h=zeros(rows,cols);E5v=zeros(rows,cols);
    E6h=zeros(rows,cols); E6v=zeros(rows,cols);
    flag=0;%To avoid errors

    %2x2  E1h and E1v
    %subtracting average of neighbouring 2x2 pixels 
    for x=2:rows
        for y=2:cols
            A1(x,y)=(sum(sum(imDouble(x-1:x,y-1:y))));
        end
    end
    for x=2:rows-1
        for y=2:cols-1
            E1h(x,y) = A1(x+1,y)-A1(x-1,y);
            E1v(x,y) = A1(x,y+1)-A1(x,y-1);
        end
    end
    E1h=E1h/2^(2*1);
    E1v=E1v/2^(2*1);

    %4x4  E2h and E2v
    if (rows<4||cols<4)
    flag=1;
    end
    %subtracting average of neighbouring 4x4 pixels
    if(flag==0)
    for x=3:rows-1
        for y=3:cols-1
            A2(x,y)=(sum(sum(imDouble(x-2:x+1,y-2:y+1))));
        end
    end
    for x=3:rows-2
        for y=3:cols-2
            E2h(x,y) = A2(x+2,y)-A2(x-2,y);
            E2v(x,y) = A2(x,y+2)-A2(x,y-2);
        end
    end
    end
    E2h=E2h/2^(2*2);
    E2v=E2v/2^(2*2);

    %8x8 E3h and E3v
    if (rows<8||cols<8)
    flag=1;
    end
    %subtracting average of neighbouring 8x8 pixels
    if(flag==0)
    for x=5:rows-3
        for y=5:cols-3
            A3(x,y)=(sum(sum(imDouble(x-4:x+3,y-4:y+3))));
        end
    end
    for x=5:rows-4
        for y=5:cols-4
            E3h(x,y) = A3(x+4,y)-A3(x-4,y);
            E3v(x,y) = A3(x,y+4)-A3(x,y-4);
        end
    end
    end
    E3h=E3h/2^(2*3);
    E3v=E3v/2^(2*3);

    %16x16 E4h and E4v
    if (rows<16||cols<16)
    flag=1;
    end
    %subtracting average of neighbouring 16x16 pixels
    if(flag==0)
    for x=9:rows-7
        for y=9:cols-7
            A4(x,y)=(sum(sum(imDouble(x-8:x+7,y-8:y+7))));
        end
    end
    for x=9:rows-8
        for y=9:cols-8
            E4h(x,y) = A4(x+8,y)-A4(x-8,y);
            E4v(x,y) = A4(x,y+8)-A4(x,y-8);
        end
    end
    end
    E4h=E4h/2^(2*4);
    E4v=E4v/2^(2*4);

    %32x32 E5h and E5v
    if (rows<32||cols<32)
    flag=1;
    end
    %subtracting average of neighbouring 32x32 pixels
    if(flag==0)
    for x=17:rows-15
        for y=17:cols-15
            A5(x,y)=(sum(sum(imDouble(x-16:x+15,y-16:y+15))));
        end
    end
    for x=17:rows-16
        for y=17:cols-16
            E5h(x,y) = A5(x+16,y)-A5(x-16,y);
            E5v(x,y) = A5(x,y+16)-A5(x,y-16);
        end
    end
    end
    E5h=E5h/2^(2*5);
    E5v=E5v/2^(2*5);

    %64x64 E6h and E6v
    if (rows<64||cols<64)
    flag=1;
    end
    %subtracting average of neighbouring 64x64 pixels
    if(flag==0)
    for x=33:rows-31
        for y=33:cols-31
            A6(x,y)=(sum(sum(imDouble(x-32:x+31,y-32:y+31))));
        end
    end
    for x=33:rows-32
        for y=33:cols-32
            E6h(x,y) = A6(x+32,y)-A6(x-32,y);
            E6v(x,y) = A6(x,y+32)-A6(x,y-32);
        end
    end
    end
    E6h=E6h/2^(2*6);
    E6v=E6v/2^(2*6);

    %at each point pick best size "Sbest", which gives highest output value
    for i=1:rows
        for j=1:cols
            [maxv,index]=max([abs(E1h(i,j)),abs(E1v(i,j)),abs(E2h(i,j)),abs(E2v(i,j)),...
                abs(E3h(i,j)),abs(E3v(i,j)),abs(E4h(i,j)),abs(E4v(i,j)),abs(E5h(i,j)),...
                abs(E5v(i,j)),abs(E6h(i,j)),abs(E6v(i,j))]);
            k=floor((index+1)/2);%'k'corresponding to highest E in either direction
            Sbest(i,j)=2.^k;
        end
    end 
    %Coarseness Value
    coarseness=sum(sum(Sbest))/(rows*cols);
end

function contrast = computeContrast(image)
    [rows, cols] = size(image);
    [counts,graylevels]=imhist(image);%histogram of image
    PI=counts/(rows*cols);
    averagevalue=sum(graylevels.*PI);%mean value
    u4=sum((graylevels-repmat(averagevalue,[256,1])).^4.*PI);%4th moment about mean
    variance=sum((graylevels-repmat(averagevalue,[256,1])).^2.*PI);%variance(2nd moment about mean)
    alpha4=u4/variance^2;%kurtosis
    %Contrast Value
    contrast=sqrt(variance)/alpha4.^(1/4);

end

function direction = computeDirection(imDouble)
    [rows,cols] = size(imDouble);%size of array
    
    PrewittH = [-1 0 1;-1 0 1;-1 0 1];%for measuring horizontal differences
    PrewittV = [1 1 1;0 0 0;-1 -1 -1];%for measuring vertical differences

    %Applying PerwittH operator
    deltaH=zeros(rows,cols);
    for i=2:rows-1
    for j=2:cols-1
        deltaH(i,j)=sum(sum(imDouble(i-1:i+1,j-1:j+1).*PrewittH));
    end
    end
    %Modifying borders
    for j=2:cols-1
        deltaH(1,j)=imDouble(1,j+1)-imDouble(1,j);
        deltaH(rows,j)=imDouble(rows,j+1)-imDouble(rows,j);  
    end
    for i=1:rows
        deltaH(i,1)=imDouble(i,2)-imDouble(i,1);
        deltaH(i,cols)=imDouble(i,cols)-imDouble(i,cols-1);  
    end

    %Applying PerwittV operator
    deltaV=zeros(rows,cols);
    for i=2:rows-1
        for j=2:cols-1
            deltaV(i,j)=sum(sum(imDouble(i-1:i+1,j-1:j+1).*PrewittV));
        end
    end
    %Modifying borders
    for j=1:cols
        deltaV(1,j)=imDouble(2,j)-imDouble(1,j);
        deltaV(rows,j)=imDouble(rows,j)-imDouble(rows-1,j);  
    end
    for i=2:rows-1
        deltaV(i,1)=imDouble(i+1,1)-imDouble(i,1);
        deltaV(i,cols)=imDouble(i+1,cols)-imDouble(i,cols);  
    end

    %Magnitude
    deltaG=(abs(deltaH)+abs(deltaV))/2;

    %Local edge direction (0<=theta<pi)
    theta=zeros(rows,cols);
    for i=1:rows
        for j=1:cols
            if (deltaH(i,j)==0)&&(deltaV(i,j)==0)
                theta(i,j)=0;
            elseif deltaH(i,j)==0
                theta(i,j)=pi;           
            else          
                theta(i,j)=atan(deltaV(i,j)/deltaH(i,j))+pi/2;
            end
        end
    end

    deltaGt = deltaG(:);
    theta1=theta(:);

    %Set a Threshold value for delta imDouble
    n = 16;
    HD = zeros(1,n);
    Threshold=12;
    counti=0;
    for m=0:(n-1)
        countk=0;
        for k = 1:length(deltaGt)
            if ((deltaGt(k)>=Threshold) && (theta1(k)>=(2*m-1)*pi/(2*n)) && (theta1(k)<(2*m+1)*pi/(2*n)))
                countk=countk+1;
                counti=counti+1;
            end
        end
        HD(m+1) = countk;
    end
    HDf = HD/counti;
    %peakdet function to find peak values
    [m p]=peakdet(HDf,0.000005);

    Fd=0;
    for np = 1:length(m)
        phaiP=m(np)*(pi/n);
        for phi=1:length(HDf)
                Fd=Fd+(phi*(pi/n)-phaiP)^2*HDf(phi);
        end
    end
    rows = (1/n);
    
    direction = 1 - rows*np*Fd;
end

