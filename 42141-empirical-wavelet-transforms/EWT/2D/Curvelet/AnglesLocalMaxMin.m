function bound = AnglesLocalMaxMin(f,N)

%================================================================
% function bound = AnglesLocalMaxMin(f,N)
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

% We check if the endpoint are local maxima or minima (we work on the torus)
if ((f(end)<f(1)) && (f(1)>f(2)))
    locmax(1)=f(1);
end
if ((f(end)>f(1)) && (f(1)<=f(2)))
    locmin(1)=f(1);
end

if ((f(end-1)<f(end)) && (f(end)>f(1)))
    locmax(end)=f(end);
end
if ((f(end-1)>f(end)) && (f(end)<=f(1)))
    locmin(end)=f(end);
end

% We keep the N-th highest maxima and their index
[lmax,Imax]=sort(locmax,1,'descend');
if length(lmax)>N
    Imax=sort(Imax(1:N));
else
    Imax=sort(Imax);
    N=length(lmax);
end


% We detect the lowest minima between two consecutive maxima
bound=zeros(1,N);
for i=1:N
   if i==N
       [lmin,ind]=sort([locmin(Imax(i):end);locmin(1:Imax(1))]);
       tmp=lmin(1);
       n=1;
       if n<length(lmin)
            n=2;
            while ((n<=length(lmin)) && (tmp==lmin(n)))
                n=n+1;
            end
       end
        bound(i)=Imax(i)+ind(ceil(n/2))-1;
       if bound(i)>length(f)
           bound(i)=bound(i)-length(f);
       end
   else
       [lmin,ind]=sort(locmin(Imax(i):Imax(i+1)));
       tmp=lmin(1);
       n=1;
       if n<length(lmin)
            n=2;
            while ((n<=length(lmin)) && (tmp==lmin(n)))
                n=n+1;
            end
       end
       bound(i)=Imax(i)+ind(ceil(n/2))-1;
   end
end

bound=sort(bound);