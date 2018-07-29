% -------------------------------------------------------------------------
% runduffsr.m
% Numerically solve the driven duffing oscillator with noise. Compute 
% the averaged signal and noise amplitude spectra for varing noise 
% strength. Plot signal-to-noise vs noise strength and time-series, phase
% space, well occupation distributions, and amplitude spectra for four 
% chosen noise strengths.
% Dependencies: duff.m and noise.m
% -------------------------------------------------------------------------

clear all

tic % start timer

global p w

% -------------------------------------------------------------------------

X0 = [0 0]'; % initial conditions
t0 = 0; % initial time
tf = 1000; % final time
dt = 0.05; % time step
T = (t0:dt:tf); % time vector
options = [];

f = (1:length(T))/(length(T)*dt); % frequency
f = f(1:(ceil(length(T)/2))); % first half of frequency axis

win = hann(length(T)); % hanning window

wmax = 10; % noise cut-off frequency
alpha = 0.5; % strength of non-linear term
beta = 1; % strength of linear term
gam = 0.5; % damping strength
A = 0.38; % driving amplitude
w0 = 0.09; % driving frequency

N = 1000; % number of terms in noise sum

d = 0.05:0.05:2; % noise strength

% noise strength values for plots
dc = [0.1 0.5 1 2];

dw0 = w0*0.25; % integration range (w0+/- 25%)

M = 4; % number of terms in average (>= 2)

% initialize arrays
x = zeros(length(T),length(dc));
v = zeros(length(T),length(dc));
lc = zeros(1,length(dc));

Fd = zeros((1+length(T))/2,M);
Fdn = zeros((1+length(T))/2,M);

Sd = zeros((1+length(T))/2,length(d));
Sdn = zeros((1+length(T))/2,length(d));

Pd = zeros(1,length(d));
Pdn = zeros(1,length(d));

% -------------------------------------------------------------------------

for l = 1:length(d) % loop over noise strength array
 
n = d(l);

for j = 1:M % average amplitudes 
  
p = unifrnd(0,2*pi,1,N); % random phases in noise
w = unifrnd(0,wmax,1,N); % random frequencies in noise

% numerically solve duffing oscillator
[t,y]=ode23(@duff,T,X0,options,gam,alpha,beta,A,w0,n);

% create x and v vectors at various noise strengths (d = 0.1,0.5,1.5,4)
% and get index for plots
if j == 1
    for i = 1:length(dc)
        if n == dc(i)
            x(:,i) = y(:,1);
            v(:,i) = y(:,2);
            lc(i) = l;
            break
        end
    end
end

% compute positive fft of windowed time-dependent signal and noise 
% amplitudes
Fdtemp = fft(win.*y(:,1))/length(t); % signal fft
Fdntemp = fft(sqrt(n)*win.*noise(t)')/length(t); % noise fft

Fd(:,j) = Fdtemp(1:(ceil(length(t)/2))); % positive half of signal fft
Fdn(:,j) = Fdntemp(1:(ceil(length(t)/2))); % positive half of noise frequency

clear Fdtemp Fdntemp

end

% average frequency dependent signal and noise amplitude
Sd(:,l) = sum(abs(Fd'))/M; % averaged signal amplitude
Sdn(:,l) = sum(abs(Fdn'))/M; % averaged noise amplitude

i = 1;

% find signal and noise amplitude around driving frequency
for k = 1:length(f)
    if 2*pi*f(k) >= w0-dw0 && 2*pi*f(k) <= w0+dw0 
        fr(i) = 2*pi*f(k); % frequency
        fd(i) = Sd(k,l); % signal amplitude
        fdn(i) = Sdn(k,l); % noise amplitude
        i = i + 1;   
    end
end

% integrate signal and noise amplitude around driving frequency
Pd(l) = trapz(fr,fd); % signal "power"
Pdn(l) = trapz(fr,fdn); % noise "power"

clear fr fd fdn

end

% calculate and smooth snr (dB)
SNR = smooth(10*log(Pd./Pdn),0.1);

% -------------------------------------------------------------------------

figure(1) % plot snr vs noise strength
plot(d,SNR,'-ob')
xlabel('d'); ylabel('SNR (dB)');

% plots for various noise strengths (d = 0.1,0.5,1.5,4)
figure(2) % plot time-series
subplot(4,1,1)
plot(t,x(:,1))
xlabel('t'); ylabel('x');
subplot(4,1,2)
plot(t,x(:,2))
xlabel('t'); ylabel('x');
subplot(4,1,3)
plot(t,x(:,3))
xlabel('t'); ylabel('x');
subplot(4,1,4)
plot(t,x(:,4))
xlabel('t'); ylabel('x');

figure(3) % plot phase-space
subplot(2,2,1)
plot(x(:,1),v(:,1))
xlabel('x'); ylabel('v');
subplot(2,2,2)
plot(x(:,2),v(:,2))
xlabel('x'); ylabel('v');
subplot(2,2,3)
plot(x(:,3),v(:,3))
xlabel('x'); ylabel('v');
subplot(2,2,4)
plot(x(:,4),v(:,4))
xlabel('x'); ylabel('v');

figure(4) % plot histogram of well distribution
subplot(2,2,1)
hist(x(:,1),100)
xlabel('x');
subplot(2,2,2)
hist(x(:,2),100)
xlabel('x');
subplot(2,2,3)
hist(x(:,3),100)
xlabel('x');
subplot(2,2,4)
hist(x(:,4),100)
xlabel('x');

figure(5) % plot noise subtracted amplitude spectra
plot(2*pi*f,Sd(:,lc(1))-Sdn(:,lc(1)),2*pi*f,Sd(:,lc(2))-Sdn(:,lc(2)),...
     2*pi*f,Sd(:,lc(3))-Sdn(:,lc(3)),2*pi*f,Sd(:,lc(4))-Sdn(:,lc(4)))
legend('d = 0.1','d = 0.6','d = 1.8','d = 2.4')
xlabel('\omega'); ylabel('|A|');

toc % end timer
