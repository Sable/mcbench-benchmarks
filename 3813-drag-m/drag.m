function drag(varargin)
%DRAG   Move around on a 2-D or 3-D plot.
%   DRAG with no arguments toggles the plot dragging state.
%   DRAG ON turns plot dragging on for the current figure.
%   DRAG XON, YON, or ZON turns plot dragging on for the x, y, or z axis only.
%   DRAG OFF turns plot dragging off in the current figure.
%   DRAG RESET resets the restore point to the current axis settings.
%
%   When plot dragging is on, you can click and drag the axes around while
%   maintaining the current level of zoom.  If DRAG RESET has not been
%   called the restore point is the original non-explored plot.  If DRAG
%   RESET has been called the restore point is the retore point that existed
%   when it was called.  Double clicking retores the axes to the current
%   restore point - the point at which plot dragging was first turned on for
%   this figure (or to the state to which the restore point was set by DRAG
%   RESET).
%   
%   In a figure with multiple subplots, pressing and holding the left mouse
%   button drags around the currently active subplot, while pressing and
%   holding the right mouse button drags around all subplots simultaneously.
%   Double clicking with the left mouse button restores the currently active
%   plot to its restore point, while double clicking with the right mouse
%   button restores all subplots to their defined restore point.
%   
%   DRAG(FIG,OPTION) applies the drag command to the figure specified by
%   FIG. OPTION can be any of the above arguments.
%
%   Example:
%   x = 0:0.1:5; y = exp(x);
%   figure; subplot(211); plot(x,y,'r.'); subplot(212); plot(y,x,'g.');
%   drag xon;
%
%   Ryan M. Eustice 08-15-2003
%   Woods Hole Oceanographic Institution, MS 7
%   Woods Hole, MA 02543
%   508.289.3269   ryan@whoi.edu

% History
% DATE          WHO                      WHAT
%----------    ------------------        ------------------------------
%2003-07-23    Ryan Eustice              Created & written.
%2003-08-15    Boyko Stoimenov           Modified the private function
%                                        dragreset to correctly count the
%                                        number of axes.  Also, switched
%                                        short-circuit && to & for matlab
%                                        backwards compatability.
%2004-01-29    Ryan Eustice              Fixed bug in private function
%                                        dragreset to properly count
%                                        number of axes and not count
%                                        legend or colorbar objects.

%   Note: drag uses the figure buttondown and buttonmotion functions

%
% PARSE ARGS - set fig and drag command
%
fignum = get(0,'CurrentFigure');
if isempty(fignum)
  return; % no figure
end

switch nargin
case 0 % no arg in
 switch get(fignum,'Tag')
 case 'dragon'  % toggle state
  dragoff(fignum);
 otherwise  % turn on
  figstate.motion = 'all';
  set(fignum,'UserData',figstate);
  dragon(fignum);
 end % switch get(fignum,'Tag')
case 1 % one arg in
 switch lower(varargin{1})
 case 'on'
  figstate.motion = 'all';
  set(fignum,'UserData',figstate);  
  dragon(fignum);
 case 'off'
  dragoff(fignum);
 case 'reset'
  dragreset(fignum);
 case 'xon'
  figstate.motion = 'xon';
  set(fignum,'UserData',figstate);  
  dragon(fignum);
 case 'yon'
  figstate.motion = 'yon';
  set(fignum,'UserData',figstate);  
  dragon(fignum);
 case 'zon'
  figstate.motion = 'zon';
  set(fignum,'UserData',figstate); 
  dragon(fignum);
 otherwise
  error(sprintf('Unrecognized argument ''%s''',varargin{1}));
 end % switch varargin{1}
case 2 % two args in
 fignum = varargin{1};
 switch lower(varargin{2})
 case 'on'
  figstate.motion = 'all';
  set(fignum,'UserData',figstate); 
  dragon(fignum);
 case 'off'
  dragoff(fignum);
 case 'reset'
  dragreset(fignum);
 case 'xon'
  figstate.motion = 'xon';
  set(fignum,'UserData',figstate);  
  dragon(fignum);
 case 'yon'
  figstate.motion = 'yon';
  set(fignum,'UserData',figstate);     
  dragon(fignum);
 case 'zon'
  figstate.motion = 'zon';
  set(fignum,'UserData',figstate);   
  dragon(fignum);
 otherwise
  error(sprintf('Unrecognized argument ''%s''',varargin{1}));
 end % switch varargin{2} 
otherwise % too many args
 error(nargchk(0,2,nargin));
end % switch nargin
  
%====================================================================
% drag: private
%====================================================================
function dragon(fignum)
figstate = get(fignum,'UserData');
dragreset(fignum);
set(fignum,'Interruptible','on');
set(fignum,'DoubleBuffer','on');
set(fignum,'Tag','dragon');
set(fignum,'WindowButtonDownFcn',@startexploring);
set(fignum,'WindowButtonUpFcn',@stopexploring);


function dragoff(fignum)
set(fignum,'DoubleBuffer','off');
set(fignum,'Tag','');
set(fignum,'WindowButtonDownFcn','');
set(fignum,'WindowButtonUpFcn','');  


function dragreset(fignum)
figstate = get(fignum,'UserData');
kids = get(fignum,'Children');
cc = 1;
for ii=1:length(kids)
  % check for regular axes handles by keying off the Tag field which should be
  % empty.  note that objects like legend and colorbar fill in the Tag field.
  if strcmp(get(kids(ii),'Type'),'axes') & strcmp(get(kids(ii),'Tag'),'')
    figstate.axishandle(cc) = kids(ii);
    figstate.origlimits(cc,:) = axis(kids(ii));
    cc = cc+1;
  end
end
figstate.numaxes = length(figstate.axishandle);
set(fignum,'UserData',figstate);

%====================================================================
% callbacks
%====================================================================
function startexploring(obj,eventdata)
fignum = gcbf;
figstate = get(fignum,'UserData');
switch get(fignum,'SelectionType')
case 'normal' %mouse left single-click
 figstate.whichaxes = 'current'; % only drag current axis
 axishandle = gca;
 initaxis(axishandle);
case 'open'   %mouse left or right double-click
 axishandle = gca;
 for ii=1:figstate.numaxes
   if strcmp(figstate.whichaxes,'current') & figstate.axishandle(ii) == axishandle
     % restore currently active axis limits to orig state
     axis(axishandle,figstate.origlimits(ii,:));
     break;
   elseif strcmp(figstate.whichaxes,'all')
     % restore other subplot axis limits to orig state
     axis(figstate.axishandle(ii),figstate.origlimits(ii,:));
   end
 end
case 'alt'    %mouse right single-click
 figstate.whichaxes = 'all'; % drag all axes simultaneously
 for ii=1:figstate.numaxes
   axishandle = figstate.axishandle(ii);
   initaxis(axishandle);
 end
otherwise  
  error('Mouse SelectionType unknown');
end
set(fignum,'WindowButtonMotionFcn',@setnewview);
set(fignum,'Pointer','Fleur');
set(fignum,'UserData',figstate); % store figure state


function setnewview(obj,eventdata)
persistent cc;
fignum = gcbf;
figstate = get(fignum,'UserData');
switch figstate.whichaxes
case 'current'
 axishandle = gca;
 updateaxes(axishandle,figstate.motion);
case 'all'
 for ii=1:figstate.numaxes
   axishandle = figstate.axishandle(ii);
   updateaxes(axishandle,figstate.motion);
 end
otherwise
 %do nothing
end % switch figstate.whichaxes
cc = cc+1;
if mod(cc,2)
  drawnow; % force screen update every other motion cycle (lowers cpu usage)
end


function stopexploring(obj,eventdata)
fignum = gcbf;
set(fignum,'WindowButtonMotionFcn','');
set(fignum,'Pointer','arrow');

%====================================================================
% callbacks: private
%====================================================================
function pos = getcurrentposition(axishandle)
pos = get(axishandle,'CurrentPoint');
pos = mean(pos);
pos = round(pos*1000)/1000;


function initaxis(axishandle)
state.currentaxislimits = axis(axishandle);
state.startpoint = getcurrentposition(axishandle);
set(axishandle,'UserData',state); % store axis state  


function updateaxes(axishandle,motion)
state = get(axishandle,'UserData');
state.endpoint = getcurrentposition(axishandle);
motionvector = state.startpoint - state.endpoint;
  
if length(state.currentaxislimits) == 4 % 2D plot
  switch motion
  case 'all'
   state.currentaxislimits = ...
       [state.currentaxislimits(1:2) + motionvector(1), ...
	state.currentaxislimits(3:4) + motionvector(2)];
  case 'xon'
   state.currentaxislimits = ...
       [state.currentaxislimits(1:2) + motionvector(1), ...
	state.currentaxislimits(3:4)];
  case 'yon'
   state.currentaxislimits = ...
       [state.currentaxislimits(1:2), ...
	state.currentaxislimits(3:4) + motionvector(2)];
  otherwise %do nothing
  end % switch motion  
elseif length(state.currentaxislimits) == 6 % 3D plot
  switch motion
  case 'all'
   state.currentaxislimits = ...
       [state.currentaxislimits(1:2) + motionvector(1), ...
	state.currentaxislimits(3:4) + motionvector(2), ...
	state.currentaxislimits(5:6) + motionvector(3)];
  case 'xon'
   state.currentaxislimits = ...
       [state.currentaxislimits(1:2) + motionvector(1), ...
	state.currentaxislimits(3:4), ...
	state.currentaxislimits(5:6)];    
  case 'yon'
   state.currentaxislimits = ...
       [state.currentaxislimits(1:2), ...
	state.currentaxislimits(3:4) + motionvector(2), ...
	state.currentaxislimits(5:6)];    
  case 'zon'
   state.currentaxislimits = ...
       [state.currentaxislimits(1:2), ...
	state.currentaxislimits(3:4), ...
	state.currentaxislimits(5:6) + motionvector(3)];    
  otherwise %do nothing
  end % switch motion
end
axis(axishandle,state.currentaxislimits);
set(axishandle,'UserData',state);
