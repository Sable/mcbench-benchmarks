function symbolTX = transmitter (pilot_mapping,data_mapping,G)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%         Name: transmitter.m                                           %
%%                                                                       %
%%         Description: The symbol to be transmitted is formed and       %
%%          passed to the frequency domain.                              %
%%                                                                       %
%%         Parameters: The encoded data, the mappings, the pilots and    %
%%          their positions.                                             %
%%                                                                       %
%%         Result:It gives back the chain of bits, already modulated     %
%%          in frequency, thanks to the IFFT, prepared to be sent        %
%%          through the channel.                                         %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We can make Nfft as a parameter as well, but we are keeping it fixed in
% this case.
 Nfft = 256;
 Tx = 1;            % It is indicated that data is being transmitted.

 

 symbol = createsymbol (pilot_mapping,data_mapping);
 
 symbol_ofdm = sqrt(Nfft) .* ifft(symbol,Nfft);
 
% Finally we generate the cyclic prefix so that the multipaths do not
% affect our data so much.

 symbolTX = cyclic(symbol_ofdm,G,Tx);



