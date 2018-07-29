function cdmamodem(user1,user2,snr_in_dbs)
% >>>multiple access b/w 2 users using DS CDMA
% >>>format is : cdmamodem(user1,user2,snr_in_dbs)
% >>>user1 and user2 are vectors and they should be of equal length
% >>>e.g. user1=[1 0 1 0 1 0 1] , user2=[1 1 0 0 0 1 1],snr_in_dbs=-50
% >>>or snr_in_dbs=50 just any number wud do
%        Waqas Mansoor
%         NUST , Pakistan

close all
%user1=[1 0 0 1 1 0]
%user2=[1 1 0 1 0 0]
%% to convert the binary sequences to bipolar NRZ format
length_user1=length(user1);
length_user2=length(user2);

for i=1:length_user1
    if user1(i)==0
        user1(i)=-1;
    end
end

for i=1:length_user2
    if user2(i)==0
        user2(i)=-1;
    end
end

fc=1; %%carrier frequency
eb=2;     %% energy per bit
tb=1; %% time per bit of message sequence

%%% CDMA transmitter for user1
t=0.01:0.01:tb*length_user1; %0.01
%%plotting base band signal for user1
basebandsig1=[];
for i=1:length_user1
    for j=0.01:0.01:tb%0.01
          if user1(i)==1 
              basebandsig1=[basebandsig1 1];
          else 
              basebandsig1=[basebandsig1 -1];
          end
    end
end

figure
plot(basebandsig1)
axis([0 100*length_user1 -1.5 1.5]);
title('original binary sequence for user1 is')

%%%% BPSK MODULATION FOR USER 1
bpskmod1=[];
for i=1:length_user1
    for j=0.01:0.01:tb
     bpskmod1=[bpskmod1 sqrt(2*eb)*user1(i)*cos(2*pi*fc*j)];
 end
end
length(bpskmod1)
 figure
 plot(bpskmod1)
%axis([0 100*length_user1 -2 2]);
 title(' BPSK signal for user 1 is')

%% plot fft of BPSK sequence
% figure
% plot(real(fft(bpskmod1)))
% title('FFT of BPSK signal for user1 is')

%% PN generator for user1
%% let initial seed for user1 is 1000
seed1=[1 -1 1 -1];  %convert it into bipolar NRZ format 
spreadspectrum1=[];
pn1=[];

for i=1:length_user1
    for j=1:10 %chip rate is 10 times the bit rate
        pn1=[pn1 seed1(4)];  
        if seed1 (4)==seed1(3) temp=-1;
          else temp=1;
          end
              seed1(4)=seed1(3);
              seed1(3)=seed1(2);
              seed1(2)=seed1(1);
              seed1(1)=temp;
    end
%         spreadspectrum1=[spreadspectrum1 user1(i)*pn1];
end

% each bit has 100 samples. and each pn chip has 10 samples. there r 
% 10 chip per bit there fore size of pn samples and original bit is same

pnupsampled1=[];
len_pn1=length(pn1);
for i=1:len_pn1
    for j=0.1:0.1:tb
          if pn1(i)==1 
              pnupsampled1=[pnupsampled1 1];
          else 
              pnupsampled1=[pnupsampled1 -1];
          end
    end
end
length_pnupsampled1=length(pnupsampled1);
 sigtx1=bpskmod1.*pnupsampled1;
 
figure
plot(sigtx1)
%axis([0 100*length_user1 -2 2]);
title(' spread spectrum signal transmitted for user 1 is')

%% plot fft of BPSK sequence
figure
plot(real(fft(sigtx1)))
title('FFT of spread spectrum signal transmitted for user1 is')

% rxcode1=pnupsampled1.*sigtx1;
% figure
% plot(rxcode1)
% %axis([0 100*length_user1 -2 2]);
% title(' spread spectrum signal transmitted for user 1 is')


%%% CDMA transmitter for user2
t=0.01:0.01:tb*length_user2; %0.01
%%plotting base band signal for user2
basebandsig2=[];
for i=1:length_user2
    for j=0.01:0.01:tb%0.01
          if user2(i)==1 
              basebandsig2=[basebandsig2 1];
          else 
              basebandsig2=[basebandsig2 -1];
          end
    end
end

figure
plot(basebandsig2)
axis([0 100*length_user2 -1.5 1.5]);
title('original binary sequence for user2 is')

%%%% BPSK MODULATION FOR USER 2
bpskmod2=[];
for i=1:length_user2
    for j=0.01:0.01:tb
     bpskmod2=[bpskmod2 sqrt(2*eb)*user2(i)*cos(2*pi*fc*j)];
 end
end
 figure
 plot(bpskmod2)
%axis([0 100*length_user2 -2 2]);
 title(' BPSK signal for user 2 is')

%% plot fft of BPSK sequence
% figure
% plot(real(fft(bpskmod2)))
% title('FFT of BPSK signal for user2 is')

%% PN generator for user2
%% let initial seed for user2 is 1000
seed2=[-1 1 -1 1];  %convert it into bipolar NRZ format 
spreadspectrum2=[];
pn2=[];

for i=1:length_user2
    for j=1:10 %chip rate is 10 times the bit rate
        pn2=[pn2 seed2(4)];  
        if seed2 (4)==seed2(3) temp=-1;
          else temp=1;
          end
              seed2(4)=seed2(3);
              seed2(3)=seed2(2);
              seed2(2)=seed2(1);
              seed2(1)=temp;
    end
%         spreadspectrum2=[spreadspectrum2 user2(i)*pn2];
end
pnupsampled2=[];
len_pn2=length(pn2);
for i=1:len_pn2
    for j=0.1:0.1:tb
          if pn2(i)==1 
              pnupsampled2=[pnupsampled2 1];
          else 
              pnupsampled2=[pnupsampled2 -1];
          end
    end
end
length_pnupsampled2=length(pnupsampled2);
 sigtx2=bpskmod2.*pnupsampled2;
 
figure
plot(sigtx2)
%axis([0 100*length_user2 -2 2]);
title(' spread spectrum signal transmitted for user 2 is')

%% plot fft of BPSK sequence
figure
plot(real(fft(sigtx2)))
title('FFT of spread spectrum signal transmitted for user2 is')

% rxcode2=pnupsampled2.*sigtx2;
% figure
% plot(rxcode2)
% %axis([0 100*length_user2 -2 2]);
% title(' spread spectrum signal transmitted for user 2 is')

%%%%%%%%%%%%%%%signal by adding the above 2 signals%%%%%%%%%%%
composite_signal=sigtx1+sigtx2;

%%%%%%%%%%%%%AWGN CHANNEL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
composite_signal=awgn(composite_signal,snr_in_dbs);  %% SNR of % dbs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%DMODULATION FOR USER 1%%%%%%%%%%%%%%%%%%%%
rx1=composite_signal.*pnupsampled1;
figure
plot(rx1)

%%%% BPSK DEMODULATION FOR USER 1
demodcar1=[];
for i=1:length_user1
    for j=0.01:0.01:tb
     demodcar1=[demodcar1 sqrt(2*eb)*cos(2*pi*fc*j)];
 end
end
bpskdemod1=rx1.*demodcar1;
figure
plot(bpskdemod1)
title('o/p of bpsk demod for user 1 is ')
len_dmod1=length(bpskdemod1);
sum=zeros(1,len_dmod1/100);
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
rxbits1

%%%%%%%%%%%%%DMODULATION FOR USER 2%%%%%%%%%%%%%%%%%%%%
rx2=composite_signal.*pnupsampled2;
figure
plot(rx2)

%%%% BPSK DEMODULATION FOR USER 2
demodcar2=[];
for i=1:length_user2
    for j=0.01:0.01:tb
     demodcar2=[demodcar2 sqrt(2*eb)*cos(2*pi*fc*j)];
 end
end
bpskdemod2=rx2.*demodcar2;
figure
plot(bpskdemod2)
title('o/p of bpsk demod for user 2 is ')
len_dmod2=length(bpskdemod2);
sum=zeros(1,len_dmod1/100);
for i=1:len_dmod2/100
    for j=(i-1)*100+1:i*100
        sum(i)=sum(i)+bpskdemod2(j);
    end
end
sum;
  
 rxbits2=[];
 for i=1:length_user2
    if sum(i)>0
        rxbits2=[rxbits2 1];
    else
        rxbits2=[rxbits2 0];
    end
 end
rxbits2