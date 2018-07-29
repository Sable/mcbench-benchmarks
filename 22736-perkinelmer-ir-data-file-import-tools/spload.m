function [data, xAxis, misc] = spload(filename)
% Reads in spectra from PerkinElmer block structured files.
% This version supports 'Spectrum' SP files.
% Note that earlier 'Data Manager' formats are not supported.
%
% [data, xAxis, misc] = spload(filename):
%   data:  1D array of doubles
%   xAxis: vector for abscissa (e.g. Wavenumbers).
%   misc: miscellanous information in name,value pairs

% Copyright (C)2007 PerkinElmer Life and Analytical Sciences
% Stephen Westlake, Seer Green
%
% History
% 2007-04-24 SW     Initial version

% Block IDs
DSet2DC1DIBlock               =  120;
HistoryRecordBlock            =  121;
InstrHdrHistoryRecordBlock    =  122;
InstrumentHeaderBlock         =  123;
IRInstrumentHeaderBlock       =  124;
UVInstrumentHeaderBlock       =  125;
FLInstrumentHeaderBlock       =  126;
% Data member IDs
DataSetDataTypeMember              =  -29839;
DataSetAbscissaRangeMember         =  -29838;
DataSetOrdinateRangeMember         =  -29837;
DataSetIntervalMember              =  -29836;
DataSetNumPointsMember             =  -29835;
DataSetSamplingMethodMember        =  -29834;
DataSetXAxisLabelMember            =  -29833;
DataSetYAxisLabelMember            =  -29832;
DataSetXAxisUnitTypeMember         =  -29831;
DataSetYAxisUnitTypeMember         =  -29830;
DataSetFileTypeMember              =  -29829;
DataSetDataMember                  =  -29828;
DataSetNameMember                  =  -29827;
DataSetChecksumMember              =  -29826;
DataSetHistoryRecordMember         =  -29825;
DataSetInvalidRegionMember         =  -29824;
DataSetAliasMember                 =  -29823;
DataSetVXIRAccyHdrMember           =  -29822;
DataSetVXIRQualHdrMember           =  -29821;
DataSetEventMarkersMember          =  -29820;
% Type code IDs
ShortType               = 29999;
UShortType              = 29998;
IntType                 = 29997;
UIntType                = 29996;
LongType                = 29995;
BoolType                = 29988;
CharType                = 29987;
CvCoOrdPointType        = 29986;
StdFontType             = 29985;
CvCoOrdDimensionType    = 29984;
CvCoOrdRectangleType    = 29983;
RGBColorType            = 29982;
CvCoOrdRangeType        = 29981;
DoubleType              = 29980;
CvCoOrdType             = 29979;
ULongType               = 29978;
PeakType                = 29977;
CoOrdType               = 29976;
RangeType               = 29975;
CvCoOrdArrayType        = 29974;
EnumType                = 29973;
LogFontType             = 29972;


fid = fopen(filename,'r');
if fid == -1
    error('Cannot open the file.');
    return
end

% Fixed file header of signature and description
signature = setstr(fread(fid, 4, 'uchar')');
if ~strcmp(signature, 'PEPE')
    
    error('This is not a PerkinElmer block structured file.');
    return
end
description = setstr(fread(fid, 40, 'uchar')');

% Initialize a variable so we can tell if we have read it.
xLen = int32(0);

% The rest of the file is a list of blocks
while ~feof(fid)
    blockID = fread(fid,1,'int16');
    blockSize = fread(fid,1,'int32');
    
    % feof does not go true until after the read has failed.
    if feof(fid)
        break
    end
    
    switch blockID
        case DSet2DC1DIBlock
        % Wrapper block.  Read nothing.

        case DataSetAbscissaRangeMember
            innerCode = fread(fid, 1, 'int16');
            %_ASSERTE(CvCoOrdRangeType == nInnerCode);
            x0 = fread(fid, 1, 'double');
            xEnd = fread(fid, 1, 'double');
                
        case DataSetIntervalMember
            innerCode = fread(fid, 1, 'int16');
            xDelta = fread(fid, 1, 'double');

        case DataSetNumPointsMember
            innerCode = fread(fid, 1, 'int16');
            xLen = fread(fid, 1, 'int32');

        case DataSetXAxisLabelMember
            innerCode = fread(fid, 1, 'int16');
            len = fread(fid, 1, 'int16');
            xLabel = setstr(fread(fid, len, 'uchar')');

        case DataSetYAxisLabelMember
            innerCode = fread(fid, 1, 'int16');
            len = fread(fid, 1, 'int16');
            yLabel = setstr(fread(fid, len, 'uchar')');
            
        case DataSetAliasMember
            innerCode = fread(fid, 1, 'int16');
            len = fread(fid, 1, 'int16');
            alias = setstr(fread(fid, len, 'uchar')');
          
        case DataSetNameMember
            innerCode = fread(fid, 1, 'int16');
            len = fread(fid, 1, 'int16');
            originalName = setstr(fread(fid, len, 'uchar')');
          
        case DataSetDataMember
            innerCode = fread(fid, 1, 'int16');
            len = fread(fid, 1, 'int32');
            % innerCode should be CvCoOrdArrayType
            % len should be xLen * 8
            if xLen == 0
                xLen = len / 8;
            end
            data = fread(fid, xLen, 'double');
 
        otherwise               % unknown block, just seek past it
            fseek(fid, blockSize, 'cof');
    end
end
fclose(fid);

if xLen == 0
    error('The file does not contain spectral data.');
    return
end

% Expand the axes specifications into vectors
xAxis = x0 : xDelta : xEnd;

% Return the other details as name,value pairs
misc(1,:) = {'xLabel', xLabel};
misc(2,:) = {'yLabel', yLabel};
misc(3,:) = {'alias', alias};
misc(4,:) = {'original name', originalName};

