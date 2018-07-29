% PSA depp capture driver program test 

% Clean up any unclosed instrument object
instrreset

% Initial setup
psa_ip = '141.121.95.145';
psa_port = 5025;

% MXA Interface creation and connection opening
fprintf('\nConnecting to PSA ...\n');
psa_if = tcpip(psa_ip,psa_port);

psa = icdevice('Agilent_SA_Driver.mdd', psa_if);

connect(psa)

get(psa, 'InstrumentModel')

%This is very similiar to the example in the BASIC mode programmers guide
%Please review that document for questions on the commands
geterror(psa)

set(psa,'Mode','Basic')

devicereset(psa)

invoke(psa,'WavInitIQData')

set(psa,'SASweepSingle','Off')

set(psa,'SABlank','On')

set(psa,'WavTraceDisplay','On')

set(psa,'WavIFWidth','Wide')

set(psa,'SAFreqCenter',1000000000)

set(psa,'WavAcquisitionTime',.00015)

set(psa,'WavSampleRate',50000000)

set(psa,'WavTriggerSource','Free_Run')

set(psa,'WavTimeCapture',.0025)

invoke(psa,'InitCaptureData')

get(psa,'OperationComplete')

set(psa,'WavNextCapture',1)

N = get(psa,'WavLastCapture')

%The driver tells MATLAB you are getting MSB first
set(psa,'ByteOrder','Normal')

% Get IQ data
iq = invoke(psa,'WavDeepCapture');

if 0
disconnect(psa_if)
delete([psa psa_if])
end
%fopen(psa);
