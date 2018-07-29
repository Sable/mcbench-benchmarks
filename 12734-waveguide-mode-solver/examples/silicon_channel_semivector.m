% This example computes all of the field components of a
% silicon-on-insulator nanowire waveguide.

% Refractive indices
n1 = 1.46;          % SiO2 lower cladding
n2 = 3.50;          % Silicon core
n3 = 1.00;          % Air upper cladding

% Vertical dimensions:
h1 = 500;           % lower cladding (nm)
h2 = 200;           % silicon core (nm)
h3 = 500;           % upper cladding (nm)

% Horizontal dimensions:
w = 400;            % waveguide full-width (nm)
side = 500;         % space on side of waveguide (nm)

% Grid spacing:
dx = 2.5;           % grid size (x)
dy = dx;            % grid size (y)

lambda = 1550;      % wavelength (nm)
nmodes = 1;         % number of modes to compute

[x,y,xc,yc,nx,ny,eps,edges] = ...
    waveguidemesh([n1,n2,n3],[h1,h2,h3],h2,w/2,side,dx,dy);

% Now we stretch out the mesh at the boundaries:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[200,200,200,0],[1.5,1.5,1.5,1]);

[Ex,neff] = svmodes(lambda,n2,nmodes,dx,dy,eps,'000S','EX'); 
fprintf(1,'neff(TE) = %7.5f\n',neff);

colormap(jet(256));

contourmode(x,y,Ex);
hold on;
imagemode(xc,yc,Ex,'Ex (semivectorial)');
hold off;
title('Ex (semivectorial)'); xlabel('x'); ylabel('y'); 
for v = edges, line(v{:}); end
