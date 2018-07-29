function [MinPixVal, MaxPixVal]=max_min_pix_value(im_array);
% function [MinPixVal, MaxPixVal]=max_min_pix_value(im_array);
%
% function for calculating most often occuring Min and Max intensity values
% in images
% Perfromed by calculating means of pixels within the moving boxes of 5x5 pixel size throughout the
% image
% three most minimum values are averaged to get MinPixVal
% three most maximum values are averaged to get MaxPixVal
% input im_array:
% can be one image or array of images
%
% written by K.Artyushkova
% 102003

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 

[n,m,p]=size(im_array);
for k=1:p
    a=im_array(:,:,k);
    i=1:5:n-4;
    [e,f]=size(i);
    j=1:5:m-4;
    [g,h]=size(j);
    for I=1:f
        for J=1:h
            b(I,J)=mean(mean(a(i(I):i(I)+4,j(J):j(J)+4))); 
        end
    end
    [r,p]=size(b);
    c=reshape(b,[r*p 1]);
    d=sort(c);
    MinPixVal(k)=mean(d(1:3));
    MaxPixVal(k)=mean(d((r*p-2):r*p));
end

    

