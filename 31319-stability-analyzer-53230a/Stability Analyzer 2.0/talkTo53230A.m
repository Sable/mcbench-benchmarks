function fMeas = talkTo53230A(sRate, sCount, IP_Address, inputZ)
%This function connects to a 53230A, makes gap-free measurements. SCount
%is number of measurements and SRate is the gap-free sample rate. inputZ is 
%the desired input impedance of the 53230A, 50 Ohm or high Z.
%IP_Address is the IP address of the 53230A
%questions or feedback: neil underscore forcier at agilent dot com

% Find a tcpip object.
obj1 = instrfind('Type', 'tcpip', 'RemoteHost', IP_Address, 'RemotePort', 5025, 'Tag', '');

% Create the tcpip object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = tcpip(IP_Address, 5025);
else
    fclose(obj1);
    obj1 = obj1(1);
end

%calculate input buffer for matlab each tst is 23 long including comma
buffer = (40*sCount) + 4;

% Configure instrument object, obj1
set(obj1, 'InputBufferSize', buffer);


% Configure instrument object, obj1
set(obj1, 'OutputBufferSize', 20000000);

% Connect to instrument object, obj1. If fail throw error and exit function
try
    fopen(obj1);
catch exception
    uiwait(msgbox(exception.message,'Error Message','error'));
    fMeas = -42881; 
    rethrow(exception);
    return;
end
% Communicating with instrument object, obj1.
data1 = query(obj1, '*IDN?');
% print reply
fprintf('Connected to-->%s',data1);

%reset powerplay start from known state
fprintf(obj1, '*RST');

%set instr timeout to infinite, let Matlab handle timeouts
fprintf(obj1, 'SYST:TIM INF');
fprintf(obj1, 'CONF:FREQ (@1)');
fprintf(obj1, 'FREQ:MODE CONT');
fprintf(obj1, 'INP1:COUP DC');
if inputZ == 50 %set 53230A input Z
    fprintf(obj1, 'INP1:IMP 50');%to 50 ohm
else
    fprintf(obj1, 'INP1:IMP 1e6');%to 1M ohm
end
fprintf(obj1, '*WAI');
%get peak to peak amp value for setting range and trigger level
ptp = str2double(query(obj1,'INP:LEV:PTP?'));

if ptp > 5.5 %sets input amplitude range 
    %set input amp range for 50V
    fprintf(obj1, 'INP:RANG 50');
else
    %set input amp range for 5V
    fprintf(obj1, 'INP:RANG 5');
end

vMax = str2double(query(obj1,'INP:LEV:MAX?'));
tLevel = vMax - (ptp/2); %calculate trigger level at mid point on sig amp

command1 = 'INP1:LEV ';
command = [command1 num2str(tLevel)];
fprintf(obj1, command);
fprintf(obj1, 'INP1:SLOP POS');
command1 = 'FREQ:GATE:TIME ';
command = [command1 num2str(1/sRate)];
fprintf(obj1, command);
command1 = 'SAMP:COUN ';
command = [command1 num2str(sCount)];
fprintf(obj1, command);
fprintf(obj1, 'TRIG:SOUR IMM');
fprintf(obj1,'INIT');
    
%loop until done making meas and have all the readings from memory
count = 0; %tracks reading count
fMeas=zeros(1,sCount); %allocate array
pos = 1; %tracks postion of array

%set up waitbar with cancel button
j = 1/sCount;
h = waitbar(0,'Performing frequency measurements with 53230A...','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

disp('Making measurements and retreiving readings this will take t = (1/sRate)* sample count....');
while ~isequal(count,sCount)
   readings = query(obj1,'DATA:POIN?');
   if str2double(readings)~=0
       command =['DATA:REM? ' readings];
       strTemp = query(obj1,command);
       strTemp = strrep(strTemp, ',', ' ');
       
       g = cell2mat(textscan(strTemp,'%f'))';
       fMeas(pos:(pos+length(g)-1))= g;
       pos = pos+length(g);
   end
   count = count + str2double(readings); 
   %if the waitbar cancel button was pressed do the following
   if getappdata(h,'canceling')
        fMeas = [];
        fMeas = -42881;
        delete(h);
        return;
    end
   waitbar((count*j),h,'Performing frequency measurements with 53230A...');
end
disp('Performing calculations....');
waitbar(1.0,h,'Finished frequency measurements');
delete(h);
%check for error
data1 = query(obj1,'SYST:ERR?');
% print reply
fprintf('53230A Errors-->%s',data1);

% Disconnect from instrument object, obj1.
fclose(obj1);
end