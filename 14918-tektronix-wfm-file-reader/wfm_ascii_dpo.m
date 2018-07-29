function [out_descript, outdata, timedata] = wfm_ascii_dpo(fname, data_start, data_stop)

% Converts TSD5/6/7k and DPO7k/70k .wfm file to ASCII format 
% with time array
%
% data_start and data_stop input arguments are optional
% and can be used to read parts of file
%
% To do: implement fast frame, pixel maps
%

out = [];
if nargin==0        
    fname='';
end

if isempty(fname)
    [filename,pname]=uigetfile({'*.wfm', 'Tektronix Waveform Files (*.wfm)';'*.*', 'All Files (*.*)'},'Choose Tektronix WFM file');
    fname=[pname filename];
end

%---Open file
fd = fopen(fname,'r');
if fd==-1
    error('Problem opening file "%s"',fname)
end

%---Determine byte ordering, then close and reopen with proper byte ordering
ByteOrder = fread(fd,1,'ushort');
if ByteOrder==61680
    fclose(fd);
    fd = fopen(fname,'r','ieee-be');
else
    fclose(fd);
    fd = fopen(fname,'r','ieee-le');
end

%---WFM static file information
out.ByteOrder               = fread(fd, 1,'ushort' );
out.VersionNum              = fread(fd, 8,'*char'  )';
if ~any(strcmp(out.VersionNum,{':WFM#001';':WFM#002';':WFM#003'}))
    fclose(fd);
    error('File "%s" is not a valid WFM file',fname)
end
out.NumDigitsInByteCount    = fread(fd, 1,'char'   );
out.NumBytesToEOF           = fread(fd, 1,'long'   );
out.NumBytesPerPoint        = fread(fd, 1,'char'   );
out.ByteOffsetToCurveBuffer = fread(fd, 1,'long'   );
out.HorZoomScale            = fread(fd, 1,'long'   );
out.HorZoomPos              = fread(fd, 1,'float32');
out.VerZoomScale            = fread(fd, 1,'double' );
out.VerZoomPos              = fread(fd, 1,'float32');
out.WaveformLabel           = fread(fd,32,'*char'  )';
out.N                       = fread(fd, 1,'ulong'  );
out.HeaderSize              = fread(fd, 1,'ushort' );

%---WFM header
out.SetType                 = fread(fd, 1,'int'   );
out.WfmCnt                  = fread(fd, 1,'ulong' );
jnk                         = fread(fd,36,'uchar' ); % Skip these for now
out.DataType                = fread(fd, 1,'int'   );
jnk                         = fread(fd,28,'uchar' ); % Skip these for now
switch out.VersionNum
case {':WFM#002' ':WFM#003'}
    jnk                     = fread(fd, 1,'ushort'); % Skip these for now
end
jnk                         = fread(fd,12,'uchar' ); % Skip these for now

%---Explicit Dimension 1/2
s = [];
for n=1:2
    s.DimScale              = fread(fd, 1,'double');
    s.DimOffset             = fread(fd, 1,'double');
    s.DimSize               = fread(fd, 1,'ulong' );
    s.Units                 = fread(fd,20,'*char' );
    s.DimExtentMin          = fread(fd, 1,'double');
    s.DimExtentMax          = fread(fd, 1,'double');
    s.DimResolution         = fread(fd, 1,'double');
    s.DimRefPoint           = fread(fd, 1,'double');
    s.Format                = fread(fd, 1,'int'   );
    s.StorageType           = fread(fd, 1,'int'   );
    jnk                     = fread(fd,20,'uchar' ); % Skip these for now
    s.UserScale             = fread(fd, 1,'double');
    s.UserUnits             = fread(fd,20,'*char' );
    s.UserOffset            = fread(fd, 1,'double');
    switch out.VersionNum
    case ':WFM#003'
        s.PointDensity      = fread(fd, 1,'double');
    otherwise
        s.PointDensity      = fread(fd, 1,'ulong' );
    end
    s.HRef                  = fread(fd, 1,'double');
    s.TrigDelay             = fread(fd, 1,'double');
    out.ExplicitDimension(n) = s;
end

%---Implicit Dimension 1/2
s=[];
for n=1:2
    s.DimScale              = fread(fd, 1,'double');
    s.DimOffset             = fread(fd, 1,'double');
    s.DimSize               = fread(fd, 1,'ulong' );
    s.Units                 = fread(fd,20,'*char' )';
    jnk                     = fread(fd,16,'uchar' ); % Skip these for now
    s.DimResolution         = fread(fd, 1,'double');
    jnk                     = fread(fd,12,'uchar' ); % Skip these for now
    s.UserScale             = fread(fd, 1,'double');
    s.UserUnits             = fread(fd,20,'*char' );
    s.UserOffset            = fread(fd, 1,'double');
    switch out.VersionNum
    case ':WFM#003'
        s.PointDensity      = fread(fd, 1,'double');
    otherwise
        s.PointDensity      = fread(fd, 1,'ulong' );
    end
    s.HRef                  = fread(fd, 1,'double');
    s.TrigDelay             = fread(fd, 1,'double');
    out.ImplicitDimension(n) = s;
end

%---Time Base 1/2 Information
s=[];
for n=1:2
    s.RealPointSpacing      = fread(fd, 1,'ulong' );
    s.Sweep                 = fread(fd, 1,'int'   );
    s.TypeOfBase            = fread(fd, 1,'int'   );
    out.TimeBase(n) = s;
end

%---WFM Update Spec
jnk                         = fread(fd,24,'uchar'); % Skip these for now

%---WFM Curve Information
jnk                         = fread(fd,10,'uchar'); % Skip these for now
PrechargeStartOffset        = fread(fd, 1,'ulong');
DataStartOffset             = fread(fd, 1,'ulong');
PostchargeStartOffset       = fread(fd, 1,'ulong');
PostchargeStopOffset        = fread(fd, 1,'ulong');
EndOfCurveBufferOffset      = fread(fd, 1,'ulong');

%---FastFrame Frames
%OPTIONAL

%---Curve Buffer
out.CurveSizeInBytes = PostchargeStartOffset - DataStartOffset;
out.CurveSize = out.CurveSizeInBytes / out.NumBytesPerPoint;
jnk = fread(fd,DataStartOffset,'uchar'); % Skip precharge

if nargin<3        
    data_start = 1;
    data_stop = out.CurveSize;
end
switch out.NumBytesPerPoint
    case 1
        if data_start > 1
        jnk = fread(fd,data_start-1,'*int8');
        out.CurveData = fread(fd,data_stop-data_start+1,'*int8');
        else
        out.CurveData = fread(fd,data_stop,'*int8');
        end
    case 2
        if data_start > 1
        out.CurveData = fread(fd,data_start-1,'*int16');
        out.CurveData = fread(fd,data_stop-data_start+1,'*int16');
        else
        out.CurveData = fread(fd,data_stop,'*int16');
        end
end

    
%---Close file
fclose(fd);
%E_DimOffset = out.ExplicitDimension(1,1).DimOffset;
%E_DimScale = out.ExplicitDimension(1,1).DimScale;
%E_CurveData = out.CurveData;
%I_DimOffset = out.ImplicitDimension(1,1).DimOffset
%I_DimScale = out.ImplicitDimension(1,1).DimScale

y = (out.ExplicitDimension(1,1).DimOffset) + (out.ExplicitDimension(1,1).DimScale)*double(out.CurveData); 
t = out.ImplicitDimension(1,1).DimOffset + out.ImplicitDimension(1,1).DimScale*(data_start:data_stop);
out_descript.Fs = 1/out.ImplicitDimension(1,1).DimScale;
out_descript.Ts = out.ImplicitDimension(1,1).DimScale;
out_descript.N = out.CurveSize;
out_descript.byte = out.NumBytesPerPoint;
outdata = y;
timedata = t;
