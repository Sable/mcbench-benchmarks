% select_region.m

% Copyright 2003-2010 The MathWorks, Inc.

f = squeeze(uint8(mean(f,3)));  %RGB color to grayscale conversion
avg = mean(f,3);                %composite leaves traces of moving objects
bg = median(double(f),3);       %ensemble median average minimizes motion

%difference image highlights circular path of motion
arcPath = imabsdiff(avg,bg);
figure, imshow(arcPath,[])
title('Click-drag-release to select region of interest')

% %user select region
% h=msgbox('Select region of interest.','ROI');
% set(h,'WindowStyle','Modal')
% waitfor(h)
  
done=false;
while ~done
  [subIm,roi]=imcrop;
  %wait for user to select region of interest (click-drag rubberband box)

  %determine corners of selected region
  x1=roi(1);  x2=roi(1)+roi(3);  xx=[x1 x1 x2 x2 x1];
  y1=roi(2);  y2=roi(2)+roi(4);  yy=[y1 y2 y2 y1 y1];
  %draw rectangle to indicate selected region
  hLine=line(xx,yy);
  title('Click inside to keep, outside to select again')
  pt=ginput(1);
  %wait for user to keep or discard selected region

  % check: is point inside region?
  if pt(1)>=roi(1) & pt(1)<=roi(1)+roi(3) & pt(2)>=roi(2) & pt(2)<=roi(2)+roi(4)
    done=true;  %exit loop
  else
    delete(hLine)   %remove previous selection
    title('Click-drag-release to select region of interest')
    %loop around to select another region
  end
end

% %display cropped region
% imshow(subIm,'notruesize')
% title('Selected region of interest')

% %convert RGB color frames to grayscale
% f = squeeze(mean(f,3));

%crop all frames; display cropped footage
f2 = zeros([size(subIm,1) size(subIm,2) nFrames]);  %allocate for cropped footage
shg, set(gcf,'doublebuffer','on')
for i=1:nFrames
  f2(:,:,i)=imcrop(f(:,:,i),roi);
  imshow(uint8(f2(:,:,i)))
  title(sprintf('Frame %d, t = %.2f sec',i,t(i)))
  drawnow, pause(0.1)
end
set(gcf,'doublebuffer','off')

f=f2; clear f2
