% MATLAB PSA/MXA IQ 
% Getting IQ data using the PSA/MXA driver and plot display
% SOURCE SETUP...QPSK singal, @ 1 GHz carrier, 5 Msps, & Gausian filter
% Version: 1.0
% Date: Sep 11, 2006  
% 2006 Agilent Technologies, Inc.

% TCPIP parameters
%  I connected using cross-over.  Use 192.168.100.1 for PC
mxa_ip = 'localhost';
mxa_port = 5025;

% MXA Interface creation and connection opening
mxa_if = tcpip(mxa_ip,mxa_port);
mxa = icdevice('IQ_Analyzer_v14.mdd', mxa_if);
connect(mxa,'object')

set(mxa,'Mode','Basic')

set(mxa,'SAFreqCenter',1000000000)

set(mxa,'SASweepSingle', 'Off')

set(mxa,'WavAcquisitionTime',.000070)

set(mxa,'WavRBW',6000000)

%example of passing SCPI
invoke(mxa,'WriteSCPI',':INIT:IMM');

% Get IQ data
iq = invoke(mxa,'WavReadIQData');

% Create a figure 1 and bring it to the front
figure(1)

% Vector plot (imag vs real)
plot(real(iq),imag(iq))

% Axis adjustment
axis([-.2 .2 -.2 .2])
axis square

% Labels
xlabel('I')
ylabel('Q')
title('IQ vector plot')

% Close the MXA connection and clean up
disconnect(mxa);
delete(mxa);
clear mxa;
