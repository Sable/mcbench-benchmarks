% remove_background.m

% Copyright 2003-2010 The MathWorks, Inc.

bg = median(double(f),3);       %ensemble median average minimizes motion
for i=1:nFrames
  f(:,:,i) = f(:,:,i) - bg;     %subtract background
end

%display background-subtracted frames
h=imshow(f(:,:,1),[]); colormap gray, caxis(limits(f)), axis image
shg, set(gcf,'doublebuffer','on')
for i=1:nFrames
  set(h,'cdata',f(:,:,i))
  title(sprintf('Frame %d, t = %.2f sec',i,t(i)))
  pause(0.1)
end
set(gcf,'doublebuffer','off')
