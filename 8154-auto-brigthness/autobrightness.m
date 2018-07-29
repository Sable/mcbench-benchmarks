% AUTOBRIGHTNESS  
%        -->Automatically adjusts brightness of images to optimum level.
%    e.g. autobrightness('Sunset.jpg','Output.jpg')

function autobrightness(input_img,output_img)

my_limit=0.5;
input_image=imread(input_img);
if size(input_image,3)==3 a=rgb2ntsc(input_image);
else     a=double(input_image)./255;
end
mean_adjustment=my_limit-mean(mean(a(:,:,1)));
a(:,:,1)=a(:,:,1)+mean_adjustment*(1-a(:,:,1));
if size(input_image,3)==3    a=ntsc2rgb(a);
end
imwrite(uint8(a.*255),output_img);