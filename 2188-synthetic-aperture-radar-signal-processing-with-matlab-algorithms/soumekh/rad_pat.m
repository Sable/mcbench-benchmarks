
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %          RADAR RADIATION PATTERN          %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cj=sqrt(-1);
pi2=2*pi;

c=3e8;                   % propagation speed
w=pi2*1e9;               % radar frequency (1GHz)
% w=pi2*2e9;               % radar frequency (2GHz)
k=w/c;                   % wavenumber
lambda=pi2/k;            % wavelength
x=100;                   % range
D=1;                     % radar diameter
guard=4;                 % guard band factor in y and ky domains
%
dell=lambda/4;           % sample spacing on surface of radar for
                         % evaluating ell surface integral
nell2=ceil(D/(2*dell));
nell=2*nell2+1;          % number of surface elements on radar
ell=dell*(-nell2:nell2); % cross-range of surface elements on radar

% OPTIONS: option=1 is for a planar radar
%          option=2 is for a parabolic radar (without a feed)

option=1;

if option == 1,          % Planar Radar

 xell=zeros(1,nell);     % range of surface elements on radar
 B=(x*lambda)/D;         % beamwidth (y domain support)
 kumax=(pi2/D);          % ky (slow-time Doppler) domain support
 jac=ones(1,nell);       % radar surface jacobian

elseif option == 2,            % Parabolic Radar
 
 xf=2;                         % focal range
 xell=(ell.^2)/(2*xf);         % range of surface elements on radar
 phd=atan(D/(2*xf));           % divergence angle
 B=x*sin(phd);                 % beamwidth (y domain support)
 kumax=k*sin(phd);             % ky (slow-time Doppler) domain support
 jac=sqrt(1+(ell/xf).^2);      % radar surface jacobian

end;

dy=pi/(guard*kumax);     % sample spacing in y domain for h(x,y,omega)
ny=guard*2*ceil(B/dy);   % number of y samples
y=dy*(-ny/2:ny/2-1);     % y array
dky=pi2/(ny*dy);         % sample spacing in ky (Doppler) domain
ky=dky*(-ny/2:ny/2-1);   % ky (Doppler) array

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Transmit-mode Radiation Pattern  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dis=sqrt(((x-xell(:)).^2) ...
  *ones(1,ny)+(ones(nell,1)*y-ell(:)*ones(1,ny)).^2);
ht=sum(((jac(:)*ones(1,ny)).*exp(-cj*k*dis))./dis);

plot(y,real(ht),'-',y,abs(ht),'--');axis('square')
xlabel('Cross-range Y, meters')
ylabel('Real Part & Magnitude')
title('Transmit-mode Radiation Pattern')
print P3.1a.ps
pause(1)

dis=sqrt(x^2+y.^2);
h0t=exp(-cj*k*dis)./dis;        % ideal (omni-directional) source
                                % spatial radiation pattern
%
hd=ht.*conj(h0t);      % radiation pattern deviation from ideal source
phd=angle(hd);          % and its phase
I=ny/2+1:-1:1;
temp=unwrap(angle(hd(I)));
uphd=zeros(1,ny);
uphd(I)=temp;
uphd(ny/2+2:ny)=temp(2:ny/2);       % and its unwrapped phase
%
plot(y,uphd);
axis('square')
xlabel('Cross-range Y, meters')
ylabel('Phase, radians')
title('Unwrapped Phase Deviation form Ideal Source')
axis([y(1) y(ny) -4 4])
print P3.2a.ps
pause(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Doppler Spectrum of Transmit-mode Radiation Pattern  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fht=fty(ht);
plot(ky,real(fht),'-',ky,abs(fht),'--');axis('square')
xlabel('Spatial (Doppler) Frequency K_y, radians/m')
ylabel('Real Part & Magnitude')
title('Transmit-mode Radiation Pattern Doppler Spectrum')
print P3.3a.ps
pause(1)

kxt=k^2-ky.^2;
kxt=sqrt((kxt > 0).*kxt);
fh0t=exp(-cj*kxt*x-cj*.25*pi);    % ideal (omni-directional) source
                                  % Doppler spectrum
%
fhd=fht.*conj(fh0t);               % deviation from ideal source
pfhd=angle(fhd);                   % and its phase
I=ny/2+1:-1:1;
temp=unwrap(angle(fhd(I)));
upfhd=zeros(1,ny);
upfhd(I)=temp;
upfhd(ny/2+2:ny)=temp(2:ny/2);       % and its unwrapped phase

%
plot(ky,upfhd);
axis('square')
xlabel('Spatial (Doppler) Frequency K_y, radians/m')
ylabel('Phase, radians')
title('Doppler Domain Unwrapped Phase Deviation form Ideal Source')
axis([ky(1) ky(ny) -4 4])
print P3.4a.ps
pause(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       T&R Radiation Pattern      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=ht.^2;

plot(y,real(h),'-',y,abs(h),'--');axis('square')
xlabel('Cross-range Y, meters')
ylabel('Real Part & Magnitude')
title('T&R Radiation Pattern')
print P3.5a.ps
pause(1)

h0=exp(-cj*2*k*sqrt(x^2+y.^2));    % ideal T&R radiation pattern
%
hd=h.*conj(h0);         % radiation pattern deviation from ideal T&R
phd=angle(hd);          % and its phase
I=ny/2+1:-1:1;
temp=unwrap(angle(hd(I)));
uphd=zeros(1,ny);
uphd(I)=temp;
uphd(ny/2+2:ny)=temp(2:ny/2);       % and its unwrapped phase
%
plot(y,uphd);
axis('square')
xlabel('Cross-range Y, meters')
ylabel('Phase, radians')
title('Unwrapped Phase Deviation form Ideal T&R')
axis([y(1) y(ny) -4 4])
print P3.6a.ps
pause(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Doppler Spectrum of Transmit-Receive Mode Radiation Pattern %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fh=fty(h);
plot(ky,real(fh),'-',ky,abs(fh),'--');axis('square')
xlabel('Spatial (Doppler) Frequency K_y, radians/m')
ylabel('Real Part & Magnitude')
title('T&R Radiation Pattern Doppler Spectrum')
print P3.7a.ps
pause(1)

kx=(2*k)^2-ky.^2;
kx=sqrt((kx > 0).*kx);
fh0=exp(-cj*kx*x-cj*.25*pi);    % ideal Transmitter-Receiver
                                % Doppler spectrum
%
fhd=fh.*conj(fh0);               % deviation from ideal T&R
pfhd=angle(fhd);                 % and its phase
I=ny/2+1:-1:1;
temp=unwrap(angle(fhd(I)));
upfhd=zeros(1,ny);
upfhd(I)=temp;
upfhd(ny/2+2:ny)=temp(2:ny/2);       % and its unwrapped phase

%
plot(ky,upfhd);
axis('square')
xlabel('Spatial (Doppler) Frequency K_y, radians/m')
ylabel('Phase, radians')
title('Doppler Domain Unwrapped Phase Deviation form Ideal T&R')
axis([ky(1) ky(ny) -4 4])
print P3.8a.ps
pause(1)

