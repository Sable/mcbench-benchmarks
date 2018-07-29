% Fracture flow - analytical solution
%
%  E.Holzbecher,    18.4.2011 
%
%-------------------------------------------------- 
perm = 0;           % =1: permeable fracture, =0 impermeable obstacle
velo = 1/10/sqrt(2);% velocity at infinity  
alpha = pi/4;       % baseflow angle
a=2;                % half-length of fracture / obstacle
xmin = -5; xmax = 5; ymin = -5; ymax = 5;
N = 101;

% process & visualize
a = a*a;
xvec = linspace(xmin,xmax,N);
yvec = linspace(ymin,ymax,N);
[x,y] = meshgrid (xvec,yvec);                          % mesh
z = x+i*y;
if perm
    Phi = velo*(z*cos(alpha)-i*sqrt(z.*z-a).*sin(alpha+(x<0)*pi+pi)); % potential
    contourf (x,y,imag(Phi),20);
    hold on; colorbar;
    contour (x,y,real(Phi),20,'w');
    [u,v] = gradient (imag(Phi));           
else
    Phi = velo*(z*cos(alpha)-i*sqrt(z.*z-a).*sin(alpha+(x<0)*pi)); % potential
    contourf (x,y,real(Phi),20);
    hold on; colorbar;
    contour (x,y,imag(Phi),20,'w');
    [u,v] = gradient (real(Phi));
end
qx = ceil(size(x)/9); qy = ceil(size(y)/9);

quiver (x(1:qx:end,1:qy:end),y(1:qx:end,1:qy:end),...
    u(1:qx:end,1:qy:end),v(1:qx:end,1:qy:end),0.5,'w');