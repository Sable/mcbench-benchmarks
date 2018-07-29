function [symbolRx,hHat] = decoder (pilots_tx,data_tx,symbol_channel_rx,n_mod_type,codeRS,template,snr,encode,bits_ofdm,channel,SUI);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%     Name: decoder.m                                                   %
%%                                                                       %
%%     Description: In this file, the different stages of the WiMAX      %
%%      Receiver are called to undo all the stages realized in the       %
%%      transmitter.(Encoding, Interleaving, Randomization)              %
%%                                                                       %
%%                                                                       %
%%      Parameters: All the parameters that have comprised the           %
%%       transmitter : used modulation, Reed Solomon code, template      %
%%       of puncturing, the SNR, size of the Cyclic Prefix and the       %
%%       Received symbol.                                                %
%%                                                                       %
%%      Result: It gives back the chain of bits corresponding to the     %
%%       sent data.                                                      %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters that have not been introduced in the call of the function.
  
 BSID = 1;            % These three values comprise the algorithm of the  
 DIUC = 7;            % randomization of data. The are used to calculate
 Frame = 1;           % the seed.
 
 Tx = 0;              % Indicate that we are not transmitting.

% Here the position of the pilots are indicated, since i need to know where
% they are to be able to estimate the channel.

 v_pilots = [41 66 91 116 142 167 192 217]; 
 
% After getting the received symbol, the channel is to be estimated using
% the pilot carriers. This is bypassed for an AWGN channel.

if SUI == 0
    estimate_rx = symbol_channel_rx;
elseif SUI ~= 0
    estimate_rx = estimatechannel(pilots_tx,data_tx,v_pilots,symbol_channel_rx,channel);  
end


% We have already secured the OFDM symbol in the frequency domain. Now
% we must properly extract the data of this symbol.
 
 data_mapped_rx = extract_data(estimate_rx,v_pilots);
 
% Once the sent bits have been extracted and the channel has been
% estimated, the inverse process for the encoding must be done. In the
% first place, we have to demap the signal.

 data_interleaved_rx = mapping(data_mapped_rx,n_mod_type,Tx);

 if encode
     % If we have encoded the data, it must be sent to the convolutional
     % decoder after being de-interleaved. First we De-interleave.

     data_convolutional_rx = interleaving (data_interleaved_rx,n_mod_type,Tx);

     % Now the data is sent to the convolutional decoder.
     
     data_RS_rx = viterbi(data_convolutional_rx,template,Tx);

     % Now the data is sent to the ReedSolomon decoder.
     
     data_random_rx = ReedSolomon (data_RS_rx,codeRS,Tx);

     % The data was first randomized, so now finally we have to
     % de-randomize the data to get the received signal.

     symbolRx = random (data_random_rx,BSID,DIUC,Frame) ;
     
 else
     % If the data was not encoded, it will be enough to only de-interleave
     % the signal.

     symbolRx = data_interleaved_rx;
          
 end

 return;
 