function realTimeMic(duration, nBlocks, useVideo)

%
% function realTimeMic(duration, nBlocks, useVideo)
%
% This function records: 
%  - audio data from soundcard's input and 
%  - video data from webcam input
%
% In particular, 'nBlocks' of audio segments of size 'duration' are
% recorded and an image is taken every 'duration' seconds.
%
% %%%%%%%%%% %
% ARGUMENTS: %
% %%%%%%%%%% %
% duration: (in seconds) the duration of each audio segment (and the time
%            interval between two succcesive images taken from cam).
% nBlocks:   number of blocks to be recorded
% useVideo:  1 for recording video and 0 otherwise
% 

clc;
fprintf('--------------------------------------------------------------------------\n')
fprintf('Real Time Microphone and Camera acquisition and audio-video processing.\n\n');
fprintf('Theodoros Giannakopoulos\n');
fprintf('http://www.di.uoa.gr/~tyiannak\n');
fprintf('Dep. of Informatics and Telecommunications,\n');
fprintf('University of Athens, Greece\n');
fprintf('--------------------------------------------------------------------------\n')

warning off;

% OPEN SOUNDCARD INPUT:      
ai = analoginput('winsound');
addchannel(ai,1);
Fs = 22050;
NFFT = 16000 / 100;
set (ai, 'SampleRate', Fs);
set (ai, 'SamplesPerTrigger', duration*Fs);
Flag = 0;
numOfProcessedBlocks = 0;

% OPEN VIDEO INPUT:
if (useVideo==1)
    vid = videoinput('winvideo', 1);
    set(vid,'FramesPerTrigger',1);
    set(vid,'TriggerRepeat',Inf);
    triggerconfig(vid, 'Manual');
    start(vid);
end

scrsz = get(0, 'ScreenSize');
%figure('Position', [1 scrsz(4) scrsz(3) scrsz(4)]);
W = 25;
F = figure;
set(F,'Position', [W 0 scrsz(3)-W scrsz(4)-3*W]);

Differences = zeros(nBlocks,1);
DifferencesAudio = zeros(nBlocks,1);

bufStdZ = zeros(5,1);
bufMeanZ = zeros(5,1);
bufProc = zeros(5,1);

for (i=1:nBlocks)
    % trigger video:
    if (useVideo==1) trigger(vid); end
    
    % start recodring process:
    start(ai);

    C1 = clock;
    
    if (useVideo==1)
        IM = (getdata(vid,1,'uint8'));
        IMGray = rgb2gray(IM);
    end
    
    if (useVideo==1)
        if (i==1) IM_PREV = IMGray; end % previous video frame
    end            
        
        if (useVideo==1)        
            subplot(2,4,5);imshow(IM); title('Current Frame')

            IM_DIFF = abs(double(IMGray) - double(IM_PREV)); 
            subplot(2,4,6);imshow(IM_DIFF / 256); title('Motion');
            IM_DIFF_PLOT_VIDEO = zeros(100,2);
            Differences(i) = mean(mean(IM_DIFF));
            if (Differences(i)<100)
                IM_DIFF_PLOT_VIDEO(end-Differences(i):end,:) = 1;
            else
                IM_DIFF_PLOT_VIDEO(1:end,:) = 1;
            end
            subplot(2,4,8); imshow(IM_DIFF_PLOT_VIDEO,[]);  
            drawnow;
        end    
            
    % if at least one segment has been buffered:
    if ((i>1) && (Flag==1))        
        numOfProcessedBlocks = numOfProcessedBlocks + 1;        
        % re-sample (16KHz) the current segment:        
        tempX = imresize(x, [(16000/22050)*length(x) 1]);
        if (numOfProcessedBlocks==1)
            tempXPrev = tempX;
        end
                        
        time = (i-1)*duration+1/16000: 1/16000 :i*duration;        
        
        % plot current audio block:
        subplot(2,4,1);        
        Pl = plot(time, tempX); 
        axis([min(time) max(time) -1 1]);
        title('Current Audio Block');

        S  = log(abs(specgram(tempX,NFFT,16000,NFFT,0))); % current segment
        Sp = log(abs(specgram(tempXPrev,NFFT,16000,NFFT,0)));
        
        % plot current block's spectgram:
        subplot(2,4,3); specgram(tempX,NFFT,16000,NFFT,0); title('Spectogram');
                      
        SpecDiff = abs(S - Sp);
        DifferencesAudio(i-1) = 100 * mean(mean(SpecDiff)) / mean(mean(abs(S)));
        
        Z = zcr(tempX, 0.050*16000, 0.050*16000, 16000);
        meanZ = mean(Z);
        stdZ = std(Z);
        bufMeanZ(1:end-1) = bufMeanZ(2:end);        
        bufMeanZ(end) = meanZ;
        bufStdZ(1:end-1) = bufStdZ(2:end);
        bufStdZ(end) = stdZ;
        
        subplot(2,4,2); 
        timeZ = (i-5)*duration+duration: duration :i*duration;
        plot(timeZ,bufMeanZ);
        hold on;
        plot(timeZ,bufStdZ,'r');        
        legend('Mean of ZCR','Std of ZCR');
        axis([min(timeZ) max(timeZ) 0 0.50]);
        hold off;
        title('Mean and Std of the ZCR sequence')

        % find audio spectral difference
        IM_DIFF_PLOT_AUDIO = zeros(100,2);
        if (DifferencesAudio(i-1)<100)
            IM_DIFF_PLOT_AUDIO(end-DifferencesAudio(i-1):end,:) = 1;
        else
            IM_DIFF_PLOT_AUDIO(1:end,:) = 1;
        end
        subplot(2,4,4); imshow(IM_DIFF_PLOT_AUDIO,[]);
        drawnow;               
        tempXPrev = tempX;
    end
    
    C2 = clock;
    Etime = etime(C2,C1);
    bufProc(1:end-1) = bufProc(2:end);
    bufProc(end) = 100 * Etime / duration;
    timeP = (i-5)*duration+duration: duration :i*duration;    
    subplot(2,4,7); 
    plot(timeP, bufProc); 
    axis([min(timeP) max(timeP) 0 100]);
    title('Processing Performance');    
    
    if (useVideo==1)
        IM_PREV = IMGray; % keep previous frame
    end
                   
    if (strcmp(get(ai,'Running'),'On')==1)
        Flag = 1;
        x = getdata(ai, duration * Fs);         
        if (i>1) xPrev = x; else xPrev = zeros(duration*Fs,1); end        
    else
        Flag = 0;
        x = zeros(duration*Fs,1);
        xPrev = x;
        fprintf('%30s\n','Problem reading input!!!!!!');
        % X = [X zeros(1,22050)];
    end
            
    
end
if (useVideo==1)
    stop(vid);
end

% Step 5: Clean up
delete(ai);
clear ai

