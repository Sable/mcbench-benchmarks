%==========================================================================
%                         copywrite 2011
%           iterative-Maximum ratio combining (i-MRC) detector
%     for spatial Modulation (SM) MIMO transmission technique.
%
% This Matlab code computes the BER of the SM for the case where the
% channel coefficients are modeled as uncorrelated  Rayleigh fading channel
% M is the modulation order of M-QAM schemes.
% Mt = number of transmit antennas.
% Mr = number of receive antennas.
%                This code is written by Rajab Legnain
%==========================================================================
function simulation_of_SM_iMRC()
clear all;   clc;
mode = 1;                    % mode = 1 the channel is     normalized,  
                             % mode = 2 the channel is not normalized
global M Mt hmodem bit_T
M = 16;   
Mt = 4;
Mr = 4;
bit_SMsym = log2(M*Mt);      % number of bit per spatial modulation sysmbol
Nbits = bit_SMsym*1e4;       % Number of bits to be simulated.

hmodem =   modem.qammod('M',M,  'SymbolOrder', 'Gray','InputType', 'bit');
hdemodem = modem.qamdemod('M', M,'SymbolOrder','Gray','OutputType','bit');
Eac = (mean(hmodem.Constellation .* conj(hmodem.Constellation)));                     
SNR = 0 : 2 :24;             % signal-to-noise ratio in dB
No= (Eac)*10.^(-SNR/10);     % noise variance

L_SNR=length(SNR);
ber= zeros (L_SNR,1); 
bit_R=zeros(Nbits, 1);

%%
bit_T = randi([0 1],Nbits,1);
[mod_T ante]= SpatialMod();    % Spatial Modulation
mod_T = mod_T.';

for ii=1:L_SNR    
    for j = 1 : size(mod_T ,2)
        channel = sqrt(.5)*( randn(Mr,Mt,1) + 1i*randn(Mr,Mt,1)); 
        noise = sqrt(.5)*(randn(Mr , 1) + 1i*randn(Mr , 1))* sqrt(No(ii));      
        p = diag(channel'*channel);               
        switch mode
            case 1
               y = channel(:,ante(j))*(mod_T(ante(j) ,j)./sqrt(p(ante(j)))) + noise;  
               z = (channel'*y)./p.^.5;
            case 2
               y = channel(:,ante(j)) * mod_T(ante(j) ,j) + noise ; 
               z = (channel'*y)./p;
        end        
        [~,ant_est] = max(abs(z));
        bi_ant = de2bi(ant_est - 1 ,  log2(Mt)  ,'left-msb');
        bi_mod = demodulate(hdemodem, z(ant_est,1) );
        bit_R( (j-1)*bit_SMsym+1 : (j-1)*bit_SMsym+bit_SMsym,1) = [bi_ant.' ; bi_mod];
        
    end
    [~,ber(ii,1)] = biterr(bit_T(:,1),bit_R(:));
end

semilogy(SNR,ber(:,1),'color',[0,0.75,0.75],'linestyle','-','LineWidth',1);
grid on;
xlabel('$$SNR$$','Interpreter','latex')
ylabel('BER','Interpreter','latex')
title('Bit Error Rate of SM using i-MRC detector')
legend([num2str(M),'-QAM'] ,  'Location','NorthEast')
end 



function [signal ant_no]= SpatialMod()
global M Mt hmodem bit_T
Nt    = log2(Mt);
Nobit = log2(M);
x = reshape(bit_T,Nobit+Nt,[]);

ant_no =  bi2de([x(1:Nt,:)].' , 'left-msb') + 1;
digMod = modulate(hmodem,x(Nt+1:end,:));


signal = zeros(Mt , length(digMod));


for i = 1 : length(digMod)
    signal( ant_no(i) , i) = digMod(i);
end

signal = signal.';
end
