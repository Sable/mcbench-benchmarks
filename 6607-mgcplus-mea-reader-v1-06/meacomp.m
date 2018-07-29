function [fileinfo,CHINFO]=meacomp(meafile,compfactor);
% MEACOMP
%           [FILEINFO,CHINFO]=MEACOMP([MEAFILE],[COMPRESSION])
%
%           MEAFILE:        Name of a CP42 measurement file with
%                           Measurement value format 4 Byte INT.
%           COMPRESSION:    Samples / Block. Default value=500
%
%           MEACOMP reads the values of the CP42 measurement file.
%           A block containing all channels/signals is read. The
%           number of samples is specified by the variable
%           compression. From every channel/signal the max. and
%           min. value are subtracted, so that you get an information
%           about "signal activity" in each block.
%
%           The information about the file is stored in the struct
%           variable FILEINFO, the information about channels and
%           signals is contained in the variable CHINFO.
%           CHINFO(k).data contains the "compressed" activity information,
%           CHINFO(k).timeax contains the sample index.

CHINFO=[];
CHSET=[];
fileinfo=[];
warning off;

if nargin==0,               % No Input argument
    [fn,pn]=uigetfile('*.me*','Select a CP42 data file');
    if fn==0,
        return
    end
    meafile=[pn,fn];
    compfactor=500;
end

if nargin==1,               % One Input argument
    if ~isstr(meafile),     % If Graphic Option was specified...
        compfactor=meafile;
        [fn,pn]=uigetfile('*.me*','Select a CP42 data file');
        if fn==0,
            return
        end
        meafile=[pn,fn];
    else                    % CP42 filename was specified
        compfactor=500;
    end
end
        
if exist(meafile)~=2,
    disp(['File does not exist : ',meafile]);
    return;
end

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
                                % Activity Monitor
if ~isempty(get(0,'CurrentFigure')),
    figure(gcf+1);
end
set(gcf,'Position',[60,80,400,200],'NumberTitle','Off',...
	'Menu','None','Name','Bereits erledigt [%]','Visible','On');
axha=gca;
set(axha,'Visible','Off');
teha=text(0.5,0.5,'0 %');
set(teha,'HorizontalAlignment','Center','VerticalAlignment','Middle',...
	'FontName','TimesNewRoman','FontSize',48,'FontWeight','Bold','Color','b');
anzold=0;
drawnow;

noblock=floor(a(4)/compfactor);
restsamp=a(4) - noblock*compfactor;
Bmin=40;
if noblock<Bmin,
    compfactor=ceil(a(4) ./Bmin);
    noblock=floor(a(4)/compfactor);
    restsamp=a(4) - noblock*compfactor;
end

data=[];
timeax=[];
for qz=1:1:noblock
    data0=fread(fid,[nrow+nplus,compfactor],'int32');  % Read Data
    data0=double(data0);
    for p=1:nrow
        data0(p,:)=((data0(p,:) .*CHINFO(p).Scaling) ./1966080000) - CHINFO(p).Offset;
    end
    exceed=(max(data0.')-min(data0.')).';
    data=[data,exceed];
    idxstamp=compfactor .*qz - 250;
    timeax=[timeax,idxstamp];
    anzneu=round(100*qz/noblock);
    if anzneu>=anzold+2,
        set(teha,'String',[int2str(anzneu),' %']);
        drawnow;
        anzold=anzneu;
    end
end
if restsamp>0                                                   
    data0=fread(fid,[nrow+nplus,compfactor],'int32');  % Read Rest of Data
    data0=double(data0); 
    for p=1:nrow
        data0(p,:)=((data0(p,:) .*CHINFO(p).Scaling) ./1966080000) - CHINFO(p).Offset;
    end
    exceed=(max(data0.')-min(data0.')).';
    data=[data,exceed];
    idxstamp=noblock*compfactor + (restsamp/2);
    timeax=[timeax,idxstamp];
end
close(gcf);

for p=1:length(CHINFO),
    datakt=data(p,:);
    umax=max(datakt);
    umin=min(datakt);
    activity=100 .*((datakt - umin) ./(umax-umin));
    CHINFO(p).data=activity;
    CHINFO(p).timeax=timeax;
    CHINFO(p).Unit='Activity [%]';
end

if mgctime,
    CHINFO=CHINFO(1:length(CHINFO)-2);      % Only meas. channels !
                                            % Time information is
                                            % appended. CHINFO can
                                            % reduced by the last 2
                                            % rows
end
fclose(fid);                                % Close measurement file
plotmeac(CHINFO);
% END OF MEACOMP

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

function plotmeac(CHINFO);
% PLOTMEAC
%           plotmeac(CHINFO)
%
%           This function displays measurement data of a CP42 mea-file in
%           several subplots. Different signals of one channel are shown
%           together in one subplot (e. g. Gross, PV1 and PV2 part of a
%           signal are shown together).

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
    
    bed1=~((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)));
    bed2=((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)) & (newinfo(3)==oldinfo(3)));
    
    if bed1 | bed2,
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
    
    bed1=~((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)));
    bed2=((newinfo(1)==oldinfo(1)) & (newinfo(2)==oldinfo(2)) & (newinfo(3)==oldinfo(3)));
    
    if bed1 | bed2,
        graphakt=graphakt+1;
        hold off;
        subplot(graph,1,graphakt);

        ploha=plot(CHINFO(p).timeax,CHINFO(p).data,'b-');
        set(gca,'FontSize',8,'Color',[1,1,1]);
        yha=ylabel(['Activity ',CHINFO(p).Unit]);
        set(yha,'FontSize',8);
        hti=title(CHINFO(p).ChannelName);
        set(hti,'FontSize',8);
        hold on;
    else
        plot(CHINFO(p).timeax,CHINFO(p).data,'m-');
    end
    oldinfo=newinfo;
end
xha=xlabel('Index');
set(xha,'FontSize',8);
set(gcf,'Name','Activity Monitoring','NumberTitle','Off');
