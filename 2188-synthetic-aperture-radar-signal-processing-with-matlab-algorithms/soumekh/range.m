

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %       PULSED RANGE IMAGING        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


colormap(gray(256))
cj=sqrt(-1);
pi2=2*pi;
%
c=3e8;                   % Propagation speed
B0=100e6;                % Baseband bandwidth is plus/minus B0
w0=pi2*B0;
fc=1e9;                  % Carrier frequency
wc=pi2*fc;
Xc=2.e3;                 % Range distance to center of target area
X0=50;                   % target area in range is within [Xc-X0,Xc+X0]
%
% Case 1:
 Tp=.1e-6;               % Chirp pulse duration

% Case 2:
 Tp=10e-6;               % Chirp pulse duration

alpha=w0/Tp;             % Chirp rate
wcm=wc-alpha*Tp;         % Modified chirp carrier
%
dx=c/(4*B0);             % Range resolution
%
dt=pi/(2*alpha*Tp);      % Time domain sampling (gurad band plus minus
                         % 50 per) or use dt=1/(2*B0) for a general
                         % radar signal

Tx=(4*X0)/c;             % Range swath echo time period
dtc=pi/(2*alpha*Tx);     % Time domain sampling for compressed signal
                         % (gurad band plus minus 50 per)
%
Ts=(2*(Xc-X0))/c;        % Start time of sampling
Tf=(2*(Xc+X0))/c+Tp;     % End time of sampling

% If Tx < Tp, choose compressed signal parameters for measurement
%
flag=0;                  % flag=0 indicates that Tx > Tp
if Tx < Tp,
 flag=1;                 % flag=1 indicates that Tx < TP
 dt_temp=dt;             % Store dt
 dt=dtc;                 % Choose dtc (dtc > dt) for data acquisition
end;

% Measurement parameters
%
n=2*ceil((.5*(Tf-Ts))/dt);   % Number of time samples
t=Ts+(0:n-1)*dt;             % Time array for data acquisition
dw=pi2/(n*dt);               % Frequency domain sampling
w=wc+dw*(-n/2:n/2-1);        % Frequency array (centered at carrier)
x=Xc+.5*c*dt*(-n/2:n/2-1);   % range bins (array); reference signal is
                             % for target at x=Xc.
kx=(2*w)/c;                  % Spatial (range) frequency array
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ntarget=4;                        % number of targets
%%%%%%%%%%%%% Targets' parameters  %%%%%%%%%%%%%%%%%%
%
% xn: range;               fn: reflectivity
%
xn(1)=0;                   fn(1)=1;
xn(2)=.7*X0;               fn(2)=.8;
xn(3)=xn(2)+2*dx;          fn(3)=1.;
xn(4)=-.5*X0;              fn(4)=.8;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
s=zeros(1,n);              % Initialize echoed signal array

na=8;                      % Number of harmonics in random phase               
ar=rand(1,na);             % Amplitude of harmonics
ter=2*pi*rand(1,na);       % Phase of harmonics

for i=1:ntarget;
   td=t-2*(Xc+xn(i))/c;
   pha=wcm*td+alpha*(td.^2);         % Chirp (LFM) phase
   for j=1:na;                       % Loop for CPM harmonics
      pha=pha+ar(j)*cos((w(n/2+1+j)-wc)*td+ter(j));
   end;
   s=s+fn(i)*exp(cj*pha).*(td >= 0 & td <= Tp);
end;

% If flag=1, i.e., Tx < Tp, perform upsmapling
%
if flag == 1,
 td0=t-2*(Xc+0)/c;
 pha0=wcm*td0+alpha*(td0.^2);        % Reference chirp phase
 scb=conj(s).*exp(cj*pha0);          % Baseband compressed signal
                                     % (This is done by hardware)
 scb=[scb,scb(n:-1:1)];  % Append mirror image in time to reduce wrap
                         % around errors in interpolation (upsampling)
 fscb=fty(scb);          % F.T. of compressed signal w.r.t. time
%
 dt=dt_temp;                     % Time sampling for echoed signal
 n_up=2*ceil((.5*(Tf-Ts))/dt);   % Number of time samples for upsampling
 nz=n_up-n;                      % number of zeros for upsmapling is 2*nz
 fscb=(n_up/n)*[zeros(1,nz),fscb,zeros(1,nz)];
%
 scb=ifty(fscb);
 scb=scb(1:n_up);            % Remove mirror image in time
%
% Upsampled parameters

 n=n_up;
 t=Ts+(0:n-1)*dt;             % Time array for data acquisition
 dw=pi2/(n*dt);               % Frequency domain sampling
 w=wc+dw*(-n/2:n/2-1);        % Frequency array (centered at carrier)
 x=Xc+.5*c*dt*(-n/2:n/2-1);   % range bins (array); reference signal is
                              % for target at x=Xc.
 kx=(2*w)/c;                  % Spatial (range) frequency array
%
 td0=t-2*(Xc+0)/c;
 s=conj(scb).*exp(cj*wcm*td0+cj*alpha*(td0.^2));  % Decompression

end;

% Reference echoed signal
%
td0=t-2*(Xc+0)/c;
pha0=wcm*td0+alpha*(td0.^2);         % Chirp (LFM) phase
for j=1:na;                          % Loop for CPM harmonics
   pha0=pha0+ar(j)*cos((w(n/2+1+j)-wc)*td0+ter(j));
end;
s0=exp(cj*pha0).*(td0 >= 0 & td0 <= Tp);
%
% Baseband conversion
%
sb=s.*exp(-cj*wc*t);
sb0=s0.*exp(-cj*wc*t);

%
plot(t,real(sb))
xlabel('Time, sec')
ylabel('Real Part')
title('Baseband Echoed Signal')
axis('square')
axis([Ts Tf 1.1*min(real(sb)) 1.1*max(real(sb))])
print P1.1a.ps
pause(1)
%
plot(t,real(sb0))
xlabel('Time, sec')
ylabel('Real Part')
title('Baseband Reference Echoed Signal')
axis('square')
axis([Ts Tf 1.1*min(real(sb0)) 1.1*max(real(sb0))])
print P1.2a.ps
pause(1)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RECONSTRUCTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Fourier Transform
%
fsb=fty(sb);
fsb0=fty(sb0);

% Power equalization
%
mag=abs(fsb0);
amp_max=1/sqrt(2);     % Maximum amplitude for equalization
afsb0=abs(fsb0);
P_max=max(afsb0);
I=find(afsb0 > amp_max*P_max);
nI=length(I);
fsb0(I)=((amp_max*(P_max^2)*ones(1,nI))./afsb0(I)).* ...
        exp(cj*angle(fsb0(I)));
%
% Apply a window (e.g., power window) on fsb0 here
%
E=sum(mag.*abs(fsb0));
%
plot((w-wc)/pi2,abs(fsb))
xlabel('Frequency, Hertz')
ylabel('Magnitude')
title('Baseband Echoed Signal Spectrum')
axis('square')
print P1.3a.ps
pause(1)
%
plot((w-wc)/pi2,abs(fsb0))
xlabel('Frequency, Hertz')
ylabel('Magnitude')
title('Baseband Reference Echoed Signal Spectrum')
axis('square')
print P1.4a.ps
pause(1)
%
% Matched Filtering
%
fsmb=fsb.*conj(fsb0);
%
plot((w-wc)/pi2,abs(fsmb))
xlabel('Frequency, Hertz')
ylabel('Magnitude')
title('Baseband Matched Filtered Signal Spectrum')
axis('square')
print P1.5a.ps
pause(1)
%
% Inverse Fourier Transform
%
smb=ifty(fsmb);       % Matched filtered signal (range reconstruction)
%
% Display
%
plot(x,(n/E)*abs(smb))
xlabel('Range, meters')
ylabel('Magnitude')
title('Range Reconstruction Via Matched Filtering')
axis([Xc-X0 Xc+X0 0 1.1]); axis('square')
print P1.6a.ps
pause(1)

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Time domain Compression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
td0=t-2*(Xc+0)/c;
scb=conj(s).* ...
     exp(cj*wcm*td0+cj*alpha*(td0.^2));  % Baseband compressed signal
%
plot(t,real(scb))
xlabel('Time, sec')
ylabel('Real Part')
title('Time Domain Compressed Signal')
axis('square')
print P1.7a.ps
pause(1)

fscb=fty(scb);
X=(c*(w-wc))/(4*alpha);     % Range array for time domain compression
plot(X+Xc,(dt/Tp)*abs(fscb))
xlabel('Range, meters')
ylabel('Magnitude')
title('Range Reconstruction Via Time Domain Compression')
axis([Xc-X0 Xc+X0 0 1.1]); axis('square')
%axis([Xc-X0 Xc+X0 0 1.1*max(abs(fscb))]); axis('square')
print P1.8a.ps
pause(1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%        FREQUENCY-DEPENDENT TARGET REFLECTIVITY  %%%%%%%
%%%%%%%%%%%%%%%%%   (RESONANCE PHENOMENON)   %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SIMULATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Add Resonance to Target Signature
% at Center of Target Area
%
eta=2;
%
% CASE 1:
gamma=1;
%
% CASE 2:
% gamma=5;

% Reference echoed signal
%
td0=t-2*(Xc+0)/c;
pha0=wcm*td0+alpha*(td0.^2);
s0=exp(cj*pha0).*(td0 >= 0 & td0 <= Tp);
%
% Baseband conversion
%
sb0=s0.*exp(-cj*wc*t);
fsb0=fty(sb0);

fsb1=fsb0.*exp(cj*eta*sin(gamma*kx)); % F.T. of resonant echoed signal
sb1=ifty(fsb1);                       % Resonant echoed signal
%
plot(t,real(sb1))
xlabel('Time, sec')
ylabel('Real Part')
title('Baseband Echoed Signal')
axis('square')
axis([Ts Tf 1.1*min(real(sb1)) 1.1*max(real(sb1))])
print P1.9a.ps
pause(1)
%
% Matched Filtering
%
fsmb1=fsb1.*conj(fsb0);
%
% Inverse Fourier Transform
%
smb1=ifty(fsmb1);   % Matched filtered signal (range reconstruction)
%
% Display
%
plot(x,abs(smb1))
xlabel('Range, meters')
ylabel('Magnitude')
title('Range Reconstruction Via Matched Filtering')
axis([Xc-X0 Xc+X0 0 1.1*max(abs(smb1))]); axis('square')
print P1.10a.ps
pause(1)
%
