function saverd3(fname,A,timewindow,timeinterval,antennasep)
% saverd3(fname,A,timewindow,timeinterval,antennasep)
%
% timewindow: [ns]
% timeinterval: seconds between traces
%
% Aslak Grinsted feb 2004

fname=strrep(lower(fname),'.rd3','');

fid=fopen([fname '.rd3'],'w');
A=(A-mean(mean(A)));
A=A*32767./max(max(abs(A)));
fwrite(fid,A,'short'); % should it be transposed?
fclose(fid);

fid=fopen([fname '.rad'],'w');

freq=size(A,1)*1000/timewindow;
freqsteps=1;
syscal=1/(freqsteps*freq);

stacks=1;
stacktime=size(A,1)*stacks/100000;

fprintf(fid,'SAMPLES:%i\r\n',size(A,1)); % SAMPLES:1024
fprintf(fid,'FREQUENCY:%0.6f\r\n',freq); % FREQUENCY:9410.717437
fprintf(fid,'FREQUENCY STEPS:%i\r\n',freqsteps);% FREQUENCY STEPS:12                    ??????????????
fprintf(fid,'SIGNAL POSITION:%0.6f\r\n',0); % SIGNAL POSITION:-0.156152          ????????????
fprintf(fid,'RAW SIGNAL POSITION:%i\r\n',1); % RAW SIGNAL POSITION:50401      ????????????
fprintf(fid,'DISTANCE FLAG:%i\r\n',0); % DISTANCE FLAG:0
fprintf(fid,'TIME FLAG:%i\r\n',1); % TIME FLAG:1
fprintf(fid,'PROGRAM FLAG:%i\r\n',0); % PROGRAM FLAG:0
fprintf(fid,'EXTERNAL FLAG:%i\r\n',0); % EXTERNAL FLAG:0
fprintf(fid,'TIME INTERVAL:%0.6f\r\n',timeinterval); % TIME INTERVAL:0.100000
fprintf(fid,'DISTANCE INTERVAL:%0.6f\r\n',0.1); % DISTANCE INTERVAL:0.100000
fprintf(fid,'OPERATOR:\r\n'); % OPERATOR:
fprintf(fid,'CUSTOMER:\r\n');% CUSTOMER:
fprintf(fid,'SITE:\r\n');% SITE:
fprintf(fid,'ANTENNAS:unknown\r\n');% ANTENNAS:800 MHz
fprintf(fid,'ANTENNA ORIENTATION:NOT VALID FIELD\r\n');% ANTENNA ORIENTATION:NOT VALID FIELD
fprintf(fid,'ANTENNA SEPARATION:%0.6f\r\n',antennasep);% ANTENNA SEPARATION:0.150000    ?????????????????
fprintf(fid,'COMMENT:Saved from matlab\r\n'); % COMMENT:
fprintf(fid,'TIMEWINDOW:%0.6f\r\n',timewindow); % TIMEWINDOW:108.812108   --nanoseconds for all samples
fprintf(fid,'STACKS:%i\r\n',stacks); % STACKS:1
fprintf(fid,'STACK EXPONENT:%i\r\n',0); % STACK EXPONENT:0
fprintf(fid,'STACKING TIME:%0.6f\r\n',stacktime); % STACKING TIME:0.010240                ??????????
fprintf(fid,'LAST TRACE:%i\r\n',size(A,2)); %LAST TRACE:18461   

fprintf(fid,'STOP POSITION:%0.2f\r\n',size(A,2)*timeinterval); % STOP POSITION:53.16                 ??????????
fprintf(fid,'SYSTEM CALIBRATION:%0.10f\r\n',syscal);% SYSTEM CALIBRATION:0.0000088552   ?????? this has some effect on y-axis???
fprintf(fid,'START POSITION:%0.2f\r\n',0);% START POSITION:0.00   
fprintf(fid,'SHORT FLAG:%i\r\n',1);% SHORT FLAG:1
fprintf(fid,'INTERMEDIATE FLAG:%i\r\n',0);% INTERMEDIATE FLAG:0
fprintf(fid,'LONG FLAG:%i\r\n',0);% LONG FLAG:0
fprintf(fid,'PREPROCESSING:%i\r\n',0);% PREPROCESSING:0
fprintf(fid,'HIGH:%i\r\n',5);% HIGH:5
fprintf(fid,'LOW:%i\r\n',15);% LOW:15
fprintf(fid,'FIXED INCREMENT:%0.3f\r\n',0.3);% FIXED INCREMENT:0.300
fprintf(fid,'FIXED MOVES UP:%i\r\n',0);% FIXED MOVES UP:0
fprintf(fid,'FIXED MOVES DOWN:%i\r\n',1);% FIXED MOVES DOWN:1
fprintf(fid,'FIXED POSITION:%0.3f\r\n',0); % FIXED POSITION:0.000
fclose(fid);