
function exampleFilter
% function exampleFilter
%
% Example of how the Kalman filter performs for real data

load raw


%Apply filter
k=Kalman_Stack_Filter(raw);
k75=Kalman_Stack_Filter(raw,0.75);


%Set up image window
minMax=[min(raw(:)),max(raw(:))];
clf, colormap gray

subplot(1,3,1)
imagesc(raw(:,:,1))
title('original')
set(gca,'clim',minMax), axis off equal

subplot(1,3,2)
imagesc(k(:,:,1))
title('filtered, gain=0.5')
set(gca,'clim',minMax), axis off equal

subplot(1,3,3)
imagesc(k75(:,:,1))
title('filtered, gain=0.75')
set(gca,'clim',minMax), axis off equal


%Loop movie 
disp('crtl-c to stop movie')
while 1
    for i=1:size(k,3)
        
        subplot(1,3,1)
        set(get(gca,'children'),'CData',raw(:,:,i))
        
        subplot(1,3,2)
        set(get(gca,'children'),'CData',k(:,:,i))
        
        subplot(1,3,3)
        set(get(gca,'children'),'CData',k75(:,:,i))
        
        
        pause(0.05)
        drawnow
    end
end
