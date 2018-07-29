function [Ioutput]= marrfilter(I)
I1=im2double(I);
[Izerosmooth]= filtering(I1);
[Ioutput]=zerocrossing(Izerosmooth);
Ioutput1=im2uint8(Ioutput);
Ioutput1= Ioutput1>105;
imshow(Ioutput1);

figure;
  subplot(2,2,1);imshow(I);title('origional image');
  subplot(2,2,2);imshow(Izerosmooth);title('Zerosmooth image');
   subplot(2,2,3);imshow(Ioutput);title('output image');
   subplot(2,2,4);imshow(Ioutput1);title('output image with threshold');


   