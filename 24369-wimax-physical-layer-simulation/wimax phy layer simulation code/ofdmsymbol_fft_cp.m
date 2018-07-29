function [data_out]=ofdmsymbol_fft_cp(data_in,G,TxRx)

% We can make Nfft as a parameter as well
 Nfft = 256;

 if TxRx==10
      data=data_in'; %this makes the input column vector to a array

% %% making odfm symbol and taking IFFT
% function  symbol_ofdm = createsymbol (pilots,data)

%% now first generate the pilot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=complex(-1,0);
B=complex(1,0);
pilots = [A B A B B B A A];  %%% here we direct making the pilot,detail procedure given below

% n_symbol = 1;  % At the time of generating the pilots, I need to know what symbol i am simulating 
%                % because the seed to do it depends on it.
% % The values of the pilots are to be modulated are defined in the standard as such(pp 443) :
% % Before beginning, it is necessary to consider that the value to calculate depends on 2 factors : 
% % the number of symbols and whether we are in the uplink or dwnlink. We will consider that we are in
% % the downlink and we are transmitting the symbol "1". 
% % If we want to consider the other uplink connection, the seed would be "10101010101".
% % 
% seed = [1 1 1 1 1 1 1 1 1 1 1];
% for i=1:n_symbol+2                         
%     wk(i) = seed (11);                 
%     next = xor(seed(9),seed(11));
%     seed = [next seed(1,1:10)];
% end
% 
% % Once the value of wk is found(that depends on the number of symbol with wihich it is working),
% % the values of the subcarriers must be found and of the mapping of them with BPSK constellation.
% 
% wk = wk(n_symbol+2)
% A = 1 - 2*wk                           % Values defined in the standard.
% B = 1 - 2*(~wk)
% value_carrier = [A B A B B B A A]
% 
% % For uplink, the values should be [A B A B A A A A]
% 
% pilot_mapping = 2*mapping(value_carrier,1,Tx);      
% 
% % The factor of "2" is due to the fact that the pilots are transmitted to a
% % double power of the information bits.

% NOW The guard bands are prepared.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

guard1 = complex (0,0) * ones (1,28);
DC = complex (0,0);
guard2 = complex (0,0) * ones (1,27);

% The pilot and guard subcarriers are placed according to the standard.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

symbol_ofdm = [guard1 data(1:12) pilots(1) data(13:36)...
    pilots(2) data(37:60) pilots(3) data(61:84) pilots(4)...
    data(85:96) DC data(97:108) pilots(5) data(109:132) pilots(6)...
    data(133:156) pilots(7) data(157:180) pilots(8) data(181:192) guard2];

% here the ofdm symbol is completed
%Now taking IFFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 symbol_ofdm = sqrt(Nfft).*ifft(symbol_ofdm,Nfft);

 %Now adding cyclic prefix%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% we generate the cyclic prefix so that the multipaths do not affect our data so much.
margin = length(symbol_ofdm)*G;
data_tx = [symbol_ofdm((end-margin+1):end) symbol_ofdm];
data_out=data_tx;      

   % At receiving end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif TxRx==01
       
data_rx=data_in;
% First, we must remove the CP.
margin = length(data_rx)*G;
margin = margin/(1+G);
symbol_ofdm_rx= data_rx(margin+1:end);
   
% After removing the CP, we have to inverse the IFFT, logcally by FFT. 

 symbol_rx = fft(symbol_ofdm_rx,Nfft) ./ sqrt(Nfft);
  
 % Here the pilots are indicated, since i need to know where they are.
 % now we will be able to estimate the channel.

 pilots = [symbol_rx(41) symbol_rx(66) symbol_rx(91) symbol_rx(116) symbol_rx(142) symbol_rx(167) symbol_rx(192) symbol_rx(217)];
      
% After getting the received symbol, the channel is to be estimated using
% the pilot carriers. This is bypassed for an AWGN channel.
 
% Next, the values of the data and pilot carriers are extracted
 data_total = [symbol_rx(29:40) symbol_rx(42:65) symbol_rx(67:90) symbol_rx(92:115) symbol_rx(117:128)...
           symbol_rx(130:141) symbol_rx(143:166) symbol_rx(168:191) symbol_rx(193:216) symbol_rx(218:229)];
 data_out=data_total'; %this makes it a column vector 
else
      disp('error in ofdmsymbol_fft_cp.m function');
end
        
  

       
 

  

 
 
 
 
 
 
 
 