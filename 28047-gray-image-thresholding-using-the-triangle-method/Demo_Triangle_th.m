%Demo triangle_th.m performing gray image thresholding 
using the Triangle Method.
%The demo reads a RGB image of vegetation against soil background.
%This image is converted to a gray level image

%% Read image RGB image and convert to gray level
%Reads RGB
Ib=imread('coins.png');
%%
[lehisto x]=imhist(Ib);
[level]=triangle_th(lehisto,256);
I_bw=im2bw(Ib,level);

%%
%Show results
%Input image
subplot(2,3,1); imshow(Ib); axis off;  title('Input image');
%Binary image
subplot(2,3,2); imshow(I_bw); axis off; title('Triangle method');
%graythresh for comparison
subplot(2,3,3); imshow(im2bw(Ib,graythresh(Ib))); axis off; title('graythresh - Image Toolbox');
%Histogram
subplot(2,3,[4:6]); bar(x,lehisto); xlim([0 255]);
line([73 255],[4264 0],'Color','r','LineWidth',2);
line([79 79],[0 max(ylim)],'Color','b','LineWidth',2);
hold on;
plot(10,50,':w');  %Dummy point to make a 2 line entry in legend
line([126 126],[0 max(ylim)],'Color','g','LineWidth',2);
hl=legend('Data','Base line used in Triangle Method','Threshold by Triangle Method','(see triangle_th.m for details)','Threshnold by graythresh.m');
set(hl,'Interpreter','none');
