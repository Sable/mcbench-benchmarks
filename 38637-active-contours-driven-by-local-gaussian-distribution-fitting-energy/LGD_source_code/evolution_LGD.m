% This is the evolution step for segmentation using local gaussian distribution (LGD)
% fitting energy
%
% Reference: <Li Wang, Lei He, Arabinda Mishra, Chunming Li. 
% Active Contours Driven by Local Gaussian Distribution Fitting Energy.
% Signal Processing, 89(12), 2009,p. 2435-2447>
%
% Please DO NOT distribute this code to anybody.
% Copyright (c) by Li Wang
%
% Author:       Li Wang
% E-mail:       li_wang@med.unc.edu
% URL:          http://www.unc.edu/~liwa/
%
% 2010-01-02 PM

function [u ]= evolution_LGD(Img,u,epsilon,Ksigma,KONE,KI,KI2,mu,nu,lambda1,lambda2,timestep,alf)

u=NeumannBound(u);
K=curvature_central(u); 
H=Heaviside(u,epsilon);
Delta = Dirac(u,epsilon);

KIH = imfilter((H.*Img),Ksigma,'replicate');
KH = imfilter(H,Ksigma,'replicate');
u1= KIH./(KH);
u2 = (KI - KIH)./(KONE - KH);

KI2H = imfilter(Img.^2.*H,Ksigma,'replicate');

sigma1 = (u1.^2.*KH - 2.*u1.*KIH + KI2H)./(KH);
sigma2 = (u2.^2.*KONE - u2.^2.*KH - 2.*u2.*KI + 2.*u2.*KIH + KI2 - KI2H)./(KONE-KH);

sigma1 = sigma1 + eps;
sigma2 = sigma2 + eps;


localForce = (lambda1 - lambda2).*KONE.*log(sqrt(2*pi)) ...
    + imfilter(lambda1.*log(sqrt(sigma1)) - lambda2.*log(sqrt(sigma2)) ...
    +lambda1.*u1.^2./(2.*sigma1) - lambda2.*u2.^2./(2.*sigma2) ,Ksigma,'replicate')...
    + Img.*imfilter(lambda2.*u2./sigma2 - lambda1.*u1./sigma1,Ksigma,'replicate')...
    + Img.^2.*imfilter(lambda1.*1./(2.*sigma1) - lambda2.*1./(2.*sigma2) ,Ksigma,'replicate');

A = -alf.*Delta.*localForce;%data force
P=mu*(4*del2(u) - K);% level set regularization term, please refer to "Chunming Li and et al. Level Set Evolution Without Re-initialization: A New Variational Formulation, CVPR 2005"
L=nu.*Delta.*K;%length term
u = u+timestep*(L+P+A);

return;



function g = NeumannBound(f)
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);


function K = curvature_central(u);
[bdx,bdy]=gradient(u);
mag_bg=sqrt(bdx.^2+bdy.^2)+1e-10;
nx=bdx./mag_bg;
ny=bdy./mag_bg;
[nxx,nxy]=gradient(nx);
[nyx,nyy]=gradient(ny);
K=nxx+nyy;


function h = Heaviside(x,epsilon)
h=0.5*(1+(2/pi)*atan(x./epsilon));

function f = Dirac(x, epsilon)
f=(epsilon/pi)./(epsilon^2.+x.^2);


