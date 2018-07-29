
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %    PULSED STRIPMAP SAR SIMULATION AND RECONSTRUCTION   %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


colormap(gray(256))
cj=sqrt(-1);
pi2=2*pi;
%
c=3e8;                   % propagation speed
f0=50e6;                 % baseband bandwidth is 2*f0
w0=pi2*f0;
fc=100e6;                % carrier frequency
wc=pi2*fc;
lambda_min=c/(fc+f0);    % Wavelength at highest frequency
lambda_max=c/(fc-f0);    % Wavelength at lowest frequency
kc=(pi2*fc)/c;           % wavenumber at carrier frequency
kmin=(pi2*(fc-f0))/c;    % wavenumber at lowest frequency
kmax=(pi2*(fc+f0))/c;    % wavenumber at highest frequency
%
Xc=500;                  % Range distance to center of target area
X0=200;                  % Target area in range is within [Xc-X0,Xc+X0]
Y0=300;                  % Target area in cross-range is within [-Y0,Y0]
%
D=2*lambda_max;          % Diameter of planar radar
                         % (Beamwidth of a planar radar aperture varies
                         %  with fast-time frequency)
%
Bmin=(Xc-X0)*tan(asin(lambda_min/D));    % Minimum half-beamwidth
Bmax=(Xc+X0)*tan(asin(lambda_max/D));    % Maximum half-beamwidth
L=Bmax+Y0;                          % Synthetic aperture length is 2*L

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    u domain parameters and arrays for SAR signal     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
du=D/4;                           % sample spacing in aperture domain
du=du/1.2;                        % 10 percent guard band                    
m=2*ceil(L/du);                   % number of samples on aperture
dku=pi2/(m*du);                   % sample spacing in ku domain
u=du*(-m/2:m/2-1);                % synthetic aperture array
ku=dku*(-m/2:m/2-1);              % ku array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% u domain parameters and arrays for compressed SAR signal %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
x_t=[Xc-X0:2*X0:Xc+X0];
lambda_t=[lambda_min:lambda_max-lambda_min:lambda_max];
B_t=x_t(:)*tan(asin(lambda_t/D));
L_t=B_t+Y0;
duc=min(min((x_t(:)*lambda_t)./(4*L_t))); % sample spacing in u domain
                                          % for compressed SAR signal
                                          % Less restrictive: use duc=du or
                                          % duc=du/2
clear x_t lambda_t
dkuc=dku;
mc=2*ceil(pi/(duc*dkuc));      % number of samples on aperture
mc=2^ceil(log(mc)/log(2));     % is chosen to be a power of 2
duc=pi2/(mc*dkuc);
uc=duc*(-mc/2:mc/2-1);         % synthetic aperture array
dkuc=pi2/(mc*duc);             % sample spacing in ku domain
kuc=dkuc*(-mc/2:mc/2-1);       % kuc array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       Fast-time domain parameters and arrays         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
Tp=1.5e-7;                     % Chirp pulse duration
alpha=w0/Tp;                   % Chirp rate
wcm=wc-alpha*Tp;               % Modified chirp carrier
%
Rmin=Xc-X0;
Rmax=sqrt((Xc+X0)^2+Bmax^2);
Ts=(2/c)*Rmin;                 % start time of sampling
Tf=(2/c)*Rmax+Tp;              % end time of sampling
T=Tf-Ts;                       % fast-time interval of measurement
Ts=Ts-.1*T;                    % start slightly earlier (10% guard band)
Tf=Tf+.1*T;                    % end slightly later (10% guard band)
T=Tf-Ts;
theta_ax=asin(lambda_min/D);
Tmin=max(T,(4*X0)/ ...
         (c*cos(theta_ax))); % Minimum required fast-time interval
%
dt=1/(4*f0);                 % Time domain sampling (guard band factor 2)
n=2*ceil((.5*Tmin)/dt);      % number of time samples
t=Ts+(0:n-1)*dt;             % time array for data acquisition
dw=pi2/(n*dt);               % Frequency domain sampling
w=wc+dw*(-n/2:n/2-1);        % Frequency array (centered at carrier)
k=w/c;                       % Wavenumber array
Ik=find(k >= kmin & k <= kmax);
[temp,nk]=size(Ik);
lambda=zeros(1,n);
lambda(Ik)=(pi2*ones(1,nk))./k(Ik);      % Wavelength array
phi_d=asin(lambda/D);                    % Divergence angle
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       Resolution         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DX=c/(4*f0);                      % range resolution
DY=D/2;                           % cross-range resolution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           Parameters of Targets                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ntarget=9;                        % number of targets
% Set ntarget=1 to see "clean" PSF of target at origin
% Try this with other targets

% xn: range;            yn= cross-range;    fn: reflectivity
  xn=zeros(1,ntarget);  yn=xn;              fn=xn;

% Targets within digital spotlight filter
%
  xn(1)=0;              yn(1)=0;            fn(1)=1;
  xn(2)=.7*X0;          yn(2)=-.6*Y0;       fn(2)=1.4;
  xn(3)=0;              yn(3)=-.85*Y0;      fn(3)=.8;
  xn(4)=-.5*X0;         yn(4)=.75*Y0;       fn(4)=1.;
  xn(5)=-.5*X0+DX;      yn(5)=.75*Y0+DY;    fn(5)=1.;

% Targets outside digital spotlight filter  
% (Run the code with and without these targets)
%
  xn(6)=-1.2*X0;        yn(6)=.75*Y0;       fn(6)=1.;
  xn(7)=.5*X0;          yn(7)=1.25*Y0;      fn(7)=1.;
  xn(8)=1.1*X0;         yn(8)=-1.1*Y0;      fn(8)=1.;
  xn(9)=-1.2*X0;        yn(9)=-1.75*Y0;     fn(9)=1.;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                   SIMULATION                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
s=zeros(n,m);        % SAR signal array
%
for i=1:ntarget;
 td=t(:)*ones(1,m)-2*ones(n,1)*sqrt((Xc+xn(i))^2+(yn(i)-u).^2)/c;
 sn=fn(i)*exp(cj*wcm*td+cj*alpha*(td.^2)).*(td >= 0 & td <= Tp & ...
   ones(n,1)*abs(u) <= L & t(:)*ones(1,m) < Tf);

 sn=sn.*exp(-cj*wc*t(:)*ones(1,m));      % Fast-time baseband conversion

%
% calculate (omega,u)-domain beam pattern
     theta_n=ones(nk,1)*atan((yn(i)-u)/(Xc+xn(i)));
     beam_p=zeros(n,m);
     beam_p(Ik,:)=(.5+.5*cos((pi*theta_n)./(phi_d(Ik).'*ones(1,m)))).* ...
        (abs(theta_n) <= phi_d(Ik).'*ones(1,m));
     
% incorporate beam pattern in (omega,u) domain
%
  s=s+iftx(ftx(sn).*beam_p);
end;
%

G=abs(s)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(t,u,256-cg*(G-ng));
axis('square');axis('xy')
xlabel('Fast-time t, sec')
ylabel('Synthetic Aperture (Slow-time) U, meters')
title('Measured Stripmap SAR Signal')
print P6.1.ps
pause(1)
%
td0=t(:)-2*Xc/c;
s0=exp(cj*wcm*td0+cj*alpha*(td0.^2)).*(td0 >= 0 & td0 <= Tp);
s0=s0.*exp(-cj*wc*t(:));            % Baseband reference fast-time signal

s=ftx(s).*(conj(ftx(s0))*ones(1,m));  % Fast-time matched filtering
%
G=abs(iftx(s))';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
tm=(2*Xc/c)+dt*(-n/2:n/2-1);   % fast-time array after matched filtering
image(tm,u,256-cg*(G-ng));
axis('square');axis('xy')
xlabel('Fast-time t, sec')
ylabel('Synthetic Aperture (Slow-time) U, meters')
title('Stripmap SAR Signal after Fast-time Matched Filtering')
print P6.2.ps
pause(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Digital Spotlighting via Slow-time Compression  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%% NOTE: This code performs "narrow-bandwidth" digital spotlighting.
%%       To improve results, convert the code to "wide-bandwidth"
%%       digital spotlighting (polar format processing).
%
% Upsample data before compression for digital spotlighting
%
fs=fty(s);
mz=mc-m;        % number of zeros is 2*mz
fs=(mc/m)*[zeros(n,mz/2),fs,zeros(n,mz/2)];
s=ifty(fs);

Ls=100*du;                 % Half-width of a subaperture (200 samples
                           % within each subaperture)
mcs=2*ceil(Ls/duc);        % Number of subaperture slow-time samples
                           % for compressed SAR signal
mcs=2^ceil(log(mcs)/log(2));    % Readjust to power of 2
if mcs > mc, mcs=mc; end;
ns=mc/mcs;                  % Number of subapertures
us=duc*(-mcs/2:mcs/2-1);    % Subaperture u array
dkus=pi2/(mcs*duc);         % Subaperture ku (Doppler) spacing
kus=dkus*(-mcs/2:mcs/2-1);  % Subaperture ku array
 

s_ds=zeros(n,mc);           % Initialize digital spotlight SAR array

PH=asin(kus/(2*kc));        % Angular Doppler domain
R=(c*tm)/2;                 % Transform fast-time to range

for i=1:ns; i                 % loop for each subaperture
    I=(1:mcs)+(i-1)*mcs;
    Yi=uc(I(mcs/2+1));        % Squint cross-range of i-th subaperture
    tei=atan(Yi/Xc);          % Squint angle of i-th subaperture
    Ri=sqrt(Xc^2+Yi^2);       % Squint radial range of i-th subaperture
    tt=(2*sqrt(Xc^2+uc(I).^2)-2*Ri)/c;
    fpi=iftx(fty(s(:,I).*exp(cj*w(:)*tt)));    % slow-time compression and
                                   % Fourier transform to (t,ku) domain
                                   % to obtain polar format reconstruction
                                   % within i-th subaperture
    W_di=(abs(R(:)*cos(PH+tei)-Xc) < X0 & ...
       abs(R(:)*sin(PH+tei)-Yi) < Y0);         % Digital spotlight filter
    G=(abs(fpi)/max(max(abs(fpi)))+.1*W_di)';
    xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
    image(tm,kuc,256-cg*(G-ng));
    xlabel('Fast-time t, sec')
    ylabel('Synthetic Aperture (Slow-time) Doppler Frequency k_u, rad/m')
    title('Polar Format SAR Reconstruction with Digital Spotlight Filter')
    axis square; axis xy;
    print P6.3.ps
    pause(1)
    s_ds(:,I)=ifty(ftx(fpi.*W_di)).*exp(-cj*w(:)*tt); % decompression
                          % and Fourier transforming to (omega,u) domain
end;
 
% Downsample data in ku domain to remove redundancy
% (Remove zeros which were added before slow-time compression)
%
fs=fty(s_ds);              % F.T. of SAR signal w.r.t. u
%
mz=mc-m;        % number is redundant samples is mz
fs=(m/mc)*fs(:,mz/2+1:mz/2+m);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    2D BEAM PATTERN MATCHED FILTERING     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              CAUTION                            %
% Applying 2D beam pattern matched filter worsens the PSF. For    %
% digital reconstruction via spatial frequency interpolation or   %
% range stacking, one may remove this beam pattern matched filter %
% to improve PSF. However, for TDC and backprojection, removal of %
% this matched filter degrades the reconstruction in certain      %
% frequency bands.                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
phi=zeros(n,m);
Iku=(ones(nk,1)*abs(ku) < 2*k(Ik).'*ones(1,m));
phi(Ik,:)=asin((Iku.*(ones(nk,1)*ku))./(2*k(Ik).'*ones(1,m)));
beam_p=zeros(n,m);
beam_p(Ik,:)=(.5+.5*cos((pi*phi(Ik,:))./(phi_d(Ik).'*ones(1,m)))).* ...
        Iku.*(abs(phi(Ik,:)) <= phi_d(Ik).'*ones(1,m));
     
fs=fs.*beam_p;       % Beam pattern 2D matched filtering. To remove
                     % this filter, use: beam_p=ones(n,m)     

s_ds=ifty(fs);       % Save digitally-spotlighted (omega,u) domain
                     % data for TDC and projection

G=abs(iftx(s_ds))';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(tm,u,256-cg*(G-ng));
axis('square');axis('xy')
xlabel('Fast-time t, sec')
ylabel('Synthetic Aperture (Slow-time) U, meters')
title('Stripmap SAR Signal after Digital Spotlighting')
print P6.4.ps
pause(1)

G=abs(fs)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(k*c/pi2,ku,256-cg*(G-ng));
axis('square');axis('xy')
xlabel('Fast-time Frequency \omega/(2*pi), Hertz')
ylabel('Synthetic Aperture (Slow-time) Frequency k_u, rad/m')
title('Stripmap SAR Signal Spectrum after Digital Spotlighting')
print P6.5.ps
pause(1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    SLOW-TIME DOPPLER SUBSAMPLING     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
if Y0 < L,
 ny=2*ceil(1.2*Y0/du);      % Number of samples in y domain
                            % with 20 percent guard band
 ms=floor(m/ny);            % subsampling ratio
 tt=floor(m/(2*ms));
 I=m/2+1-tt*ms:ms:m/2+1+(tt-1)*ms; % subsampled index in ku domain
 [tt,ny]=size(I);           % number of subsamples
 fs=fs(:,I);                % subsampled SAR signal spectrum
 ky=ku(I);                  % subsampled ky array
 dky=dku*ms;                % ky domain sample spacing
else,
 dky=dku;
 ny=m;
 ky=ku;
end;

dy=pi2/(ny*dky);            % y domain sample spacing
y=dy*(-ny/2:ny/2-1);        % cross-range array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             RECONSTRUCTION           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ky=ones(n,1)*ky;       % ky array
kx=(4*k(:).^2)*ones(1,ny)-ky.^2;
kx=sqrt(kx.*(kx > 0));                  % kx array
%
plot(kx(1:20:n*ny),ky(1:20:n*ny),'.')
xlabel('Spatial Frequency k_x, rad/m')
ylabel('Spatial Frequency k_y, rad/m')
title('Stripmap SAR Spatial Frequency Data Coverage')
axis image; axis xy
print P6.6.ps
pause(1)
%
kxmin=min(min(kx));
kxmax=max(max(kx));
dkx=pi/X0;        % Nyquist sample spacing in kx domain
nx=2*ceil((.5*(kxmax-kxmin))/dkx); % Required number of
                      % samples in kx domain;
                      % This value will be increased slightly
                      % to avoid negative array index
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                         %%%
%%%   FIRST TWO OPTIONS FOR RECONSTRUCTION:                 %%%
%%%                                                         %%%
%%%     1. 2D Fourier Matched Filtering and Interpolation   %%%
%%%     2. Range Stacking                                   %%%
%%%                                                         %%%
%%%     Note: For "Range Stacking," make sure that the      %%%
%%%           arrays nx, x, and kx are defined.             %%%
%%%                                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    2D FOURIER MATCHED FILTERING AND INTERPOLATION    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Matched Filtering
%
fs0=(kx > 0).*exp(cj*kx*Xc+cj*.25*pi ...
           -cj*2*k(:)*ones(1,ny)*Xc); % reference signal complex conjugate
fsm=fs.*fs0;     % 2D Matched filtering

% Interpolation
%
is=8;       % number of neighbors (side lobes) used for sinc interpolator
I=2*is+1;
kxs=is*dkx; % plus/minus size of interpolation neighborhood in KX domain
%
nx=nx+2*is+4;  % increase number of samples to avoid negative
               %  array index during interpolation in kx domain
KX=kxmin+(-is-2:nx-is-3)*dkx;     % uniformly-spaced kx points where
                                  % interpolation is done
kxc=KX(nx/2+1);                   % carrier frequency in kx domain
KX=KX(:)*ones(1,ny);
%
F=zeros(nx,ny);         % initialize F(kx,ky) array for interpolation

for i=1:n;                       % for each k loop
  i                              % print i to show that it is running
 icKX=round((kx(i,:)-KX(1,1))/dkx)+1; % closest grid point in KX domain
 cKX=KX(1,1)+(icKX-1)*dkx;            % and its KX value
 ikx=ones(I,1)*icKX+[-is:is]'*ones(1,ny);
 ikx=ikx+nx*ones(I,1)*[0:ny-1];
 nKX=KX(ikx);
 SINC=sinc((nKX-ones(I,1)*kx(i,:))/dkx);             % interpolating sinc
 HAM=.54+.46*cos((pi/kxs)*(nKX-ones(I,1)*kx(i,:)));  % Hamming window
         %%%%%   Sinc Convolution (interpolation) follows  %%%%%%%%
 F(ikx)=F(ikx)+(ones(I,1)*fsm(i,:)).*(SINC.*HAM);
end
%
%  DISPLAY interpolated spatial frequency domain image F(kx,ky)

KX=KX(:,1).';
KY=ky(1,:);

G=abs(F)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(KX,KY,256-cg*(G-ng));
axis image; axis xy
xlabel('Spatial Frequency k_x, rad/m')
ylabel('Spatial Frequency k_y, rad/m')
title('Wavefront Stripmap SAR Reconstruction Spectrum')
print P6.7.ps
pause(1)

%
f=iftx(ifty(F));     % Inverse 2D FFT for spatial domain image f(x,y)
%
dx=pi2/(nx*dkx);     % range sample spacing in reconstructed image
x=dx*(-nx/2:nx/2-1); % range array
%
% Display SAR reconstructed image

G=abs(f)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(Xc+x,y,256-cg*(G-ng));axis([Xc-X0 Xc+X0 -Y0 Y0]);
axis image; axis xy
xlabel('Range X, meters')
ylabel('Cross-range Y, meters')
title('Wavefront Stripmap SAR Reconstruction')
print P6.8.ps
pause(1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      RANGE STACK WAVEFRONT RECONSTRUCTION       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
f_stack=zeros(nx,ny); % Initialize reconstruction array in (x,y) domain
for i=1:nx; i        % Stack's loop for reconstruction at each range
 f_stack(i,:)=ifty(sum(fs.*exp(cj*kx*(Xc+x(i)) ...
  +cj*.25*pi-cj*2*k(:)*ones(1,ny)*Xc)));
end;

% Remove carrier in range domain
f_stack=f_stack.*exp(-cj*x(:)*kxc*ones(1,ny));
%
f_stack=f_stack/nx; % Scale it for comparison with Fourier interpolation
                    % Use "f_stack-f" to display difference of two
                    % reconstructions
           
G=abs(f_stack)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(Xc+x,y,256-cg*(G-ng));axis([Xc-X0 Xc+X0 -Y0 Y0]);
axis image; axis xy
xlabel('Range X, meters')
ylabel('Cross-range Y, meters')
title('Range Stack Stripmap SAR Reconstruction')
print P6.9.ps
pause(1)
                
F_stack=ftx(fty(f_stack)); % Reconstruction array in spatial frequency
                           % domain; Use "F_stack-F" to display
                           %  difference of two reconstructions
%
G=abs(F_stack)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(KX,KY,256-cg*(G-ng));
axis image; axis xy
xlabel('Spatial Frequency k_x, rad/m')
ylabel('Spatial Frequency k_y, rad/m')
title('Range Stack Stripmap SAR Reconstruction Spectrum')
print P6.10.ps
pause(1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%     TIME DOMAIN CORRELATION RECONSTRUCTION      %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
f_tdc=zeros(nx,ny); % Initialize reconstruction array in (x,y) domain

for i=1:nx; i
   Bmaxi=(Xc+x(i))*tan(asin(lambda/D));  % Half-beamwidth at range x(i)
   for j=1:ny;
      Iu=(ones(n,1)*abs(y(j)-u) <= Bmaxi(:)*ones(1,m));
      t_ij=(2*sqrt((x(i)+Xc)^2+(y(j)-u).^2))/c;
      f_tdc(i,j)=sum(sum(s_ds.*exp(cj*w(:)*(t_ij-tm(n/2+1))).* ...
         (Iu & ones(n,1)*(t_ij >= Ts & t_ij <= Tf))));
   end;
end;

% Remove carrier in range domain
f_tdc=f_tdc.*exp(-cj*x(:)*kxc*ones(1,ny));
%
           
G=abs(f_tdc)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(Xc+x,y,256-cg*(G-ng));axis([Xc-X0 Xc+X0 -Y0 Y0]);
axis image; axis xy
xlabel('Range X, meters')
ylabel('Cross-range Y, meters')
title('TDC Stripmap SAR Reconstruction')
print P6.11.ps
pause(1)
                
F_tdc=ftx(fty(f_tdc));     % Reconstruction array in spatial frequency
%
G=abs(F_tdc)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(KX,KY,256-cg*(G-ng));
axis image; axis xy
xlabel('Spatial Frequency k_x, rad/m')
ylabel('Spatial Frequency k_y, rad/m')
title('TDC Stripmap SAR Reconstruction Spectrum')
print P6.12.ps
pause(1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%           BACKPROJECTION RECONSTRUCTION         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
f_back=zeros(nx,ny); % Initialize reconstruction array in (x,y) domain
n_ratio=100;              % Upsampling ratio in fast-time domain
nu=n_ratio*n;             % Size of upsampled s(t,u) array in t domain
nz=nu-n;                  % Number of zeros
dtu=(n/nu)*dt;            % Fast-time sample spacing of upsampled array
tu=dtu*(-nu/2:nu/2-1);    % Upsampled reference fast-time array
X=x(:)*ones(1,ny);
Y=ones(nx,1)*y;

for j=1:m; j
   t_ij=(2*sqrt((X+Xc).^2+(Y-u(j)).^2))/c;
   t_ij=round((t_ij-tm(n/2+1))/dtu)+nu/2+1;
   it_ij=(t_ij > 0 & t_ij <= nu);
   t_ij=t_ij.*it_ij+nu*(1-it_ij);
   S=ifty([zeros(1,nz/2),s_ds(:,j).',zeros(1,nz/2)])...
      .*exp(cj*wc*tu);                % Upsampled data
   S(nu)=0;
   Bmax_xy=(Xc+X)*tan(asin(lambda_max/D));   % Maximum half-beamwidth
   Iu=(abs(Y-u(j)) <= Bmax_xy);
   f_back=f_back+S(t_ij).*Iu;
end;

clear X Y

% Remove carrier in range domain
f_back=f_back.*exp(-cj*x(:)*kxc*ones(1,ny));
%
  
G=abs(f_back)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(Xc+x,y,256-cg*(G-ng));axis([Xc-X0 Xc+X0 -Y0 Y0]);
axis image; axis xy
xlabel('Range X, meters')
ylabel('Cross-range Y, meters')
title('Backprojection Stripmap SAR Reconstruction')
print P6.13.ps
pause(1)
                
F_back=ftx(fty(f_back));     % Reconstruction array in spatial frequency
%
G=abs(F_back)';
xg=max(max(G)); ng=min(min(G)); cg=255/(xg-ng);
image(KX,KY,256-cg*(G-ng));
axis image; axis xy
xlabel('Spatial Frequency k_x, rad/m')
ylabel('Spatial Frequency k_y, rad/m')
title('Backprojection Stripmap SAR Reconstruction Spectrum')
print P6.14.ps
pause(1)

