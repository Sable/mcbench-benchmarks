% Calculate the (circularly polarized) modes of a gyrotropic
% ridge waveguide.  This example incorporates complex
% off-diagonal elements in the permittivity tensor, in order
% to model the faraday effect in the presence of an applied DC
% magnetic field.

lambda = 1.485;      % wavelength (um)

% Refractive indices:
dn = 1.85e-4;       % YIG birefringence
n1 = 1.94;          % lower cladding (GGG)
n2 = 2.18;          % lower cladding (Bi:YIG)
n3 = 2.19;          % core (Bi:YIG)
n4 = 1;             % upper cladding (air)
delta = +2.4e-4;    % Faraday rotation constant

% Vertical dimensions:
h1 = 0.5;           % lower cladding
h2 = 3.1;           % cladding
h3 = 3.9;           % core

h4 = 0.5;           % upper cladding
rh = 0.500;         % Ridge height

% Horizontal dimensions
rw = 4.0;           % Ridge half-width
side = 6.0;         % Space on side

% Grid size
dx = 0.100;         % grid size (horizontal)
dy = 0.050;         % grid size (vertical)

nmodes = 2;         % number of modes to compute

[x,y,xc,yc,nx,ny,epsxx,edges] = waveguidemeshfull([n1,n2-dn,n3-dn,n4], ...
                                              [h1,h2,h3,h4],rh,rw,side,dx,dy);
epszz = epsxx;  
[x,y,xc,yc,nx,ny,epsyy,edges] = waveguidemeshfull([n1,n2,n3,n4], ...
                                                [h1,h2,h3,h4],rh,rw,side,dx,dy);
[x,y,xc,yc,nx,ny,epsxy,edges] = waveguidemeshfull([0,sqrt(delta),sqrt(delta),0], ...
                                                [h1,h2,h3,h4],rh,rw,side,dx,dy);
epsxy = j*epsxy;
epsyx = -epsxy;

% Now we stretch out the mesh at the boundaries:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[10,10,60,60],[2,2,5,5]);

[Hx,Hy,neff] = wgmodes (lambda, n3, nmodes, dx, dy, epsxx, ...
                        epsxy, epsyx, epsyy, epszz, '0000');
fprintf(1,'neff = %8.6f\n',neff);
beta = 2*pi*real(neff)/lambda;
Lb = -pi/diff(beta);
fprintf(1,'Lb = %.3f mm\n\n',Lb/1000);

% Report the transverse Stokes parameters
S0 = abs(Hx).^2 + abs(Hy).^2;
S1 = abs(Hx).^2 - abs(Hy).^2;
S2 = 2*real(Hx.*conj(Hy));
S3 = 2*imag(Hx.*conj(Hy));
el = 180*atan(S3./sqrt(S1.^2 + S2.^2))/pi;
az = 180*atan2(S2,S1)/pi;

% locate peak value of S0
[pk,jj] = max(reshape(S0(:,:,1),(nx+1)*(ny+1),1));
ix = reshape((1:nx+1)'*ones(1,ny+1),(nx+1)*(ny+1),1);
ix = ix(jj);
iy = reshape( ones(nx+1,1)*(1:ny+1),(nx+1)*(ny+1),1);
iy = iy(jj);

fprintf(1,'Transverse Stokes Parameters at (x,y) = (%.1f,%.1f) um\n', ...
        x(ix),y(iy));
fprintf('Mode     S0       S1       S2       S3    az(deg)  el(deg)\n');
for ii = 1:nmodes,
  fprintf(1,'%2d   %7.4f  %+7.4f  %+7.4f  %+7.4f  %+7.2f  %+7.2f\n',...
          ii,S0(ix,iy,ii),S1(ix,iy,ii),S2(ix,iy,ii),S3(ix,iy,ii),...
          az(ix,iy,ii),el(ix,iy,ii))
end

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

figure(2);

Hrcp = (Hx + j*Hy)/sqrt(2);
Hlcp = (Hx - j*Hy)/sqrt(2);

for ii = 1:nmodes,
  subplot(nmodes,2,2*(ii-1)+1);
  contourmode(x,y,Hrcp(:,:,ii));
  title(sprintf('Hrcp (mode %d)',ii));
  for v = edges, line(v{:}); end
  
  subplot(nmodes,2,2*(ii-1)+2);
  contourmode(x,y,Hlcp(:,:,ii));
  title(sprintf('Hlcp (mode %d)',ii));
  for v = edges, line(v{:}); end
end
