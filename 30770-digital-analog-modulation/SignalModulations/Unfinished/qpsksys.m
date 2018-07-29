function qpsksys(bin,f)

disp('========================================');
disp(' HAM DIEU CHE DICH 4 PHA: QPSK');
disp(' VI DU: qpsksys([0 1 0 1 1 0 1 1 0],3)');
disp('Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
disp('========================================');

bin=[0 0 1 0 0 1 0 1 1 1 1 1];f=3;k=1000;

t=0:2*pi/(k-1):2*pi;

L = length(bin);bit1=ones(1,k/2);bit0=zeros(1,k/2);mbit=[];mcw=[];
sig00=cos(f*t);sig01=cos(f*t+pi/2);sig10=cos(f*t+pi);sig11=cos(f*t+3*pi/2);

if 2*round(L/2)~=L
    error('DO DAI CUA CHUOI bin LA CHAN');
end

for n=1:2:L;
    if bin(n)==0 && bin(n+1)==0;
       cw=sig00;bit=[bit0 bit0];
    elseif bin(n)==0 && bin(n+1)==1;
       cw=sig01;bit=[bit0 bit1];
    elseif bin(n)==1 && bin(n+1)==0;
       cw=sig10;bit=[bit1 bit0];
    elseif bin(n)==1 && bin(n+1)==1;
       cw=sig11;bit=[bit1 bit1];
    end
   %base=sig00;mbase=[mbase base];
   mbit=[mbit bit];
   mcw=[mcw cw];
   
end
psk=mcw;
%==========================================================================
s=length(mcw);mreco=[];

for m=1:k:s
   
    if mcw(m)==1 
       reco=[bit0 bit0];
    elseif mcw(m)==-1
       reco=[bit1 bit0];
    elseif mcw(m)==0 && mcw(m+2)>0
       reco=[bit1 bit1]; 
    elseif mcw(m)==0 && mcw(m+2)<0
       reco=[bit0 bit1];
    end
    mreco=[mreco reco];
end
depsk=mreco;

subplot(3,1,1);plot(mbit,'r','linewidth',2);axis([0  k/2*L -0.5 1.5]);grid on;title('Data in');
subplot(3,1,2);plot(psk,'m','linewidth',1.5);axis([0  k/2*L -1.5 1.5]);grid on;title('PSK modulation');
%hold on;plot(mbase,'--');
subplot(3,1,3);plot(depsk,'g','linewidth',1.5);axis([0  k/2*L -0.5 1.5]);grid on;title('PSK demodulation,Data out');