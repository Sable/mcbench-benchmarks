% contourlet.m
% written by: Duncan Po
% Date: August 24, 2002
% Performs the Contourlet Transform on an Image
% Usage: coefs = contourlet(pyrfilter, dirfilter, levndir, imname, imformat)
%        coefs = contourlet(pyrfilter, dirfilter, levndir, image)
% Inputs:   pyrfilter   - Pyramid filter (e.g. '9-7')
%           dir         - Directional filter (e.g. 'cd')
%           levndir     - the number of subbands in each level
%           imname      - the name of the image in a file
%           imformat    - the format of the image file
%           image       - the image in memory
% Output:   coefs       - contourlet coefficients in subband structure

function coefs = contourlet(pyrfilter, dirfilter, levndir, imname, imformat)

if nargin == 5
    pic = imread(imname,imformat);  
    pic = double(pic);
elseif nargin == 4
    pic = imname;
end;

%figure;
%imshow(uint8(pic));

coefs = pdfbdec(pic, pyrfilter, dirfilter, levndir);
