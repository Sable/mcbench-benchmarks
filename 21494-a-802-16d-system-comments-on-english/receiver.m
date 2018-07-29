function symbol_rx = receiver (symbolTx,G);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%     Name: receiver.m                                                  %
%%                                                                       %
%%     Description: In this function, the sampling of the signal which   %
%%      has arrived from the channel is realised.It is done with the     %
%%      FFT function. Before that, the Cyclic Prefix must be cleared     %
%%      which was added in the transmitter.                              %
%%                                                                       %
%%     Parameters: The arriving symbol and the size of the CP.           %
%%                                                                       %
%%                                                                       %
%%     Result: It gives back the chain of bits corresponding to the      %
%%      sent data. It is necessary to decode them now.                   %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 Nfft = 256;
 Tx = 0;            % Indicating that we are not transmitting.
 
% First, we must remove the CP.
 
 symbol_ofdm_rx = cyclic(symbolTx,G,Tx);
 
% After removing the CP, we have to inverse the IFFT, logcally by FFT.
 
 symbol_rx = fft(symbol_ofdm_rx,Nfft) ./ sqrt(Nfft);



