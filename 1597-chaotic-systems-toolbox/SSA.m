function [pc,s,v]=SSA(x,dim,tau)
%Syntax: [pc,s,v]=SSA(x,dim,tau)
%_______________________________
%
% Singular Spectrum Analysis for a time series.
%
% pc is the matrix with the principal components of x.
% s is the vector of the singular values of x given dim and tau.
% v is the matrix of the singular vectors of x given dim and tau.
% x is the time series.
% dim is the embedding dimension.
% tau is the time delay.
%
%
% Reference:
%
% Elsner J B, Tsonis A A (1996): Singular Spectrum Analysis - A New Tool in
% Time Series Analysis. Plenum Press.
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% 14 Jul 2001

if nargin<3 | isempty(tau)==1
    tau=1;
end

% Make the trajectory matrix
[Y,T]=phasespace(x,dim,tau);
%T=length(x);Y=x;

% Normalize
Y=Y/sqrt(T);

% SVD on Y
[u,s,v]=svd(Y,0);
s=diag(s);

% Calculate the Principal Components
pc=Y*v;
