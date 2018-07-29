function cobagelombang3
% caobagel3 : generates wave time signal from wave spectrum, 
% JONSWAP etc
% 
% Baharuddin Ali, 
% email : b4li313@gmail.com
% Kediri-East Java-Indonesia
close all;clear;clc;

Hw=2.4; % wave height significant (m)
Tw=6.6; % Peak period (s)

w=linspace(0.2,2.5,50);
delta_w = w(2)-w(1);  
w = w + delta_w .* rand(1,length(w)); % random selection of frequencies
w3=w;

%----- Jonswap spectrum ------
gama  = 2.5;
fp    = 2*pi/Tw;
fac1  = (320*Hw^2)/Tw^4;
sigma = (w<=fp)*0.07+(w>fp)*0.09;
Aa    = exp(-((w/fp-1)./(sigma*sqrt(2))).^2);
fac2  = w.^-5;
fac3  = exp(-(1950*w.^-4)/Tw^4);
fac31 = exp(-5/4*(w/fp).^-4);
fac4  = gama.^Aa;
S     = fac1.*fac2.*fac3.*fac4;
%--------------------------------           
skl  = 50;   % use scale model to reduce time consume in calculation..!!
tend = 1560; % example : about 3 hours for model scale 1:50
sfr   = 25;   % sampling frequency (Hz)
t = [0: 1/sfr: tend]*sqrt(skl); % time vector
phi = 2*pi*(rand(1,length(w))-0.5); % random phase of ith frequency
A = sqrt(2*S.*delta_w); % amplitude of ith frequency

for i = 1:length(t)
    wave(i) = sum(A .* cos(w*t(i) + phi));
end

[S2,W2]=HitSpek3(wave',length(wave),400,sfr,skl); % 400 :hamming variabel, custom, can be modified

smax=(max(S)<=max(S2))*max(S2)+(max(S)>max(S2))*max(S);
subplot(2,1,1)
plot(W2,S2,w3,S,'r');xlabel('w (rad/s)');ylabel('Spectral (m^2.s)');
legend('measured','theoretical');
grid;
axis([w3(1) w3(end) 0 smax*1.2]);
subplot(2,1,2)
plot(t,wave);xlabel('t (sec)');ylabel('Z_a (m)');grid;
axis([0 t(end) -inf*1.2 inf*1.2]);

function [S,W]=HitSpek3(z,n,m,sfr,skl);
% HitSpek2 : generate wave spectrum from time signal
%
zf = fft(z);
R  = zf.*conj(zf)/n;
fr = (0:n-1)/n*sfr;
P  = 2*R/sfr;
w  = hamming(m) ;                
w  = w/sum(w) ;                  
w  = [w(ceil((m+1)/2):m);zeros(n-m,1);w(1:ceil((m+1)/2)-1)];  
w    = fft(w) ;                    
pavg = fft(P) ;                 
pavg = ifft(w.*pavg) ; 

S = abs(pavg(1:ceil(n/2)));
F = fr(1:ceil(n/2));

S=S/(2*pi)*sqrt(skl);% Spectral (m^2.s)
W=2*pi*F/sqrt(skl); % w (rad/s)