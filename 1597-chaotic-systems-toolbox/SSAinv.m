function xr=SSAinv(pc,v,tau,k)
%Syntax: xr=SSAinv(pc,v,tau,k)
%_____________________________
%
% The inverse of Singular Spectrum Analysis for a time series.
%
% xr is the reconstructed time series.
% pc is the matrix with the principal components of x.
% v is the matrix of the singular vectors of x given dim and tau.
% tau is the time delay.
% k is the vector with the indices of the components to be reconstructed.
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

% pc must be a 2-dimensional matrix
if ndims(pc)>2
   error('pc must be a 2-dimensional matrix.');
end

% v must be a 2-dimensional matrix
if ndims(v)>2
   error('v must be a 2-dimensional matrix.');
end


if nargin<3 | isempty(k)==1
    k=size(v,2);
else
    
    % k must be either a scalar or a vector
    if min(size(k))>1
        error('k must be either a scalar or a vector.');
    end
    
    % k must be contain integer values
    if sum(abs(k-round(k)))~=0
        error('k must be contain integer values.');
    end
    
    % k must not be bellow 1
    if any(k<1)==1
        error('k must not be bellow 1.');
    end
end

 
% T is the length of the trajectory matrix and dim its dimension
[T dim]=size(pc);

% N is the length of the time series
N=T+(dim-1)*tau;

% Reconstruct the k Principal Components
pc=pc(:,k)*v(:,k)';

% Initialize xr
xr=zeros(N,1);
times=zeros(N,1);

% Calculate the reconstructed time series
for i=1:dim
   xr(1+(i-1)*tau:T+(i-1)*tau)=xr(1+(i-1)*tau:T+(i-1)*tau)+pc(:,i);
   times(1+(i-1)*tau:T+(i-1)*tau)=times(1+(i-1)*tau:T+(i-1)*tau)+1;
end
xr=xr./times*sqrt(T);
