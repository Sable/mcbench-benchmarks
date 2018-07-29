% This example shows how to calculate the even and odd modes
% of two coupled waveguides, using the semivectorial modesolver

% Refractive indices:
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Layer heights:
h1 = 2.0;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding
rh = 1.1;           % Ridge height

% Horizontal dimensions:
rw = 1.0;           % Ridge half-width
d = 2.5;            % center-to-center separation
side = 2.5;         % Space on side

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

lambda = 1.55;      % wavelength
nmodes = 1;         % number of modes to compute

[x,y,xc,yc,nx,ny,eps,edges] = waveguidemeshfull([n1,n2,n3],[h1,h2,h3],...
                                          rh,rw,[(d/2-rw),side],dx,dy);

% First, we calculate the symmetric mode

[Ex1,neff1] = svmodes(lambda,n2,nmodes,dx,dy,eps,'000S','EX');
fprintf(1,'neff(1) = %.6f\n',neff1);

% Next, we calculate the symmetric mode

[Ex2,neff2] = svmodes(lambda,n2,nmodes,dx,dy,eps,'000A','EX');
fprintf(1,'neff(2) = %.6f\n',neff2);

subplot(211);
contourmode(x,y,Ex1);
title('Ex (Symmetric TE Mode)'); xlabel('x'); ylabel('y'); 
for v = edges, line(v{:}); end

subplot(212);
contourmode(x,y,Ex2);
title('Ex (Antisymmetric TE Mode)'); xlabel('x'); ylabel('y'); 
for v = edges, line(v{:}); end
