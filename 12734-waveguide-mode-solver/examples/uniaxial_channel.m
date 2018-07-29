% This example shows how to find the modes of a birefringent
% (uniaxial) waveguide.  The extraordinary axis of the core
% region is chosen to point in the x direction, such that the
% permittivity tensor is diagonal.

n1 = 1.55;          % cladding index
n2x = 2.156;        % extraordinary index (core)
n2y = 2.232;        % ordinary index (core)
n2z = 2.232;        % ordinary index (core)

Rx = 0.30;
Ry = 0.20;
side = 0.2;

dx = 0.0025;        % grid size (x)
dy = dx;            % grid size (y)

lambda = 1.00;      % wavelength
nmodes = 2;         % number of modes to compute

fprintf (1,'generating index mesh...\n');

[x,y,xc,yc,nx,ny,epsxx,edges] = ...
    waveguidemeshfull([n1,n2x,n1],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 
[x,y,xc,yc,nx,ny,epsyy,edges] = ...
    waveguidemeshfull([n1,n2y,n1],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 
[x,y,xc,yc,nx,ny,epszz,edges] = ...
    waveguidemeshfull([n1,n2z,n1],[side,2*Ry,side],2*Ry,Rx, ...
                  side,dx,dy); 

% Now we stretch out the mesh at the boundaries:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[80,80,80,80],[4,4,4,4]);

[Hx,Hy,neff] = wgmodes (lambda, n2y, nmodes, dx, dy, epsxx, epsyy, epszz, '0000');

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
