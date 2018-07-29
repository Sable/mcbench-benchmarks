function intruderdetection(logName, secondsToRecord, silentAlarm)
%INTRUDERDETECTION A simple intruder detection monitor.
%
%    INTRUDERDETECTION starts the intruder detection monitor. 
%  
%    Whenever the default motion or sound thresholds are exceeded, an
%    alarm will sound, and video and audio data will be recorded for 10
%    seconds. Video and audio data will be record to the files,
%    'IntruderLog-yyyymmddTHHMMS.avi' and 'IntruderLog-yyyymmddTHHMMS.daq'.
%
%    When the monitor is closed, the .DAQ file is converted to a Microsoft
%    WAVE file, 'IntruderLog-yyyymmddTHHMMS.wav'. In addition, a .MAT
%    file is written that contains information that includes the absolute
%    time stamps of each intruder event.
%
%    The sound for the alarm is read from the file 'alarm.wav'. 
%
%    INTRUDERDETECTION(LOGNAME) starts the monitor and uses the given
%    path and file name for the log files. The file name should be given
%    without an extension.
%
%    INTRUDERDETECTION(LOGNAME, SECONDSTORECORD) specifies the name of the
%    log files and the number of seconds to record for each intruder
%    event.
%   
%    INTRUDERDETECTION(LOGNAME, SECONDSTORECORD, SILENTALARM) specifies the
%    name of the log files, the number of seconds to record, and whether
%    the alarm should be silent or not.
%
%    Example:
%
%        % Record data in the directory 'D:\Logs' with the file names
%        % 'MyOffice.avi' and 'MyOffice.wav'. For each intruder event, 
%        % record data for 30 seconds and use a silent alarm.
%        INTRUDERDETECTION('D:\Logs\MyOffice', 30, true);
%
%    See also VIDEOINPUT, ANALOGINPUT, ANALOGOUTPUT, WAVREAD, and WAVWRITE.
%

%    DTL
%    Copyright 2007-2008 The MathWorks, Inc.

if ~ispc
    error('INTRUDERDETECTION is only supported on Microsoft Windows platforms.');
end

%% Set defaults, if none provided.
if nargin < 3
    silentAlarm = false;
end
if nargin < 2
    secondsToRecord = 10;
end
if nargin < 1
    logName = ['IntruderLog-' datestr(now,30)];
end

%% Other settings...

% Maxmimum rate at which to record video to disk.
maxDiskFrameRate = 5;
% Video codec to use.
videoCompression = 'Cinepak';
% Maximum rate at which to display video and audio data.
maxDisplayRate = 10;
% Threshold at which to consider the motion something of interest.
motionThreshold = 200;         % Between 0 and 255
% Threshold at which to consider the sound something of interest.
soundThreshold = 0.08;         % Between 0.0 and 1.0 volts.

%% Create a video input object and determine the average frame rate.
vid = videoinput('winvideo'); 
disp(sprintf('Measuring actual frame rate...'));
triggerconfig(vid,'manual');
set( vid, 'FramesPerTrigger', 50 );
start(vid);
pause(1.0);
trigger(vid);
% Acquire 50 frames or 20 seconds of data, whichever comes first.
try
    wait(vid,20,'running');
catch
    % Supress any error and just use the frames we were able to get.
    stop(vid);
end
[frames,relTimes] = getdata(vid, vid.FramesAvailable);
actualFrameRate = 1/mean(diff(relTimes));
disp(sprintf('Average frame rate:%f measured over %d frames',...
              actualFrameRate, size(frames,ndims(frames))));

%% Configure the video input object to detect motion and record video when
%% triggered.

% Keep the recording frame rate under maxDiskFrameRate.
set(vid, 'FrameGrabInterval', ceil(actualFrameRate / maxDiskFrameRate) ); 
framesPerSecond = actualFrameRate / get(vid, 'FrameGrabInterval');
frameLogFile = avifile(logName,...
                       'Compression', videoCompression,...
                       'Fps', framesPerSecond );
set(vid, 'TriggerRepeat', Inf);
framesToRecord = ceil(framesPerSecond * secondsToRecord); 
set(vid, 'FramesPerTrigger', framesToRecord);
set(vid, 'LoggingMode', 'disk');
set(vid, 'DiskLogger', frameLogFile);
set(vid, 'StartFcn', @videoStartFcn);
% Display at close to the actual frame rate but no more than maxUpdateRate.
displayPeriod = max(1.1*(1/actualFrameRate), 1/maxDisplayRate); 
set(vid, 'TimerPeriod', displayPeriod); 
set(vid, 'TimerFcn', @videoTimerFcn);

% Adjust the number of seconds that we are recording to match the
% number of frames.
secondsToRecord = framesToRecord / framesPerSecond;

%% Configure the analog input object to detect noise and record sound when
%% triggered.

ai = analoginput('winsound');
addchannel(ai,[1 2]);
set(ai, 'LoggingMode', 'disk');
set(ai, 'LogFileName', logName);
set(ai, 'LogToDiskMode', 'overwrite');
set(ai, 'TriggerType', 'manual');
set(ai, 'TriggerRepeat', Inf);
samplesToRecord = ceil(ai.SampleRate * secondsToRecord);
set(ai, 'SamplesPerTrigger', samplesToRecord );

%% Configure the analog output object to make alarm.

% Shorten alarm so the sound doesn't trigger a new intruder alert.
secondsToAlarm = secondsToRecord - 1;

% If alarm is too short, make it silent.
if secondsToAlarm < 1 
    secondsToAlarm = 1;
    silentAlarm = true;
end

ao = analogoutput('winsound');
[alarmData, frequency, nbits] = customAlarmData();
addchannel(ao,1:size(alarmData,2)); % Add a channel for each alarm channel.
set(ao, 'SampleRate', frequency);
set(ao, 'BitsPerSample', nbits);
putdata(ao, alarmData);
set(ao, 'TriggerType', 'immediate');
set(ao, 'RepeatOutput', Inf); 
set(ao, 'TimerPeriod', secondsToAlarm);
set(ao, 'TimerFcn', @alarmTimerFcn);
set(ao, 'StopFcn', @alarmStopFcn);

%% Create the figure
fig = figure('DoubleBuffer','on', ...
             'Name', 'Intruder Detection', ...
             'NumberTitle', 'off', ...
             'WindowStyle', 'docked', ...
             'Toolbar', 'none', ...
             'MenuBar', 'none', ...
             'Color',[.5 .5 .5], ...
             'CloseRequestFcn', @figureCloseFcn, ...
             'DeleteFcn', @figureDeleteFcn);   

%% Initialize the previous image.
imagePrevious = [];
timePrevious = [];

%% Start the sound and video input objects
start(ai); 
start(vid);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Generate custom alarm data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function [data, frequency, nbits] = customAlarmData()
        [data, frequency, nbits] = wavread('alarm.wav','double');
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Do any user-specific action when intruder is detected.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function customIntruderAction()
        % e.g. Send notification.
        %sendmail <your email address> 'Intruder Alert';
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Video Timer Function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   function videoStartFcn(vid, event) %#ok<INUSD>
       % Get initialize image and time.
       imagePrevious = getsnapshot(vid);
       timePrevious = now;
   end
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Video Timer Function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function videoTimerFcn(vid, event) %#ok<INUSD>

    %% Get the most recent image and time.
    try
        imageCurrent = getsnapshot(vid);
        timeCurrent = now;
    catch
        % getsnapshot can fail if object is deleted while we are waiting.
        return;
    end

    %% Get the sound that occured since the last image.
    samplesRequested =  ceil((timeCurrent - timePrevious) * (60*60*24) *...
                                                            ai.SampleRate);
    warning('off','daq:peekdata:requestedSamplesNotAvailable');
    try
        sound = peekdata(ai, samplesRequested);
    catch
        % Occasionally, peekdata fails.
        sound = zeros(samplesRequested, length(ai.Channel));
    end
    warning('on','daq:peekdata:requestedSamplesNotAvailable');

    %% Compute the difference between the current and previous images
    imageDifference = abs(imagePrevious - imageCurrent);
    imageMax = max(imageDifference(:));

    %% Compute the loudest sound detected during the interval.
    sound = sound - mean(sound(:,1)); % Center about the mean.
    soundMax = max(max(abs(sound)));  % Calculate max deviation from mean.

    % Save the current image and time for the next iteration.
    imagePrevious = imageCurrent;
    timePrevious = timeCurrent;
        
    %% Make our figure current.
    figOld = get(0,'CurrentFigure');
    if fig ~= figOld
        set(0, 'CurrentFigure', fig);
    end

    %% Show the current image and time.
    subplot(1,2,1);
    image(imageCurrent);
    label = datestr(timeCurrent, 'HH:MM:SS:FFF');
    xlabel(label);
    set(gca,'XTick',[], 'YTick',[]);

    %% Show the sound and maximum values.
    subplot(1,2,2);
    plot(sound);
    axis([0 size(sound,1) -1 1]);
    label = sprintf('Motion:%03d  Sound:%04.2f', imageMax, soundMax);
    xlabel(label);
    set(gca,'XTick',[]);

    %% Look for motion.
    if imageMax > motionThreshold
        motion = true;
    else
        motion = false;
    end

    %% Look for noise.
    if soundMax > soundThreshold
        noise = true;
    else
        noise = false;
    end

    % If we are not yet in a recording/alarm state.
    if ~islogging(vid) && ~islogging(ai) && ~isrunning(ao)
        % If either motion or noise occur, begin recording.
        if ( motion || noise )
            % Give visual indication of recording.
            set(gcf, 'Color', [1 0 0]);

            % Start alarm if desired.
            if ~silentAlarm
                start(ao);
            end

            % Begin recording sound.
            trigger(ai);
            
            % Begin recording video.
            trigger(vid);

            % Do any custom action.
            customIntruderAction();
        else
            % Give visual indication of not recording.
            set(gcf, 'Color', [.5 .5 .5]);
        end;
    end

    % Restore previous figure.
    if fig ~= figOld
        set(0, 'CurrentFigure', figOld);
    end

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Alarm Timer Callback
    %    Stop the alarm.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function alarmTimerFcn(obj, event)  %#ok<INUSD>
        % Stop the alarm.
        stop(obj);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Alarm Stop Callback
    %    Reload the alarm data for the next time.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function alarmStopFcn(obj, event)  %#ok<INUSD>
        % Reload data for the next time alarm is started.
        putdata(obj, alarmData);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Figure Close Function
    %    Stop objects and close figure window.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function figureCloseFcn(obj, event)  %#ok<INUSD,INUSD>
        try
            % Stop objects so they don't write to figure any more.
            stop(vid);
            stop([ai ao]);
        catch
        end
        closereq;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Figure Delete Function
    %    Cleanup objects and files.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function figureDeleteFcn(obj, event)  %#ok<INUSD,INUSD>
        % Save video and audio events to a MAT file.
        videoEvents = vid.EventLog; %#ok<NASGU>
        audioEvents = ai.EventLog; %#ok<NASGU>
        save(logName,'videoEvents','audioEvents');
            
        % Close video logging file.
        videoFile = close(vid.DiskLogger);       %#ok<NASGU>

        % Delete objects.
        delete(vid);
        delete([ai ao]);

        % Convert audio data into wav file.
        disp(sprintf('Writing wave file...'));
        soundData = daqread(logName);
        soundInfo = daqread(logName, 'info');
        wavwrite(soundData, soundInfo.ObjInfo.SampleRate, ...
                 soundInfo.HwInfo.Bits, logName);
        disp(sprintf('Done.'));
    end
end
