% This example shows how to calculate the TM_01 mode of a step-index
% fiber.  The magnetic field for the TM_01 mode is azimuthally
% symmetric, which means that both Hx and Hy are of the same
% magnitude, making this an excellent test case for the
% full-vector modesolver.  It also compares the numerically
% calculated result with the exact solution.  Note that the
% modes look virtually identical, but there is a discrepancy
% betweeen the numerically-computed eigenvalue and the exact
% eigenvalue.  This is thought to be caused by the the
% inaccuracy of representing a curved core-clad interface with
% a staircase function.

% Refractive indices:
nco = 2.5;          % core index
ncl = 1.5;          % cladding index
r = 0.30;           % core radius (um)

side = 0.2;         % space on side (um)

dx = 0.002;         % grid size (horizontal)
dy = 0.002;         % grid size (vertical)

lambda = 1;         % wavelength
nmodes = 1;         % number of modes to compute

% Boundary conditions for antisymmetric mode
boundary = '0A0S'; 

% Set up finite difference mesh:
[x,y,xc,yc,nx,ny,eps] = fiber([nco,ncl],[r],side,dx,dy);

% Now we stretch out the mesh at the boundaries:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[96,0,96,0],[4,1,4,1]);

% Solve for mode (using transverse H modesolver)
[Hx,Hy,neff] = wgmodes (lambda, nco, nmodes, dx, dy, eps, ...
                         boundary); 
fprintf(1,'neff (finite difference) = %8.6f\n',neff);

% Now solve for the exact eigenmodes
V = 2*pi*r/lambda*sqrt(nco^2-ncl^2);
U = fzero(@(U) ...
           nco^2*besselj(1,U)/(U*besselj(0,U)) + ...
           ncl^2*besselk(1,sqrt(V^2-U^2))/ ...
           (sqrt(V^2-U^2)*besselk(0,sqrt(V^2-U^2))), 3.2);
W = sqrt(V^2-U^2);
neff0 = sqrt(nco^2 - (U/(2*pi*r/lambda))^2);
fprintf(1,'neff (exact solution)    = %8.6f\n',neff0);

rho = sqrt(x.^2*ones(size(y)) + ones(size(x))*y.^2);
sinphi = ones(size(x))*y./rho;
cosphi = x*ones(size(y))./rho;
Hx0 = zeros(size(rho));
Hy0 = zeros(size(rho));
kv = find(rho < r);
Hx0(kv) = -sinphi(kv).*besselj(1,U*rho(kv)./r)/besselj(1,U);
Hy0(kv) = cosphi(kv).*besselj(1,U*rho(kv)./r)/besselj(1,U);
kv = find(rho >= r);
Hx0(kv) = -sinphi(kv).*besselk(1,W*rho(kv)./r)/besselk(1,W);
Hy0(kv) = cosphi(kv).*besselk(1,W*rho(kv)./r)/besselk(1,W);
[hmax,kv] = max(abs(Hx0(:)));
hmax = Hx0(kv);
Hx0 = Hx0/hmax;
Hy0 = Hy0/hmax;

figure(1);

subplot(221);
contourmode(x,y,Hx);
title('Hx (finite difference)');

subplot(222);
contourmode(x,y,Hy);
title('Hy (finite difference)');

subplot(223);
contourmode(x,y,Hx0);
title('Hx (exact)');

subplot(224);
contourmode(x,y,Hy0);
title('Hy (exact)');

