% imshow_frap - function to display images in 0 to 255 grayscales
%   imshow_frap(I,I_lim,ax_p) where:
%
%   I = the image (as a 2D matrix)
%   I_lim = a vector where I_lim(1) is the min intensity and I_lim(2) the
%       max intensity in the image
%   ax_p = figure axes

function imshow_frap(I,I_lim,ax_p)

x=(1:1:size(I,2));
y=(1:1:size(I,1));

I2=(I-I_lim(1))/(I_lim(2)-I_lim(1));

colormap(hsv(256));
map=colormap('gray');

image(x,y,I2,'CDataMapping','scaled')
set(ax_p,'CLim',[0,1])
axis(ax_p,'tight')
axis(ax_p,'off')
box(ax_p,'off')
