function O = colormix(I,n,disp)
%COLORMIX Quantizes a grayscale image and assigns random colors to each gray level.
%          (just for fun :) ) 
%
%    Usage: O = colormix(I,n,disp)
%               I is the one band input image
%               n is the quantization level
%               Output image displayed if disp is 1.
%
%    Written and tested in Matlab R14SP1
%    Date: 01.10.2006 
%
%    Author: Atakan Varol
%    email: atakan.varol@vanderbilt.edu
%    homepage: http://people.vanderbilt.edu/~atakan.varol/

[R C B]= size(I); 

% Check the parameters
if (B ~= 1)
     disp(sprintf('Only grayscale images\n')); return ;
end
if (n>7 | n<1)
   disp(sprintf('The quantization level should be between 1 and 7\n')); return;
end

levels = 2^n;       % The number of different gray levels in the image
colors = randint(levels,3, [0 255]); % Create the color palette

% Image Quantization
M=I/(2^(8-n));
J=M*(2^(8-n));

% Color mixing
Red = zeros(R,C);
Green = zeros(R,C);
Blue = zeros(R,C);

for t = 1:levels
    Red(J == uint8(256/levels*t)) = colors(t,1);
    Green(J == uint8(256/levels*t)) = colors(t,2);
    Blue(J == uint8(256/levels*t)) = colors(t,3);
end

O = zeros(R,C,3);

O(:,:,1) = Red;
O(:,:,2) = Green;
O(:,:,3) = Blue;
O = uint8(O);

% Display the images
if (disp == 1)
    figure,imshow(I),title('The original image')
    figure,imshow(J);title('The quantized image')
    figure,imshow(O); title('The color mixed image')
end

return;