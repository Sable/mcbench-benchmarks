function bpsksys(bin,f)

disp('========================================');
disp(' HAM DIEU CHE DICH 2 PHA: BPSK');
disp(' VI DU:bpsksys([0 1 0 1 1 0 1 1 0],3)');
disp('Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
disp('========================================');

bin=[0 1 0 1 1 0 1 1 1 0];f=3;k=1000;

t=0:2*pi/(k-1):2*pi;

L = length(bin);sig0=cos(f*t);sig1=cos(f*t+pi);
bit1=ones(1,k);bit0=zeros(1,k);
mbit=[];mcw=[];

for n=1:L;
    if bin(n)==0;
       cw=sig0;bit=bit0;
    else 
       cw=sig1;bit=bit1;
    end
   mbit=[mbit bit];
   mcw=[mcw cw];
end
psk=mcw;
%================================================
s=length(mcw);mrec=[];

for m=0:k:s
    if mcw(m)<0
       rec=bit1;
    elseif mcw(m)>0
       rec=bit0;
    end
    mrec=[mrec rec];
end
depsk=mrec;
subplot(3,1,1);plot(mbit,'r','linewidth',2);axis([0  k*L -0.5 1.5]);grid on;title('Data in');
subplot(3,1,2);plot(psk,'m','linewidth',1.5);axis([0  k*L -1.5 1.5]);grid on;title('PSK modulation');
subplot(3,1,3);plot(depsk,'g','linewidth',2);axis([0  k*L -.5 1.5]);grid on;title('PSK demodulation,Data out');