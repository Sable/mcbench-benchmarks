%MIRT2D_MEXINTERP  Fast 2D linear interpolation 
% 
% ZI = mirt2D_mexinterp(Z,XI,YI) interpolates 2D image Z at the points with coordinates XI,YI.
% Z is assumed to be defined at regular spaced points 1:N, 1:M, where [M,N]=size(Z).
% If XI,YI values are outside the image boundaries, put NaNs in ZI.
% 
% The performance is similar to Matlab's ZI = INTERP2(Z,XI,YI,'linear',NaN).
% If Z is a 3D matrix, then iteratively interpolates Z(:,:,1), Z(:,:,2),Z(:,:,3),.. etc.
% This works faster than to interpolate each image independaently, such as
%  ZI(:,:,1) = INTERP2(Z(:,:,1),XI,YI);
%  ZI(:,:,2) = INTERP2(Z(:,:,2),XI,YI);
%  ZI(:,:,3) = INTERP2(Z(:,:,3),XI,YI);
% 
%  The speed gain is from the precomputation of coefficients for interpolation, which are the same for all images.
%  Interpolation of a set of images is useful, e.g. for image registration, when one has to interpolate image and its gradients
%  at the same positions.
%
%  Andriy Myronenko, Feb 2008, email: myron@csee.ogi.edu, 
%  homepage: http://www.bme.ogi.edu/~myron/



% The function below compiles the mirt2D_mexinterp.cpp file if you haven't done it yet.
% It will be executed only once at the very first run.
function Output_images = mirt2D_mexinterp(Input_images, XI,YI)

pathtofile=which('mirt2D_mexinterp.cpp');
pathstr = fileparts(pathtofile);
mex(pathtofile,'-outdir',pathstr);

Output_images = mirt2D_mexinterp(Input_images, XI,YI);

end