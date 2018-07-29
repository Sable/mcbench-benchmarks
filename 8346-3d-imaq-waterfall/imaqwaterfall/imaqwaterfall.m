function varargout = imaqwaterfall(varargin)
% IMAQWATERFALL MATLAB code for imaqwaterfall.fig
%      IMAQWATERFALL, by itself, creates a new IMAQWATERFALL or raises the existing
%      singleton*.
%
%      H = IMAQWATERFALL returns the handle to a new IMAQWATERFALL or the handle to
%      the existing singleton*.
%
%      IMAQWATERFALL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAQWATERFALL.M with the given input arguments.
%
%      IMAQWATERFALL('Property','Value',...) creates a new IMAQWATERFALL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imaqwaterfall_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imaqwaterfall_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Copyright 2007 - 2010 The MathWorks, Inc. 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imaqwaterfall_OpeningFcn, ...
                   'gui_OutputFcn',  @imaqwaterfall_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end




% --- Executes just before imaqwaterfall is made visible.
function imaqwaterfall_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for imaqwaterfall
handles.output = hObject;


% Initialise the video input
try
    % reset and start up video capture
    imaqreset
    if size(varargin) == [1 1]        
        vid = videoinput(varargin{1});
    else
        vid = videoinput('winvideo');
    end
    vid.FramesPerTrigger = 1;
    vid.TriggerRepeat = Inf;
    vid.FrameGrabInterval = 1;

    %set up an images to put pictures in
    vidRes = get(vid, 'VideoResolution');
    nBands = get(vid, 'NumberOfBands');
    hIm1 = image( zeros(vidRes(2), vidRes(1), nBands),'parent',handles.axes1);

    % store reference to video object for use later in cleanup
    handles.vid = vid;
    
    % get handles of some important objects (to avoid referencing handles)
    ax1 = handles.axes1;
    ax2 = handles.axes2;
    ax3 = handles.axes3;

    % provide some information to the user
    a = vid.Name;
    str = ['Video Input Device: ' a];
    set(handles.txt_device1,'string',str);
    
    % Use the timer to process input frames
    vid.TimerPeriod = 1/15; % try updating 15 times/second.
    vid.TimerFcn = {@imaqcallback};

    % Alternative is to use the FramesAcquiredFcn if we need to ensure
    % that we process every frame.
    %vid.FramesAcquiredFcnCount=1;
    %vid.FramesAcquiredFcn = {@imaqcallback};

    start(vid);
        
catch
    disp 'no video input'
    handles.vid=0;
    guidata(hObject, handles);
end

% Update handles structure
guidata(hObject, handles);


    % --- Nested Callback for having acquired an image
    function imaqcallback(vid,event)

    % variables determining size of histogram
    n = 100;    %number of points
    m = 40;     %number of time steps to keep

    % get a persistent variable to keep the plot history in
    persistent tracer
    if ~exist('tracer')
        tracer=zeros(n,m);
    end
    if size(tracer) ~= [n m]
        tracer=zeros(n,m);
    end

    % access the video object in a try construct, in case the callback
    % gets fired after the object is deleted on cleanup
    try
        % get the latest frame and clear the buffer
        I = getdata(vid,1);
        flushdata(vid)

        % process the data to give histograms
        I_gr = rgb2gray(I);
        [counts,x] = imhist(I_gr,n);
        
        % plot the video image
        set(hIm1,'CData',I)
        set(ax1,'xticklabel',[])
        set(ax1,'yticklabel',[])
        
        % keep history of histograms in 'tracer'
        tracer(:,2:m)=tracer(:,1:m-1);
        tracer(:,1)=counts;

        % plot the 2d histogram of the current frame
        plot(ax2,x,counts);
        xlabel(ax2,'Pixel Brightness')
        ylabel(ax2,'Pixel Count')

        % find out the type of 3d plot we want...
        val = get(handles.lst_plotmode,'value');

        % if we want a cyclic plot, choose the particular one we want
        if val==1
            c = clock;
            val = floor(c(6)/12+2);
        end

        % make the appropriate 3d plot
        switch val
            case 2 %surf plot
                surf(ax3,tracer)
                set(ax3,'view',[-37.5 60],'ydir','reverse')
                shading(ax3,'interp');

            case 3 %mesh plot
                mesh(ax3,tracer)
                set(ax3,'view',[-37.5 60],'ydir','reverse')

            case 4 %mosaic plot
                surf(ax3,[1:m],[1:n],tracer)
                set(ax3,'view',[0 90])
                axis(ax3,'tight')

            case 5 %sliding plot
                surf(ax3,[1:m],[1:n],tracer)
                set(ax3,'view',[0 90])
                axis(ax3,'tight')
                shading(ax3,'interp');

            case 6 %rotating surf plot
                surf(ax3,tracer)
                c = clock;
                phi = c(6)*24;
                shading(ax3,'interp');
                set(ax3,'view',[phi 70],'ydir','reverse')
        end
        xlabel(ax3,'Time (frames)')
        ylabel(ax3,'Pixel Brightness')
        zlabel(ax3,'Pixel Count')
        
    end %try
    end %function imaqcallback
end %function imaqwaterfall_OpeningFcn



% --- Outputs from this function are returned to the command line.
function varargout = imaqwaterfall_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

% delete objects
if handles.vid~=0
    vid = handles.vid;
    stop(vid)
    delete(vid)
    clear vid
end

% Finally, close the figure
delete(hObject);

end


% --- Executes during object creation, after setting all properties.
function lst_plotmode_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

