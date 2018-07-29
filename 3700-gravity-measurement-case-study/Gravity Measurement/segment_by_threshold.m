% segment_by_threshold.m

% Copyright 2003-2010 The MathWorks, Inc.

%detect ball in each frame (statistical threshold)
%tic
mu=mean(f(:));                              %global mean
sig=std(f(:));                              %global deviation
bw=abs(f-mu)>3*sig;                         %threshold segmentation
%toc

%display detected ball in each frame
shg, set(gcf,'doublebuffer','on')
for i=1:nFrames
  imshow(bw(:,:,i),'notruesize')
  title(sprintf('Frame %d, t = %.2f sec',i,t(i)))
  drawnow, %pause(0.1)
  if i<10, pause, end
end
set(gcf,'doublebuffer','off')
