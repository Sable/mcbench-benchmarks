function chan=loadacq (filename)
%LOADACQ Loads *.ACQ file (http://www.biopac.com) into a channel structure
%  (c) 2003 Mihai Moldovan 
%   M.Moldovan@mfi.ku.dk

clc
disp(['loading ... ' filename])

h=[];
m=[];
chan=[];
mark=[];

if exist (filename)~=2
    return
end

[fid,message]=fopen(filename);
if fid<2
      fclose (fid);
      error (message)
end

fseek(fid, 0, 'eof');
filesize = ftell(fid);
frewind(fid);

% -----------------------------------
% Graph Header Section
% -----------------------------------

h.nItemHeaderLen  = fread(fid,1,'short');  % offset 0 -not used
h.lVersion= fread(fid,1,'long');  % -file version 

%30 = Pre-version 2.0 
%31 = Version 2.0 Beta 1 
%32 = Version 2.0 release 
%33 = Version 2.0.7 (Mac) 
%34 = Version 3.0 In-house Release 1 
%35 = Version 3.03 
%36 = version 3.5x (Win 95, 98, NT) 
%37 = version of BSL/PRO 3.6.x 
%38 = version of Acq 3.7.0-3.7.2 (Win 98, 98SE, NT, Me, 2000) 
%39 = version of Acq 3.7.3 or above (Win 98, 98SE, 2000, Me, XP) 

if h.lVersion<30 |  h.lVersion>39
    error ('expecting version 2.0 -> 3.7.3')
end    

h.lExtItemHeaderLen= fread(fid,1,'long');  % offset 6 
h.nChannels =fread(fid,1,'short');
h.nHorizAxisType =fread(fid,1,'short');

%0 = Time in seconds 
%1 = Time in HMS format 
%2 = Frequency 
%3 = Arbitrary 

h.nCurChannel  =fread(fid,1,'short');
h.dSampleTime =fread(fid,1,'double'); %ms/sample
h.dTimeOffset  =fread(fid,1,'double');
h.dTimeScale   =fread(fid,1,'double'); %ms/div
h.dTimeCursor1  =fread(fid,1,'double');
h.dTimeCursor2   =fread(fid,1,'double');
h.rcWindow  =fread(fid,1,'int64');

for i=1:6
    h.nMeasurement(i)=fread(fid,1,'short');
end

%0 = No measurement 
%1 = Value Absolute voltage 
%2 = Delta Voltage difference 
%3 = Peak to peak voltage 
%4 = Maximum voltage 
%5 = Minimum voltage 
%6 = Mean voltage 
%7 = Standard deviation 
%8 = Integral 
%9 = Area 
%10 = Slope 
%11 = LinReg 
%13 = Median 
%15 = Time 
%16 = Delta Time 
%17 = Freq 
%18 = BPM 
%19 = Samples 
%20 = Delta Samples 
%21 = Time of Median 
%22 = Time of Max 
%23 = Time of Min 
%25 = Calculation 
%26 = Correlation 

h.fHilite  =fread(fid,1,'short');
%0 = Don't gray 
%1 = Gray. 

h.dFirstTimeOffset   =fread(fid,1,'double');
h.nRescale =fread(fid,1,'short');
%0 = Don't autoscale 
%1 = Autoscale. 

h.szHorizUnits1 =fread(fid,40,'*char')';
h.szHorizUnits2 =fread(fid,10,'*char')';

h.nInMemory  =fread(fid,1,'short');
%0 = Keep 
%1 = Don't keep. 

h.fGrid   =fread(fid,1,'short');
h.fMarkers   =fread(fid,1,'short');
h.nPlotDraft     =fread(fid,1,'short');
h.nDispMode     =fread(fid,1,'short');
%0 = Scope 
%1 = Chart. 

h.nReserved   =fread(fid,1,'short');

%version 3.0 and above
if h.lVersion>33

h.BShowToolBar =fread(fid,1,'short');
h.BShowChannelButtons=fread(fid,1,'short');
h.BShowMeasurements  =fread(fid,1,'short');
h.BShowMarkers  =fread(fid,1,'short');
h.BShowJournal  =fread(fid,1,'short');
h.CurXChannel  =fread(fid,1,'short');
h.MmtPrecision =fread(fid,1,'short');

end


%version 3.02 and above
if h.lVersion>34

h.NMeasurementRows = fread(fid,1,'short');

for i=1:40
    h.mmt(i)=fread(fid,1,'short');
end

for i=1:40
    h.mmtChan(i)=fread(fid,1,'short');
end
end

%version 3.5x and above
if h.lVersion>35

for i=1:40
    h.mmtCalcOpnd1(i)=fread(fid,1,'short');
end

for i=1:40
    h.mmtCalcOpnd2(i)=fread(fid,1,'short');
end

for i=1:40
    h.mmtCalcOp(i)=fread(fid,1,'short');
end

for i=1:40
    h.mmtCalcConstant(i)=fread(fid,1,'double');
end
end

%version 3.7.0 and above
if h.lVersion>36

h.bNewGridwithMinor = fread(fid,1,'long');
h.colorMajorGrid = fread(fid,1,'long');
h.colorMinorGrid = fread(fid,1,'long');
h.wMajorGridStyle=fread(fid,1,'short');
h.wMinorGridStyle =fread(fid,1,'short');
h.wMajorGridWidth=fread(fid,1,'short');
h.wMinorGridWidth=fread(fid,1,'short');
h.bFixedUnitsDiv  = fread(fid,1,'long');
h.bMid_Range_Show  = fread(fid,1,'long');
h.dStart_Middle_Point =fread(fid,1,'double');

for i=1:60
    h.dOffset_Point(i) =fread(fid,1,'double');
end

h.hGrid =fread(fid,1,'double');

for i=1:60
    h.vGrid(i) =fread(fid,1,'double'); 
end

h.bEnableWaveTools  =fread(fid,1,'long');                    
end

%version 3.7.3 and above
if h.lVersion>38
    h.horizPrecision=fread(fid,1,'short');
end

%------------------------------
%per channel data section
%------------------------------

for i=1:h.nChannels
    
h.lChanHeaderLen(i) =fread(fid,1,'long');    
h.nNum(i) =fread(fid,1,'short');    
h.szCommentText{i} =fread(fid,40,'*char')'; 
h.rgbColor(i) =fread(fid,1,'long');    
h.nDispChan(i)  =fread(fid,1,'short');
h.dVoltOffset(i) =fread(fid,1,'double'); 
h.dVoltScale(i) =fread(fid,1,'double'); 
h.szUnitsText{i} =fread(fid,20,'*char')';
h.lBufLength(i) =fread(fid,1,'long');  
h.dAmplScale(i) =fread(fid,1,'double');
h.dAmplOffset(i)=fread(fid,1,'double');
h.nChanOrder(i) =fread(fid,1,'short');
h.nDispSize(i) =fread(fid,1,'short');

%version 3.0 and above
if h.lVersion>33
 h.plotMode(i) =fread(fid,1,'short');
 h.vMid (i)=fread(fid,1,'double');
end

%version 3.7.0 and above
if h.lVersion>36
 h.szDescription {i}=fread(fid,128,'*char')'; 
 h.nVarSampleDivider (i)=fread(fid,1,'short');  
end

%version 3.7.3 and above
if h.lVersion>38
 h.vertPrecision (i)=fread(fid,1,'short');   
end

end

%------------------------------
%foreign data section
%------------------------------
h.nLength =fread(fid,1,'short'); %total length of foreign data
h.nID =fread(fid,1,'short');
h.ByForeignData =fread(fid, h.nLength-4,'int8')'; 

%------------------------------
%per channel data types section
%------------------------------

for i=1:h.nChannels
h.nSize(i)=fread(fid,1,'short');
h.nType(i)=fread(fid,1,'short');
%1 = double 
%2 = int 
end

%------------------------------
%channel data section
%------------------------------

  hh=h.lBufLength;
  hm=max(unique(hh));
  hh=hh./hm;
  hh=1./hh -1;
  
  hi=zeros(1,h.nChannels);
  hn=ones(1,h.nChannels);

  m=zeros(h.nChannels,hm);
  
for i=1:hm
    for c=1:h.nChannels
        
        if hi(c)==0
        
            if h.nSize(c)==2
                v=fread(fid,1,'short');   
            else
                v=fread(fid,1,'double');     
            end    
        
            m(c,hn(c))=v;
            hn(c)=hn(c)+1;
        
            %reset counter
            hi(c)=hh(c);
        else
            %jump this sample    
            hi(c)=hi(c)-1;
        end    
        
    end
end    

hn=hn-1;
hh=hh+1;

for c=1:h.nChannels
    chan(c).id=h.nNum(c);
    
    rgb='000000';
    str = dec2hex(h.rgbColor(c));
    rgb((7-length(str)):6)=str;
        
    mcol=[];
    mcol(1)=hex2dec(rgb(5:6))/255;
    mcol(2)=hex2dec(rgb(3:4))/255;
    mcol(3)=hex2dec(rgb(1:2))/255;
    
    chan(c).color=mcol;    
    
    t=h.szCommentText{c};
    ti=find(t> ' ');
    t=t(1:max(ti));
    chan(c).name=t;
    
    t=h.szUnitsText{c};
    ti=find(t> ' ');
    t=t(1:max(ti));
    chan(c).units=t ; 
    
    chan(c).ms=h.dSampleTime * hh(c);
    
    chan(c).data=m(c,1:hn(c)) * h.dAmplScale(c) + h.dAmplOffset(c) ;
    chan(c).mdata=[];
    chan(c).mname={};
        
    %chan(c).dVoltOffset=h.dVoltOffset(c) ; 
    %chan(c).dVoltScale=h.dVoltScale(c) ; 
    %chan(c).dAmplScale=h.dAmplScale(c);
    %chan(c).dAmplOffset=h.dAmplOffset(c);
    %chan(c).size=h.lBufLength(c);
    %chan(c).data=m(c,1:hn(c)) * h.dVoltScale(c) + h.dVoltOffset(c) ;
        
end    

%------------------------------
%marker data section
%------------------------------

h.lLength  = fread(fid,1,'long');
h.lMarkers = fread(fid,1,'long'); %number of markers

for i=1:h.lMarkers
    h.lSample(i)=fread(fid,1,'long');
    h.fSelected(i)=fread(fid,1,'short'); 
    h.fTextLocked(i) =fread(fid,1,'short'); 
    h.fPositionLocked(i) =fread(fid,1,'short'); 
    h.nTextLength(i) =fread(fid,1,'short'); 
    t =fread(fid, h.nTextLength(i)+1,'*char')';
    t=t(1:length(t)-1);
    h.szText{i}=t;
end

%-------------------------------------------------
%attach markers
%-------------------------------------------------

for c=1:h.nChannels

   for i=1:h.lMarkers 
        chan(c).mdata(i)=h.lSample(i)* hh(c);
        chan(c).mname{i}=h.szText{i};
   end 
end    


fclose (fid);
clc

%return
%-----------------------------------------------