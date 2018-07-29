function varargout = readRigolWaveform(filename, varargin)
%Reads a binary waveform (.wfm) file stored by a Rigol oscilloscope.
%
% readRigolWaveform(filename) Displays information about the recorded
% signal(s) in the waveform file and plots the signal(s).
%
% filename - filename of Rigol binary waveform
%
%
% [y, nfo] = readRigolWaveform(filename) Reads the signal(s) in the
% specified file.
%
% filename - filename of Rigol binary waveform
% y        - column array with data. If both channels were recorded it
%            contains two channels.
% nfo      - structure with time axis and other information
%            nfo.x0: time corresponding to first sample
%            nfo.dx: sample time (= 1 / sample_frequency)
%            nfo.notes: text field other oscilloscope settings
%

if ~exist('filename', 'var')
    error('Error using this function. For help type: help readRigolWaveform');
end

if nargout == 0
    fprintf('---\nFilename: %s\n', filename);
end

%% Open the file and check the header
if ~exist(filename, 'file')
    error('Specified file (%s) doesn''t exist.', filename);
end

fid = fopen(filename, 'r');
if fid == -1
    error('Unable to open %s for reading.', filename);
end

% Check first two bytes
header = fread(fid, 2, '*uint8');
if (header(1) ~= 165) || (header(2) ~= 165)
    error('Incorrect first two bytes. This files does not seem to be a Rigol waveform file.');
end


%% Check which channels were recorded
fseek(fid, 49, -1);
ch1Recorded = (fread(fid, 1, '*uint8') == 1);
fseek(fid, 73, -1);
ch2Recorded = (fread(fid, 1, '*uint8') == 1);


%% Nr. of data points
fseek(fid, 28, -1);
N = fread(fid, 1, 'uint32=>double');
if nargout == 0
    fprintf('Record length: %dk\n', N / 1024);
end


%% Time axis
if nargout == 0
    fprintf('- Time axis\n');
end
fseek(fid, 84, -1);
time.scale = fread(fid, 1, 'uint64=>double') * 1e-12;
time.delay = fread(fid, 1, 'int64=>double') * 1e-12;
fseek(fid, 100, -1);
time.fs = fread(fid, 1, 'single=>double');

nfo.x0 = -N / 2 / time.fs + time.delay;
nfo.dx = 1 / time.fs;
if nargout == 0
    fprintf('    scale: %ss/div\n', nr2str(time.scale));
    fprintf('    delayed: %ss\n', nr2str(time.delay));
    fprintf('    sample frequency: %sS/s\n', nr2str(time.fs));
end


%% Read ch1 and ch2 information
if ch1Recorded
    ch1Info = readChannelInfo(fid, 1, (nargout == 0));
else
    ch1Info = [];
end
if ch2Recorded
    ch2Info = readChannelInfo(fid, 2, (nargout == 0));
else
    ch2Info = [];
end


%% Read ch1 and ch2 data
fseek(fid, 272, -1);
if ch1Recorded
    ch1Data = (125 - fread(fid, N, 'uint8=>double')) / 250 * 10 * ch1Info.scale;
    ch1Data = ch1Data - ch1Info.position;
end
if ch2Recorded
    ch2Data = (125 - fread(fid, N, 'uint8=>double')) / 250 * 10 * ch2Info.scale;
    ch2Data = ch2Data - ch2Info.position;
end


%% Trigger mode
if nargout == 0
    fprintf('- Trigger\n');
end
fseek(fid, 142, -1);
triggermode = fread(fid, 1, '*uint16');
if triggermode == hex2dec('0000')
    trigger.mode = 'edge';
elseif triggermode == hex2dec('0101')
    trigger.mode = 'pulse';
elseif triggermode == hex2dec('0303')
    trigger.mode = 'vid';
elseif triggermode == hex2dec('0202')
    trigger.mode = 'slope';
elseif triggermode == hex2dec('0004')
    trigger.mode = 'alt';
elseif triggermode == hex2dec('0505')
    trigger.mode = 'pattern';
elseif triggermode == hex2dec('0606')
    trigger.mode = 'duration';
else
    error('Unknown trigger mode.');
end
if nargout == 0
    fprintf('    mode: %s\n', trigger.mode);
end

triggersource = fread(fid, 1, '*uint8');
if triggersource == 0
    trigger.source = 'ch1';
elseif triggersource == 1
    trigger.source = 'ch2';
elseif triggersource == 2
    trigger.source = 'ext';
elseif triggersource == 3
    trigger.source = 'ext/5';
elseif triggersource == 5
    trigger.source = 'acLine';
elseif triggersource == 7
    trigger.source = 'dig.ch';
else
    error('Unknown trigger source.');
end
if nargout == 0
    fprintf('    source: %s\n', trigger.source);
end

%% Close file
fclose(fid);


%% Plot signals
if nargout == 0
    figure;
    tf = nfo.x0 + (N - 1) * nfo.dx;
    t = linspace(nfo.x0, tf, N);
    
    if exist('ch1Data', 'var') && exist('ch2Data', 'var')
        plot(t, ch1Data, t, ch2Data);
        legend('Ch1', 'Ch2');
    elseif exist('ch1Data', 'var')
        plot(t, ch1Data);
        legend('Ch1');
    else
        plot(t, ch2Data);
        legend('Ch2');
    end
    grid on;
    xlabel('Time (s)');
    ylabel('Voltage (V)');
end


%% Assign output arguments
if nargout >= 1
    % Assign signal y
    if ch1Recorded && ~ch2Recorded
        y = ch1Data;
    elseif ~ch1Recorded && ch2Recorded
        y = ch2Data;
    else
        y = [ch1Data ch2Data];
    end
    varargout{1} = y;
end
if nargout >= 2
    nfo.notes = createNotes(time, ch1Info, ch2Info, trigger);
    varargout{2} = nfo;
end


end  % end of main function


%% Function: readChannelInfo
function [ info ] = readChannelInfo(fid, chNr, printInfo)
    % Data addresses (decimal) for ch1 and ch2
    % [scale, position, probe attenuation]
    allAddresses = [
        36 40 46
        60 64 70
    ];
    adrs = allAddresses(chNr, :);
    
    if printInfo
        fprintf('- Ch%d\n', chNr);
    end
       
    % Vertical scaling
    fseek(fid, adrs(1), -1);
    info.scale = fread(fid, 1, 'uint32=>double') * 1e-6;
    if printInfo
        fprintf('    scale: %sV/div\n', nr2str(info.scale));
    end
    
    % Vertical position
    fseek(fid, adrs(2), -1);
    info.position = fread(fid, 1, 'int16=>double') / 25 * info.scale;
    if printInfo
        fprintf('    position: %sV\n', nr2str(info.position));
    end

    % Probe attenuation
    fseek(fid, adrs(3), -1);
    probeatten = fread(fid, 1, '*uint16');
    if probeatten == hex2dec('3F80')
        info.probeatten = 1;
    elseif probeatten == hex2dec('4120')
        info.probeatten = 10;
    elseif probeatten == hex2dec('42C8')
        info.probeatten = 100;
    elseif probeatten == hex2dec('447A')
        info.probeatten = 1000;
    else
        error('Unknown ch%d probe attenuation.', chNr);
    end
    if printInfo
        fprintf('    probe attenuation: %gx\n', info.probeatten);
    end
end


%% Function: createNotes
function [ notes ] = createNotes(timeInfo, ch1Info, ch2Info, triggerInfo)
    notes = sprintf('time.scale = %ss/div\n', nr2str(timeInfo.scale));
    notes = sprintf('%stime.delay = %ss\n', notes, nr2str(timeInfo.delay));
    notes = sprintf('%stime.fs = %sS/s\n', notes, nr2str(timeInfo.fs));
    if ~isempty(ch1Info)
        notes = sprintf('%sch1.scale = %sV/div\n', notes, nr2str(ch1Info.scale));
        notes = sprintf('%sch1.position = %sV\n', notes, nr2str(ch1Info.position));
        notes = sprintf('%sch1.probe_attenuation = %gx\n', notes, ch1Info.probeatten);
    end
    if ~isempty(ch2Info)
        notes = sprintf('%sch2.scale = %sV/div\n', notes, nr2str(ch2Info.scale));
        notes = sprintf('%sch2.position = %sV\n', notes, nr2str(ch2Info.position));
        notes = sprintf('%sch2.probe_attenuation = %gx\n', notes, ch2Info.probeatten);
    end
    notes = sprintf('%strigger.mode = %s\n', notes, triggerInfo.mode);
    notes = sprintf('%strigger.source = %s\n', notes, triggerInfo.source);
end


%% Function: nr2str
function [ nrString ] = nr2str(number)
    absnr = abs(number);
    if absnr == 0
        nrString = sprintf('%g ', number);
    elseif absnr < 1e-9
        nrString = sprintf('%g p', number / 1e-12);
    elseif absnr < 1e-6
        nrString = sprintf('%g n', number / 1e-9);
    elseif absnr < 1e-3
        nrString = sprintf('%g u', number / 1e-6);
    elseif absnr < 1
        nrString = sprintf('%g m', number / 1e-3);
    elseif absnr < 1e3
        nrString = sprintf('%g ', number);
    elseif absnr < 1e6
        nrString = sprintf('%g k', number / 1e3);
    elseif absnr < 1e9
        nrString = sprintf('%g M', number / 1e6);
    else
        nrString = sprintf('%g G', number / 1e9);
    end
end
