function fsksys(bin,fh,fl)

disp('========================================');
disp(' HAM DIEU CHE DICH TAN: FSK');
disp(' VI DU: fsksys([0 1 0 1 1 0 1 1 0],2,5)');
disp('Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
disp('========================================');

bin=[0 1 0 1 1 0 1 1 1 0];fh=10;fl=2;k=1000;

t=0:2*pi/(k-1):2*pi;

L = length(bin);sigh=cos(fh*t);sigl=cos(fl*t);
bit1=ones(1,k);bit0=zeros(1,k);
mbit=[];mcw=[];

for n=1:L;
    if bin(n)==0;
       cw=sigl;bit=bit0;
    else 
       cw=sigh;bit=bit1;
    end
   mbit=[mbit bit];
   mcw=[mcw cw];
end
fsk=mcw;
%==============================================
s=length(mcw);b=round(k/fh);mrec=[];
for m=1:k:s
    vm=abs(mcw(m));vmb=abs(mcw(m+b));
    if vmb >= 0.95*vm   
       rec=bit1;
    else
        rec=bit0;
    end
    mrec=[mrec rec];
end
defsk=mrec;
subplot(3,1,1);plot(mbit,'r','linewidth',2);axis([0  k*L -0.5 1.5]);grid on;title('Data in');
subplot(3,1,2);plot(fsk,'m','linewidth',1.5);axis([0  k*L -1.5 1.5]);grid on;title('FSK modulation');
subplot(3,1,3);plot(defsk,'g','linewidth',2);axis([0  k*L -0.5 1.5]);grid on;title('FSK demodulation, Data out');