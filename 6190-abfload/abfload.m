function [d,si]=abfload(fn,varargin)
% ** function [d,si]=abfload(fn,varargin)
% loads and returns data in the Axon abf format PRIOR TO VERSION 2.0.
% Data may have been acquired in the following modes:
% (1) event-driven variable-length
% (2) event-driven fixed-length 
% (3) gap-free
% Information about scaling, the time base and the number of channels and 
% episodes is extracted from the header of the abf file (see also abfinfo.m).
% All optional input parameters listed below (= all except the file name) 
% must be specified as parameter/value pairs, e.g. as in 
%          d=abfload('d:\data01.abf','start',100,'stop','e');
%
%                    >>> INPUT VARIABLES >>>
%
% NAME        TYPE, DEFAULT      DESCRIPTION
% fn          char array         abf data file name
% start       scalar, 0          only gap-free-data: start of cutout to be read (unit: sec)
% stop        scalar or char,    only gap-free-data: end of cutout to be read (unit: sec). 
%             'e'                 May be set to 'e' (end of file).
% sweeps      1d-array or char,  only episodic data: sweep numbers to be read. By default, 
%             'a'                 all sweeps will be read ('a')
% channels    cell array         names of channels to be read, like {'IN 0','IN 8'};
%              or char, 'a'       ** make sure spelling is 100% correct (including blanks) **
%                                 if set to 'a', all channels will be read
% chunk       scalar, 0.05       only gap-free-data: the elementary chunk size (Megabytes) 
%                                 to be used for the 'discontinuous' mode of reading data 
%                                 (when less channels shall be read than exist in file)
% machineF    char array,        the 'machineformat' input parameter of the
%              'ieee-le'          matlab fopen function. 'ieee-le' is the correct 
%                                 option for windows; depending on the
%                                 platform the data were recorded/shall be read
%                                 by abfload 'ieee-be' is the alternative.
% 
%                    <<< OUTPUT VARIABLES <<<
%
% NAME        TYPE            DESCRIPTION
% d                           the data read, the format depending on the recording mode
%             1. GAP-FREE:
%             2d array        2d array of size 
%                              '<data pts>' by '<number of chans>'
%                              Examples of access:
%                              d(:,2)       data from channel 2 at full length
%                              d(1:100,:)   first 100 data points from all channels
%             2. EPISODIC FIXED-LENGTH:
%             3d array        3d array of size 
%                              '<data pts per sweep>' by '<number of chans>' by '<number of sweeps>'
%                              Examples of access:
%                              d(:,2,:)            is a matrix which contains all events (at full length) 
%                                                  of channel 2 in its columns
%                              d(1:200,:,[1 11])   contains first 200 data points of events #1 
%                                                  and #11 of all channels
%             3. EPISODIC VARIABLE-LENGTH:
%             cell array      cell array whose elements correspond to single sweeps. Each element is
%                              a (regular) array of size
%                              '<data pts per sweep>' by '<number of chans>'
%                              Examples of access:
%                              d{1}                 a 2d-array which contains sweep #1 (all of it, all channels)
%                              d{2}(1:100,2)        a 1d-array containing first 100 data points of of channel 2 in sweep #1
%
% si          scalar          the sampling interval in usec
%
% Date of this version: June 17, 2011

% future improvements:
% - handle expansion of header in transition to file version 1.65 better

% --- defaults   
% gap-free
start=0.0;
stop='e';
% episodic
sweeps='a';
% general
channels='a';
% the size of data chunks (see above) in Mb. 0.05 Mb is an empirical value
% which works well for abf with 6-16 channels and recording durations of 
% 5-30 min
chunk=0.05;
machineF='ieee-le';
verbose=1;

% assign values of optional input parameters, if any were given
pvpmod(varargin);   

if verbose, disp(['** ' mfilename]); end
d=[]; 
si=[];
if ischar(stop)
  if ~strcmpi(stop,'e')
    error('input parameter ''stop'' must be specified as ''e'' (=end of recording) or as a scalar');
  end
end

% --- obtain vital header parameters and initialize them with -1 
% temporary initializing var
tmp=repmat(-1,1,16);
% for the sake of typing economy set up a cell array (and convert it to a struct below)
% column order is 
%        name, position in header in bytes, type, value)
headPar={
  'fFileVersionNumber',4,'float',-1;  
  'nOperationMode',8,'int16',-1; 
  'lActualAcqLength',10,'int32',-1;
  'nNumPointsIgnored',14,'int16',-1;
  'lActualEpisodes',16,'int32',-1;
  'lFileStartTime',24,'int32',-1;
  'lDataSectionPtr',40,'int32',-1;
  'lSynchArrayPtr',92,'int32',-1;
  'lSynchArraySize',96,'int32',-1; 
  'nDataFormat',100,'int16',-1;            
  'nADCNumChannels', 120, 'int16', -1;
  'fADCSampleInterval',122,'float', -1; 
  'fSynchTimeUnit',130,'float',-1;
  'lNumSamplesPerEpisode',138,'int32',-1;        
  'lPreTriggerSamples',142,'int32',-1;        
  'lEpisodesPerRun',146,'int32',-1;        
  'fADCRange', 244, 'float', -1;
  'lADCResolution', 252, 'int32', -1;
  'nFileStartMillisecs', 366, 'int16', -1;
  'nADCPtoLChannelMap', 378, 'int16', tmp;
  'nADCSamplingSeq', 410, 'int16',  tmp;
  'sADCChannelName',442, 'uchar', repmat(tmp,1,10);
  'fADCProgrammableGain', 730, 'float', tmp;
  'fInstrumentScaleFactor', 922, 'float', tmp;
  'fInstrumentOffset', 986, 'float', tmp;
  'fSignalGain', 1050, 'float', tmp;
  'fSignalOffset', 1114, 'float', tmp;
  'nTelegraphEnable',4512,'int16',tmp;
  'fTelegraphAdditGain',4576,'float',tmp
};

fields={'name','offs','numType','value'};
s=cell2struct(headPar,fields,2);
numOfParams=size(s,1);
clear tmp headPar;

if ~exist(fn,'file'), error(['could not find file ' fn]); end
if verbose, disp(['opening ' fn '..']); end
[fid,messg]=fopen(fn,'r',machineF); 

if fid == -1,error(messg);end;   
% determine absolute file size
fseek(fid,0,'eof');
fileSz=ftell(fid);
fseek(fid,0,'bof');

% read all vital information in header
% convert names in structure to variables and read value from header
for g=1:numOfParams,
  if fseek(fid, s(g).offs,'bof')~=0, 
    fclose(fid);
    error(['something went wrong locating ' s(g).name]); 
  end;
  sz=length(s(g).value);
  eval(['[' s(g).name ',n]=fread(fid,sz,''' s(g).numType ''');']);
  if n~=sz, 
    fclose(fid);    
    error(['something went wrong reading value(s) for ' s(g).name]); 
  end;
end;

if lActualAcqLength<nADCNumChannels, 
  fclose(fid);
  error('less data points than sampled channels in file'); 
end
% the numerical value of all recorded channels (numbers 0..15)
recChIdx=nADCSamplingSeq(1:nADCNumChannels);
% the corresponding indices into loaded data d
recChInd=1:length(recChIdx);
% the channel names, e.g. 'IN 8'
recChNames=(reshape(char(sADCChannelName),10,16))';
recChNames=recChNames(recChIdx+1,:);

chInd=[];
eflag=0;
if ischar(channels) 
  if strcmp(channels,'a')
    chInd=recChInd;
  else
    fclose(fid);
    error('input parameter ''channels'' must either be a cell array holding channel names or the single character ''a'' (=all channels)');
  end
else
  for i=1:length(channels)
    tmpChInd=strmatch(channels{i},recChNames,'exact');
    if ~isempty(tmpChInd)
      chInd=[chInd tmpChInd];
    else
      % set error flag to 1
      eflag=1;
    end
  end;
end
if eflag
  fclose(fid);
  disp('**** available channels:');
  disp(recChNames);
  disp(' ');
  disp('**** requested channels:');
  disp(strvcat(channels));
  error('at least one of the requested channels does not exist in data file (see above)');
end

% fFileVersionNumber needs a fix - for whatever reason its value is sometimes 
% a little less than what it should be (e.g. 1.6499999xxxx instead of 1.65)
fFileVersionNumber=.001*round(fFileVersionNumber*1000);

% gain of telegraphed instruments, if any
if fFileVersionNumber>=1.65
  addGain=nTelegraphEnable.*fTelegraphAdditGain;
  addGain(addGain==0)=1;
else
  addGain=ones(size(fTelegraphAdditGain));
end

% tell me where the data start
blockSz=512;
switch nDataFormat
  case 0
    dataSz=2;  % bytes/point
    precision='int16';
  case 1
    dataSz=4;  % bytes/point
    precision='float32';
  otherwise
    fclose(fid);
    error('invalid number format');
end;
headOffset=lDataSectionPtr*blockSz+nNumPointsIgnored*dataSz;
% fADCSampleInterval is the TOTAL sampling interval
si=fADCSampleInterval*nADCNumChannels;

if ischar(sweeps) && sweeps=='a'
  nSweeps=lActualEpisodes;
  sweeps=1:lActualEpisodes;
else
  nSweeps=length(sweeps);
end;  

switch nOperationMode
  case 1
    if verbose, 
      disp('data were acquired in event-driven variable-length mode'); 
    end
    warndlg('function abfload has not yet been thorougly tested for data in event-driven variable-length mode - please double-check that the data loaded is correct','Just a second, please');
    if (lSynchArrayPtr<=0 || lSynchArraySize<=0), 
      fclose(fid);
      error('internal variables ''lSynchArraynnn'' are zero or negative'); 
    end
    switch fSynchTimeUnit
      case 0  % time information in synch array section is in terms of ticks
        synchArrTimeBase=1;
      otherwise % time information in synch array section is in terms of usec
        synchArrTimeBase=fSynchTimeUnit;    
    end;  
    % the byte offset at which the SynchArraySection starts
    lSynchArrayPtrByte=blockSz*lSynchArrayPtr;
    % before reading Synch Arr parameters check if file is big enough to hold them
    % 4 bytes/long, 2 values per episode (start and length)
    if lSynchArrayPtrByte+2*4*lSynchArraySize<fileSz, 
      fclose(fid);
      error('file seems not to contain complete Synch Array Section'); 
    end
    if fseek(fid,lSynchArrayPtrByte,'bof')~=0, 
      fclose(fid);
      error('something went wrong positioning file pointer to Synch Array Section'); 
    end
    [synchArr,n]=fread(fid,lSynchArraySize*2,'int32');
    if n~=lSynchArraySize*2,
      fclose(fid);
      error('something went wrong reading synch array section');
    end
    % make synchArr a lSynchArraySize x 2 matrix
    synchArr=permute(reshape(synchArr',2,lSynchArraySize),[2 1]);
    % the length of episodes in sample points
    segLengthInPts=synchArr(:,2)/synchArrTimeBase;
    % the starting ticks of episodes in sample points WITHIN THE DATA FILE
    segStartInPts=cumsum([0 (segLengthInPts(1:end-1))']*dataSz)+headOffset;
    % start time (synchArr(:,1)) has to be divided by nADCNumChannels to get true value
    % go to data portion
    if fseek(fid,headOffset,'bof')~=0, 
      fclose(fid);
      error('something went wrong positioning file pointer (too few data points ?)'); 
    end
    for i=1:nSweeps,
      % if selected sweeps are to be read, seek correct position
      if ~isequal(nSweeps,lActualEpisodes), 
        fseek(fid,segStartInPts(sweeps(i)),'bof'); 
      end;
      [tmpd,n]=fread(fid,segLengthInPts(sweeps(i)),precision);
      if n~=segLengthInPts(sweeps(i)), 
        warning(['something went wrong reading episode ' int2str(sweeps(i)) ': ' segLengthInPts(sweeps(i)) ' points should have been read, ' int2str(n) ' points actually read']); 
      end;
      dataPtsPerChan=n/nADCNumChannels;
      if rem(n,nADCNumChannels)>0, 
        fclose(fid);
        error('number of data points in episode not OK'); 
      end
      % separate channels..
      tmpd=reshape(tmpd,nADCNumChannels,dataPtsPerChan);
      % retain only requested channels
      tmpd=tmpd(chInd,:);
      tmpd=tmpd';
      % if data format is integer, scale appropriately; if it's float, tmpd is fine 
      if ~nDataFormat
        for j=1:length(chInd),
          ch=recChIdx(chInd(j))+1;
          tmpd(:,j)=tmpd(:,j)/(fInstrumentScaleFactor(ch)*fSignalGain(ch)*fADCProgrammableGain(ch)*addGain(ch))...
            *fADCRange/lADCResolution+fInstrumentOffset(ch)-fSignalOffset(ch);
        end;
      end
      % now place in cell array, an element consisting of one sweep with channels in columns
      d{i}=tmpd;
    end;  
  case {2,5}
    if nOperationMode==2
      if verbose
        disp('data were acquired in event-driven fixed-length mode');  
      end
    else 
      if verbose
        disp('data were acquired in waveform fixed-length mode (clampex only)');  
      end
    end
    % determine first point and number of points to be read 
    startPt=0;
    dataPts=lActualAcqLength;
    dataPtsPerChan=dataPts/nADCNumChannels;
    if rem(dataPts,nADCNumChannels)>0, 
      fclose(fid);
      error('number of data points not OK'); 
    end
    dataPtsPerChanPerSweep=dataPtsPerChan/lActualEpisodes;
    if rem(dataPtsPerChan,lActualEpisodes)>0
      fclose(fid);
      error('number of data points not OK');
    end
    dataPtsPerSweep=dataPtsPerChanPerSweep*nADCNumChannels;
    if fseek(fid,startPt*dataSz+headOffset,'bof')~=0
      fclose(fid);
      error('something went wrong positioning file pointer (too few data points ?)'); 
    end
    d=zeros(dataPtsPerChanPerSweep,length(chInd),nSweeps);
    % the starting ticks of episodes in sample points WITHIN THE DATA FILE
    selectedSegStartInPts=((sweeps-1)*dataPtsPerSweep)*dataSz+headOffset;
    for i=1:nSweeps,
      fseek(fid,selectedSegStartInPts(i),'bof'); 
      [tmpd,n]=fread(fid,dataPtsPerSweep,precision);
      if n~=dataPtsPerSweep, 
        fclose(fid);
        error(['something went wrong reading episode ' int2str(sweeps(i)) ': ' dataPtsPerSweep ' points should have been read, ' int2str(n) ' points actually read']); 
      end;
      dataPtsPerChan=n/nADCNumChannels;
      if rem(n,nADCNumChannels)>0
        fclose(fid);
        error('number of data points in episode not OK'); 
      end;
      % separate channels..
      tmpd=reshape(tmpd,nADCNumChannels,dataPtsPerChan);
      % retain only requested channels
      tmpd=tmpd(chInd,:);
      tmpd=tmpd';
      % if data format is integer, scale appropriately; if it's float, d is fine 
      if ~nDataFormat
        for j=1:length(chInd),
          ch=recChIdx(chInd(j))+1;
          tmpd(:,j)=tmpd(:,j)/(fInstrumentScaleFactor(ch)*fSignalGain(ch)*fADCProgrammableGain(ch)*addGain(ch))...
            *fADCRange/lADCResolution+fInstrumentOffset(ch)-fSignalOffset(ch);
        end;
      end
      % now fill 3d array
      d(:,:,i)=tmpd;
    end;  
    
  case 3
    if verbose, disp('data were acquired in gap-free mode'); end
    % from start, stop, headOffset and fADCSampleInterval calculate first point to be read 
    %  and - unless stop is given as 'e' - number of points
    startPt=floor(1e6*start*(1/fADCSampleInterval));
    % this corrects undesired shifts in the reading frame due to rounding errors in the previous calculation
    startPt=floor(startPt/nADCNumChannels)*nADCNumChannels;
    % if stop is a char array, it can only be 'e' at this point (other values would have 
    % been caught above)
    if ischar(stop),
      dataPtsPerChan=lActualAcqLength/nADCNumChannels-floor(1e6*start/si);
      dataPts=dataPtsPerChan*nADCNumChannels;
    else
      dataPtsPerChan=floor(1e6*(stop-start)*(1/si));
      dataPts=dataPtsPerChan*nADCNumChannels;
      if dataPts<=0 
        fclose(fid);
        error('start is larger than or equal to stop'); 
      end
    end
    if rem(dataPts,nADCNumChannels)>0
      fclose(fid);
      error('number of data points not OK'); 
    end
    if fseek(fid,startPt*dataSz+headOffset,'bof')~=0, 
      fclose(fid);
      error('something went wrong positioning file pointer (too few data points ?)');
    end
    % *** decide on the most efficient way to read data:
    % (i) all (of one or several) channels requested: read, done
    % (ii) one (of several) channels requested: use the 'skip' feature of
    % fread 
    % (iii) more than one but not all (of several) channels requested:
    % 'discontinuous' mode of reading data. Read a reasonable chunk of data
    % (all channels), separate channels, discard non-requested ones (if
    % any), place data in preallocated array, repeat until done. This is
    % faster than reading the data in one big lump, separating channels and
    % discarding the ones not requested
    if length(chInd)==1 && nADCNumChannels>1
      % --- situation (ii)
      % jump to proper reading frame position in file
      if fseek(fid,(chInd-1)*dataSz,'cof')~=0
        fclose(fid);
        error('something went wrong positioning file pointer (too few data points ?)');
      end
      % read, skipping nADCNumChannels-1 data points after each read
      dataPtsPerChan=dataPts/nADCNumChannels;
      [d,n]=fread(fid,dataPtsPerChan,precision,dataSz*(nADCNumChannels-1));
      if n~=dataPtsPerChan,
        fclose(fid);
        error(['something went wrong reading file (' int2str(dataPtsPerChan) ' points should have been read, ' int2str(n) ' points actually read']);
      end
    elseif length(chInd)/nADCNumChannels<1
      % --- situation (iii)
      % prepare chunkwise upload:
      % preallocate d
      d=repmat(nan,dataPtsPerChan,length(chInd));
      % the number of data points corresponding to the maximal chunk size, 
      % rounded off such that from each channel the same number of points is
      % read (do not forget that each data point will by default be made a
      % double of 8 bytes, no matter what the original data format is) 
      chunkPtsPerChan=floor(chunk*2^20/8/nADCNumChannels);
      chunkPts=chunkPtsPerChan*nADCNumChannels;
      % the number of those chunks..
      nChunk=floor(dataPts/chunkPts);
      % ..and the remainder
      restPts=dataPts-nChunk*chunkPts;
      restPtsPerChan=restPts/nADCNumChannels;
      % chunkwise row indices into d
      dix=(1:chunkPtsPerChan:dataPtsPerChan)';
      dix(:,2)=dix(:,1)+chunkPtsPerChan-1;
      dix(end,2)=dataPtsPerChan;
      if verbose && nChunk
        disp(['reading file in ' int2str(nChunk) ' chunks of ~' num2str(chunk) ' Mb']);
      end
      % do it: if no remainder exists loop through all rows of dix,
      % otherwise spare last row for the lines below (starting with 
      % 'if restPts')
      for ci=1:size(dix,1)-(restPts>0)
        [tmpd,n]=fread(fid,chunkPts,precision);
        if n~=chunkPts
          fclose(fid);
          error(['something went wrong reading chunk #' int2str(ci) ' (' ...
            int2str(chunkPts) ' points should have been read, ' int2str(n) ' points actually read']); 
        end
        % separate channels..
        tmpd=reshape(tmpd,nADCNumChannels,chunkPtsPerChan);
        d(dix(ci,1):dix(ci,2),:)=tmpd(chInd,:)';
      end
      % collect the rest
      [tmpd,n]=fread(fid,restPts,precision);
      if n~=restPts
        fclose(fid);
        error(['something went wrong reading last chunk (' ...
          int2str(restPts) ' points should have been read, ' int2str(n) ' points actually read']);
      end
      % separate channels..
      tmpd=reshape(tmpd,nADCNumChannels,restPtsPerChan);
      d(dix(end,1):dix(end,2),:)=tmpd(chInd,:)';
    else
      % --- situation (i)
      [d,n]=fread(fid,dataPts,precision);
      if n~=dataPts, 
        fclose(fid);
        error(['something went wrong reading file (' int2str(dataPts) ' points should have been read, ' int2str(n) ' points actually read']); 
      end;
      % separate channels..
      d=reshape(d,nADCNumChannels,dataPtsPerChan);
      d=d';
    end
    % if data format is integer, scale appropriately; if it's float, d is fine 
    if ~nDataFormat
      for j=1:length(chInd),
        ch=recChIdx(chInd(j))+1;
        d(:,j)=d(:,j)/(fInstrumentScaleFactor(ch)*fSignalGain(ch)*fADCProgrammableGain(ch)*addGain(ch))...
          *fADCRange/lADCResolution+fInstrumentOffset(ch)-fSignalOffset(ch);
      end;
    end
  otherwise
    disp('recording mode of data must be event-driven variable-length (1), event-driven fixed-length (2) or gap-free (3) -- returning empty matrix');
    d=[];
    si=[];
end;
  
fclose(fid);