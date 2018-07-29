function [A,offset,scaling,channels]=rdTCscope(fname)
%rdTCscope   function to read data from an ASCII file (*.dat) created by 
%            TwinCAT Scope View.
%            A contains time and measuring data from all channels CH1 ... CHn . 
%            A = [ time(CH1) data(CH1) time(CH2) data(CH2) ... time(CHn) data(CHn)]
%
%       [A,offset,scaling,channels]=rdTCscope(fname);
%
%       fname    = Filename (without extension *.dat)
%       A        = matrix of data (<nb> values of real)
%       offset   = Offset of each channel
%       scaling  = scaling of each channel
%       channels = structure containing names of each channel
%
%       example:
%       [A,offset,scale,channels]=rdTCscope('NCiExample');
%       plot(A(:,1),A(:,2));    % plot CH1 vs. time
%       hold on;
%       plot(A(:,3),A(:,4));    % plot CH2 vs. time
%       plot(A(:,7),A(:,8));    % plot CH4 vs. time
%
%       see also padTCscope
%

%==========================================================================
% HOCHSCHULE AUGSBURG
% Fakultät für Maschinenbau und Verfahrenstechnik
% Prof. Dr.-Ing. Michael Glöckler
% © 2012
% michael.gloeckler@hs-augsburg.de
%==========================================================================

clc;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
if nargin<1 || nargin>1
  error('falsche Anzahl an Argumenten !');
end;

%--------------------------------------------------------------------------
% init constants
%--------------------------------------------------------------------------
A = [];
channels = [];

%--------------------------------------------------------------------------
% open file
%--------------------------------------------------------------------------
fid = fopen([fname '.dat'],'r');
    if fid==-1, error(['unable to open file ' fname '.dat']), end;

disp(['reading data from : ' fname '.dat']);

%==========================================================================
%	read file header
%==========================================================================
while 1
    
    line = fgetl(fid);                  % read one line
	if ischar(line)==0, break, end;     % stop, if line contains no character
 
    % find offsets
	if strcmp(line,'Offset')==1 || strcmp(line,'offset')==1 || strcmp(line,'OFFSET')==1
		line = fgetl(fid);
		offset = sscanf(line,'%f')';
		disp(['file contains ' num2str(length(offset)) ' channels']), drawnow;
    end;

    % find scales
	if strcmp( deblank(line),'Scaling Factor')==1 %#ok<*ALIGN>
		line = fgetl(fid);
		scaling  = sscanf(line,'%f')';
    end

	if strncmpi( line,'Time',4)==1
        channels_line = line;
        channels = [];
        Tabs = [0 strfind(channels_line,native2unicode(09))];
        for i=2:length(Tabs)
        	channels(i-1).name = channels_line(Tabs(i-1)+1:Tabs(i)-1); %#ok<*AGROW>
        end;
        break;
    end
        
	if strcmp( deblank(line),'')==1
        % skip empty lines
	end;
    
end

%==========================================================================
%	read data line by line
%==========================================================================
disp('please wait, this may take some time.');

% line 1
line = fgetl(fid);
A = [A; sscanf(line,'%f')'];
nb = length(A);
iLines =1;

% line 2..n
while 1
	line = fgetl(fid);
	if ischar(line)==0, break, end,     % stop, if line contains no character
	B = sscanf(line,'%f');              % othwise: find data and assign to B
	if length(B)~=nb , break, end,
	A = [A; B'];
	iLines = iLines + 1;
end

% promt the result
disp(['file contains ' num2str(iLines) ' measures']), drawnow,
    
fclose(fid);

return;