function RGB2 = filterColors(RGB, T1, T2, T3,nPoints)


% function RGB2 = filterColors(RGB, T1, T2, T3,nPoints)
% 
% This function is used for creating a partly gray image, from a colored
% one. nPoints from the area need to be provided from the user.
%
% ARGUMENTS:
%  - RGB: the input image
%  - T1:  threshold of the R coefficient
%  - T2:  threshold of the G coefficient
%  - T2:  threshold of the B coefficient
%  - nPoints: number of points to be entered by the user
% 
% RETURNS:
%  - RGB2 : the new image
%
%
% Theodoros Giannakopoulos
% www.di.uoa.gr/~tyiannak
% tyiannak@gmail.com
%


R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

str = sprintf('Please select %d points from the area of the desired color.', nPoints);
f = figure('Name', str);
warning off;
imshow(RGB);

count = 0;

for (i=1:nPoints)
    [x,y] = ginput(1);        
    count = count + 1;
    xs(count) = round(x);
    ys(count) = round(y);        
end

N = 3;

for (i=1:count)
    r = R( ys(i)-N : ys(i)+N , xs(i)-N : xs(i)+N);
    g = G( ys(i)-N : ys(i)+N , xs(i)-N : xs(i)+N);
    b = B( ys(i)-N : ys(i)+N , xs(i)-N : xs(i)+N);    
    meanR(i) = mean(mean(r));
    meanG(i) = mean(mean(g));
    meanB(i) = mean(mean(b));        
end

MR = mean(meanR);
MG = mean(meanG);
MB = mean(meanB);


Gray = rgb2gray(RGB);

I = find( (abs(double(R)-double(MR))>T1) | (abs(double(G)-double(MG))>T2) | (abs(double(B)-double(MB))>T3));
%I1 = (abs(R-MR)>T1);
%I2 = (abs(G-MG)>T2);
%I3 = (abs(B-MB)>T3);

R(I) = Gray(I);
G(I) = Gray(I);
B(I) = Gray(I);

RGB2(:,:,1) = R;
RGB2(:,:,2) = G;
RGB2(:,:,3) = B;

close(f);
%figure;
%imshow(RGB2);