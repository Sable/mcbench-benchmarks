% This example demonstrates how to use the auxilliary routine
% (postprocess.m) to calculate the four remaining field
% components (Hz, Ex, Ey, Ez) once the transverse magnetic
% field components (Hx, Hy) are known.  The waveguide
% considered here is a uniaxial channel waveguide with the
% c-axis oriented at pi/4 relative to the x-y axes.

n1 = 1.55;
n2x = 2.156;
n2y = 2.232;
n2z = 2.232;
theta = pi/4;

e2xx = n2x^2*cos(theta)^2 + n2y^2*sin(theta)^2;
e2yy = n2y^2*cos(theta)^2 + n2x^2*sin(theta)^2;
e2xy = cos(theta)*sin(theta)*(n2x^2-n2y^2);
e2yx = e2xy;

Rx = 0.30;
Ry = 0.20;
side = 0.20;

dx = 0.0025;        % grid size (x)
dy = dx;            % grid size (y)

lambda = 1.00;      % wavelength
nmodes = 1;         % number of modes to compute

fprintf (1,'generating index mesh...\n');

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

[Hz,Ex,Ey,Ez] = postprocess (lambda, neff, Hx, Hy, dx, dy, epsxx, epsxy, epsyx, epsyy, epszz, '0000');

figure(1);

subplot(231);
contourmode(x,y,Hx);
title('Hx');
for v = edges, line(v{:}); end

subplot(232);
contourmode(x,y,Hy);
title('Hy');
for v = edges, line(v{:}); end

subplot(233);
contourmode(x,y,Hz);
title('Hz');
for v = edges, line(v{:}); end

subplot(234);
contourmode(x,y,Ex);
title('Ex');
for v = edges, line(v{:}); end

subplot(235);
contourmode(x,y,Ey);
title('Ey');
for v = edges, line(v{:}); end

subplot(236);
contourmode(x,y,Ez);
title('Ez');
for v = edges, line(v{:}); end

figure(2);

ii = 1;
colormap(jet(256));
hn = abs(interp2(y,x,Hy,side+Ry,0));
en = abs(interp2(yc,xc,Ex,side+Ry,0));

subplot(231);
imagemode(x,y,Hx/hn);
title(sprintf('Hx (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(232);
imagemode(x,y,Hy/hn);
title(sprintf('Hy (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(233);
imagemode(x,y,Hz/hn);
title(sprintf('Hz (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(234);
imagemode(x,y,Ex/en);
title(sprintf('Ex (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(235);
imagemode(x,y,Ey/en);
title(sprintf('Ey (mode %d)',ii));
for v = edges, line(v{:}); end

subplot(236);
imagemode(x,y,Ez/en);
title(sprintf('Ez (mode %d)',ii));
for v = edges, line(v{:}); end
