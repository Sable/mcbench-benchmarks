close all
zebra = imread('zebra.bmp');
figure; imagesc(zebra); title('original image');

[Zebra1] = Nonlinear_Diffusion(double(zebra),1,1e-2,1,20,0, 0);
title('total variation flow(p=1, tau=1), 20 time steps');
[Zebra2] = Nonlinear_Diffusion(double(zebra),1,1e-3,1.2,20, 0,0);
title('edge enhacing flow(p=1.2, tau=1), 20 time steps');
[Zebra3] = Nonlinear_Diffusion(double(zebra),3,1e-3,1.2,30, 0,0);
title('edge enhacing flow(p=1.2, tau=3), 30 time steps');
[Zebra4] = Nonlinear_Diffusion(double(zebra),3,1e-3,1.3,30, 0,0);
title('edge enhacing flow(p=1.3, tau=3), 30 time steps');

house = imread('house_noisy.bmp');
figure; imagesc(house); title('original image');

[House1] = Nonlinear_Diffusion(double(house),1,1e-3,1,50, 0,0);
title('total variation flow(p=1, tau=1) , 50 time steps');

[House2] = Nonlinear_Diffusion(double(house),5,1e-3,1,10, 0,0);
title('total variation flow(p=1, tau=5) , 10 time steps');

[House4] = Nonlinear_Diffusion(double(house),5,1e-3,1,20, 0,0.5);
title('total variation flow(p=1, tau=5), 20 time steps, regularization sigma=0.5');

[House5] = Nonlinear_Diffusion(double(house),5,1e-3,1,20, 0,1);
title('total variation flow(p=1, tau=5), 20 time steps, regularization sigma=1');

[House6] = Nonlinear_Diffusion(double(house),5,1e-3,1.2,40, 0,0);
title('edge ehnacing flow(p=1.2, tau=5), 40 time steps');

[House7] = Nonlinear_Diffusion(double(house),5,1e-3,1.4,60, 0,0.4);
title('edge ehnacing flow(p=1.4, tau=5), 60 time steps, regularization sigma=0.4');

figure;
subplot(2,2,1); imagesc(zebra); title('original image'); 
subplot(2,2,2); imagesc(Zebra4/255); title('filtered image');
subplot(2,2,3); imagesc(house); title('original image');
subplot(2,2,4); imagesc(House7/255); title('filtered image');