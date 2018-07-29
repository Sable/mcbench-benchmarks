% Simple script to read a video file and track a single red marker
% in 2D using the hue and saturation values. The largest red blob is 
% detected and the mean co-ordinate position of this blob is tracked. This
% code does not have any tracking built-in: it treats each frame
% idependently.
%
% This assumes that the video is a constant frame rate video. The resulting 
% co-ordinate time series are stored in the variables: t, Xc and Yc.

fname = 'Capture 1 (5-10-2011 3-29 PM).wmv';
% Download from http://www.youtube.com/watch?v=Thnv0IQqXFE
% for a sample video on which this program was tested.

hmfr = video.MultimediaFileReader(fname);
hp  = video.VideoPlayer;
hpI = video.VideoPlayer;

hcsc = video.ColorSpaceConverter;
hcsc.Conversion = 'RGB to HSV';

fi = 0;
fps = 30;
refColor = [0.8 0.8];
cD = 0.05;
start_t = 0;
Xc = [];
Yc = [];
t  = [];
while ~isDone(hmfr)
    fi = fi + 1;
    tf = fi/fps;
    videoFrame = step(hmfr);
    if tf < start_t
        continue;
    end
    vI =  step(hcsc, videoFrame);
    [xc, yc, vI] = FrameByColorDistance(vI, refColor, cD);
    Xc = [Xc; xc]; %#ok<AGROW>
    Yc = [Yc; yc]; %#ok<AGROW>
    t  = [t; tf];  %#ok<AGROW>
    DisplayFrame(hp, videoFrame, fi, fps);
    DisplayFrame(hpI, floor(vI*255), fi, fps);
end
release(hp);
release(hmfr);