function onoff = emgonoff(rawemg, fs, ws, sd)
% EMGONOFF - Find on/off times and indicies of raw EMG data.
% Calculate average(mean) value of resting EMG
% Define "on" EMG as the sample where average value of EMG in a given window
% range around the sample is a given # of std. dev. above avg. resting EMG.
%
% onoff = emgonoff(rawemg, fs, ws, sd)
%
% Use the mouse to select two ranges of "resting" EMG from a graph of the
% full-wave rectified EMG data.  Click four times: start and end of 1st
% resting range, and start and end of 2nd resting range.  Mouse clicks need
% to be consecutive and in order of increasing time (i.e. left-to-right on
% the graph).  The first range should precede the EMG burst associated with
% the muscle contraction under consideration.  The sedond range should be 
% the resting EMG data immediately following the EMG burst.
%
% rawemg = input file raw emg data (1-column vector)
% fs = sampling rate of raw EMG data in Hz
% ws = window size in milliseconds (50ms @ 2400Hz = 120 samples)
% sd = number of std. deviations above resting rms emg to trigger an "ON"
% Default values: 
%   ws = 50ms
%   sd = 1

% Algorythm for EMG onset & offset taken from 
% Hodges, P.W. and B.H. Bui, _A comparison of computer-based methods for 
% the determination of onset of muscle contraction using electromyography._ 
% Electroencephalography & Clinical Neurophysiology, 1996. 101(6): p. 511-9
%
% Created by: Kieran A. Coghlan, BSME, MSES
% SUNY at Buffalo, New York
% <kc_news@sonic.net>
% Last modified: 1 May, 2006

%% Check inputs for defaults
if nargin < 2, error('Not enough inputs. Type "help emgonoff" for help.'); end
if nargin < 3, ws = 50; end
if nargin < 4, sd = 1; end;
%% Full-Wave-Rectify the raw data
fwlo = abs(rawemg(:,1));
%% prepare for loop
% Get two ranges for resting emg (before & after burst) using ginput
R = input('\nUse the mouse to select FOUR points to define the begining and \nend of two data ranges that will be used to calculate average\nresting EMG values before and after the EMG burst (muscle contraction)\nPress [RETURN] to begin: ');
clear R;
f1 = figure;
plot(fwlo);
[x y] = ginput(4); %click four times: two for start/end of resting emg before burst two for resting emg after burst
x = round(x);
clear y;
%close(f1);clear f1; % Leave commented if you want to keep EMG graph up to 
%                    % do a visual QA of on/off results.
%% preallocate arrays
mvgav = zeros(x(4)-x(1),1);
onoff(1,1) = 0;
i=0;
restav = mean(fwlo(x(1):x(2))); %average value of rest EMG before ON
reststd = std(fwlo(x(1):x(2))); %std. dev. of rest EMG before ON
restav2 = mean(fwlo(x(3):x(4))); %average value of rest EMG after OFF
reststd2 = std(fwlo(x(3):x(4))); %std. dev. of rest EMG after OFF
%% window size (in samples) = ws*fs e.g. 50ms*2400Hz = 120 samples
sws2 = fs*(0.001*ws);
sws = 0.5*(sws2);
sws = round(sws);
%% find "ON" index:
% for xi, change from x(1) to x(2) if you want to ignore any "blips"
% within the resting range.
%xi = x(1);
xi = x(2);
xi = round(xi);
for n = 2:length(mvgav);
    mvgav(n,1) = mean(fwlo((xi-sws):(xi+sws)));
    if mvgav(n) > restav+sd*reststd;
        i = i+1;
        onoff(i,1) = xi;
        break
    end
    xi = xi+1;
end
%% find "OFF" index:
clear n xi i
mvgav2=zeros(x(4)-x(1),1);
i=0;
xi=onoff(1,1)+(1/2)*(x(3)-onoff(1,1)); %start OFF search approx. 1/2 way through ON burst.
%% OFF loop:
xi=round(xi);
for n=2:length(mvgav2);
    mvgav2(n,1)=mean(fwlo((xi-sws):(xi+sws)));
    if mvgav2(n)<restav2+sd*reststd2;
        i=i+1;
        onoff(i,2)=xi;
        break
    end
    xi=xi+1;
end