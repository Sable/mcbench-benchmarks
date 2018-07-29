% This example illustrates how to use perfectly matched layers
% at the edges of the computation window. The waveguide
% considered here is the same as in 'basic_semivector.m', with
% the exception that we have added a substrate layer that has
% the same refractive index of the core.  The modesolver
% computes a complex propagation constant that includes the
% propagation loss associated with radiation into the
% substrate.  
%
% Note that the perfectly-matched layer is constructed using
% the stretchmesh routine, with a complex stretching factor
% (i.e., complex coordinate stretching.)

% Refractive indices:
ns = 3.44;          % Substrate
n1 = 3.34;          % Lower cladding
n2 = 3.44;          % Core
n3 = 1.00;          % Upper cladding (air)

% Vertical dimensions:
hs = 4.0;           % Substrate
h1 = 1.1;           % Lower cladding
h2 = 1.3;           % Core thickness
h3 = 0.5;           % Upper cladding
rh = 1.1;           % Ridge height

% Horizontal dimensions:
rw = 1.0;           % Ridge half-width
side = 1.5;         % Space on side

% Grid size:
dx = 0.0125;        % grid size (horizontal)
dy = 0.0125;        % grid size (vertical)

lambda = 1.55;      % vacuum wavelength
nmodes = 1;         % number of modes to compute

fprintf (1,'generating index mesh...\n');
[x,y,xc,yc,nx,ny,eps,edges] = waveguidemesh([ns,n1,n2,n3],[hs,h1,h2,h3], ... 
                                            rh,rw,side,dx,dy); 

% Complex coordinate stretching:
[x,y,xc,yc,dx,dy] = stretchmesh(x,y,[0,160,20,0],1+j*2);

% NOTE:  when analyzing leaky modes, it is important that you
% provide a good guess, usually by solving the mode of an
% equivalent non-leaky structure first.

guess = 3.388688;

[Hx,Hy,neff] = wgmodes(lambda,guess,nmodes,dx,dy,eps,'000A');

fprintf(1,'Real[nte] = %.6f\n',real(neff));
fprintf(1,'Imag[nte] = %.6e\n',imag(neff));
alpha = -2000*imag(neff)*2*pi/lambda;	% cm^-1
dBpercm = 10*alpha/log(10);
fprintf(1,'Attenuation = %7.5f dB/cm\n',dBpercm);

Hx = Hx/max(Hy(:));
Hy = Hy/max(Hy(:));

subplot(121);
contourmode(x,y,real(Hx));
title('Hx (TE mode)'); xlabel('x'); ylabel('y'); 
for v = edges, line(v{:}); end

subplot(122);
contourmode(x,y,real(Hy));
title('Hy (TE mode)'); xlabel('x'); ylabel('y'); 
for v = edges, line(v{:}); end
