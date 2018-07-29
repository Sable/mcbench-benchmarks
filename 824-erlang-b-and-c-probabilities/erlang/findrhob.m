%
% rho=findrhob(n,p)
%
% Finds an intensity rho such that B(n,rho)=p.  
%
% Note: Must have 0<p<1.  Returns NaN if p is not in this range.
%
function rho=findrhob(n,p)
%
% Sanity check- make sure that n is a positive integer.
%
  if ((floor(n) ~= n) || (n < 1))
    warning('n is not a positive integer');
    rho=NaN;
    return;
  end;
%
% Sanity check- make sure that p is a probability with 0<p<1.
%
  if ((p<0.0) || (p>1.0))
     warning('Invalid p value!');
     rho=NaN;
     return;
  end;
%
% We know that at rho=0, p=0, and at rho=+Inf, p=1.   We start by finding
% an interval [0,a] containing the root.
%
a=1.0;
testp=erlangb(n,a);
while (testp < p),
  a=a*2.0;
  testp=erlangb(n,a);
end;
%
% Now, the root is somewhere between 0 and a.  Use bisection to find it.
% 
%
left=0.0;
right=a;
mid=(left+right)/2;
midp=erlangb(n,mid);
while ((right-left) > 0.0001*max([1 left])),
  if (midp < p),
    left=mid;
    mid=(left+right)/2;
    midp=erlangb(n,mid);     
  else
    right=mid;
    mid=(left+right)/2;
    midp=erlangb(n,mid);     
  end;
end;
%
% Return the left end point of the current interval, which has prob < p.
%
rho=left;
