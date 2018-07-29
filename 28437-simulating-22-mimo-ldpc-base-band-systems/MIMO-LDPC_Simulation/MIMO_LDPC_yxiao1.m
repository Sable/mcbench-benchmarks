% Simulating 2*2 MIMO-LDPC Base-Band Systems
% Copyright (C2010-2015) Yang XIAO, Beijing Jiaotong University, Aug.10, 2010, E-Mail: yxiao@bjtu.edu.cn. 
% This program can simulate 2*2 MIMO-LDPC base-band systems.
% The MIMO system's design can refer my following book.
% [1] Yang Xiao, MIMO Multiple Antenna Wireless Communication Systems, Press of Posts and Telecommunications, Beijing, 2009.
% Different from the MIMO scheme of IEEE 802.16e, our MIMO-LDPC system has no space-time coding, 
% while it achieved good BER performance.    
%---------------------------
clear;
p=87;   %p is the prime number of rank of sub-matrices of parity check matrix;
k2=3;   % k is the row weight of parity check matrix;
j2=6;   % j is the column weight of parity check matrix;
M=k2*p; % M is the number of row of parity check matrix;
N=j2*p;  % N is the number of column of parity check matrix;            


NT1=1;
E0=eye(p);
EZ=zeros(p);
a=3; b=5;
R=0.5; % coding rate
frame_num =200;       
Npf=2*N*frame_num
dlta=1/Npf;

EZ=zeros(p);
E0=eye(p);
% The design of parity check matrix of QC LDPC without girth_4, see my book. 
E11=E0;                   E12=circshift(E0,a*NT1);   E13= circshift(E0,a^2*NT1);   E14= circshift(E0,a^3*NT1);   E15= circshift(E0,a^4*NT1);    E16= circshift(E0,a^5*NT1);
E21=EZ;                   E22=E0;                    E23=circshift(E0,a^2*b*NT1);  E24=circshift(E0,a^3*b*NT1);  E25= circshift(E0,a^4*b*NT1);  E26= circshift(E0,a^5*b*NT1);
E31=circshift(E0,b^2*NT1);E32=EZ;                    E33=E0;                       E34=circshift(E0,b^2*a^3*NT1);E35= circshift(E0,b^2*a^4*NT1);E36= circshift(E0,b^2*a^5*NT1);

h1=[E11 E12 E13 E14 E15 E16;
    E21 E22 E23 E24 E25 E26;
    E31 E32 E33 E34 E35 E36]; 
 A(:,1:M)=h1(:,1:M);
 B(:,1:M)=h1(:,M+1:N);
% 
 
 
d=mod(inv_GF2(A)*B,2); 
E00=eye(M);
% The generator matrix of QC LDPC, see my book. 
G=[d' E00];
H=sparse(h1);

N1=0;
N2=16;
% Flat fading MIMO Channel
h11=0.9;
h12=0.3;
h21=0.4;
h22=0.73;

SNRindB1=N1:1:N2;
for i=1:length(SNRindB1)
error_count1= 0;
error_count2= 0;
    for f_n = 1:frame_num 
    SNR=(10^(SNRindB1(i)/10)); 
  	sigma = 1/sqrt(2*R*SNR); 
    x1 = (sign(randn(1,size(G,1)))+1)/2; % random information bits  
    x2 = (sign(randn(1,size(G,1)))+1)/2; % random information bits  
 y1 = mod(x1*G,2);                   % LDPC Encoding for signal_1 from atenna 1 of the transmitter
 y2 = mod(x2*G,2);                   % LDPC Encoding for signal_2 from atenna 2 of the transmitter
    z1=2*y1-1;                       % BPSK modulation
    z2=2*y2-1;                         % BPSK modulation
    z11=h11*z1+h12*z2+sigma*randn(1,size(G,2));    % AWGN transmission
    z22=h21*z1+h22*z2+sigma*randn(1,size(G,2));
HC=[h11 h12;h21 h22];   % Channel Matrix
HC1=HC^(-1);
u=HC1*[z11;z22];        % ZF spatial decoding
u1=u(1,:);              % recieved signal_1 from atenna 1 of the receiver 
u2=u(2,:);              % recieved signal_2 from atenna 1 of the receiver 
    f11=1./(1+exp(-2*u1/sigma^2));        % likelihoods
    f01=1-f11;
    [z1_hat, success, k] = ldpc_decode(f01,f11,H);   %  LDPC decoding for signal_1
    x1_hat = z1_hat(size(G,2)+1-size(G,1):size(G,2));
    x1_hat1 = x1_hat';
    f12=1./(1+exp(-2*u2/sigma^2));        % likelihoods
    f02=1-f12;
    [z2_hat, success, k] = ldpc_decode(f02,f12,H);   %  LDPC decoding for signal_2
    x2_hat = z2_hat(size(G,2)+1-size(G,1):size(G,2));
    x2_hat1 = x2_hat';
    error_count2= sum(xor(x1,x1_hat1))+sum(xor(x2,x2_hat1));    % bit error count
    error_count1 = error_count1 + error_count2; 
    end    
    BER(i)= error_count1/Npf 
    if BER(i)<.1*dlta
    BER(i)=.08*dlta;
    end
end
figure(1)
semilogy(SNRindB1,BER);
xlabel('SNR(dB)');
ylabel('BER');
title('2*2 MIMO-LDPC Simulation');
axis([N1 N2 dlta 1]);
%diary off
