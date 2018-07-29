% setup_live_capture.m

% Copyright 2003-2010 The MathWorks, Inc.

vidFormat='RGB24_320x240';
devInfo=FindImaqDevices(vidFormat);

if length(devInfo)>1
  names={devInfo(:).name};
  index=listdlg('ListString',names,'Name','Select Video Device','SelectionMode','single');
else
  index=1;
end

if index>0
  disp(sprintf('Using %s camera',devInfo(index).name))
else
  error('User aborted program.')
end

%create video input object
%v=videoinput('winvideo',1,'RGB24_352x288');  %only for USB web cams
%v=videoinput('winvideo',1,'RGB24_320x240');  %for 1394 devices too
v=eval(devInfo(index).constructor);

%frame rate test
nFrames=15;
set(v,'FramesPerTrigger',nFrames)
start(v), wait(v)   %wait 'til done
[f,t]=getdata(v);
fps=1/median(diff(t));
cv=relvar(diff(t));
if cv>2
  warning(sprintf('Excessive time variation +/- %.3g%%, Substituting linear indices.',cv))
  t=[0:nFrames-1]'/fps;
end
disp(sprintf('15-frame capture test => %.3g fps',fps))

%configure desired frame rate
src = getselectedsource(v);
params = get(src);
if isfield(params,'FrameRate')
  set(src,'FrameRate','30')
end

%configure desired number frames
nFrames=50;
set(v,'FramesPerTrigger',nFrames)

%configure sample rate
nSkip=0;
set(v,'FrameGrabInterval',nSkip+1)

%preview scene (close during capture for max fps)
tic, preview(v), toc

%let user get appartus ready to grab frames
h=msgbox('Make sure experiment ready to acquire video.','Setup');
set(h,'WindowStyle','Modal')
waitfor(h)

%capture video sequence
preview(v)      %give preview window focus again
pause(2)        %let camera stabilize auto gain first
start(v)        %start acquiring
wait(v)         %wait 'til done

%xfer data from IMAQ engine to MATLAB
tic
[f,t]=getdata(v);
% myTimes=[toc diff(limits(t))]
t=[0:nFrames-1]'*median(diff(t));

%remove video object
delete(v), clear v

% %check frame rate & uniformity
% fps=(nFrames-1)/diff(limits(t))
% [mean(diff(t)) std(diff(t))]

%   %examine time stamps for consistency
%   subplot(211), plot(t), subplot(212), plot(diff(t))
%   set(gca,'ytick',1/str2num(get(src,'FrameRate'))*(0:6))
%   ylim([0 0.2])

%preserve captured video data

[fileName,pathName]=uiputfile('captured*.mat','Create file');
if fileName==0
  warning('Captured data not saved to file.')
else
  save([pathName fileName])
end
