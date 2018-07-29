function n_ber = systems (SNR,n_mod_type,G,N_SUI,encode,samples,BW,channel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
%%                                                                       %
%%      Name: systems.m                                                  %
%%                                                                       %
%%      Description: All the different stages of the system are          %
%%       called from this function. These stages are the encoder,        %
%%       the transmitter, the channel, the receiver and the decoder.     %
%%       The channel, through which the information and noise travel,    %
%%       is also simulated here.                                         %
%%                                                                       %
%%      Parameters: Each simulation depends on the signal to noise       %
%%       ratio of the system, type of modulation, size of the cyclic     %
%%       prefix, the channel that we are simulating, if the data is      %
%%       encoded or not and the number of bits sent; not to forget       %
%%       the bandwidth that we have available.                           %
%%                                                                       %
%%      Result: When the whole simulation is finished, the value of      %
%%       the BER is returned, with which a graph is shown that is of     %
%%       interest.                                                       %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if n_mod_type == 1              % As the rate is not one of the things that interfere at first, I define it here.
    rate = 1/2;                 % It might be treated as a parameter and the value might be set manually.
end                             
rate = 3/4;                     

Nfft = 256;

data_total_rx = [];
data_total = [];
data_out = [];
data_in = [];

n_symbols = samples;          % Total symbols to transmit


% Depending on the input data (modulation, rate, number of symbols and if i encode or not)
% i generate the necessary data to carry out the simulation

[data_total,amount,codeRS,template,n_symbols,rate] = generatedata(n_mod_type,rate,n_symbols,encode);
bits_ofdm = amount * 8;


 for i=1:n_symbols
    % We combine only the groups of bits necessary to form an OFDM symbol.
     data_in = data_total( 1+(i-1)*bits_ofdm : i*bits_ofdm );
          
    % When the bits of the symbol to transmit are ready,the transmitter is called so that it forms the complete OFDM symbol
    
     [pilot_mapping,data_mapping] = encoder(data_in,codeRS,template,n_mod_type,encode);
     
     symbolTx = transmitter (pilot_mapping,data_mapping,G);
      
    % The channel is simulated:
     if N_SUI == 0                       % AWGN channel 
         symbol_channel = symbolTx;
     elseif N_SUI~=0                     % Channel with fading
         
         NextSymbol = 8 .* sqrt(Nfft) .* ifft(randint(1,Nfft));
         symbolTx = [NextSymbol NextSymbol symbolTx];
         symbol_channel = filter(channel,1,symbolTx);
         symbol_channel = symbol_channel(end-(256*(1+G))+1:end);
     end
     
    % The receiver is simulated:
     symbol_channel_rx = receiver (symbol_channel,G);
  
    % THe AWGN noise is added with certain relation to the SNR:
     noise_channel = noise(symbol_channel_rx,SNR,n_mod_type,encode,rate,G);
     symbol_channel_rx = symbol_channel_rx + noise_channel;
   
     
    % Decode the received bits:
     data_out = decoder (pilot_mapping,data_mapping,symbol_channel_rx,n_mod_type,codeRS,template,SNR,encode,bits_ofdm,channel,N_SUI);

    % The results are accumulated to finally verify the error.
     data_total_rx = [data_total_rx data_out];
 
 end

% Now the rate of error of the transmission is verified.

  n_ber = mean( data_total_rx(:) ~= data_total(:));

    