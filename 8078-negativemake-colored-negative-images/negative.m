% NEGATIVE : Creates colored and gray negative images.
%
% Syntax: negative(input_image_name, output_image_name)
% Example: negative('Input.jpg', 'Output.jpg');

function negative(input_image, output_image)

img=imread(input_image);
img=double(img);
inv(:,:,:)=255-img(:,:,:);
inv=uint8(inv);
imwrite(inv,output_image);