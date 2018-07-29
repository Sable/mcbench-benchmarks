%Integrand 2*pi*f*r*dr for Hankel transform.
%
% f      Function values
% r      Radial positions
% w      Integrand 2*pi*f*r*dr
%
%Principle:    Each function value f(r) is attributed to
%              the ring surface between the neighbouring
%              mid-points.
%
%              The integration interval is [0,r(end)].
%

%     Marcel Leutenegger © June 2006
%
function w=frdr(f,r)
w=numel(r);
switch w
case 0
   w=r;
case 1
   w=pi.*r.*r.*f;
case 2
   w=sum(r).^2;
   w=pi./4.*[sqrt(0.5).*w ; 4.*r(2).^2 - w].*f(:);
otherwise
   r=r(:);
   w=pi./4.*[sqrt(0.5).*(r(1) + r(2)).^2 ; (r(3:w) - r(1:w-2)).*(r(1:w-2) + 2.*r(2:w-1) + r(3:w)) ; 4.*r(w).^2 - (r(w-1) + r(w)).^2].*f(:);
end
