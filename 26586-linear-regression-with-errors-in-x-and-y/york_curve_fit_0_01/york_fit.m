function [a, b, sigma_a, sigma_b, b_save] = york_fit(X,Y,sigma_X,sigma_Y, r)
%[a, b, sigma_a, sigma_b, b_save] = york_fit(X,Y,sigma_X,sigma_Y, r)
%Performs linear regression for data with errors in both X and Y, following
%the method in York et al.
%X,Y are row vectors of regression data.
%sigma_X and sigma_Y are row vectors or single values for the error in X
%and Y.
%r is a row vector or singal value for the correlation coefficeients
%between the errors.
%
%References:
%D. York, N. Evensen, M. Martinez, J. Delgado "Unified equations for the
%slope, intercept, and standard errors of the best straight line" Am. J.
%Phys. 72 (3) March 2004.

%Copyright Travis Wiens 2010 travis.mlfx@nutaksas.com

N_itermax=10;%maximum number of interations
tol=1e-15;%relative tolerance to stop at

N=numel(X);

if nargin<5;
    r=0;
end

if numel(sigma_X)==1
    sigma_X=sigma_X*ones(1,N);
end

if numel(sigma_Y)==1
    sigma_Y=sigma_Y*ones(1,N);
end

if numel(r)==1
    r=r*ones(1,N);
end

%make initial guess at b using linear squares
tmp=Y/[X; ones(1,N)];
b_lse=tmp(1);
%a_lse=tmp(2);

b=b_lse;%initial guess

omega_X=1./sigma_X.^2;
omega_Y=1./sigma_Y.^2;

alpha=sqrt(omega_X.*omega_Y);

b_save=zeros(1,N_itermax+1);%vector to save b iterations in
b_save(1)=b;

for i=1:N_itermax
    W=omega_X.*omega_Y./(omega_X+b^2*omega_Y-2*b*r.*alpha);

    X_bar=sum(W.*X)/sum(W);
    Y_bar=sum(W.*Y)/sum(W);

    U=X-X_bar;
    V=Y-Y_bar;

    beta=W.*(U./omega_Y+b*V./omega_X-(b*U+V).*r./alpha);

    b=sum(W.*beta.*V)/sum(W.*beta.*U);
    b_save(i+1)=b;
    if abs((b_save(i+1)-b_save(i))/b_save(i+1))<tol
        break
    end
end

a=Y_bar-b*X_bar;

x=X_bar+beta;
%y=Y_bar+b*beta;

x_bar=sum(W.*x)/sum(W);
%y_bar=sum(W.*y)/sum(W);

u=x-x_bar;
%v=y-y_bar;

sigma_b=sqrt(1/sum(W.*u.^2));
sigma_a=sqrt(1./sum(W)+x_bar^2*sigma_b^2);