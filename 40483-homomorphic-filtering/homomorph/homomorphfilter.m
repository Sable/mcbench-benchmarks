clear all
%read input image
dim=imread('lena.pgm');
cim=double(dim);

[r,c]=size(dim);
cim=cim+1;
% add 1 to pixels to remove 0 values which would result in undefined log values

% natural log
lim=log(cim);

%2D fft
fim=fft2(lim);

lowg=.9; %(lower gamma threshold, must be lowg < 1)
highg=1.1; %(higher gamma threshold, must be highg > 1)
% make sure the the values are symmetrically differenced

% function call
him=homomorph(fim,lowg,highg);

%inverse 2D fft
ifim=ifft2(him);

 
 
%exponent of result
eim=exp(ifim);
 

figure;
subplot(2,3,1);imshow(dim);title('Origional image');
subplot(2,3,2);imshow(lim);title('Natural Logarithm');
subplot(2,3,3);imshow(uint8(fim));title('Fourier transform');
subplot(2,3,4);imshow(him);title('Homomorphic filter');
subplot(2,3,5);imshow((ifim));title('Inverse fourier transform');
subplot(2,3,6);imshow(uint8(eim));title('Final result');

% eim has the final result

