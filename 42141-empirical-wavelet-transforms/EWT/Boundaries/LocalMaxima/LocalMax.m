function bound = LocalMax(f,N)

%================================================================
% function bound = LocalMax(f,N)
%
% This function segments f into a maximum of N supports by taking
% the middle point between the N largest local maxima.
% Note: the detected boundaries are given in term of indices
%
% Inputs:
%   -f: the function to segment
%   -N: maximal number of bands
%
% Outputs:
%   -bound: list of detected boundaries
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%===============================================================
N=N-1;

locmax=zeros(size(f));
locmin=max(f)*ones(size(f));
% We detect the local maxima
for i=2:length(f)-1
    if ((f(i-1)<f(i)) && (f(i)>f(i+1)))
        locmax(i)=f(i);
    end
    
    if ((f(i-1)>f(i)) && (f(i)<=f(i+1)))
        locmin(i)=f(i);
    end
end

% We keep the N-th highest maxima and their index
[lmax,Imax]=sort(locmax,1,'descend');
if length(lmax)>N
    Imax=sort(Imax(1:N));
else
    Imax=sort(Imax);
    N=length(lmax);
end

% We middle point between two consecutive maxima
bound=zeros(1,N);
for i=1:N
   if i==1
       a=1;
   else
       a=Imax(i-1);
   end
   bound(i)=(a+Imax(i))/2;
end