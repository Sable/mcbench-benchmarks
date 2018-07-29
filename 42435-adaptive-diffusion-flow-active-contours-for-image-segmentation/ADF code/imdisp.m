function imdisp(I)
% balance the gray level range to display the image 
x = (0:255)./255;
grey = [x;x;x]';
minI = min(min(I));
maxI = max(max(I));
I = (I-minI)/(maxI-minI)*255;
image(I);
axis('square','off');
colormap(grey);

