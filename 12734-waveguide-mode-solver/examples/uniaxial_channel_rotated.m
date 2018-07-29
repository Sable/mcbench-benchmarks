% This example shows how to find the modes of a birefringent
% (uniaxial) waveguide.  This waveguide is the same as the one
% considered in 'uniaxial_channel.m', except that the c-axis
% is now rotated by an angle of -pi/4 relative to the x axis.

n1 = 1.55;
n2x = 2.156;
n2y = 2.232;
n2z = 2.232;
theta = -pi/4;

e2xx = n2x^2*cos(theta)^2 + n2y^2*sin(theta)^2;
e2yy = n2y^2*cos(theta)^2 + n2x^2*sin(theta)^2;
e2xy = cos(theta)*sin(theta)*(n2x^2-n2y^2);
e2yx = e2xy;

Rx = 0.30;
Ry = 0.20;
side = 0.2;

dx = 0.0025;        % grid size (x)
dy = dx;            % grid size (y)

lambda = 1.00;      % wavelength
nmodes = 2;         % number of modes to compute

[x,y,xc,yc,nx,ny,epsxx,edges] = ...
    waveguidemeshfull([n1,sqrt(e2xx),n1],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 
[x,y,xc,yc,nx,ny,epsxy,edges] = ...
    waveguidemeshfull([0,sqrt(e2xy),0],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 
[x,y,xc,yc,nx,ny,epsyx,edges] = ...
    waveguidemeshfull([0,sqrt(e2yx),0],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 
[x,y,xc,yc,nx,ny,epsyy,edges] = ...
    waveguidemeshfull([n1,sqrt(e2yy),n1],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 
[x,y,xc,yc,nx,ny,epszz,edges] = ...
    waveguidemeshfull([n1,n2z,n1],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 

% Now we stretch out the mesh at the boundaries:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[80,80,80,80],[4,4,4,4]);

[Hx,Hy,neff] = wgmodes (lambda, n2y, nmodes, dx, dy, epsxx, epsxy, epsyx, epsyy, epszz, '0000');

fprintf(1,'neff = %7.5f\n',neff);

figure(1);

for ii = 1:nmodes,
  subplot(nmodes,2,2*(ii-1)+1);
  contourmode(x,y,Hx(:,:,ii));
  title(sprintf('Hx (mode %d)',ii));
  for v = edges, line(v{:}); end  
  subplot(nmodes,2,2*(ii-1)+2);
  contourmode(x,y,Hy(:,:,ii));
  title(sprintf('Hy (mode %d)',ii));
  for v = edges, line(v{:}); end  
end

