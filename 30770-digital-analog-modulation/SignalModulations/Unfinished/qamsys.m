function qamsys(bin,f)

disp('========================================');
disp(' HAM DIEU CHE DICH BIEN & PHA: QAM');
disp(' VI DU: qamsys([0 0 0 1 1 1 0 1 1 1 1 1],3)');
disp('                Writer: Minh Dai Ca');
disp('========================================');

bin=[0 0 0 1 1 1 0 1 1 1 1 1];f=5;
t=0:2*pi/149:2*pi;

L = length(bin);bit1=ones(1,50);bit0=zeros(1,50);mbit=[];mcw=[];
sig000=cos(f*t);sig001=cos(f*t+pi/2);sig010=cos(f*t+pi);sig011=cos(f*t+3*pi/2);
sig100=2*sig000;sig101=2*sig001;sig110=2*sig010;sig111=2*sig011;

if 3*fix(L/3)~=L
    error('DO DAI CUA CHUOI bin PHAI LA BOI SO CUA 3');
end

for n=1:3:L;
    if bin(n)==0 && bin(n+1)==0 && bin(n+2)==0;
       cw=sig000;bit=[bit0 bit0 bit0];
    elseif bin(n)==0 && bin(n+1)==0 && bin(n+2)==1;
       cw=sig001;bit=[bit0 bit0 bit1];
    elseif bin(n)==0 && bin(n+1)==1 && bin(n+2)==0;
       cw=sig010;bit=[bit0 bit0 bit0];
    elseif bin(n)==0 && bin(n+1)==1 && bin(n+2)==1;
       cw=sig011;bit=[bit0 bit1 bit1];
       
    elseif bin(n)==1 && bin(n+1)==0 && bin(n+2)==0;
       cw=sig100;bit=[bit0 bit0 bit0];
    elseif bin(n)==1 && bin(n+1)==0 && bin(n+2)==1;
       cw=sig101;bit=[bit0 bit0 bit1];
    elseif bin(n)==1 && bin(n+1)==1 && bin(n+2)==0;
       cw=sig110;bit=[bit0 bit0 bit0];
    elseif bin(n)==1 && bin(n+1)==1 && bin(n+2)==1;
       cw=sig111;bit=[bit0 bit1 bit1];
    end
    mbit=[mbit bit];
   mcw=[mcw cw];
end
qam=mcw;
deqam=mcw;

subplot(3,1,1);plot(mbit,'r','linewidth',2);axis([0  50*L -0.5 1.5]);grid on;title('Data in');
subplot(3,1,2);plot(qam,'m','linewidth',1.5);axis([0  50*L -2.5 2.5]);grid on;title('PSK modulation');
subplot(3,1,3);plot(deqam,'g','linewidth',1.5);axis([0  50*L -2.5 2.5]);grid on;title('PSK demodulation,Data out');