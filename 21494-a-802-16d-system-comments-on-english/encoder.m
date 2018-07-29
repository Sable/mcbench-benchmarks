function [pilot_mapping,data_mapping] = encoder (data_in,codeRS,template,n_mod_type,encode)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%         Name: encoder.m                                               %
%%                                                                       %
%%         Description: In this file, all the different stages of        %
%%          the transmitter is called, which are defined in the  r       %
%%          IEEE802.16-2004 standard.                                    %
%%                                                                       %
%%         Result: It returns the chain of bits, already modulated       %
%%          in frequency domain, thanks to the IFFT, prepared to be      %
%%          through the channel.                                         %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 BSID = 1;            % These three values are for the algorithm of randomization of the data. 
 DIUC = 7;            % They are used to calculate the seed.
 Frame = 1;           
 
 
 n_symbol = 1;         % At the time of generating the pilots, I need to know what symbol i am simulating 
                       % because the seed to do it depends on it. 
                       
                       
 Tx = 1;               % For some functions, it is necessary to indicate that i am transmitting and not receiving.
  
if encode
    % According to the scheme, i mus introduce the data to transmit by
    % diverse phases of encoding. We begin the randomization.

     data_random = random (data_in,BSID,DIUC,Frame);

    % Now i encode with Reed-Solomon coding:

     data_RS = ReedSolomon(data_random,codeRS,Tx);

    % Afterwards, the data is sent to th convolutional encoder.

     data_convolutional = viterbi (data_RS,template,Tx);

    % Finally, we interleave the block:

     data_interleaved = interleaving (data_convolutional,n_mod_type,Tx);
else 
   
    data_interleaved = data_in;
    
end

% Once the encoding is done, the data is mapped following the constellation
% in which we are working.

 data_mapping = mapping (data_interleaved, n_mod_type,Tx);
 
% Before the OFDM symbol is created, the pilot carriers must be inserted,
% which help with channel estimation.

 pilot_mapping = generatepilot(n_symbol,Tx);
 
return;
