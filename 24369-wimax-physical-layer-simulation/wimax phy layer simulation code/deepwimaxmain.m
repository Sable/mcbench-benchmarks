%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
%%                    Name: deepwimaxmain.m                             %%
%%     In this the main file to simulate wimax PHY layer                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
clear all

    disp(' *******************************************************************************************');
    disp(' *                                                                                         *');
    disp(' *                                   M.Tech dissertation                                   *');
    disp(' *                                                                                         *');
    disp(' *              "Characterization of Physical Layer in IEEE 802.16e Standards"             *');    
    disp(' *                                                                                         *');    
    disp(' *                         Study Done by Deepak Kumar Rathore                              *');
    disp(' *                           Deptt. of ECE, NIT Kurukshetra                                *');
    disp(' *******************************************************************************************');
    disp('  ');
    disp('---> To do Simulate different modulation please enter ur choice:');
    disp('  ');
    disp('    --------------------------------------------------------------------------------------------------');
    disp('    | Modulation | BPSK 1/2 | QPSK 1/2 | QPSK 3/4 | 16-QAM 1/2 | 16-QAM 3/4 | 64-QAM 2/3 | 64QAM-3/4 |')          
    disp('    |------------|----------|----------|----------|------------|------------|------------|-----------|');
    disp('    |  rate_id   |   0      |    1     |     2    |     3      |     4      |     5      |     6     |');
    disp('    --------------------------------------------------------------------------------------------------');
    disp('  ');
    rate_id=input('      Please enter the rate_id =   ');
    disp('  ');
    G=input('      Please select the value of G(Cyclic Prefix) [1/4 1/8 1/16 1/32] G= ');
    disp('  ');
    no=input('      please enter number of ofdm symbol (eg. 10 50 100)  no=  '); 
    disp('  ');
    disp('      Realizing the simulation... Please wait a while.....');
    
bit_error_rate=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
for q=1:no
%%% data generation
data_get =data_gen(rate_id);
%%% data randomization
data_rand=randomizer(data_get);
%%% FEC ENCODER
data_rscoded=rsencodecod(data_rand,rate_id,10);
%%convolution encoder
data_coded=convolution(data_rscoded,rate_id,10);
%%% INTERLEAVING
data_interleav=interleav_d(data_coded,rate_id);
%%% Digital modulator SYMBOL MAPPER
data_mod=mod_d(data_interleav,rate_id);
%%% IFFT modulator
data_tx=ofdmsymbol_fft_cp(data_mod,G,10);

SNR=[1 2 3 5 7 9 10 12 15 17 20 22 25 27 30]; % specify SNR 
for p=1:1:15  
   snr=SNR(p);
   %%% channel 
   data_rx=channel_d(data_tx,snr);
   %%% FFT demodulator
   data_rxp=ofdmsymbol_fft_cp(data_rx,G,01);
   %%% Digital demodulator SYMBOL DEMEPPER
   data_demod=demod_d(data_rxp,rate_id);
   %%% DEINTERLEAVING
   data_deinterleav=deinterleav_d(data_demod,rate_id);
   % %%% FEC DECODER
   %% convolution decoder
   data_decoded=convolution(data_deinterleav,rate_id,01);
   %%% RSdecoder 
   data_rsdecoded=rsencodecod(data_decoded,rate_id,01); % removing added tail bits
   %%%  Data Derandomizer
   data_unrand=randomizer(data_rsdecoded);
   %% BER calculation
  [noerr(p),ber(p)] = biterr(data_unrand,data_get);
end
bit_error_rate=bit_error_rate+ber;
end
bit_error_rate=bit_error_rate/no
%%plot the grapgh
result=berplot(SNR,bit_error_rate,rate_id)

