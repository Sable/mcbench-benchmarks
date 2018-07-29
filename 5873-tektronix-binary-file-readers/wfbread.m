function [x,y]=wfbread(filename,mode)
% wfbread : Reads binary files (*.wfb) from a Tektronix DSA digitzer
% Usage:
% [x,y]=wfbread(filename,mode)
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
% Notes:
% I wrote this a number of years ago as a graduate student so I could store
% many digitizer signals on a 3.5" floppy disk.  I cannot guarantee that
% this will work on more modern digitizers as Tektronix might change their
% format.  As with any function, use at your own risk

% Created 2/16/2001 by Daniel Dolan
% Last updated on 9/14/2004
%

%%%%%%%%%%%%%%%%%%%%%
% argument checking %
%%%%%%%%%%%%%%%%%%%%%
switch nargin
case 0
   error('At least one argument required');
case 1
   mode='quiet';
case 2
otherwise
   error('Too many arguments');
end
if exist(filename)~=2
   error('Invalid file name');
end

%%%%%%%%%%%%%%%%
% main program %
%%%%%%%%%%%%%%%%
% get header from file
fid=fopen(filename,'rb');
data=fread(fid,inf,'uchar');
data=char(data)';
hL=min(findstr(data,'%'))+1;
header=data(1:hL);
if strcmp(mode,'verbose')
   for ii=1:hL
      if strcmp(header(ii),',')|strcmp(header(ii),' ')
         fprintf('\n');
      else
         fprintf('%s',header(ii));
      end
   end  
   fprintf('\n');
end

% bytes/sample
tag='BYT/NR:';
temp=extract(header,tag);
bytes=sscanf(temp,'%g');
% byte order
tag='BYT.OR:';
order=extract(header,tag);
% number of points
tag='NR.PT:';
temp=extract(header,tag);
N=sscanf(temp,'%g');
% horizontal axis 
tag='XINCR:';
temp=extract(header,tag);
dx=sscanf(temp,'%g');
tag='XZERO:';
temp=extract(header,tag);
x0=sscanf(temp,'%g');
tag='XUNIT:';
xunit=extract(header,tag);
% vertical axis
tag='YMULT:';
temp=extract(header,tag);
dy=sscanf(temp,'%g');
tag='YZERO:';
temp=extract(header,tag);
y0=sscanf(temp,'%g');
tag='YUNIT:';
yunit=extract(header,tag);

% get data from file
switch bytes
case 1
   width='integer1';
case 2
   width='integer*2';
case 3
   width='integer*3';
case 4
   width='integer*4';
otherwise
   error('Unknown data type');
end
fclose(fid);
if strcmp(order,'LSB')
   fid=fopen(filename,'r','ieee-le');
else
   fid=fopen(filename,'rb','ieee-be');
end
fseek(fid,hL,'bof'); % move to end of header
fseek(fid,3,'cof'); % skip word count
data=fread(fid,[1 N],width);  
fclose(fid);
ii=1:length(data);
y=data;
%y=data*vertGain/25/256+vertOffset-vertPos*vertGain;
%y=data*dy+dy*y0;
y=data*dy+y0;
x=x0+dx*ii;

return

% extract function
function func=extract(array,tag)
L=length(array);
p=findstr(array,tag);
p=p+length(tag);
q=p;
while ~strcmp(array(q),',')&...
      ~strcmp(array(q),';')&...
      ~strcmp(array(q),' ')
   q=q+1;
end
q=q-1;
func=array(p:q);
return