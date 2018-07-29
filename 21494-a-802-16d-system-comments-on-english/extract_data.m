function data_rx = extract_data(symbol_ofdm_rx,v_pilots)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%       Name: extract_data.m                                            %
%%                                                                       %
%%       Description: In this function, the inverse process of the       %
%%        function "createsymbol.m" is realized. That is, we extract     %
%%        the known parts of the symbol that we have received:           %
%%        --> Pilot carriers                                             %
%%        --> Data carriers                                              %
%%        --> Guard carriers                                             %
%%                                                                       %
%%       Result: The data is given back only, since the rest does not    %
%%        interest us.                                                   %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% First, the position of the data is located 
 v_data = setxor(1:length(symbol_ofdm_rx),v_pilots);
 
% Next, the values of the data and pilot carriers are extracted
 data_total = symbol_ofdm_rx (v_data);
  
% Now the dc carrier must be removed
 data_rx = [data_total(29:124) data_total(126:221)];