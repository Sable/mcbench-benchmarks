function asksys(bin,f)
disp('========================================');
disp(' HAM DIEU CHE DICH BIEN: ASK');
disp(' VI DU: asksys([0 1 0 1 1 0 1 1 0],3)');
disp('Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
disp('========================================');

bin=[0 1 0 1 1 0 1 1 1 0];f=4;k=1000;

t=0:2*pi/(k-1):2*pi;

L = length(bin);sig=cos(f*t);
bit1=ones(1,k);bit0=zeros(1,k);
mbit=[];mcw=[];
%==============================================
for n=1:L;
    if bin(n)==0;
       cw=sig;bit=bit0;
    else 
       cw=2*sig;bit=bit1;
    end
   mbit=[mbit bit];
   mcw=[mcw cw];
end
ask=mcw;

%============================================

s=length(mcw);mrec=[];

for m=1:k:s
    vm=abs(mcw(m));
   if vm > 1.5
      rec=bit1;
   elseif vm < 1.2
      rec=bit0;
    end
    mrec=[mrec rec];
end
deask=mrec;
subplot(3,1,1);plot(mbit,'r','linewidth',2);axis([0  k*L -0.5 1.5]);grid on;title('Data in');
subplot(3,1,2);plot(ask,'m','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;title('ASK modulation');
subplot(3,1,3);plot(deask,'g','linewidth',1.5);axis([0  k*L -0.5 1.5]);grid on;title('ASK demodulation,Data out');
       