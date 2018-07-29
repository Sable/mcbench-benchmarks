% load_captured_data.m

% Copyright 2003-2010 The MathWorks, Inc.

[fileName,pathName]=uigetfile('captured*.mat','Select file');
if length(fileName)>0
  load([pathName fileName])
else
  error('User aborted program')
end
if exist('fps','var')
  if exist('t_stats','var')
    disp(sprintf('fps=%.3g, Cv=%.2g%%',fps,100*t_stats(2)/t_stats(1)))
  else
    disp(sprintf('fps=%.3g',fps))
  end
end

%play back video frames
shg, set(gcf,'doublebuffer','on'), tic
for i=1:nFrames
  while toc<t(i)-t(1), pause(0.001), end
  imshow(uint8(f(:,:,:,i)))
  title(sprintf('Frame %d, t = %.2f sec',i,t(i)))
  drawnow
end
set(gcf,'doublebuffer','off')
