%% Mean-Shift Video Tracking
% by Sylvain Bernhardt
% July 2008
%% Description
% It permit to select a patch T from
% an image I.
% The outputs are the patch T, its upper left
% corner location x0,y0 and size H,W.
% If 'graph' is set to 1, it also displays
% the selected patch in a new figure.
%
% [T,x0,y0,H,W]=Select_patch(I,graph)

function [T,x0,y0,H,W]=Select_patch(I,graph)
height = size(I,1);
width = size(I,2);
% Put the figure in the center of the screen,
% without menu bar and axes.
scrsz = get(0,'ScreenSize');
figure (2)
set(2,'Name','Target Selection','Position',...
    [scrsz(3)/2-width/2 scrsz(4)/2-height/2 width height],...
    'MenuBar','none');
axis off
% Image position inside the figure
set(gca,'Units','pixels','Position',[1 1 width height])

% Display the image
imshow(I);
rect = getrect;
rect = floor(rect);
x0 = rect(1);
y0 = rect(2);
W = rect(3);
H = rect(4);
T = I(y0:y0+H-1,x0:x0+W-1,:);
if graph==1
    figure (3)
    set(3,'Name','Target Selected')
    imshow(T);
end
close (2)