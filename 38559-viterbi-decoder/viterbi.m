%% Viterbi Decoder implementation 
% Encoder: [1+D^2, 1+D+D^2]
% Channel: AWGN, Modulation: BPSK

%% Paramenter Declaration
close all;clear all;clc;
SNRdB=1:1:12;                       %SNR in dB
SNR=10.^(SNRdB/10);                 %SNR in Linear Scale
ber=zeros(1,length(SNR));           %Simulated BER 
bl=1E6;                             %Bit Length
N=1E3;                              %Block Length
info_bits=floor(2*rand(1,bl));      %Information bits (0 or 1) of length bl
        
for i=N-1:N:bl %Assigning last and second last bit of each block of length N as 0
   info_bits(i)=0;info_bits(i+1)=0; 
end

%% Encoding Part
code_bit0=conv([1 0 1] , info_bits);    %1st Code Bit
code_bit1=conv([1 1 1] , info_bits);    %2nd Code Bit

code_bit0(code_bit0 == 2)=0;
code_bit0(code_bit0 == 3)=1;
code_bit1(code_bit1 == 2)=0;
code_bit1(code_bit1 == 3)=1;
% Modulating Code Bits using BPSK Modulation
mod_code_bit0=2*code_bit0(1:bl)-1;   
mod_code_bit1=2*code_bit1(1:bl)-1;
fprintf('Encoding completed...\n');
%% Decoding Part
for k=1:length(SNR)
    % Received codebits
    y0=(sqrt(SNR(k))*mod_code_bit0)+randn(1,bl);   
    y1=(sqrt(SNR(k))*mod_code_bit1)+randn(1,bl);   
        
    for p=1:N:bl                    %Decoding is done individually for each block of length N
        distance=zeros(4,N+1);   	%For storing minimum distance for reaching each of the 4 states
        metric=zeros(8,N);         	%For storing Metric corresponding to each of the 8 transitions
        distance(1,1)=0;distance(2,1)=Inf;distance(3,1)=Inf;distance(4,1)=Inf; %Initialization of distances
        
        for i=1:N
            metric(1,i)=norm([-1,-1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 00 to 00
            metric(2,i)=norm([+1,+1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 00 to 10
            metric(3,i)=norm([-1,+1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 10 to 01    
            metric(4,i)=norm([+1,-1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 10 to 11
            metric(5,i)=norm([+1,+1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 01 to 00
            metric(6,i)=norm([-1,-1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 01 to 10
            metric(7,i)=norm([+1,-1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 11 to 01
            metric(8,i)=norm([-1,+1]-[y0(i+p-1),y1(i+p-1)]);    %Mertic for transition from state 11 to 11
  
            distance(1,i+1)=min(distance(1,i)+metric(1,i),distance(3,i)+metric(5,i));%Minimum distance to reach state 00 at time i
            distance(2,i+1)=min(distance(1,i)+metric(2,i),distance(3,i)+metric(6,i));%Minimum distance to reach state 10 at time i
            distance(3,i+1)=min(distance(2,i)+metric(3,i),distance(4,i)+metric(7,i));%Minimum distance to reach state 01 at time i
            distance(4,i+1)=min(distance(2,i)+metric(4,i),distance(4,i)+metric(8,i));%Minimum distance to reach state 11 at time i     
        end
    
        [~,state]=min(distance(:,N+1)); %For the final stage pick the state corresponding to minimum weight
    
        %Starting from the final stage using the state, distances of previous stage and metric,
        %decoding the previous state and the corresponding Code bit
        for j=N:-1:1
            [state,decoded_bit]=prev_stage(state,distance(:,j),metric(:,j));
            decoded_bit_final(j+p-1)=decoded_bit; %Storing the decoded bit in decode_bit_final vector
        end
    end             %Decoding for one block ends here
    
    %Calclating BER by comparing decode bit and corresponding transmitted bit
    ber(k) = (sum ( abs( decoded_bit_final-info_bits ) ) )/bl;      
    string = [num2str(round(k/length(SNR) * 100)) , '% decoding completed ...'];
    disp(string);
end

semilogy(SNRdB,ber,'r-<','linewidth',2.0)     %Plot for Union Bound of BER
hold on
%% Theoretical BER
BER=zeros(1,length(SNR));
for j=1:1:10
   BER=BER+(2^j)*(j)*qfunc(sqrt((j+4)*SNR)); 
end

semilogy(SNRdB,BER,'k-','linewidth',2.0)      %Plot for Simulated BER 
axis tight;grid;
legend('Simulated BER','Theoretical Union Bound on BER');
title('Viterbi decoder performance over AWGN channel for BPSK modulated symbols');
xlabel('SNR(dB)');ylabel('BER');