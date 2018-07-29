
clear all

% read and normalize image
[Im0,map] = imread('twoObj.bmp');
[Ny,Nx] = size(Im0);
Im0 = double(Im0);
Im0 = ( Im0-min(Im0(:)) )/ ( max(Im0(:))-min(Im0(:)) );

% region term
c1 = 0.26;
c2 = 0.91;
wrin = (Im0 - c2).^2;
wrout = (Im0 - c1).^2;
wr = wrout - wrin; % region term

% boundary term
Gauss = fspecial('gaussian',[Nx Ny],1);
Im0s = real(ifftshift(ifft2( fft2(Im0).* fft2(Gauss) )));
[Gx,Gy] = gradient(Im0s);
NormGrad = sqrt(Gx.^2 + Gy.^2); 
NormGrad = sqrt(Gx.^2 + Gy.^2); 
wb = 1./ (1 + 30* abs(NormGrad).^2); % edge detector

% initial level set function
phi0 = ones(size(Im0));
w=9; phi0(w+1:end-w,w+1:end-w)= -1;
phi0 = FMReDistSDF_mex(single(phi0),single(sqrt(Nx^2+Ny^2)));
phi0 = double(phi0);

figure;
subplot(121); imagesc(Im0); colormap('gray'); title('Image');
subplot(122); imagesc(phi0); colormap('gray'); colorbar; title('initial level set function and zero level contour');

disp('press any key to start segmentation'); pause;

% segment
phi  = Segment2D_public(wb,wr,-4,phi0,60);

figure;
imagesc(Im0); colormap('gray'); hold on; contour(phi,[0 0],'m'); title('final segmentation');