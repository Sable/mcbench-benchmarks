function varargout = getsamples(filename, varargin)
% Read samples from acq file
%   filename - acq file
%   varargin - channel names
% Returns column vectors of all channel data samples of requested channels.
% Example:
%   [SourceR, EMG_L, EMG_R] = getsamples('myfile.acq', 'SourceR', 'EMG_L', 'EMG_R');
% Note:
% Developed and tested for version 3.5 AcqKnowledge files, but should
% probably work with other versions as well.
% Multiple sampling rates are not supported.
% No copyright. Feel free to use this code snippet in any way you want.

n = length(varargin);        % Number of channels to read

% Step through each file section until Channel Data Section is reached.
fp = fopen(filename, 'r');
% Graph Header Section
fseek(fp, 6, 'bof');
lExtItemHeaderLen = fread(fp, 1, 'int32');
nChannels = fread(fp, 1, 'int16');
% Per Channel Data Section
sectionstart = lExtItemHeaderLen;
fseek(fp, sectionstart, 'bof');
lChanHeaderLen = fread(fp, 1, 'int32');
fseek(fp, sectionstart+88, 'bof');
lBufLength = fread(fp, 1, 'int32');     % Number of samples, same for all channels
for i=1:nChannels
    sectionstart = lExtItemHeaderLen + (i-1)*lChanHeaderLen;
    fseek(fp, sectionstart+6, 'bof');
    szCommentText(i,1:40) = fscanf(fp, '%40c', 1);  % This is the channel label
    fseek(fp, sectionstart+92, 'bof');
    dAmplScale(i) = fread(fp, 1, 'double');
    dAmplOffset(i) = fread(fp, 1, 'double');
end
% Foreign Data Section
fseek(fp, lExtItemHeaderLen+lChanHeaderLen*nChannels, 'bof');
nLength = fread(fp, 1, 'int16');
% Per Channel Data Types Section
sectionstart = lExtItemHeaderLen + lChanHeaderLen*nChannels + nLength;
fseek(fp, sectionstart, 'bof');
for i=1:nChannels
    nSize(i) = fread(fp, 1, 'int16');
    nType(i) = fread(fp, 1, 'int16');
end
choffset = cumsum([0 nSize(1:end-1)]);  % Interleave offset
% Channel Data Section
% First find indexes of channels to read by searching channel labels, ...
for k=1:n
    for i=1:nChannels
        chlabel = char(varargin{k});
        if strncmp(chlabel, szCommentText(i,:), length(chlabel))
            chindex(k) = i;
            break;
        end
    end
end
% ...then read samples, one channel at a time.
sectionstart = lExtItemHeaderLen + lChanHeaderLen*nChannels + nLength + 4*nChannels;
fseek(fp, sectionstart, 'bof');
blocksize = sum(nSize);
for k=1:n
    fseek(fp, sectionstart + choffset(chindex(k)), 'bof');
    switch nType(chindex(k))
        case 1  % double
            varargout(k) = {fread(fp, lBufLength, 'double', blocksize-8)};
        case 2  % int
            varargout(k)= {dAmplScale(chindex(k)) * fread(fp, lBufLength, 'int16', blocksize-2) + ... 
                                    dAmplOffset(chindex(k))};
    end
end

fclose(fp);
