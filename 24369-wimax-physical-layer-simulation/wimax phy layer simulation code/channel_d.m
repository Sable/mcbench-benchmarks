%% Channel
% Send signal over an AWGN channel.
function [data_rx]=channel_d(data_tx,snr)

%% specify the snr level
%snr =10; % In dB

data_rx = awgn(data_tx,snr,'measured');
