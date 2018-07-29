
%% BER COMPARISON of different M-ary QAM

% ========================================%
% User Defined Functions used in this Files are
% s2p --> Serial to Parallel Conversion
% p2s --> Parallel to Serial Conversion
% ========================================%

clc;
clear all;
close all;

bits = 1.e6;
msg  = round(rand(1,bits));                                                             % Generating Random Bit Stream
M = [4 16 64 256];                                                                                 % M-ary


for j=1:4

% ================================== Tx ============================================%

%% 16-QAM Modulation

bits_sym = log2(M(j));                                                                             % Bits per Symbol for M-ary
sym_tx = s2p(msg,bits_sym);                                                               % Serial to Parallel Conversion for QAM

H_Tx = modem.qammod('M', M(j), 'PHASEOFFSET', 0, 'SYMBOLORDER', 'BINARY', ...
                                                    'INPUTTYPE', 'BIT');                           % Generate Handle for Modulation
qam_tx = modulate(H_Tx,sym_tx);                                               % Modulation

%==================================== CHANNEL =======================================%

Eb_No = 0:2:30;
SNR = Eb_No + 10*log10(log2(M(j)));                                         % Finding out SNR from Eb/No

for i=1:length(Eb_No)

    qam_n = awgn(qam_tx,SNR(i),'measured');                      % Adding AWGN

    % ================================== Rx ============================================%
   
%% QAM De-Modulation

qam_rx = p2s(qam_n);
H_Rx = modem.qamdemod('M', M(j), 'PHASEOFFSET', 0, 'SYMBOLORDER', 'BINARY', ...
                 'OUTPUTTYPE', 'BIT');                                                 % Generate Handle for Modulation
sym_rx = demodulate(H_Rx,qam_rx);                                % Modulating data to QAM

%% Symbols to Msg Conversion

msg_rx = p2s(sym_rx);
msg_rx = msg_rx(1,1:length(msg));

[ErrBits BER(i,j)] = symerr(msg_rx,msg);                            % Calculating BER by comparisson of Rx and Tx msg

%%  Plot of  BER vs Eb/No
end

end


semilogy(Eb_No,BER(:,1),'r-*',Eb_No,BER(:,2),'b-v',Eb_No,BER(:,3),'y-s',Eb_No,BER(:,4),'m-o');    
legend('M=4','M=16','M=64','M=256');
title('BER for QAM using AWGN channel');
ylabel('BER');
xlabel('Eb/No (dB)');
grid;

% ========================================%
% Programmed By SHEIKH MUKHTAR HUSSAIN
% Fell free to contact
% mh_shiningstar@hotmail.com
% This is not copyright
% You are free to copy, edit and forward it
% ========================================%
