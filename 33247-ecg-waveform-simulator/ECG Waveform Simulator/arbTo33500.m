function arbTo33500(ecgArb,arbName)
%This function inputs waveform points and name and sends it to a 33521A or 33522A function / arbitrary
%waveform generator. The function uses LAN to connect to the 33521A/33522A and queries user for the
%instruments IP addresss.

%Start talking to 33522A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input IP address
IP_address = input('Enter IP address: ','S');

%create address string
vAddress = ['TCPIP0::',IP_address,'::inst0::INSTR'];

% Find a VISA-TCPIP object.
obj1 = instrfind('Type', 'visa-tcpip', 'RsrcName', vAddress, 'Tag', '');

% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = visa('AGILENT', 'TCPIP0::A-33522A-00665.lvld.agilent.com::inst0::INSTR');
else
    fclose(obj1);
    obj1 = obj1(1)
end

% Configure instrument object, obj1
set(obj1, 'InputBufferSize', 512);

% Configure instrument object, obj1
set(obj1, 'OutputBufferSize', 2000000);

% Connect to instrument object, obj1.
fopen(obj1);

%get 3352xA info and print it
data1 = query(obj1, '*IDN?');
% print reply
fprintf('%s',data1);

%set the 3352xA to arb for channel 1
fprintf(obj1, 'SOUR1:FUNC ARB');

%Clear violatile memory for chan 1
command = 'SOUR1:DATA:VOL:CLE';
fprintf(obj1,command);

%set byte order for bin block data
fprintf(obj1,'FORM:BORD SWAP');

%Send ECG to 3352xA using binblock for better efficency
commandName = ['SOURce1:DATA:ARBitrary ',arbName,', '];
binblockwrite(obj1, ecgArb, 'float32', commandName);

%select arb in volatile memmory 
commandName = ['SOUR1:FUNC:ARB "',arbName,'"'];
fprintf(obj1, commandName);
 
%store each ECG waveform in intermal NV memory
commandName = ['MMEM:STOR:DATA1 "INT:\',arbName,'.arb"'];
fprintf(obj1, commandName);

%set sample rate
fprintf(obj1, 'SOUR1:FUNC:ARB:SRAT 10000');

%set output impedence to high Z
fprintf(obj1, 'OUTP1:LOAD INF');

%set output amplitude on channel
fprintf(obj1, 'SOUR1:VOLT 1 VPP');
 
%set output filter to off
fprintf(obj1, 'SOUR1:FUNC:ARB:FILT OFF');
 
%turn output on
fprintf(obj1, 'OUTP1 ON');

%check for error
data1 = query(obj1,'SYST:ERR?');
% print reply
fprintf('%s',data1);

%Disconnect from instrument object, obj1.
fclose(obj1);
