function im_new=map_con(im, Min, Max, Nmin, Nmax);
% im_new=map_con(im, Min, Max, Nmin, Nmax);
% function for mapping original intensities in image to known values of
% concentration 
% 
% does the same as IMADJUST in Image Processing Toolbox but LOW, HIGH, BOT and TOP must NOT be in the range [0.0, 1.0].
%
% input:
% im - original image
% Min,Max - min and max values in original image
% Nmin, Nmax - new min, max values in output image im_new
%
% written by K.Artyushkova
% 052003

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 

[n,m]=size(im);

% finding coefficinet of y=a*x+b;
a=(Nmin-Nmax)/(Min-Max);
b=(Nmin*Max-Nmax*Min)/(Max-Min);

[n,m]=size(im);

% mapping the values 
for i=1:n
    for j=1:m
        x=im(i,j);
        if x<=Min
            im_new(i,j)=Nmin;
        elseif x>=Max;
            im_new(i,j)=Nmax;
        else im_new(i,j)=a*x+b;
        end
    end
end


