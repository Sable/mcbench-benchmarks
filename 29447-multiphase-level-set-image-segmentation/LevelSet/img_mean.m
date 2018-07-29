function img_mean(M)
M=transposer(M);
axes('position',[.6 .4 .3 .4]);
imshow(uint8(M));
title('the segmentation');
