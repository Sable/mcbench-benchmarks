%Roots of Bessel function of the first kind of order n.
%
% n      Order
% N      Number of roots
% r      First roots
%

%     Marcel Leutenegger © June 2006
%
function r=JnRoots(n,N)
m=logical(ones(1,N));
r=n*pi/2 - pi/4 + pi*(1:N);
r=step(n,r);
K=100;
while any(m) & K
   R=step(n,r(m));
   k=r(m) ~= R;
   r(m)=R;
   m(m)=k;
   K=K-1;
end
if n
   r=[0 r(r > 0)];
   r=r(1:N);
end


%Gauss-Newton step.
%
function r=step(n,r)
b=(1 - eps/2)*r;
f=(1 + eps)*r;
f=real(besselj(n,r)).*(f - b)./real(besselj(n,f) - besselj(n,b));
f(abs(f) > 0.05)=0.05;
f(isnan(f))=0;
r=r - f;
