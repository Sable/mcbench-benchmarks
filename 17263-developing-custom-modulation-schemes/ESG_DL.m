function ESG_DL(data, Fs, ipaddress, Source_Freq, RF_Amplitude_Out)
% ESG_DL allows the user to pass ESG control parameters via Simulink 'ESG Download Block'
% and then download the simulated data to the Agilent E4438C Signal Generator
% Function variables which get passed from Simulink are:
% 'data'                Complex data structure generated from Simulink
% 'Fs'                  Sample Rate
% 'ipaddress'           IP Address of ESG
% 'Source_Freq'         ESG RF Frequency
% 'RF_Amplitude_Out'    ESG RF Amplitude 
% NOTE: The called functions below require the Agilent Waveform Download Assistant .m files loaded in your path 
% Written by David L. Barner - 12/7/2006
% Revision Marta Wilczkowiak - 01/10/2007

io = agt_newconnection('tcpip',ipaddress);

[status, status_description,query_result] = agt_query(io,'*idn?');
if (status < 0) return; end

% query_result

% make sure to pass column vector
if (size(data, 1)>size(data, 2))
    data = data.';
end

maximum = max( [ real( data ) imag( data ) ] );
data = 0.7 * data / maximum;

[status, status_description] = agt_sendcommand(io, Source_Freq);
[status, status_description] = agt_sendcommand(io, RF_Amplitude_Out);
[status, status_description] = agt_waveformload(io, data, 'agtsample1', Fs, 'play','no_normscale');
[status, status_description] = agt_sendcommand( io, 'OUTPut:STATe ON' );

