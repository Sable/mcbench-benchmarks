function  symbol_ofdm = createsymbol (pilots,data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%         Archivo: createsymbol.m                                       %
%%                                                                       %
%%         Description: 3 things are assembled with this function:       %
%%          --> Pilot carriers                                           %
%%          --> Data carriers                                            %
%%          --> Guard carriers                                           %
%%                                                                       %
%%         Result: The result is the OFDM symbol ready for the cyclic    %
%%          prefix to be added and to be sent through the channel.       %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The guard bands are prepared.

guard1 = complex (0,0) * ones (1,28);
DC = complex (0,0);
guard2 = complex (0,0) * ones (1,27);

% The pilot and guard subcarriers are placed according to the standard.

symbol_ofdm = [guard1 data(1:12) pilots(1) data(13:36)...
    pilots(2) data(37:60) pilots(3) data(61:84) pilots(4)...
    data(85:96) DC data(97:108) pilots(5) data(109:132) pilots(6)...
    data(133:156) pilots(7) data(157:180) pilots(8) data(181:192) guard2];