clear;
clf;

% Load the image
I=rgb2gray(imread('lena.jpg','jpg'));
load colormaps.mat

% Show the grayscale image
colormap(grayscale);
imshow(I);

% Filter the image
[G,GABOUT]=gaborfilter(I,0.05,0.025,0,0);

clear I;

R=real(GABOUT);
I=imag(GABOUT);
M=abs(GABOUT);
P=angle(GABOUT);

clear GABOUT;

% Show the filter's outputs
figure;
colormap(redgreen);
subplot(2,2,1);
k=127.5/max(max(abs(R)));
image(uint8(k*R+127.5));
subplot(2,2,2);
k=127.5/max(max(abs(I)));
image(uint8(k*I+127.5));

% Show the kernels
colormap(redgreen);
subplot(2,2,3);
image(uint8(127.5*real(G)+127.5));
subplot(2,2,4);
image(uint8(127.5*imag(G)+127.5));

% Show the magnitudes
figure;
colormap(grayscale);
k=255/max(max(M));
image(uint8(k*M));

% Show the phases
figure;
colormap(redgreen);
k=127.5/pi;
image(uint8(k*P+127.5));
