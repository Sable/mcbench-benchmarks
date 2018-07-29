% suppress_noise.m

% Copyright 2003-2010 The MathWorks, Inc.

%tic
for i=1:nFrames
  %bw(:,:,i)=imerode(bw(:,:,i),ones(3,3));
  bw(:,:,i)=imopen(bw(:,:,i),ones(3,3));
end
%toc

%display detected ball in each frame
shg, set(gcf,'doublebuffer','on')
for i=1:nFrames
  imshow(bw(:,:,i),'notruesize')
  title(sprintf('Frame %d, t = %.2f sec',i,t(i)))
  drawnow %pause(1)
end
set(gcf,'doublebuffer','off')
