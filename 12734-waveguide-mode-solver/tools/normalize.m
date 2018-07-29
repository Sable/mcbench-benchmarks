% Normalizes all of the field components so that the mode has
% unity power (Poynting vector integrated over the cross section.)

function [ex,ey,ez,hx,hy,hz] = normalize(dx,dy,EX,EY,EZ,HX,HY,HZ)

Z0 = 119.9169832*pi; % vacuum impedance

[nx,ny] = size(EX);

if (length(dx) ~= nx),
  dx = dx*ones(nx,1);
end
if (length(dy) ~= ny),
  dy = dy*ones(1,ny);
end

ii = zeros(nx+1,ny+1);
ii(:) = (1:(nx+1)*(ny+1)); 

i1 = ii(1:nx,2:ny+1);
i2 = ii(1:nx,1:ny);
i3 = ii(2:nx+1,1:ny);
i4 = ii(2:nx+1,2:ny+1);

HXp = (HX(i1) + HX(i2)+ HX(i3) + HX(i4))/4;
HYp = (HY(i1) + HY(i2)+ HY(i3) + HY(i4))/4;

SZ = Z0*(conj(EX).*HYp - conj(EY).*HXp + EX.*conj(HYp) - EY.*conj(HXp))/4;
dA = dx*dy;
N = sqrt(sum(SZ(:).*dA(:)));
ex = Z0*EX/N;
ey = Z0*EY/N;
ez = Z0*EZ/N;
hx = HX/N;
hy = HY/N;
hz = HZ/N;



