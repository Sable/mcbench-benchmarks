%% Implementation of coherent and non-coherent DBPSK over Rayleigh channel
% with Jake's model 
clc
close all
clear all
%%
N=1000;
Ns=5E5;
SNR_dB=0:20;
snr=10.^(SNR_dB/10);

% flat fading channel with Jake's model
hn=flat_ch(Ns);

for ind=1:length(snr)
nbits1=0;%number of data sent
nerr1=0;% number of errors
nerr2=0;% number of errors
k1=0;
k2=0;
clc
snr(ind)

while nerr1<200 || nerr2<200
% random BPSK symbols
x1=bpsk(N);

% DPSK modulation
x2=dpsk(x1);

% flat fading reileigh channel CN(0,1)
%h1=cxn(N,1);
h1=hn(1+k1:N+k1);
%h2=cxn(1,1)*ones(1,N+1);
h2=hn(1+k2:N+1+k2);
k1=k1+N;
k2=k2+N+1;

% AWGN noise CN(0,N0)
sig2=1/snr(ind);
z1=cxn(N,sig2);
z2=cxn(N+1,sig2);

% received signal
y1=h1.*x1+z1;
y2=h2.*x2+z2;

% coherent detection
r1=real(y1./h1);
x1hat=sign(r1);

%non-coherent detection
for t=2:N+1
    r2(t-1)=real(y2(t)*y2(t-1)');
end
x2hat=sign(r2);

% count number of errors and data
nerr1=nerr1+sum(abs(x1-x1hat))/2;
nbits1=N+nbits1;
nerr2=nerr2+sum(abs(x1-x2hat))/2;

end

% compute practical BER for coherent detection
ber1(ind)=nerr1/nbits1;

% compute practical BER for non-coherent detection
ber2(ind)=nerr2/nbits1;

end

% theoritical BER for coherent detection: TSE book, Eq.3.19
pe1=.5*(1-sqrt(snr./(1+snr)));

% theoritical BER for non-coherent detection:TSE, Eq.3.11
pe2=.5*(1./(1+snr));

% plot coherent BER
semilogy(SNR_dB,ber1,'b--*');
hold on 
semilogy(SNR_dB,pe1,'m-.');

%plot non-coherent BEr
semilogy(SNR_dB,ber2,'r--s');
semilogy(SNR_dB,pe2,'c-.');

grid on
title('coherent and noncoherent detection over rayleigh fading channel with Jakes model');
legend('simulation coherent','theoritical coherent','simulation non-coherent','theoritical non-coherent');
xlabel('SNR,dB')
ylabel('p_e')
