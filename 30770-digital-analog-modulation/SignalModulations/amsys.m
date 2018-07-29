function amsys(fc,fm,ma)
disp('Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
fc=20;fm=1;ma=0.7;
Ac=1/ma;fs=4*fc;wc=2*pi*fc;wm=2*pi*fm;k=2;

t=0:0.099/fc:k;
%==========================================================================
vm=cos(wm*t);
vc=Ac*cos(wc*t);
vam=ammod(vm,fc,fs);                  %Ac*(1+ma*cos(wm*t)).*cos(wc*t);
%==========================================================================
vamn=awgn(vam,25,3);           %Vamn= Vam + noise
%==========================================================================
vamd=amdemod(vamn,fc,fs);               %(vamf-vc)./cos(wc*t);
%==========================================================================
[b,a] = butter(5,0.1,'low'); 
vamf = filter(b,a,vamd);        %Vamf  filted by lowpass filter
%==========================================================================
Y = fft(vm,256);
Pyy = Y.*conj(Y)/256;
%=====================================
X = fft(vamf,256);
Pxx = X.*conj(X)/256;
f = 1000/256*(0:127);
%=====================================
figure(1);
subplot(2,1,1);plot(f,Pyy(1:128),'r');title('Power  spectral density Base band');xlabel('Frequency (Hz)');ylabel('dB')
subplot(2,1,2);plot(f,Pxx(1:128),'g');title('Power spectral density AM Demod');xlabel('Frequency (Hz)');ylabel('dB')

%==========================================================================
figure(2);
subplot(5,1,1);plot(t,vm,'g');axis([0 k -1.5*Ac 1.5*Ac]);
hold on;plot(t,vc,'r');%title('Base band & Carrier wave');
               legend('Base band','Carrier wave');
subplot(5,1,2);plot(t,vam);axis([0 k -1.5*Ac 1.5*Ac]);legend('AM mod');               
subplot(5,1,3);plot(t,vamn,'y');axis([0 k -1.5*Ac 1.5*Ac]);legend('AM transmited');
subplot(5,1,4);plot(t,vamd,'m');axis([0 k -1.5*Ac 1.5*Ac]);legend('AM demod');

subplot(5,1,5);plot(t,vamf,'k');axis([0 k -1.5*Ac 1.5*Ac]);legend('AM demodulation'); 
     