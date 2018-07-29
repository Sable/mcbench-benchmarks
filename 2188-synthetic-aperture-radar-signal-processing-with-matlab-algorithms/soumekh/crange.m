
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %        CROSS-RANGE IMAGING         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


colormap(gray(256))
cj=sqrt(-1);
pi2=2*pi;
%
c=3e8;              % propagation speed
fc=200e6;           % frequency
lambda=c/fc;        % Wavelength
k=pi2/lambda;       % Wavenumber
Xc=1.e3;            % Range distance to center of target area
%
% Case 1:
L=400;              % synthetic aperture is 2*L
Y0=100;             % target area in cross-range is within [Yc-Y0,Yc+Y0]
Yc=0;               % Cross-range distance to center of target area
%
% Case 2:
% L=150;
% Y0=200;
% Yc=.5e3;
%
theta_c=atan(Yc/Xc);  % squint angle to center of target area
Rc=sqrt(Xc^2+Yc^2);   % squint range to center of target area
kus=2*k*sin(theta_c); % Doppler frequency shift in ku domain due to squint
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program performs slow-time compression to save PRF   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
Xcc=Xc/(cos(theta_c)^2);       % redefine Xc by Xcc for squint processing
%
du=(Xcc*lambda)/(4*(Y0+L));    % sample spacing in aperture domain
duc=(Xcc*lambda)/(4*Y0);       % sample spacing in aperture domain
                               % for compressed signal
DY=(Xcc*lambda)/(4*L);         % Cross-range resolution
%
L_min=max(Y0,L);               % Zero-padded aperture
%
% u domain parameters and arrays for compressed signal
%
mc=2*ceil(L_min/duc);             % number of samples on aperture
uc=duc*(-mc/2:mc/2-1);            % synthetic aperture array
dkuc=pi2/(mc*duc);                % sample spacing in ku domain
kuc=dkuc*(-mc/2:mc/2-1);          % kuc array
%
dku=dkuc;                         % sample spacing in ku domain
%
% u domain parameters and arrays for Synthetic aperture signal
%
m=2*ceil(pi/(du*dku));            % number of samples on aperture
du=pi2/(m*dku);
u=du*(-m/2:m/2-1);                % synthetic aperture array
ku=dku*(-m/2:m/2-1);              % ku array
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%          SIMULATION      %%%%%%%          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ntarget=4;             % Number of targets
%
% Targets' coordinates and reflectivity

yn(1)=0;             fn(1)=1;
yn(2)=.7*Y0;         fn(2)=1;
yn(3)=yn(2)-4*DY;    fn(3)=1.;
yn(4)=-.8*Y0;        fn(4)=1;
%
s=zeros(1,mc);         % Measured Echoed Signal (Baseband)
for i=1:ntarget;
 dis=sqrt(Xc^2+(Yc+yn(i)-uc).^2);
 s=s+fn(i)*exp(-cj*2*k*dis).*(abs(uc) <= L);
end;
%
s=s.*exp(-cj*kus*uc);     % Slow-time baseband conversion for squint
fs=fty(s);                % aliased aperture signal spectrum
%
plot(uc,real(s))
xlabel('Synthetic Aperture u, meters')
ylabel('Real Part')
title('Aliased Aperture Signal')
axis([uc(1) uc(mc) 1.1*min(real(s)) 1.1*max(real(s))]);
axis('square')
print P2.1a.ps
pause(1)
%
plot(kuc+kus,abs(fs))
xlabel('Synthetic Aperture Frequency ku, rad/m')
ylabel('Magnitude')
title('Aliased Aperture Signal Spectrum')
axis('square')
print P2.2a.ps
pause(1)

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  COMPRESSION-INTERPOLATION-DECOMPRESSION TO UNALIAS  %%
%%                   APERTURE SIGNAL                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
s=s.*exp(cj*kus*uc);
              % Original signal before baseband conversion for squint
cs=s.*exp(cj*2*k*sqrt(Xc^2+(Yc-uc).^2));  % compressed signal

%
plot(uc,real(cs))
xlabel('Synthetic Aperture u, meters')
ylabel('Real Part')
title('Compressed Aperture Signal')
axis('square')
axis([uc(1) uc(mc) 1.1*min(real(cs)) 1.1*max(real(cs))]);
print P2.3a.ps
pause(1)

cs=[cs,cs(mc:-1:1)];  % Append mirror image in slow-time to reduce
                      % wrap around errors in interpolation (upsampling)

fcs=fty(cs);          % F.T. of compressed signal w.r.t. u
%
plot(dkuc*(-mc:mc-1),abs(fcs))
xlabel('Synthetic Aperture Frequency ku, rad/m')
ylabel('Magnitude')
title('Compressed Aperture Signal Spectrum')
axis('square')
axis([-mc*dkuc mc*dkuc -.05*max(abs(fcs)) 1.05*max(abs(fcs))]);
print P2.4a.ps
pause(1)

% Zero-padding in ku domain
%
mz=m-mc;        % number of zeros is 2*mz
fcs=(m/mc)*[zeros(1,mz),fcs,zeros(1,mz)];
%
plot(dku*(-m:m-1),abs(fcs))
xlabel('Synthetic Aperture Frequency ku, rad/m')
ylabel('Magnitude')
title('Compressed Aperture Signal Spectrum after Zero-padding')
axis('square')
axis([-dku*m dku*m -.05*max(abs(fcs)) 1.05*max(abs(fcs))]);
print P2.5a.ps
pause(1)
%
cs=ifty(fcs);
cs=cs(:,1:m);            % Remove mirror image in slow-time

plot(u,real(cs))
xlabel('Synthetic Aperture u, meters')
ylabel('Real Part')
title('Compressed Aperture Signal after Upsampling')
axis([u(1) u(m) 1.1*min(real(cs)) 1.1*max(real(cs))]);
axis('square')
print P2.6a.ps
pause(1)
%
s=cs.*exp(-cj*2*k*sqrt(Xc^2+(Yc-u).^2));  % decompressed signal
s=s.*exp(-cj*kus*u);  % Baseband conversion for squint

fs=fty(s);

%
plot(u,real(s))
xlabel('Synthetic Aperture u, meters')
ylabel('Real Part')
title('Aperture Signal after Upsampling')
axis([u(1) u(m) 1.1*min(real(s)) 1.1*max(real(s))]);
axis('square')
print P2.7a.ps
pause(1)
%
plot(ku+kus,abs(fs))
xlabel('Synthetic Aperture Frequency ku, rad/m')
ylabel('Magnitude')
title('Aperture Signal Spectrum after Upsampling')
axis('square')
print P2.8a.ps
pause(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                  RECONSTRUCTION               %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%% NOTE: ku array corresponds to baseband Doppler domain
%%%       Add kus (squint Doppler shift) for true ku values
%
kx=4*(k^2)-(ku+kus).^2;
kx=sqrt(kx.*(kx > 0));        % kx array
%
fs0=(kx > 0).*exp(cj*kx*Xc+cj*(ku+kus)*Yc+cj*.25*pi); % reference signal
%
F=fs.*fs0;     % Slow-time matched filtering
f=ifty(F);
plot(u,abs(f))         % also try "real" and "imag" parts of "f" array
xlabel('Cross-range y, meters')
ylabel('Magnitude')
title('Cross-range Reconstruction')
axis('square')
axis([-Y0 Y0 0 1.1*max(abs(f))]);
print P2.9a.ps
pause(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   REDUCING BANDWIDTH OF RECONSTRUCTED IMAGE   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fc=fty(f.*exp(-cj*2*k*sqrt(Xc^2+(Yc+u).^2)+cj*kus*u));
plot(ku,abs(Fc))
xlabel('Cross-range Spatial Frequency ky, rad/m')
ylabel('Magnitude')
title('Compressed Target Function Spectrum')
axis('square')
print P2.10a.ps
pause(1)

