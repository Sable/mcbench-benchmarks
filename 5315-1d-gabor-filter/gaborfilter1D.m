%The Gabor filter is basically a Gaussian (with variances sx and sy along x and y-axes respectively)
%modulated by a complex sinusoid (with centre frequencies U and V along x and y-axes respectively) 
%described by the following equation
%%
%               1                -1     x  ^    y  ^
%%% G(x,y) = ---------- * exp ([----{(----) 2+(----) 2}+2*pi*i*(Ux+Vy)])
%            2*pi*sx*sy           2    sx       sy

%% But we use one dimentional gabor filter as below

%              1              -1    x  ^  
%%% G(x) = ---------- * exp ([----(----) 2+2*pi*i*Ux])
%           2*pi*sx            2    sx     

%And

%              1              -1    y  ^  
%%% G(y) = ---------- * exp ([----(----) 2+2*pi*i*Uy])
%           2*pi*sy            2    sy     
% By using these filters,reduces the filtering operations from O(M2N2) to O(MN2). 

%The output is
%%% Iu(x,y) = Conv(I(x,y),g(y)); 
%%% Iv(x,y) = Conv(I(x,y),g(x));
%%%Ifilt = sqrt(Iu^2+Iv^2);
%% Where I is input image.


%% Describtion :

%% I : Input image
%% Sx & Sy : Variances along x and y-axes respectively
%% U & V : Centre frequencies  along x and y-axes respectively

%% Gx & Gy : The output filters as described above
%% gabout : The output filtered image

%%  Author : Ahmad poursaberi  e-mail : a.poursaberi@ece.ut.ac.ir
%%          Faulty of Engineering, Electrical&Computer Department,Tehran
%%          University,Iran,June 2004

function [Gx,Gy,gabout] = gaborfilter1D(I,Sx,Sy,U,V);

if isa(I,'double')~=1 
    I = double(I);
end
warning off
for x = -fix(Sx):fix(Sx)
    for y = -fix(Sy):fix(Sy)
        Gx(fix(Sx)+x+1) = (1/(2*pi*Sx))*exp(-.5*((x/Sx)^2)+2*pi*i*U*x);
        Gy(fix(Sy)+y+1) = (1/(2*pi*Sy))*exp(-.5*((y/Sy)^2)+2*pi*i*V*y);
        
    end
end

gaboutu = conv2(I,double(Gy),'same');
gaboutv = conv2(I,double(Gx),'same');
gabout = uint8(sqrt(gaboutu.*gaboutu + gaboutv.*gaboutv));