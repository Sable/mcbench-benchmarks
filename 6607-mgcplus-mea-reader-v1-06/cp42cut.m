function [fileinfo,CHINFO]=cp42cut(meafile,idx);
% cp42cut
%           Read MGCplus Data files, recorded with CP42
%
%           [fileinfo,CHINFO]=cp42cut([meafile],[index])
%
%           meafile is the complete filename of the CP42 DAQ file.
%           graph is a string of length 1. If it is different from 'n',
%           then the measurement data of the file is shown.
%           Both input arguments are optional.
%
%           This function reads the data files recorded on a PC Card
%           harddisk on CP42. The input argument "meafile" is optional,
%           when it is missing, a user dialog for selecting a file with
%           extension *.me* is shown.
%
%           fileinfo is a struct, containing the FileID, the number of
%           channels "ChannelC", Byte/Line, the data format, the data offset,
%           the time format, the file comment, the comment of the current
%           parameterset, the information about the creation date and the
%           number of used slots.
%
%           CHINFO is a struct, containing information about the channel
%           number, the scaling, offset, unit, signalling bit, subchannel,
%           data, timeaxis, channel name and the channel code.
%           NEW:
%           Also the CHANNEL STATUS, including MGCplus LIMIT VALUES Switch
%           State, CHANNEL ERROR, OVERFLOW are contained in the field
%           status for each measurement channel
%               Bit 0: Status Limit Value 1
%               Bit 1: Status Limit Value 2
%               Bit 2: Status Limit Value 3
%               Bit 3: Status Limit Value  4
%               Bit 4: Overflow Gross Value
%               Bit 5: Overflow Net Value
%               Bit 6: calibration error
%               Bit 7: Change-Flag (amplifier scaling has changed)
%
%           With PLOT(CHINFO(k).timeax,CHINFO(k).data) a measurement
%           signal can be displayed.
%           TITLE(CHINFO(k).ChannelName) adds the channel name as
%           graph title
%           YLABEL(CHINFO(k).Unit) puts the used unit on the Y axis.
%
%           There is a lot of information in the mea files about channels
%           and slots. Not all of these information is evaluated.
%           Want more ? Have a look at the word file "cp42cut-FORMAT.DOC"
%
%           Only CP42 measurement files are supported. These DAQ files may
%           contain time information in following formats:
%           1) No Time Information
%           2) MGCplus Time (64 Bit)
%           3) NTP Time Format
%           The Time Formats "USB Frame Count" and 32 Bit MGC device Time
%           are not supported.
%
%           IMPORTANT:
%           Only Measurement files with format 4 BYTE INT (Intel) are
%           supported.

CHINFO=[];
CHSET=[];
fileinfo=[];

if nargin==0,               % No Input argument
    [fn,pn]=uigetfile('*.me*','Select a CP42 data file');
    if fn==0,
        return
    end
    meafile=[pn,fn];
    idx=[-Inf,+Inf];
    graf='n';
end

if nargin==1,               % One Input argument
    if length(meafile)==2,  % Index is input argument
        idx=meafile;
        [fn,pn]=uigetfile('*.me*','Select a CP42 data file');
        if fn==0,
            return
        end
        meafile=[pn,fn];
    else                    % CP42 filename was specified
        idx=[-Inf,+Inf];
    end
end
        
if exist(meafile)~=2,
    disp(['File does not exist : ',meafile]);
    return;
end

graf='n';
% That's the bug fixing from 1.04 to 1.06
idx=floor(idx);

fileinfo=struct('FileID','ChannelC','ByteLine','MVLines',...
    'MWformat','MRate','DataOffset','TimeFormat',...
    'cmt','cmtpar','creation','usedslot','filename','filesize');
chaninfo=struct('Channelnumber','Scaling','Offset','Unit',...
    'SigBit','Subchannel','data','timeax',...
    'ChannelName','chncode','SigName','SigTypus');
chsetting=struct('ChannelName','chncode','ampcode','paraflg',...
    'tabquelle','acalflg',...
    'bridget','bridgev','uk','frequenz');

% Open CP42 measurement file (on PC) for reading.
fid = fopen(meafile,'rb');
fseek(fid,0,1);             % Evaluate the filesize in Byte
filesize=ftell(fid);
fseek(fid,0,-1);

% Read Header Block. The header block of all CP42 measurement files (also
% rainflow version CP42S30) is same: 8 long values
a=fread(fid,8,'long');

if a(1)~=6001,
    disp(['Invalid File identifier : ',int2str(a(1))]);
    fclose(fid);
    return;
end

if a(8)==7001 | a(8)==7003,
    disp('32 Bit MGC Time and USB Frame Count are not supported');
    disp(['Current Time Format Identifier : ',int2str(a(8))]);
    fclose(fid);
    return;
end

% Only 4 Byte INT Intel format is supported. With newest versions of the
% HBM setup assistant, only this format is upported.
if a(5)~=1253,
    disp('Data not in 4 Byte INT (Intel) Format !');
    disp(['Current Format Identifier : ',int2str(a(5))]);
    fclose(fid);
    return;
end

% The measurement rate is coded with values > 6000.
% Decoding to Hertz !
wrat=[(6300:1:6320), (6321:6341), (6345:6347), (6350:6361);1,2,5,10,25,50,60,75,100,150,200,300,...
        400,600,800,1200,1600,2400,3200,4800,9600,3,4,6,8,15,20,30,48,64,80,96,...
        120,160,192,240,320,384,480,640,960,1920,19200,38400,76800,...
        (1/2),(1/5),(1/10),(1/20),(1/50),(1/100),(1/200),(1/500),(1/1E3),(1/2E3),(1/5E3),(1/1E4)];
k0r=find(wrat(1,:)==a(6));
if isempty(k0r),
    disp(['unknown Measurement Rate : ',int2str(a(6))]);
    fclose(fid);
    return
end
SR=wrat(2,k0r);

noofsamp=floor((filesize-a(7)) ./a(3));
if a(4)~=noofsamp,              % Sometimes some files do not have
    disp('Attention!');         % info about no. of samples
    disp('Number of Samples contained');
    disp('in File seems to be invalid');
    disp(['File : ',int2str(a(4))]);
    disp(['calc : ',int2str(noofsamp)]);
    a(4)=noofsamp;
end                             % (File Repairing)


fileinfo.FileID=a(1);           % File-ID (6001)
fileinfo.ChannelC=a(2);         % Channel Count (incl. Time Channels)
fileinfo.ByteLine=a(3);         % Size MeasVal-Line / Bytes
fileinfo.MVLines=a(4);          % No. of MeasVal-Lines
fileinfo.MWformat=a(5);         % MeasVal-Format
                                % (1253 is required: 4 Byte INT Intel)
fileinfo.MRate=SR;              % Sample Rate in Hz
fileinfo.DataOffset=a(7);       % Data Offset in Byte
fileinfo.TimeFormat=a(8);       % Time Channel Format
                                % (see TCS command, only with CP42)
fileinfo.filename=meafile;
fileinfo.filesize=filesize;

% Read Block with channel parameters
for ch=1:a(2),
    chaninfo.Channelnumber=fread(fid,1,'long');     % Channelnumber
    chaninfo.Scaling=fread(fid,1,'float');          % Scale Factor
    chaninfo.Offset=fread(fid,1,'float');           % Offset
    chaninfo.Unit=setstr(fread(fid,[1,4],'char'));  % Unit
    chaninfo.SigBit=fread(fid,1,'short');           % Signal-Bitfeld
    
    sigbin=flipud(dec2bin(chaninfo.SigBit));        % Convert Signal Bitfield
                                                    % to binary representation
    if length(sigbin)>6,                            % Only the lower 6 Bit
        sigbin=sigbin(1:6);                         % contain sig. types!
    end
    numsigs=sum(sigbin);                            % No. of Signals / Channels
    kitypus=find(sigbin==1);                        % Positions of signals
    
    sucha=fread(fid,1,'short');                     % Subchannel No.
    if sucha==0,
        chaninfo.Subchannel=1;
    else
        chaninfo.Subchannel=sucha;
    end
    
    for sgtype=1:numsigs,                           % Evaluate Signal-
        typaktuell=kitypus(sgtype);                 % type information
        switch typaktuell
            case {1}
                chaninfo.SigName=' (Gross)';
            case {2}
                chaninfo.SigName=' (Net)';
            case {3}
                chaninfo.SigName=' (PV1)';
            case {4}
                chaninfo.SigName=' (PV2)';
            case {5}
                chaninfo.SigName=' (CPV)';
            case {6}
                chaninfo.SigName=' (DIG)';
        end
        chaninfo.SigTypus=typaktuell;
        CHINFO=[CHINFO,chaninfo];
    end
end

% Read Block with amplifer settings
switch a(8)
    case {7000}
        w0=a(2)-2;              % w0 = Number of amplifiers used for DAQ
        mgctime=1;              % mgctime=1, when recorded with MGC time
    otherwise
        w0=a(2);
        mgctime=0;
end

for ch=1:w0;
    qtmp=setstr(fread(fid,[1,47],'char'));  % Read ChannelName
    % The channel name contains the name in hyphens and some stupid signs.
    % The channel names are redesigned in the following lines...
    ki34=find(abs(qtmp)==34);               % The channel name is between
    if length(ki34)>=2,                     % two hyphens.
        qtmp=qtmp(ki34(1)+1:ki34(2)-1);
        qtmp=deblank(qtmp);
    end
    ki59=find(abs(qtmp)==59);               % Sometimes, the strings contains
    if ~isempty(ki59),                      % a final semicolon. It is removed
        qtmp=qtmp(1:max(ki59)-1);
    end
    qtmp=deblank(qtmp);                     % Remaining blanks are removed

    chsetting.ChannelName=qtmp;
    chsetting.chncode=fread(fid,1,'char');  % Read Channel Code
    chsetting.ampcode=fread(fid,1,'char');  % Read amplifier code
    chsetting.paraflg=fread(fid,1,'char');  % parflag (1..8: intern, 9: XM001)
    chsetting.tabquelle=fread(fid,1,'char');% Where is the chart from ?
    chsetting.acalflg=fread(fid,1,'char');  % AutoCalibration on / off ?
    fseek(fid,3,0);                         % Ignore loca_, meas_ and stat_flg
    chsetting.bridget=fread(fid,1,'int16'); % Read Bridgetype
    chsetting.bridgev=fread(fid,1,'char');  % Read Bridge supply voltage
    %statu=fseek(fid,167,0);
    statu=fseek(fid,166,0);
    sucha=fread(fid,1,'char');
    if sucha==0,
        chsetting.uk=1;
    else
        chsetting.uk=sucha;
    end
    CHSET=[CHSET,chsetting];

end

for qz=1:length(CHSET),                     % Append Chan. Name and Sig. type
    chanakt=CHSET(qz).chncode;
    sucha=CHSET(qz).uk;
    for qz2=1:length(CHINFO),
        chan2=CHINFO(qz2).Channelnumber;
        sucha2=CHINFO(qz2).Subchannel;
        if ((chanakt==chan2) & (sucha==sucha2)),
            CHINFO(qz2).ChannelName=[CHSET(qz).ChannelName,CHINFO(qz2).SigName];
        end
    end
end

creation=setstr(fread(fid,[1,26],'char'));  % Date and Time of File Creation
fileinfo.creation=creation;                 % e. g. Wed Sep 03
                                            % 14:43:06 1997
                                                    
comment=setstr(fread(fid,[1,80],'char'));   % Comment of the measurement
fileinfo.cmt=comment;

commentpar=setstr(fread(fid,[1,80],'char'));% Comment of active parameterset
fileinfo.cmtpar=commentpar;

slotnumber=fread(fid,1,'int');              % No. of used slots for meas.

fseek(fid,a(7),-1);                         % Goto Data Section

nrow=length(CHINFO);                        % If MGC Time Format (a(8)=7000),
                                            % then two time channels are
                                            % contained in CHINFO
if a(8)>7000,
    nplus=2;
else
    nplus=0;
end

idx=[min(idx),max(idx)];
idxmin=max(1,idx(1));
idxmax=min(a(4),idx(2));

data=[];
fseek(fid,a(7)+(nrow+nplus)*(idxmin-1)*4,-1);
data=fread(fid,[(nrow+nplus),(idxmax-idxmin+1)],'int32');
data=double(data);

status=data - 256 .*floor(data ./256);      % Extract status information

for p=1:nrow
  data(p,:)=((data(p,:) .*CHINFO(p).Scaling) ./1966080000) - CHINFO(p).Offset;
  CHINFO(p).data=data(p,:);                 % Append MV's to Channel Info
  CHINFO(p).status=status(p,:);
end

switch a(8)                                 % Build Time channel
    case {7000}                             % MGCplus Time Channel
        timeax=data(length(CHINFO),:)+data(length(CHINFO)-1,:);
        % timeax=timeax-timeax(1);
    case {7002}                             % NTP Time channel
        timeax=data(nrow+nplus-1,:)+(data(nrow+nplus,:) ./1E6);
        timeax=timeax-timeax(1);
    otherwise
        timeax=(0:1:a(4)-1) ./SR;
end

for p=1:length(CHINFO),
    CHINFO(p).timeax=timeax;
end

if mgctime,
    CHINFO=CHINFO(1:length(CHINFO)-2);      % Only meas. channels !
                                            % Time information is
                                            % appended. CHINFO can
                                            % reduced by the last 2
                                            % rows
end
fclose(fid);                                % Close measurement file

if nargout<2 | graf~='n',
    plotcp42(CHINFO);                       % Disp Measurement Data
end 
% END OF cp42cut


function plotcp42(CHINFO);
% PLOTCP42
%           plotcp42(CHINFO)
%
%           This function displays measurement data of a CP42 mea-file in
%           several subplots. Different signals of one channel are shown
%           together in one subplot (e. g. Gross, PV1 and PV2 part of a
%           signal are shown together).
%
%           If the signals have a sample rate trigger, the fast measurement
%           rate periods are highlighted yellow.

if isempty(CHINFO),                 % No input argument leads outside
    return;
end

cnt=length(CHINFO);
oldinfo=[-1,-1,-1];
graph=0;

% Evaluate Number of needed Subplots
for p=1:cnt,
    kanal=CHINFO(p).Channelnumber;
    unterkanal=CHINFO(p).Subchannel;
    signal=CHINFO(p).SigTypus;
    newinfo=[kanal,unterkanal,signal];
    
    if ~((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2))),
        graph=graph+1;
    end
    oldinfo=newinfo;
end
oldinfo=[-1,-1,-1];

% if more than 6 subplots are needed, the function is left.
if graph>6,
    disp('Too much information for complete graphical presentation');
    return;
end
% Build up the graph
graphakt=0;
for p=1:cnt,
    kanal=CHINFO(p).Channelnumber;
    unterkanal=CHINFO(p).Subchannel;
    signal=CHINFO(p).SigTypus;
    newinfo=[kanal,unterkanal,signal];
    
    if ~((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2))),
        graphakt=graphakt+1;
        hold off;
        subplot(graph,1,graphakt);
        
        % Analyze Time Axis for Sample Rates
        % The analysis is done for each new subplot,
        % because CHINFO can be composed of data
        % of independent mea-Files !
        % (Not the case, when it is called direct from
        % cp42cut !)
        tx=CHINFO(p).timeax;
        dtx=diff(tx(:).');          % Specify time difference between
        dtx=[dtx(1),dtx];           % to samples
        if any(dtx==0),
            disp('At least two Samples with same time stamp !');
        else
            df=round(1 ./dtx);      % Evaluate Sample Frequency
            fmin=min(df);           % It is assumed, that only 2
            fmax=max(df);           % frequencies occure
            % Take care with files, which have got time information
            % in NTP Time Format
            if fmax~=fmin,          % If there are 2 freqs, plot field
                flimit=0.5*(fmin+fmax);
                idxmin=findgrup(df<flimit,1); % Determine Areas of low
                idxmax=findgrup(df>flimit,1); % and high sample rate
                tmin=tx(idxmin);    % Specify Time Limits of these areas
                tmax=tx(idxmax);    % tmin: Time Ranges Low Freq
                ymax=max(CHINFO(p).data); % Specify the min- and max-
                ymin=min(CHINFO(p).data); % values of the signal
                FL1=[tmin;flipud(tmin)];  % Now, the rectangle info
                FL2=[tmax;flipud(tmax)];  % for the highlight field
                YL1=ones(4,size(tmin,2)); % is calculated-
                YL1(1,:)=ymin;
                YL1(2,:)=ymin;
                YL1(3,:)=ymax;
                YL1(4,:)=ymax;
                YL2=ones(4,size(tmax,2));
                YL2(1,:)=ymin;
                YL2(2,:)=ymin;
                YL2(3,:)=ymax;
                YL2(4,:)=ymax;
                filha=fill(FL2,YL2,[1,1,0.5]); % Plot the highlight field
                set(filha,'EdgeColor','None'); % into the subplot.
                hold on;
            end
        end
        % Now plot the signal data !
        ploha=plot(CHINFO(p).timeax,CHINFO(p).data,'b-');
        set(gca,'FontSize',8,'Color',[1,1,1]);
        yha=ylabel(CHINFO(p).Unit);
        set(yha,'FontSize',8);
        hti=title(CHINFO(p).ChannelName);
        set(hti,'FontSize',8);
        hold on;
    else
        plot(CHINFO(p).timeax,CHINFO(p).data,'m-');
    end
    oldinfo=newinfo;
end
xha=xlabel('Time [s]');
set(xha,'FontSize',8);
set(gcf,'Name','CP42 measurement file','NumberTitle','Off');

% END OF PLOTCP42

function y=dec2bin(x,y);
% DEC2BIN	Conversion from decimal to binary numbers
% 
%		Y=DEC2BIN(X,Y)		: single number, recursive
% or	Y=DEC2BIN(X) 		: Row Vector, Single number             
% 
%		The binary representation is contained in the vector y.
%       The 1st element is the LSB.    
%
%		When DEC2BIN is used only with one input argument
%       Y=DEC2BIN(X), the conversion is done iteratively.
%       X may be a row vector. Y is a matrix. Each column
%       represents a binary number.
%       The last row contains the LSB's.  

if nargin==2			% Single Value - rec.
	if x>=1	
	N=nextpow2(x+1E-4)-1;
	y(1,N+1)=1;
	x=x - (2^N);
		if abs(x)>=0.2
			y=dec2bin(x,y);
		end
	end
else					% Vector - non rec.
	maxx=max(max(x));
	minx=min(min(x));
		if minx<0
			disp('Range Error !');
			return;
		end
	basis=ceil(log(maxx+1E-4)/log(2));
	xk=x;
	y=[];
		for k=(basis-1):(-1):0
			xtmp=floor(xk ./(2^k));
			y=[y;xtmp];
			xk=xk - (2^k)*xtmp;
		end
end                     % Prozedurende "dec2bin"

function K=findgrup(a,modus);
% FINDGRUP
%		K=FINDGRUP(A,[MODUS])
%		Start and Endpositions of 1-Groups of the
%       binary vector A are determined.
%       If the optional argument MODUS (Default = 0)
%       is not used, then leading and finishing
%       1-Groups are neglected.
%
%		Example:
%		(1)	:	>> a=[1,1,1,0,0,0,1,1,0,0,0,1,1,1];
%				>> ki=findgrup(a) % or ki=findgrup(a,0)
%
%				ki=[7;
%				    8]
%
%		(2)	:	>> ki=findgrup(a,1)
%
%				ki=[ 1, 7,12;
%				     3, 8,14]

if nargin==1, modus=0; end

a=a(:).';

if modus~=0, a=[0,a,0]; end

if isempty(find(a)) | isempty(find(~a)),
	K=[];
	return;
end

% Where starts and ends Group of 1 ?
d=diff(a);

kmin=find(d>0) + 1; kmin=kmin(:);
kmax=find(d<0) + 1; kmax=kmax-1; kmax=kmax(:);

if a(1)==1, kmax=kmax(2:length(kmax)); end
if a(length(a))==1, kmin=kmin(1:length(kmin)-1); end
K=[kmin,kmax].';
if modus~=0, K=K-1; end			% END OF FINDGRUP