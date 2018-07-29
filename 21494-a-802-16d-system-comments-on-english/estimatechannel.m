function data_rx = estimatechannel(pilot_tx,data_tx,v_pilot,symbol_rx,channel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                       %
%%     Name: estimatechannel.m                                           %
%%                                                                       %
%%     Description: In this function, an estimation of the channel is    %
%%      realized.                                                        %
%%                                                                       %
%%     Result: The result is the data when we have realized the          %
%%      estimation. Only the decoding would be left afterwards.          %
%%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The following command would serve to calculate the pilots received and
% from then we can initiate the calculations for estimating the channel.
% ---> pilots_rx = symbol_rx(v_pilot);


% In this case, we calculate the frequency response of each component of
% the channel.
v_estimate = fft(channel,256);
v_estimate = conj(v_estimate');


% We undo what the channel has done to each of the samples in the symbol.
data_rx = symbol_rx ./ v_estimate;