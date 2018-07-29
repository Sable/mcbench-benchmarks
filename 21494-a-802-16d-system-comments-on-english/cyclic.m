function m_tx_guard = cyclic(symbol_ofdm,G,Tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                      %
%%      Name: cyclic.m                                                  %
%%      Description: It receives the vector OFDM symbol just before     %
%%       sending it through the channel.                                %
%%                                                                      %
%%      Parameteres:                                                    %
%%        --> Tx = 1 -->it is transmitting and we just need to add      %
%%            the cyclic prefix.                                        %
%%            If Tx = 0, it is receiving and the cyclic prefix must be  %
%%            eliminated.                                               %
%%       Result: It gives back the same vector with the cyclic prefix   %
%%        added accoeding to the given proportion of G (1/4, 1/8,       %
%%        1/16 y 1/32)                                                  %
%%                                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Amount that must be added to the OFDM symbol
  margin = length(symbol_ofdm)*G;
       
if Tx==1
       m_tx_guard = [symbol_ofdm((end-margin+1):end) symbol_ofdm];
    
elseif Tx==0
    margin = margin/(1+G);
    m_tx_guard = symbol_ofdm(margin+1:end);
    
end
