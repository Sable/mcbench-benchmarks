% Calculate the fundamental mode of an electrooptic polymer
% ridge waveguide, with the core region poled at an angle of
% pi/4 relative to the vertical.  

lambda = 1.55;      % wavelength (um)

% Refractive indices:

n1 = 1.504;         % lower cladding
n2x = 1.612;        % core (ordinary)
dn = 0.04;          % core birefringence
n2y = n2x + dn;     % core (extraordinary)
n2z = n2x;          % core (ordinary)
n3 = 1.488;         % upper cladding
theta = pi/4;       % poling orientation

% Rotate epsilon matrix for core region
e2xx = n2x^2*cos(theta)^2 + n2y^2*sin(theta)^2;
e2yy = n2y^2*cos(theta)^2 + n2x^2*sin(theta)^2;
e2xy = cos(theta)*sin(theta)*(n2x^2-n2y^2);
e2yx = e2xy;

% Layer heights:
h1 = 2.5;           % lower cladding
h2 = 3.0;           % core
h3 = 2.5;           % upper cladding

rh = 0.50;          % Ridge height
rw = 3.0;           % Ridge half-width
side = 12.0;        % Space on side

dx = 0.050;         % grid size (horizontal)
dy = 0.100/3;       % grid size (vertical)

nmodes = 1;         % number of modes to compute
guess = n2y;

fprintf (1,'generating index mesh...\n');
[x,y,xc,yc,nx,ny,epsxx,edges] = waveguidemeshfull([n1,sqrt(e2xx),n3], ...
                                            [h1,h2,h3],rh,rw,side,dx,dy);
[x,y,xc,yc,nx,ny,epsxy,edges] = waveguidemeshfull([0,sqrt(e2xy),0], ...
                                            [h1,h2,h3],rh,rw,side,dx,dy);
[x,y,xc,yc,nx,ny,epsyx,edges] = waveguidemeshfull([0,sqrt(e2yx),0], ...
                                            [h1,h2,h3],rh,rw,side,dx,dy);
[x,y,xc,yc,nx,ny,epsyy,edges] = waveguidemeshfull([n1,sqrt(e2yy),n3], ...
                                            [h1,h2,h3],rh,rw,side,dx,dy);
[x,y,xc,yc,nx,ny,epszz,edges] = waveguidemeshfull([n1,n2z,n3], ...
                                            [h1,h2,h3],rh,rw,side,dx,dy);

% Now we stretch out the mesh at the boundaries:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[10,10,40,40],[1,1,2,2]);

[Hx,Hy,neff] = wgmodes (lambda, guess, nmodes, dx, dy, epsxx, ...
                        epsxy, epsyx, epsyy, epszz, '0000');

fprintf(1,' neff = %8.6f\n',neff);

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

