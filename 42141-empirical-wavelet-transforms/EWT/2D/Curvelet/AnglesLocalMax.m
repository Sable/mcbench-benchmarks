function bound = AnglesLocalMax(f,N)

%================================================================
% function bound = AnglesLocalMax(f,N)
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

locmax=zeros(size(f));
% We detect the local maxima
for i=2:length(f)-1
    if ((f(i-1)<f(i)) && (f(i)>f(i+1)))
        locmax(i)=f(i);
    end
end

% We check if the endpoint are local maxima or minima (we work on the torus)
if ((f(end)<f(1)) && (f(1)>f(2)))
    locmax(1)=f(1);
end

if ((f(end-1)<f(end)) && (f(end)>f(1)))
    locmax(end)=f(end);
end

% We keep the N-th highest maxima and their index
[lmax,Imax]=sort(locmax,1,'descend');
if length(lmax)>N
    Imax=sort(Imax(1:N));
else
    N=length(lmax);
end


% We take the middle point between two consecutive maxima
bound=zeros(1,N);
for i=1:N
   if i==N
       bound(i)=(Imax(i)+Imax(1)+length(f))/2;
       if bound(i)>length(f)
           bound(i)=bound(i)-length(f);
       end
   else
       bound(i)=(Imax(i)+Imax(i+1))/2;
   end
end

bound=sort(bound);