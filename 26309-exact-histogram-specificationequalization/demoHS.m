function demoHS
close all

im=imread('pout.tif');
im_0=histeq(im);
im_1=exact_histogram(im);

H=imhist(im);
H_0=imhist(im_0);
H_1=imhist(im_1);

% Original image
%--------------------------------------------------------------------------
figure('color',[1 1 1]) 
h_im=axes('units','normalized','position',[0.05 0.1 0.4 0.8]);
imshow(im)

h_h=axes('units','normalized','position',[0.55 0.1 0.4 0.8]);
bar(0:255,H,'b');
set(h_h,'xlim',[0 255],'FontSize',15,'FontWeight','bold')
set(get(h_h,'Title'),'String','Original Image','FontSize',20,'FontWeight','bold')

Ylim_ref=get(h_h,'ylim');

% Histogram equalization example and comparison
%==========================================================================

% Classical histogram equalization
%--------------------------------------------------------------------------
figure('color',[1 1 1]) 
h_im=axes('units','normalized','position',[0.05 0.1 0.4 0.8]);
imshow(im_0)

h_h=axes('units','normalized','position',[0.55 0.1 0.4 0.8]);
bar(0:255,H_0,'b');
set(h_h,'xlim',[0 255],'ylim',Ylim_ref,'FontSize',15,'FontWeight','bold')
set(get(h_h,'Title'),'String','Classical Histogram Equalization','FontSize',20,'FontWeight','bold')

% Exact histogram equalization
%--------------------------------------------------------------------------
figure('color',[1 1 1]) 
h_im=axes('units','normalized','position',[0.05 0.1 0.4 0.8]);
imshow(im_1)

h_h=axes('units','normalized','position',[0.55 0.1 0.4 0.8]);
bar(0:255,H_1,'r');
set(h_h,'xlim',[0 255],'ylim',Ylim_ref,'FontSize',15,'FontWeight','bold')
set(get(h_h,'Title'),'String','Exact Histogram Equalization','FontSize',20,'FontWeight','bold')
