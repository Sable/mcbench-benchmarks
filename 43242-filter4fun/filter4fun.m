function y=filter4fun(fun,t,x)
% Filter using the procedure fft-filter-ifft.
% Syntax: y=filter4fun(fun,t,x) where t is the time-vector (s) and 
% x is the signal-vector.
% fun is a function of .m-type or e.g., defined as fun=@(f) 1./f
% fun could be of analytic type like n-order Butterworth 1./(1+(f/fc).^n)
%
% % Example 1:
% % Define signal
% f=80;                   % Frequency of signal
% w=2*pi*f;               % Angular frequency
% n=2^10;                 % Number of samples in time
% t=linspace(0,1/f,n);    % Time-vector
% x0=2*sin(w*t);          % Base signal
% x1=x0+sin(3*w*t);       % Extra signal 1
% x=1+x1+2*cos(41*w*t);   % Signal=x1+Offset+extra signal 2
%
% % Define filter-function "fun" and apply filter on x
% fun = @(f) f<200; % Low-pass filter with cut-off at f=200Hz
%
% % Apply filter
% y=filter4fun(fun,t,x);
% y=real(y);    % ignore small imaginary residuals from ifft (don't for
%               % subsequent filters)
% % Plot and compare 
% figure(1), clf;plot(t,x0,'b',t,x1,'r',t,x,'g');
% hold on;plot(t,y,'k:','linewidth',3);grid;
% xlabel('time (s)')
% legend('x0=2*sin(w*t)','x1=x0+sin(3*w*t)','x=1+x1+2*cos(41*w*t)',...
% 'y: f<200Hz')
%
% % Example 2: Band-stop and remove DC
% f=80;                   % Frequency of signal
% w=2*pi*f;               % Angular frequency
% n=2^10;                 % Number of samples in time
% t=linspace(0,1/f,n);    % Time-vector
% x0=2*sin(w*t);          % Base signal
% x1=x0+sin(3*w*t);       % Extra signal 1
% x=1+x1+2*cos(41*w*t);   % Signal=x1+Offset+extra signal 2
%
% % Define Ac and band-stopp filter
% fun = @(f) (f>0).*(1-(f>200).*(f<300)); % Band-stop filter around f=240Hz
%
% % Apply filter
% y=real(filter4fun(fun,t,x));
% % Plot and compare 
% figure(1), clf;plot(t,x0,'b',t,x1,'r',t,x,'g');
% hold on;plot(t,y,'k:','linewidth',2);grid;
% xlabel('time (s)')
% legend('x0=2*sin(w*t)','x1=x0+sin(3*w*t)','x=1+x1+2*cos(41*w*t)',...
% 'y: (f>0).*(1-(f>200).*(f<300))')
%
% % Example 3: RC low-pass filter (phase might not be right)
% f=80;                   % Frequency of signal
% w=2*pi*f;               % Angular frequency
% n=2^10;                 % Number of samples in time
% t=linspace(0,1/f,n);    % Time-vector
% x0=2*sin(2*pi*80*t);    % Base signal
% x1=x0+sin(2*pi*240*t);  % Extra signal 1
% x=1+x1+2*cos(2*pi*3280*t);   % Signal=x1+Offset+extra signal 2
%
% % Define RC-filter with fc=1kHz
% R=1000;
% C=159e-9;
% f0=1/R/C/2/pi   % fc at 1000Hz
% % add small df to avoid singulariy at f=0
% fun = @(f) (1./(j*2*pi*(f-j*1e-6)*C))./(R+1./(j*2*pi*(f-j*1e-6)*C)); % LP RC-filter
%
% % Apply filter
% y=real(filter4fun(fun,t,x));
% % Plot and compare 
% figure(1), clf;plot(t,x0,'b',t,x1,'r',t,x,'g');
% hold on;plot(t,y,'k-','linewidth',2);grid;
% xlabel('time (s)')
% legend('x0=2*sin(w*t)','x1=x0+sin(3*w*t)','x=1+x1+2*cos(41*w*t)',...
% 'y: (1./(j*2*pi*f*C))./(R+1./(j*2*pi*f*C))')

x=reshape(x,size(t));
n=length(t);

% Define frequency grid
Ts=t(2)-t(1);    % sampling frequency
fmax=1/Ts;       % max frequency 
df=fmax/(n-1);   % discrete step on frequency axis
fvec=0:df:df*(n-1);

% Fast Fourier Transform of signal, fft
X=fft(x);

% Apply filter (up to fN=fmax=1/dt/2)
filter=fun(fvec);       

% Let the mirror frequencies (f>fN) have the same filter-function
% X(1) carries the DC-info and fun(f) should include infor for f=0
% so that f(1) is defined (not NaN for instance).
ix_mirror=n-(2:floor(n/2))+2;                   % mirror index
filter(ix_mirror)=(filter(2:floor(n/2)));       % filter of mirror index

% apply the filter on the transformed signal X
Y=filter.*X;

% Inverse transform back the signal X in f-domain to time-domain with ifft
y=ifft(Y);

