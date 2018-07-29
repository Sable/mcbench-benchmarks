function varargout = daqstopbutton(fig,obj,varargin);
%DAQSTOPBUTTON        Add a stop/start button to a data acquisition application
%
% DAQSTOPBUTTON(FIG,OBJ) adds a start/stop button to figure FIG.  This
% button can be used to start and stop data acquisition object OBJ.
% DAQSTOPBBUTTON will also delete OBJ when FIG is closed (i.e., it sets
% FIG's CloseRequestFcn to delete the object)
%
% DAQSTOPBUTTON(FIG,OBJ,'P1','V1','P2','V2', ...) specifies Property-Value
% pairs for configuring properties of the start/stop button.  Any valid
% property of a togglebutton can be specified.
%
% HBUTTON = DAQSTOPBUTTON(...) returns a handle to the start/stop button
%
% Note: This button does not "listen" to determine if your object changes
%   state.  For instance, if you have a finite number of samples
%   acquired after starting, the button will not reset automatically
%   when your object stops running.  Don't despair, since it is easy
%   enough to do on your own!
%
% Example:
%      fh = figure;                         % Create a figure
%      ai = analoginput('winsound');        % Create an input object
%      addchannel(ai,1);                    % Add a channel
%      set(ai,'TriggerRepeat',inf);         % Configure to run infinitely
%      set(ai,'TimerFcn','plot(peekdata(ai,500))'); % Each timer event will plot recent data
%      hButton = daqstopbutton(fh,ai);      % Add the stopbutton

%   Scott Hirsch 
%   shirsch@mathworks.com
%   Copyright 2003 The MathWorks, Inc

%Error checking
msg = nargchk(2,inf,nargin);
error(msg)

if ~all(isvalid(obj))
    error('Second input argument must be valid daq object')
end;

% Create the button
hButton = uicontrol(fig,'style','togglebutton',varargin{:});

%Check current state of the object
val = strcmp(obj.Running,'On');

if val==1       %Already running
    set(hButton,'String','Stop');
    set(hButton,'Value',1)
else
    set(hButton,'String','Start');
    set(hButton,'Value',0)
end;

set(hButton,'Callback',{@localStartStopObject,obj})

% Configure the CloseRequestFcn of the figure
setappdata(fig,'DaqStopButtonObject',obj)
cr = get(fig,'CloseRequestFcn');
cr = ['obj=getappdata(gcf,''DaqStopButtonObject'');stop(obj);delete(obj);' cr];
set(fig,'CloseRequestFcn',cr);

% Return a handle to the button
if nargout
    varargout{1} = hButton;
end;


function localStartStopObject(hButton,action,obj)
% Callback for the start/stop button
val = get(hButton,'Value');
if val==1       %Pushed in
    set(hButton,'String','Stop');
    if all(isvalid(obj))
        start(obj)
    end;
else
    set(hButton,'String','Start');
    if all(isvalid(obj))
        stop(obj)
    end;
end;

