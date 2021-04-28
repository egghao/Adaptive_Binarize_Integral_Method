function [imgOut] = AdaptiveThreshold(imgIn,w,h,s,t)
% Binarize image based on algorithm suggested by D. Bradley & G. Roth
% (DOI:10.1080/2151237X.2007.10129236)
% Parameters
% 
% Input:
% imgIn  - a grayscale image (uint8)
% w      - width of input image
% h      - height of input image
% s      - size of window (tunable)
% t      - threshold (tunable)
% 
% Output:
% imgOut - a binary image
% 

% Turn input image into double type for calculation
imgIn = double(imgIn); 

% Initialize a w x h matrix for integral image
I = zeros(w,h);

% First scan: Calculation of integral image 
for i = 1:w
    sum = 0;
    for j = 1:h
        sum = sum + imgIn(i,j);
        if i == 1
            I(i,j) = sum;
        else
            I(i,j) = I(i-1,j) + sum;
        end
    end
end

% Second scan: sliding window for every pixel of input image
for i = 1:w
    for j = 1:h
        x1 = round(i-s/2); % add 'round' in case that s is odd
        x2 = round(i+s/2);
        y1 = round(j-s/2);
        y2 = round(j+s/2);
        % Boundary check
        if x1<2
            x1 = 2; 
        end
        if y1<2
            y1 = 2;
        end
        if x2>w
            x2 = w;
        end
        if y2>h
            y2 = h;
        end
        count = (x2-x1)*(y2-y1);
        sum = I(x2,y2)-I(x2,y1-1)-I(x1-1,y2)+I(x1-1,y1-1);
        if imgIn(i,j)*count<=sum*(100-t)/100
            imgOut(i,j) = 0;
        else
            imgOut(i,j) = 255;
        end
    end
    
end
imgOut = uint8(imgOut);
end

