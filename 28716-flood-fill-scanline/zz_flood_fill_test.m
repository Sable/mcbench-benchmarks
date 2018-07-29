I=imread('smile.png'); % load image

subplot(1,2,1);
imshow(I);
title('original image');
tol=2; % tolerance
r=[20;30]; % start point of flood
ms=flood_fill(I,r,tol); % make flood fill

cl=[0; 255; 255];% color to fill
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

R(ms)=cl(1);
G(ms)=cl(2);
B(ms)=cl(3);

I(:,:,1)=R;
I(:,:,2)=G;
I(:,:,3)=B;

subplot(1,2,2);
imshow(I);
title('flood fill');



