function gifplayer(gif_image,delay_length)
% The function displays any animated GIF's in a figure window
%
%% Demo : gifplayer; %plays the animated crystal.gif file
%
%% Usage:
% ex: gifplayer('animated.gif',0.1); %name of the gif file and the delay in
% which to update the frames in the GIF file
%
%% Vihang Patil, Oct 2006
% Copyright 2006-2007 Vihang Patil
% Email: vihang_patil@yahoo.com
% Created: 17th Oct 2006
%
%% Revision:
% Date: 19th Oct 2006..Removed the setappdata and getappdata and used
% functions handling property. Multiple Gif's can be called upon which can
% be opened in new figure window.
% ex: figure;gifplayer;
% ex: figure;gifplayer('abcd.gif',0.1); and so on
% 
%% P.N: PLease make sure to close the existing window in which the gif is
% currently being played and open a separate window for another GIF
% image.If another GIF is opened in the same window then the first timer
% continues to run even if you close the figure window.


if nargin<1
    gif_image = 'crystal.gif';
    delay_length = 0.2;%frame will be updated after 0.2 sec
elseif nargin <2
    delay_length = 0.2;%frame will be updated after 0.2 sec
end

[pathstr, name, ext, versn] = fileparts(gif_image); % file information retrieved here

if strcmp(ext,'.gif')
    [handles.im,handles.map] = imread(gif_image,'frames','all'); %read all frames of an gif image
    handles.len = size(handles.im,4); % number of frames in the gif image
    handles.h1 = imshow(handles.im(:,:,:,1),handles.map);%loads the first image along with its colormap
    handles.guifig = gcf;
    handles.count = 1;% intialise counter to update the next frame
    handles.tmr = timer('TimerFcn', {@TmrFcn,handles.guifig},'BusyMode','Queue',...
        'ExecutionMode','FixedRate','Period',delay_length); %form a Timer Object
    guidata(handles.guifig, handles);
    start(handles.tmr); %starts Timer
else
    error('Not a GIF image.Load only GIF images'); %If image is not GIF, show this error
end
set(gcf,'CloseRequestFcn',{@CloseFigure,handles});


function TmrFcn(src,event,handles)
%Timer Function to animate the GIF

handles = guidata(handles);
set(handles.h1,'CData',handles.im(:,:,:,handles.count)); %update the frame in the axis
handles.count = handles.count + 1; %increment to next frame
if handles.count > handles.len %if the last frame is achieved intialise to first frame
    handles.count = 1;
end
guidata(handles.guifig, handles);



function CloseFigure(src,event,handles)
% Function CloseFigure(varargin)
stop(handles.tmr);delete(handles.tmr);%removes the timer from memory
closereq;


