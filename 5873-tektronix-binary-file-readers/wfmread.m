function [x,y]=wfmread(filename,mode)
% wfmread   :   Reads binary *.WFM file from a Tektronix TDS digitizer
% Usage:
% [x,y]=wfmread(filename,mode);
% x and y are one dimensional arrays containing the horizontal and vertical
% data from the signal contained in filename.
%
% filename is a character string name of a *.WFM file.  If filename is
% omitted or empty, a graphical window is launched to help the user choose
% the desired file.
%
% mode allows the user to get some extra information about the digitizer
% settings.  This feature is disabled by default, but can be activated by
% setting mode to 'verbose'.
%
%
% Notes:
% I wrote this a number of years ago as a graduate student so I could store
% many digitizer signals on a 3.5" floppy disk.  I cannot guarantee that
% this will work on more modern digitizers as Tektronix might change their
% format.  As with any function, use at your own risk
%
% Created 6/10/2000 by Daniel Dolan
% Last updated 9/14/2004
%

%%%%%%%%%%%%%%%%%%%%%
% argument checking %
%%%%%%%%%%%%%%%%%%%%%
if nargout<2
   error('Two outputs required');
end

switch nargin
case 0
   filename='';
   mode='quiet';
case 1
   mode='quiet';
case 2
   if ~strcmp(mode,'verbose')& ~strcmp(mode,'quiet')
      error('Invalid mode');
   end
otherwise
   error('Too many arguments');
end 

if isempty(filename)
    [fname,pname]=uigetfile('*.wfm;*.WFM','Choose Tektronix WFM file');
    filename=[pname fname];
end

if exist(filename)~=2
   error('Invalid file name');
end

%%%%%%%%%%%%%%%%
% main program %
%%%%%%%%%%%%%%%%
[fp,message]=fopen(filename,'rb','b'); % big-endian format
if fp==-1
    error(['Unable to open file: ' filename]);
end

% main header
a=fread(fp,1,'uchar');
if char(a)==':'
   start=fread(fp,7,'uchar');
else
   start=fread(fp,6,'uchar');
end
start=char([a start']);
count_bytes=str2num(char(fread(fp,1,'uchar'))'); % number of bytes in count
bytes=str2num(char(fread(fp,count_bytes,'uchar'))'); % bytes to end of file
magic_num=fread(fp,1,'int32'); % "magic number"
length=fread(fp,1,'int32'); % length of header+curve data

% reference header
vertPos=fread(fp,1,'double');
horzPos=fread(fp,1,'double');
vertZoom=fread(fp,1,'double');
horzZoom=fread(fp,1,'double');

% waveform header
acqmode=fread(fp,1,'int16');
minMaxFormat=fread(fp,1,'int16');
duration=fread(fp,1,'double');
vertCpl=fread(fp,1,'int16');
horzUnit=fread(fp,1,'int16');
horzScalePerPoint=fread(fp,1,'double');
vertUnit=fread(fp,1,'int16');
vertOffset=fread(fp,1,'double');
vertPos=fread(fp,1,'double');
vertGain=fread(fp,1,'double');
%recordLength=fread(fp,1,'uint64');
recordLength=fread(fp,1,'uint32');
trigPos=fread(fp,1,'int16');
wfmHeaderVersion=fread(fp,1,'int16');
sampleDensity=fread(fp,1,'int16');
burstSegmentLength=fread(fp,1,'int16');
sourceWfm=fread(fp,1,'int16');
video1=fread(fp,3,'int16');
video2=fread(fp,1,'double');
video3=fread(fp,1,'int16');

% check to see extended header is present
if (length-2*recordLength-2*32)==196
   % stuff
end

% print some important info for the user
if strcmp(mode,'verbose')
   switch acqmode
   case 285
      fprintf('Sample Mode (number of data points= %d)\n',recordLength);
   end
   
   switch horzUnit
   case 609
      fprintf('Horizontal units are volts \n');
   case 610
      fprintf('Horizontal units are seconds \n');
      fprintf('\t Sampling rate= %g Hz \n',horzScalePerPoint)
      fprintf('\t Duration of sweep= %g s\n',duration);
   end
   
   switch vertUnit
   case 609
      fprintf('Vertical units are volts \n');
   case 610      
      fprintf('Vertical units are seconds \n');
   end
   
   switch vertCpl
   case 565
      fprintf('DC coupling \n');
   case 566
      fprintf('AC coupling \n');
   end
   
end

% extract the data
preamble=fread(fp,16,'int16');
data=fread(fp,recordLength,'int16');
postamble=fread(fp,16,'int16');
checksum=fread(fp,1,'int16');
fclose(fp);

% calculate the x and y data series
ii=0:(recordLength-1);
x=(ii'-recordLength*trigPos/100)*horzScalePerPoint;
y=data*vertGain/25/256+vertOffset-vertPos*vertGain;