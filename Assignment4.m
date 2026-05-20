close all
clear
clc

%Jonathan Bradford - CSCI 158 Spring 2025
%Hough Transform - Assignmment 4

%Global variables:
circleImg = imread("circles.png");  %read original image of varying circles
[x, y, ~] = size(circleImg);        %x/y will hold image size globally
binaryImg(x, y) = 0;                %to hold binary version of image
accumMat(x, y) = 0;                 %accum matrix for hough space
finalImg(x, y) = 0;                 %will hold filtered radius image
radius = 10;                        %desired circular radius to find
edges = [0, 0];                     %matrix to hold edge location values
edgeCount = 1;                      %variable to iterate above matrix
circlePos = [0, 0];                 %matrix of circle's positions 
circleCount = 1;                    %holds count of circles
theta_step = pi / 180;              %'step' for each angle iteration
thetas = 0:theta_step:2*pi;         

%Loop does simple binarization the original image of circles
for i = 1:x
    for j = 1:y
        if circleImg(i, j) < 128 
            binaryImg(i, j) = 0;
        else
            binaryImg(i, j) = 255;
        end
    end
end

%We use a built in/simple canny edge detector on the binary image
edgeImg = edge(binaryImg, 'canny');
[row, col] = size(edgeImg);

%store the location of each circle edge in 'edges' matrix
for i = 1:x
    for j = 1:y
        if edgeImg(i, j) == 1
            edges(edgeCount, 1) = i;
            edges(edgeCount, 2) = j;
            edgeCount = edgeCount + 1;            
        end
    end
end



%This loop implements the accumulative matrix count for our hough space
for i = 1:(edgeCount - 1)   %for each edge pos, calculate potential centers
    tempx = edges(i, 1);
    tempy = edges(i, 2);
    as = round(tempx - radius * cos(thetas));   
    bs = round(tempy - radius * sin(thetas));
    
    %loop over every possible center val
    for j = 1:length(as)
        a = as(j);
        b = bs(j);

        %does boundary check then adds 1 to accumulative matrix
        if (a >= 1 && a <= x) && (b >= 1 && b <= y)
            accumMat(a, b) = accumMat(a, b) + 1;
        end
    end
end

%simple loop to get the max val in the accum matrix to get threshold
mVal = 0;
for k = 1:x
    for l = 1:y
        if mVal < accumMat(k, l)
            mVal = accumMat(k, l);
        end
    end
end

%utilize simple linear threshold with max value 
threshold = mVal * 0.75;

%this loop scans over the accum matrix and finds values above threshold.
%if value is above threshold, we mark the pos as a circle matching our r
for i = 1:x
    for j = 1:y
        if accumMat(i, j) > threshold
            circlePos(circleCount, 1) = i;
            circlePos(circleCount, 2) = j;
            circleCount = circleCount + 1;
        end
    end
end

%this loop/function goes through the circle locations that exceeded t
%and 'draws' the circle in our final image
for i = 1:(circleCount - 1)
    tempx = circlePos(i, 1);
    tempy = circlePos(i, 2);
    
    %get values surrounding center
    as = round(tempx - radius * cos(thetas));
    bs = round(tempy - radius * sin(thetas));

    for j = 1:length(as)
        a = as(j);
        b = bs(j);
        %we 'draw' it white
        if (a >= 1 && a <= x) && (b >= 1 && b <= y)
            finalImg(a, b) = 255;
        end
    end    
end


%Outputs the original image, edge image, and resulting
%derived image from the hough space above
subplot(1, 3, 1)
imshow(binaryImg);
title('Original Image:')
subplot(1, 3, 2)
imshow(edgeImg);
title('Edge filtered:')
subplot(1, 3, 3)
imshow(finalImg);
title('R = 10 Filter:')