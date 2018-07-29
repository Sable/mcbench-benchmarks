%% DS - CDMA (SNR-Performance)
clear all;close all;clc;
nu=input('Number of Users = ');
u=[];s=[];
ml=input('Number of bits for each user = ');
hl=2^nextpow2(nu);
% 
for k = 1:nu
    
u_binary(k,:)=randi([0 1],1,ml);

end
for k = 1:nu
    
u_BPSK(k,:)=u_binary(k,:)*2-1;

end
for n=1:nu
    s(n,:)=cdmat(u_BPSK(n,:),hl,n);
end
cd1=sum(s);
%% Oversampling
cd =rectpulse(cd1,4);
loo=0;
for SNR=0:2:8
    
    loo=loo+1;
    
    t=awgn(cd,SNR,'measured');
    
    %% Integrate and dump (downsampling)
    or=intdump(t,4);

    sr=[];
    for p=1:nu
        sr(p,:)=cdmar(or,hl,p,ml);
    end
    
    binary_rx=(sr+1)/2;
[n(loo),r(loo)]=symerr(u_BPSK,sr);
end

figure;%plot combined signals
%Tx
subplot(211);stem(cd1(1:20),'filled');
title('Combined signals (only 20 symbols');
xlabel('Index of Combined symbols');
ylabel('Magnitude');
grid;
%Rx
subplot(212);stem(or(1:20),'filled');
title('Combined noisy signals (only 20 symbols');
xlabel('Index of Combined symbols');
ylabel('Magnitude');

grid;

SNR=0:2:8;
figure; % plot the BER vs. SNR
semilogy(SNR,r,'r-x'),grid;

figure;% plot data for a randomly selected user such as user no. 1 before the BPSK mapping Tx and Rx
% Tx
subplot(211);stem(u_binary(1,1:10),'filled');grid 
xlabel('Bits index');
title('Transmitted Bits (showing only 10 bits)');
% Rx
subplot(212);stem((sr(1,1:10)+1)/2,'filled');grid 
xlabel('Bits index');
title('Received Bits (showing only 10 bits)');

figure;% plot data for a randomly selected user such as user no. 1 after the BPSK mapping Tx and Rx
% Tx
subplot(211);stem(u_BPSK(1,1:10),'filled');grid 
xlabel('Symbol index');
title('Transmitted BPSK Symbols (showing only 10 Symbol)');
% Rx
subplot(212);stem(sr(1,1:10),'filled');grid 
xlabel('Symbol index');
title('Received BPSK Symbols (showing only 10 Symbol)');



