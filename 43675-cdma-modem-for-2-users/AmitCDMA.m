close all;
clc;
clear all;
%% read user 1 and user 2 and plot data-in and baseband signals
user1=[1 0 0 1 1 0];
user2=[1 1 0 1 0 0];
snr_in_dbs=10;
figure(1)
subplot(4,2,1);
plot(rectpulse(user1,100)); %100 means one bit duration(actually its an analog pulse!)
axis([0 length(rectpulse(user1,100)) -0.2 1.2]);
title('user1 data-in');
subplot(4,2,2);
plot(rectpulse(user2,100));
axis([0 length(rectpulse(user2,100)) -0.2 1.2]);
title('user2 data-in');
user1(user1(:)==0)=-1;
user2(user2(:)==0)=-1;

length_user1=length(user1);
length_user2=length(user2);
fc=1; % carrier frequency
eb=2; % energy per bit
tb=1; % time per bit of message sequence
%Chip rate is 10 times bit rate i.e tc=0.1*tb

basebandsig1=rectpulse(user1,100);
subplot(4,2,3);
plot(basebandsig1);
title('Baseband signal user 1 NRZ form');
axis([0 100*length_user1 -1.2 1.2]);
basebandsig2=rectpulse(user2,100);
subplot(4,2,4);
plot(basebandsig2);
title('Baseband signal user 2 NRZ form');
axis([0 100*length_user1 -1.2 1.2]);

%% BPSK signal for user1 and user2
t=0.01:0.01:length_user1;
modwave=sqrt(2*eb)*cos(2*pi*fc*(t));
bpsk_user1=basebandsig1.*modwave;
bpsk_user2=basebandsig2.*modwave;
subplot(4,2,5)
plot(bpsk_user1)
title(' BPSK signal for user 1');
axis([0 100*length_user1 -2 2]);
subplot(4,2,6)
plot(bpsk_user2)
axis([0 100*length_user2 -2 2]);
title(' BPSK signal for user 2');

%% FFTs of BPSK for user 1 and user2
subplot(4,2,7);
plot(real(fft(bpsk_user1)));
title('FFT of BPSK signal for user1 is');
subplot(4,2,8);
plot(real(fft(bpsk_user2)));
title('FFT of BPSK signal for user2 is');

%% PN sequence for user 1
% let initial seed for user1 is 1010
seed1=[1 -1 1 -1];  %convert it into bipolar NRZ format 
pn1=[];

for i=1:length_user1
    for j=1:10 %chip rate is 10 times the bit rate
        pn1=[pn1 seed1(4)];  
        if seed1 (4)==seed1(3) 
        temp=-1;
        else temp=1;
        end
              seed1(4)=seed1(3);
              seed1(3)=seed1(2);
              seed1(2)=seed1(1);
              seed1(1)=temp;
    end

end
figure(2);
 subplot(2,4,1);
stem(pn1);
axis([0,length(pn1),-1.2,1.2])
title('PN sequence for user1')
 
 
 
pnupsampled1=[];
len_pn1=length(pn1);
for i=1:len_pn1
    for j=0.1:0.1:tb
    pnupsampled1=[pnupsampled1 pn1(i)];
    end
end
length_pnupsampled1=length(pnupsampled1);
subplot(2,4,2)
stem(pnupsampled1);
axis([0,length(pnupsampled1),-1.2,1.2])
title('PN sequence for user1 upsampled');
 
%% PN sequence for user 2
 % let initial seed for user2 is 0101
seed2=[-1 1 -1 1];  %convert it into bipolar NRZ format 
pn2=[];
 
for i=1:length_user2
    for j=1:10 %chip rate is 10 times the bit rate
        pn2=[pn2 seed2(4)];  
        if seed2(4)==seed2(3) 
        temp=-1;
        else temp=1;
        end
              seed2(4)=seed2(3);
              seed2(3)=seed2(2);
              seed2(2)=seed2(1);
              seed2(1)=temp;
    end

end
 
 subplot(2,4,5);
stem(pn2);
axis([0,length(pn2),-1.2,1.2])
title('PN sequence for user2')
pnupsampled2=[];
len_pn2=length(pn2);
for i=1:len_pn2
    for j=0.1:0.1:tb
    pnupsampled2=[pnupsampled2 pn2(i)];
    end
end
length_pnupsampled2=length(pnupsampled2);
subplot(2,4,6)
stem(pnupsampled2);
axis([0,length(pnupsampled2),-1.2,1.2])
title('PN sequence for user2 upsampled');
 
%% transmitted signals and their FFTs
 
subplot(2,4,3);
sigtx1=bpsk_user1.*pnupsampled1;
plot(sigtx1);
title('spread spectrum signal txd for user 1');
 
subplot(2,4,7);
sigtx2=bpsk_user2.*pnupsampled2;
plot(sigtx2);
title('spread spectrum signal txd for user 2');

subplot(2,4,4);
plot(real(fft(sigtx1)));
title('FFT of spreaded signal tx by user1');

subplot(2,4,8);
plot(real(fft(sigtx2)));
title('FFT of spreaded signal tx by user2');

%% Composite Signal with noise

composite_signal=awgn(sigtx1+sigtx2,snr_in_dbs);
figure(3)
subplot(4,2,1);
plot(sigtx1+sigtx2);
title('Composite signal sigtx1+sigtx2');
subplot(4,2,2);
plot(composite_signal);
title(sprintf('Composite signal + noise\n SNR=%ddb',snr_in_dbs));

%% Received Signals for user 1 and user 2

rx1=composite_signal.*pnupsampled1;
rx2=composite_signal.*pnupsampled2;

subplot(4,2,3);
plot(rx1);
title('Received signal from user1 after multiplying it with pn seq');
subplot(4,2,4);
plot(rx2);
title('Received signal from user2 after multiplying it with pn seq');

%% BPSK Demodulation for user 1
bpskdemod1=rx1.*modwave;
subplot(4,2,5)
plot(bpskdemod1)
title('o/p of bpsk demod for user 1 is ')
len_dmod1=length(bpskdemod1);
sum=zeros(1,len_dmod1/100);
%code for performing Integrate and dump operation
for i=1:len_dmod1/100
    for j=(i-1)*100+1:i*100
        sum(i)=sum(i)+bpskdemod1(j);
    end
end
sum;
  
 rxbits1=[];
 for i=1:length_user1
    if sum(i)>0
        rxbits1=[rxbits1 1];
    else
        rxbits1=[rxbits1 0];
    end
 end

rxbits1=rectpulse(rxbits1,100); 
subplot(4,2,7);
plot(rxbits1)
axis([0 600 -0.2 1.2]);
title('Received bits of user1 data')
%% BPSK Demodulation for user 2
bpskdemod2=rx2.*modwave;
subplot(4,2,6)
plot(bpskdemod2)
title('o/p of bpsk demod for user 2 is ')
len_dmod2=length(bpskdemod2);
sum=zeros(1,len_dmod2/100);
%code for performing Integrate and dump operation
for i=1:len_dmod2/100
    for j=(i-1)*100+1:i*100
        sum(i)=sum(i)+bpskdemod1(j);
    end
end

  
 rxbits2=[];
 for i=1:length_user2
    if sum(i)>0
        rxbits2=[rxbits2 1];
    else
        rxbits2=[rxbits2 0];
    end
 end

rxbits2=rectpulse(rxbits2,100); 
subplot(4,2,8);
plot(rxbits2);
axis([0 600 -0.2 1.2]);
title('Received bits of user2 data');