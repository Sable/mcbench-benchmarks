function [ varargout ] = readLeCroyWaveJetWfm( varargin )
%readLeCroyWaveJetWfm - Read binary waveform (.wfm) files as saved by
% LeCroy WaveJet oscilloscopes.
%
% readLeCroyWaveJetWfm( filename )
%
%   Loads the specified file, shows some information about the file,
%   and displays the waveform(s).
%
% [ data ] = readLeCroyWaveJetWfm( filename )
% [ data nfo ] = readLeCroyWaveJetWfm( filename )
%
%   Load the specified file and returns its data.
%   data - Array with loaded waveform(s). If only one channel was recorded
%          this is a single column with the waveform. If more than one
%          channel was recorded this is a 2D array where each column
%          corresponds with a channel. If a lower number channel is not
%          recorded it will contain a column with NaN's. If a higher number
%          channel is not recorded, it's column is removed from the data
%          array. E.g. ch1: x, ch2: 0, ch3: x, ch4: 0 will result in a 2D
%          array with 3 column, where the second column contains NaN's.
%   nfo - structure with time axis information and text header
%         nfo.x0    - time of first sample (trigger will be at t = 0)
%         nfo.dx    - sampling time, i.e. time between two consecutive samples
%         nfo.notes - text field with complete oscilloscope setup.
%

% Copyright (c) 2008-2010, Paul Wagenaars
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%
% Changelog:
% v0.1 (2008-06-29)
%   - initial release
%
% v0.2 (2008-08-??)
%   - in averaging mode the binary WFM waveform seems to have a half a
%     sample offset compared to the ASCII CSV file. The binary waveform is
%     now shifted half sample downwards.
%   - if averaging mode is turned on the data of inactive channels was
%     skipped incorrectly. This has been fixed.
%
% v0.3 (2010-03-02)
%   - made function compatible with GNU Octave.
%   - fixed waveforms with multiple waveform modes, e.g. when averaging and
%     equivalent sampling are specified at the same time.
%


% Define some constants
global RLWJW_XWAV_DEF_INF_NOACQ RLWJW_XWAV_DEF_INF_NORM RLWJW_XWAV_DEF_INF_PEAK
global RLWJW_XWAV_DEF_INF_EQU   RLWJW_XWAV_DEF_INF_AVG  RLWJW_XWAV_DEF_INF_ROLL
global RLWJW_XWAV_DEF_INF_ILV
RLWJW_XWAV_DEF_INF_NOACQ = uint16(0);  % 0x0000 /* Not acquired */
RLWJW_XWAV_DEF_INF_NORM = uint16(1);   % 0x0001 /* Normal wave */
RLWJW_XWAV_DEF_INF_PEAK = uint16(2);   % 0x0002 /* Peak wave */
RLWJW_XWAV_DEF_INF_EQU = uint16(4);    % 0x0004 /* Equ wave */
RLWJW_XWAV_DEF_INF_AVG = uint16(8);    % 0x0008 /* Average wave */
RLWJW_XWAV_DEF_INF_ROLL = uint16(16);  % 0x0010 /* Roll wave */
RLWJW_XWAV_DEF_INF_ILV = uint16(32);   % 0x0020 /* Interleave wave */

% Maximum memory enum
global MAX_MEM_ENUM
MAX_MEM_ENUM = 1024 * [0 0.5 ; 1 1 ; 2 10 ; 3 100 ; 4 500];

% V/div enum
global RLWJW_VDIV_ENUM
RLWJW_VDIV_ENUM = [10 5 2 1 500e-3 200e-3 100e-3 50e-3 20e-3 10e-3 5e-3 2e-3];

% time/div enum
global RLWJW_TDIV_ENUM
RLWJW_TDIV_ENUM = [50     20     10     5     2     1     500e-3  200e-3  100e-3 ...
             50e-3  20e-3  10e-3  5e-3  2e-3  1e-3  500e-6  200e-6  100e-6 ...
             50e-6  20e-6  10e-6  5e-6  2e-6  1e-6  500e-9  200e-9  100e-9 ...
             50e-9  20e-9  10e-9  5e-9  2e-9  1e-9  500e-12 200e-12 100e-12 ...
             50e-12 20e-12 10e-12 5e-12 2e-12 1e-12 500e-15 200e-15 100e-15];

% Display informatie about waveform(s)
infomode = (nargout == 0);

if nargin < 1
    error('No filename specified.');
else
    filename = varargin{1};
end

if infomode
    fprintf('Loading %s\n', filename);
end

% Open file
[fid, msg] = fopen(filename, 'r', 'b');
if fid == -1
    error('Unable to open %s: %s', filename, msg);
end

% Skip text header
fullheader = '';
while true
    line = fgetl(fid);
    fullheader = sprintf('%s%s\n', fullheader, line);
    if ~ischar(line)
        fclose(fid);
        error('Unable to find end of setup information. Is this a correct LeCroy WaveJet .wfm file?');
    elseif strcmp(line, '[END OF SETUP]');
        % The 'fgetl' function seems to consume one byte too much.
        % So, here we check the byte and rewind in necessary.
        fseek(fid, -1, 'cof');
        data = fread(fid, 1, 'uint8');
        if (data ~= 10) && (data ~= 13)
            fseek(fid, -1, 'cof');
        end
        break;
    end
end

% Read the XWAV_TDE_WAVEINF structure
wavinf = load_XWAV_TDE_WAVEINF(fid);

% Read waveform data
data = nan(wavinf.timebase.memoryLength + 1, 4);
dataStart = wavinf.timebase.validWfmStart;
memLen = wavinf.timebase.memoryLength;
bankSize = wavinf.timebase.bankSize;
validChannels = nan(1,4);
if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_AVG)
    bytesPerSample = 2;
else
    bytesPerSample = 1;
end
sampleType = sprintf('int%d', 8 * bytesPerSample);
maxValue = 2^(8 * bytesPerSample);
for j = 1:4
    if wavinf.channels(j).isValid
        validChannels(j) = 1;
        singleChannel = fread(fid, bankSize, sampleType);
        if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_AVG)
            % In average mode there is a half a sample offset compared to
            % the csv file. Here we correct that.
            singleChannel = singleChannel - 127;
        end
        singleChannel = singleChannel * 8 * wavinf.channels(j).vdiv / maxValue;
        singleChannel = singleChannel - wavinf.channels(j).offset;
        data(:, j) = singleChannel((5 + dataStart):(memLen + dataStart + 5));
    else
        validChannels(j) = 0;
        fseek(fid, bankSize * bytesPerSample, 'cof');
    end
end
fclose(fid);
clear singleChannel;

% Select only the "good" channels
if sum(validChannels) == 1
    data = data(:, validChannels == 1);
elseif sum(validChannels) < 4
    maxIndex = find(validChannels == 1, 1, 'last');
    data = data(:, 1:maxIndex);
end

% Create nfo structure
totalTime = 10.0 * wavinf.timebase.tdiv;
nfo.dx = totalTime / (wavinf.timebase.memoryLength);
nfo.x0 = -0.5 * totalTime - wavinf.timebase.delay + nfo.dx;
nfo.notes = fullheader;

if infomode
    showInfo(wavinf, nfo, data);
end

% Set the output arguments
if nargout >= 1
    varargout{1} = data;
end
if nargout >= 2
    varargout{2} = nfo;
end

end  % End of main function

%%
%% SUBFUNCTIONS
%%

%% load_XWAV_TDE_WAVEINF
% Loads a wave information structure from file.
% The structure (C code):
% typedef struct
% {
%   XWAV_TDE_WAVEINF_TBASE  TbaseInfo;  /* Time Base Info. */
%   XWAV_TDE_WAVEINF_CH     ChInfo[4];  /* Ch Info. */
% } XWAV_TDE_WAVEINF;
function [waveinfo] = load_XWAV_TDE_WAVEINF(fid)
    waveinfo.timebase = load_XWAV_TDE_WAVEINF_TBASE(fid);
    waveinfo.channels = load_XWAV_TDE_WAVEINF_CH(fid);
end

%% load_XWAV_TDE_WAVEINF_TBASE
% Loads a time base information structure from file.
% The structure (C code):
% typedef struct
% {
%   SVMNG_TDE_TRGDLY delay;        /* Trigger delay time?i-500s..750s?j*/
%   XWAV_TDE_TSTAMP  Tstamp;       /* Time stamp */
%   IWDP_TDE_BANKS   bankNr;       /* Current bank size setting in enum */
%   Uint             mleng;        /* Memory length */
%   Uint             BankSize;     /* Actual bank size (512..512*1024) */
%   Uint             TrgSkew;      /* Trigger skew(TDC): WDP internal value */
%   Uint             WavValidAdr;  /* Start address for valid waveform data */
%   Ushort           wvinf;        /* Bitfielf of waveform mode */
%   Ushort           AvgTimes;     /* Number of average (0,1?`256) */
%   char             tim;          /* time/div in enum */
%   char             spclk;        /* sampling clock in enum */
%   Uchar            RdmInitVal;   /* Random seed: WDP internal value */
%   Uchar            WavSkew;      /* Fraction of delay and trigger skew in a
%                                     sampling clock. 0..99 for normalwaveform,
%                                     0..49 for interleaved waveform,
%                                     (0..100)/(equivalent sampling) for EQU. */
%   Uchar            maxmem;       /* MAX MEMORY LENGTH	0:0.5k, 1:1k, 2:10k,
%                                     3:100k, 4:500k */
%   Ushort           MaskBank;     /* Mask for bank number */
% } XWAV_TDE_WAVEINF_TBASE;
%
% Sizes of the differnet bank numbers (bankNr):
% IWDP_ENM_BANKS = [8 16 32 64 128 256 512 1024 2*1024 4*1024 8*1024 ...
%      16*1024 32*1024 64*1024 128*1024 256*1024 512*1024 1048576 ...
%      2*1048576 4*1048576 Inf];
function [tbase] = load_XWAV_TDE_WAVEINF_TBASE(fid)
    global MAX_MEM_ENUM RLWJW_TDIV_ENUM
    tbase.delay = load_SVMNG_TDE_TRGDLY(fid);
    tbase.timeStamp = load_XWAV_TDE_TSTAMP(fid);
    tbase.bankNr = fread(fid, 1, 'uint32');
    tbase.memoryLength = fread(fid, 1, 'uint32');
    tbase.bankSize = fread(fid, 1, 'uint32');
    tbase.triggerSkew = fread(fid, 1, 'uint32');
    tbase.validWfmStart = fread(fid, 1, 'uint32');
    tbase.wfmMode = fread(fid, 1, 'uint16');
    tbase.nrAvgs = fread(fid, 1, 'uint16');
    tbase.tdivEnum = fread(fid, 1, 'uint8');
    tbase.tdiv = RLWJW_TDIV_ENUM(1 + tbase.tdivEnum);
    tbase.samplingClockEnum = fread(fid, 1, 'uint8');
    tbase.rndInit = fread(fid, 1, 'uint8');
    tbase.wavSkew = fread(fid, 1, 'uint8');
    tbase.maxMemory = MAX_MEM_ENUM(1 + fread(fid, 1, 'uint8'), :);
    tbase.bankMask = fread(fid, 1, 'uint16');
    fread(fid, 1, 'uint8');
end

%% load_SVMNG_TDE_TRGDLY
% // Trigger delay structure
% typedef struct {
%  Uint sgn;  // -1:-/0:+
%  Uint sec;  // 0?`750s     (1s?`750s)
%  Uint us;   // 0?`999999us (1us?`999ms)
%  Uint ps;   // 0?`999999ps (1ps?`999ns)
% } SVMNG_TDE_TRGDLY;
function [delay] = load_SVMNG_TDE_TRGDLY(fid)
    sgn = fread(fid, 1, 'uint32');
    sec = fread(fid, 1, 'uint32');
    us = fread(fid, 1, 'uint32');
    ps = fread(fid, 1, 'uint32');
    if sgn == 0
        delay = 1.0;
    else
        delay = -1.0;
    end
    delay = delay * (sec + 1e-6 * us + 1e-12 * ps);
end

%% load_XWAV_TDE_TSTAMP
% Load time stamp information.
%
% // Date structure
% typedef struct {
%   Ushort  year;
%   Uchar   month;
%   Uchar   day;
% } SVMNG_TDE_DATE;
% 
% // Time structure
% typedef struct {
%   Uchar   hour;
%   Uchar   min;
%   Uchar   sec;
% } SVMNG_TDE_TIME;
% 
% typedef struct {
%   SVMNG_TDE_DATE  date;   // DATE year:2000..2099, month:1..12, day:1..31
%   SVMNG_TDE_TIME  time;   // TIME hour:0..23, min:0..59, sec:0..59
%   Uchar           msec;   // 100ms
% } XWAV_TDE_TSTAMP;
function [tstamp] = load_XWAV_TDE_TSTAMP(fid)
    year = fread(fid, 1, 'uint16');
    month = fread(fid, 1, 'uint8');
    day = fread(fid, 1, 'uint8');
    hour = fread(fid, 1, 'uint8');
    min = fread(fid, 1, 'uint8');
    sec = fread(fid, 1, 'uint8');
    msec = 100 * fread(fid, 1, 'uint8');
    tstamp = [year month day hour min sec msec];
end

%% load_XWAV_TDE_WAVEINF_CH
% Load channel information for a single channel.
function [chs] = load_XWAV_TDE_WAVEINF_CH(fid)
    global RLWJW_VDIV_ENUM
    chs = struct('offset', {NaN NaN NaN NaN}, ...
        'vdivEnum', {NaN NaN NaN NaN}, ...
        'isValid', {false false false false});
    for i = 1:4
        chs(i).offset = fread(fid, 1, 'int32');
        chs(i).vdivEnum = fread(fid, 1, 'uint8');
        chs(i).vdiv = RLWJW_VDIV_ENUM(1 + chs(i).vdivEnum);
        chs(i).offset = chs(i).offset / 3200 * chs(i).vdiv;
        chs(i).isValid = (fread(fid, 1, 'uint8') > 0);
        chs(i).unknown = fread(fid, 1, 'uint16');
    end
end

%% Show information about the waveform(s)
function showInfo(wavinf, nfo, data)
    global RLWJW_XWAV_DEF_INF_NOACQ RLWJW_XWAV_DEF_INF_NORM
    global RLWJW_XWAV_DEF_INF_PEAK  RLWJW_XWAV_DEF_INF_EQU
    global RLWJW_XWAV_DEF_INF_AVG   RLWJW_XWAV_DEF_INF_ROLL
    global RLWJW_XWAV_DEF_INF_ILV
    fprintf('Time stamp: %04d-%02d-%02d %02d:%02d:%02d.%03d\n', ...
        wavinf.timebase.timeStamp);
    fprintf('Memory length: %d (max.mem %dk)\n', wavinf.timebase.memoryLength, ...
        wavinf.timebase.maxMemory(2)/1024);
    fprintf('Bank size: %d\n', wavinf.timebase.bankSize);
    fprintf('Waveform mode:');
    if wavinf.timebase.wfmMode == RLWJW_XWAV_DEF_INF_NOACQ
        fprintf(' not_acquired');
    else
        if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_NORM)
            fprintf(' normal');
        end
        if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_PEAK)
            fprintf(' peak');
        end
        if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_EQU)
            fprintf(' equivalent_sampling');
        end
        if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_AVG)
            fprintf(' averaged(%dx)', wavinf.timebase.nrAvgs);
        end
        if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_ROLL)
            fprintf(' roll');
        end
        if bitand(wavinf.timebase.wfmMode, RLWJW_XWAV_DEF_INF_ILV)
            fprintf(' interleaved');
        end
    end
    fprintf('\n');
    fprintf('Hor. resolution: %g s/div (%d)\n', wavinf.timebase.tdiv, ...
        wavinf.timebase.tdivEnum);
    fprintf('Trigger delay: %g s\n', wavinf.timebase.delay);
    fprintf('Valid wfm start: %d\n', wavinf.timebase.validWfmStart);

    fprintf('                    Channel 1  Channel 2  Channel 3  Channel 4 \n');
    fprintf('offset         (V)  %9g  %9g  %9g  %9g\n', wavinf.channels.offset);
    fprintf('resolution (V/div)  %9g  %9g  %9g  %9g\n', wavinf.channels.vdiv);
    fprintf('channel on or off?  %9g  %9g  %9g  %9g\n', wavinf.channels.isValid);
    fprintf('unknown             %9d  %9d  %9d  %9d\n', wavinf.channels.unknown);
    
    xf = (wavinf.timebase.memoryLength) * nfo.dx + nfo.x0;
    t = linspace(nfo.x0, xf, wavinf.timebase.memoryLength + 1);
    figure;
    plot(t, data);
    grid on;
    xlabel('Time (s)');
end  % end of showInfo function

