function createAnimatedGifFromWav(wavFileName, windowLength, Width, framesPerSec)

%
% function createAnimatedGifFromWav(wavFileName, windowLength, Width, framesPerSec)
%
% This function read a .wav audio file and creates an animated gif: in each
% frame of the gif file, a seperate audio window is presented, along with
% the corresponding spectrogram.
%
% ARGUMENTS:
% wavFileName: the name of the .wav file to read
% windowLength: the length (in seconds) of each window to be plotted in the gif
% Width: the width of the generated .gif file
% framesPerSec: frames per second for the gif animated file.
%
% NOTE: the generated .gif file's name is [wavFileName_animatedGIF.gif]
%
% EXAMPLE:
% The following line will read b.wav, will spitt the file into windows of 2
% seconds (non-overlapping) and will create a gif file (of 450 pixels
% width) and 10 frames per seconds:
%
% >> createAnimatedGifFromWav('b.wav',2,450,10);
% 
%
%  ----------------------------------
% | Theodoros Giannakopoulos         |
% | http://www.di.uoa.gr/~tyiannak   |
%  ----------------------------------
%

% frame time interval:
framesT = 1/framesPerSec;

% initial index of audio data:
I = 1;

% read audio data:
[x,fs] = wavread(wavFileName);
% convert window value from time to samples:
win = windowLength * fs;

% initialize figure:
h = figure;
Loop = {'LoopCount',Inf};
count = 0;

% total number of audio windows (and corresponding frames in gif file):
total = floor((length(x)-win) / (win));

% gif file name:
fn = [wavFileName '_animatedGIF.gif'];

% main loop:
while (I+win<length(x)) % while reading audio data:
    count = count + 1;
    fprintf('Saving Image %d of %d\n',count, total);
    % get current audio data:
    tempX = x(I:I+win);
    
    % plot audio data:
    subplot(2,1,1);
    time = (0:1/fs:(length(tempX)-1)/fs) + I/fs;
    plot(time, tempX);
    axis([time(1) time(end) -1 1]);

    % plot respective spectrogram:
    subplot(2,1,2);
    SPECTROGRAM(tempX, 0.050*fs, 0, 0.050*fs, fs);
    ylabel('');
    xlabel('');

    % update window position:
    I = I + win;
    
    % save current figure in temporary jpeg file...
    saveas(h,'imageTemp', 'jpg');
    
    % ... and get image data:
    RGB = imread('imageTemp.jpg');    

    % resize image (according to Width argument):
    R = RGB(:,:,1); G = RGB(:,:,2); B = RGB(:,:,3);
    R = imresize(R, [Width NaN]); G = imresize(G, [Width NaN]); B = imresize(B, [Width NaN]);
    clear RGB; RGB(:,:,1) = R; RGB(:,:,2) = G; RGB(:,:,3) = B;

    % convert to indexed image (256 colors used):
    [ind,map]=rgb2ind(RGB,256);
	
    % write gif file
    if count==1 % if this is the first frame-->overwrite file
		imwrite(ind,map,fn,'gif' ...
			, 'DelayTime', framesT ...
			, 'WriteMode','overwrite' ...
			, Loop{:} ...
			);
    else % ... else append image to existing file
		imwrite(ind,map,fn,'gif' ...
			, 'DelayTime', framesT ...
			, 'WriteMode','append' ...
			);
    end    
end




