function Image_out=Intensity_adjust(Image_in);
%This code extends the intensity limits of  an image from [low_in; high_in]
%to [0;255]. It is most convenient for applications where operations such 
%as edge detection or black to white transformations are to be performed
%on a sequence of images. Threshold values are fixed for different images. 
% 
%   CLASS SUPPORT
%   -------------
%   The input is an RGB image. 
% 
%    
%   Syntaxes:
%   Image_out=Intensity_adjust('sky.jpg');
%   The output is an RGB image of the same size as the initial image. 
%   This code is written by:
%                         Nassim Khaled
%                         American University of Beirut
%                         Research and Graduate Assistant
%    
%  Developed under Matlab 7                       Date:  April,2005

a=imread(Image_in);
s=rgb2gray(a);
b=double(s);
low_in=min(b(:))/255;
high_in=max(b(:))/255;
Image_out = imadjust(a,[low_in; high_in],[0;1]);
