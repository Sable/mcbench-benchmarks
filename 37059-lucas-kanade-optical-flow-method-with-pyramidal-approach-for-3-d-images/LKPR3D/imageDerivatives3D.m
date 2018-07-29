function [ Ix, Iy, Iz, It ] = imageDerivatives3D( image1, image2 )
%This function computes 3D derivatives between two 3D images. 
%
%   There are four derivatives here; three along X, Y, Z axes and one along
%   timeline axis.
%
%   -image1, image2 :   two subsequent images or frames
%   -dx, dy, dz : vectors along X, Y and Z axes respectively
%   -dt : vectors along timeline axis
%   -Ix, Iy, Iz : derivatives along X, Y and Z axes respectively
%   -It : derivatives along timeline axis
%
%   Author: Mohammad Mustafa
%   By courtesy of The University of Nottingham and 
%   Mirada Medical Limited, Oxford, UK
%
%   Published under a Creative Commons Attribution-Non-Commercial-Share Alike
%   3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%   
%   June 2012


dx=zeros(2,2,2);
dx(:,:,1)=[-1 1; -1 1 ]; dx(:,:,2)=[-1 1; -1 1 ];
dx=0.25*dx;

dy=zeros(2,2,2);
dy(:,:,1)=[-1 -1; 1 1 ]; dy(:,:,2)=[-1 -1; 1 1 ];
dy=0.25*dy;

dz=zeros(2,2,2);
dz(:,:,1)=[-1 -1; -1 -1 ]; dz(:,:,2)=[1 1; 1 1 ];
dz=0.25*dz;

dt=ones(2,2,2);
dt=0.25*dt;

% Computing derivatives
Ix = 0.5 * (convn(image1,dx) + convn(image2,dx) );
Iy = 0.5 * (convn(image1,dy) + convn(image2,dy) );
Iz = 0.5 * (convn(image1,dz) + convn(image2,dz) );
It = 0.5 * (convn(image1,dt) - convn(image2,dt) );

% Aadjusting sizes
Ix=Ix(1:size(Ix,1)-1, 1:size(Ix,2)-1, 1:size(Ix,3)-1);
Iy=Iy(1:size(Iy,1)-1, 1:size(Iy,2)-1, 1:size(Iy,3)-1);
Iz=Iz(1:size(Iz,1)-1, 1:size(Iz,2)-1, 1:size(Iz,3)-1);
It=It(1:size(It,1)-1, 1:size(It,2)-1, 1:size(It,3)-1);


end

