function fmsys(f,fc,fs,dev)
disp('Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
f=5;fc=40;fs=10*fc;dev=20;

t=0:0.001:0.5;
%=====================================
x=cos(2*pi*f*t);
c=cos(2*pi*fc*t);
y=fmmod(x,fc,fs,dev);

dy=awgn(y,25,'measured');
dyn=fmdemod(dy,fc,fs,dev);
[b,a] = butter(10,0.1); 
dyn1 = filter(b,a,dyn);
%=====================================
X = fft(x,512);
Pxx = X.* conj(X) / 512;
Y = fft(dyn1,512);
Pyy = Y.* conj(Y) / 512;
f = 1000*(0:256)/512;
figure(2);
subplot(2,1,1);plot(f,Pxx(1:257),'g');title('Frequency content of Basseband ');xlabel('frequency (Hz)')
subplot(2,1,2);plot(f,Pyy(1:257),'r');title('Frequency content of FM');xlabel('frequency (Hz)')

%=====================================
figure(1);
subplot(5,1,1);plot(t,x,'r');hold on;plot(t,c,'g');legend('base band','carrier wave');;title('base band & carrier wave');
subplot(5,1,2);plot(t,y,'y');title('FM modulation');
subplot(5,1,3);plot(t,dy,'g');axis([0 0.5 -1 1]);title('FM modulation + AWGN');
subplot(5,1,4);plot(t,dyn);axis([0 0.5 -1.3 1.3]);title('FM demodulation');
subplot(5,1,5);plot(t,dyn1,'r');axis([0 0.5 -1.3 1.3]);title('FM demodulation filter');

