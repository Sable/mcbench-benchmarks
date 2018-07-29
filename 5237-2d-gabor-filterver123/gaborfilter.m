%%%%%%%VERSION 1

%The Gabor filter is basically a Gaussian (with variances sx and sy along x and y-axes respectively)
%modulated by a complex sinusoid (with centre frequencies U and V along x and y-axes respectively) 
%described by the following equation
%%
%               1                -1     x  ^    y  ^
%%% G(x,y) = ---------- * exp ([----{(----) 2+(----) 2}+2*pi*i*(Ux+Vy)])
%            2*pi*sx*sy           2    sx       sy

%% Describtion :

%% I : Input image
%% Sx & Sy : Variances along x and y-axes respectively
%% U & V : Centre frequencies  along x and y-axes respectively

%% G : The output filter as described above
%% gabout : The output filtered image

%%  Author : Ahmad poursaberi  e-mail : a.poursaberi@ece.ut.ac.ir
%%          Faulty of Engineering, Electrical&Computer Department,Tehran
%%          University,Iran,June 2004

function [G,gabout] = gaborfilter(I,Sx,Sy,U,V);

if isa(I,'double')~=1 
    I = double(I);
end

for x = -fix(Sx):fix(Sx)
    for y = -fix(Sy):fix(Sy)
        G(fix(Sx)+x+1,fix(Sy)+y+1) = (1/(2*pi*Sx*Sy))*exp(-.5*((x/Sx)^2+(y/Sy)^2)+2*pi*i*(U*x+V*y));
    end
end

Imgabout = conv2(I,double(imag(G)),'same');
Regabout = conv2(I,double(real(G)),'same');

gabout = uint8(sqrt(Imgabout.*Imgabout + Regabout.*Regabout));