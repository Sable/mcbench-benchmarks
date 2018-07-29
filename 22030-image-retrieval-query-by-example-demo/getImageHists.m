function [Hist, RGBt] = getImageHists(imageName, PLOT)

% read RGB data:
RGB = imread(imageName);
RGBt = RGB;
RGB = rgb2hsv(RGB);

% get image size:
[M,N,ttt] = size(RGB);

range = 0.0:0.1:1.0;

Hist = zeros(length(range),length(range),length(range));

for (i=1:M)
    for (j=1:N)
%        N1 = histc(RGB(i,j,1), range);
%        N2 = histc(RGB(i,j,2), range);
%        N3 = histc(RGB(i,j,3), range);                
        
%        nn1 = find(N1==1);
%        nn2 = find(N2==1);
%        nn3 = find(N3==1);            
        
        nn1 = round(RGB(i,j,1) * 10)+1;
        nn2 = round(RGB(i,j,2) * 10)+1;        
        nn3 = round(RGB(i,j,3) * 10)+1;
        
        Hist(nn1, nn2, nn3) = Hist(nn1, nn2, nn3) + 1;
        
    end
end

Hist = Hist / (M*N);