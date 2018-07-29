%test script fgg_2D_experiment.m for the 2D NFFT based on Fast Gaussian
%Gridding.
%
%NOTE: In order for this FGG_2D to work, the C 
%file "FGG_Convolution2D.c" must be compiled into a Matlab executable
%(cmex) with the following command: mex FGG_Convolution2D.c
%
%Code by (send correspondence to):
%Matthew Ferrara, Research Mathematician
%AFRL Sensors Directorate Innovative Algorithms Branch (AFRL/RYAT)
%Matthew.Ferrara@wpafb.af.mil

clear all;
close all;
%clc
%path(path, './nfftde');%NFFT mex files from Potts, et al.

% make an "image"
%Note for even lengths, the Nfft routine defines the image-space origin
% at pixel location [Nx/2 + 1, Ny/2 + 1].
% Convention:  x counts down rows, y counts L to R columns.
N=16;%even length assumed below...tedious to generalize...
z = zeros(N,N);%
%Make a smiley face:
z(N/2+3,N/2-1 : N/2+1 ) = 1;
z(N/2+2,N/2-2 ) = 1;
z(N/2+2,N/2+2 ) = 1;
z(N/2-1,N/2-1) = 1;
z(N/2+1,N/2) = 1;
z(N/2-1,N/2+1) = 1;
%imagesc(z)

N=[N,N];
img=double(z);
% Now, let's compute a matlab DFT in d dimensions using the "nfft" command.
% Note, use fftshifts to match indexing convention as used above in Pott's
% nfft.
data=fftshift(ifftn(ifftshift(img)));
DFTout = fftshift(fftn(ifftshift(data),N));
z=z(:);

% We need knots on [-1/2, 1-1/Nx]x[-1/2, 1-1/Ny] as fundamental period.
% make square grid of knots for exact comparison to fft
tmpx = linspace(-1/2,1/2 -1/N(1), N(1));% tmpx(end)=[];
tmpy = linspace(-1/2,1/2 -1/N(2), N(2));% tmpy(end)=[];

%this creates N+1 points, then discards point at +0.5.
%store my K knots as a d-by-K matrix (d=2 dimension here)
%...following four lines could be cleverly vectorized, avoiding loop.
[Y,X]=meshgrid(tmpy,tmpx);


knots=[X(:),Y(:)];

Nx=N(1);
Ny=N(2);
%set the desired number of digits of accuracy desired from the NUFFT
%routine:
Desired_accuracy = 6;%6=single precision, 12=double precision.
tic
MattOut_Gauss=FGG_2d_type1(data(:),knots,[Nx,Ny],Desired_accuracy);
imagesc(abs(MattOut_Gauss))
colorbar
title('(Type-I Fast Gaussian Gridding) NFFT output')
disp(['NUFFT evaluated in ',num2str(toc),' seconds'])
MattOut_t2=iFGG_2d_type2(MattOut_Gauss,knots,Desired_accuracy);
MattOut_Gauss=FGG_2d_type1(MattOut_t2(:),knots,[Nx,Ny],Desired_accuracy);
figure
imagesc(abs(MattOut_Gauss))
colorbar
title('(Type-I Fast Gaussian Gridding) NFFT output from Type-II-generated data')
norm(MattOut_t2-z(:))

figure
imagesc(abs(img-MattOut_Gauss))
colorbar
title('Error between DFT and NFFT')
Mean_Error=mean(abs(MattOut_Gauss(:)-DFTout(:)))