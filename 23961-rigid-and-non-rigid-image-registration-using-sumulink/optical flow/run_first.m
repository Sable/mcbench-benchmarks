clc; clear all;close all;
file_name_i1='lenag1.png'; %i1 will be registered tohwards i2
file_name_i2='lenag2.png';
I1=im2double(imread(file_name_i1));  
I2=im2double(imread(file_name_i2)); 
i1=I1(:,:,1);             %in case picture is not grayscale
i2=I2(:,:,1);
SAD_before_registration=sum(sum(abs(i2-i1))); % compute SAD before
figure();
 imshow(i1);
 title('i1')
 figure();
 imshow(i2);
 title('i2');
  figure();
