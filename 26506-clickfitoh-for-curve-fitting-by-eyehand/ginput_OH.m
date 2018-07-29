function [out1,out2,out3] = ginput_OH(arg1,strpointertype,xx,yy)

% function [X,Y,BUTTON] = ginput_OH(N,pointertype,xx,yy)
%
% ginput_OH.m has the same functionality as Matlab's ginput.m with
% two additional features: 
% 1. From the first click onward the pointer is connected to the previous
%    mouse click by a line. 
% 2. Selectable cursor pointer (copied from MYGINPUT by F. Moisy)
%
% INPUT:
% N = number of points
% pointertype: 'fullcrosshair','crosshair','arrow','circle'etc. 
%           See "Specifying the Figure Pointer" in Matlab's documentation
%           to see the list of available pointers. (default = 'fullcrosshair')
% xx      : reference for line of first point (used by clickfit_OH)
% yy      : reference for line of first point (used by clickfit_OH)
%
% OUTPUT:
% X     : x-coordinates of the clicked series
% Y     : y-coordinates of the clicked series
% BUTTON : see GINPUT
%
% USES:
% ginput.m rev.  5.32.4.13 (M2009a)
% gline.m rev.  2.12.2.5 (M2009a)
% MYGINPUT by F. Moisy (../fileexchange/12770-myginput)
%
% USED by:
% clickfit_OH.m
%
% Author:   Oscar Hartogensis (oscar.hartogensis at wur.nl)
% Date:     Januari 2010
% Rev:


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjusted by MYGINPUT and ginput_OH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<2 strpointertype='fullcrosshair'; end
if nargin<4 xx=[]; yy=[]; end
first_run = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

out1 = []; out2 = []; out3 = []; y = [];
c = computer;
if ~strcmp(c(1:2),'PC') 
   tp = get(0,'TerminalProtocol');
else
   tp = 'micro';
end

if ~strcmp(tp,'none') && ~strcmp(tp,'x') && ~strcmp(tp,'micro'),
   if nargout == 1,
      if nargin == 1,
         out1 = trmginput(arg1);
      else
         out1 = trmginput;
      end
   elseif nargout == 2 || nargout == 0,
      if nargin == 1,
         [out1,out2] = trmginput(arg1);
      else
         [out1,out2] = trmginput;
      end
      if  nargout == 0
         out1 = [ out1 out2 ];
      end
   elseif nargout == 3,
      if nargin == 1,
         [out1,out2,out3] = trmginput(arg1);
      else
         [out1,out2,out3] = trmginput;
      end
   end
else
   
   fig = gcf;
   figure(gcf);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Adjusted by ginput_OH
    % Copy-Paste from gline.m rev.  2.12.2.5 (M2009a)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    draw_fig = gcf;
    ax = get(draw_fig,'CurrentAxes');
    if isempty(ax)
       ax = axes('Parent',draw_fig);
    end

    oldtag = get(draw_fig,'Tag');
    figure(draw_fig);
    if any(get(ax,'view')~=[0 90]), 
     set(draw_fig, 'Tag', oldtag);
     error('stats:gline:NotTwoDimensional','GLINE works only for 2-D plots.');
    end

    % Can't do this if another mouse mode is active
    hManager = uigetmodemanager(draw_fig);
    if (~isempty(hManager.CurrentMode))
       error('stats:gline:ModeActive',...
             'Cannot use GLINE while the mouse mode ''%s'' is active.',...
             get(hManager.CurrentMode,'name'))
    end

    % Create an invisible line to preallocate the xor line color.
    xlimits = get(ax,'Xlim');
    x_gl = (xlimits + flipud(xlimits))./2;
    ylimits = get(ax,'Ylim');
    y_gl = (ylimits + flipud(ylimits))./2;
    hline = line(x_gl,y_gl,'Parent',ax,'Visible','off');

    bdown = get(draw_fig,'WindowButtonDownFcn');
    bup = get(draw_fig,'WindowButtonUpFcn');
    bmotion = get(draw_fig,'WindowButtonMotionFcn');
    oldud = get(draw_fig,'UserData');
    %    set(draw_fig,'WindowButtonDownFcn','gline(''down'')')
    %    set(draw_fig,'WindowButtonMotionFcn','gline(''motion'')')
    %    set(draw_fig,'WindowButtonupFcn','')

    ud.hline = hline;
    ud.pts = [xx,yy;xx,yy];
    ud.buttonfcn = {bdown; bup; bmotion};
    ud.oldud = oldud;
    ud.oldtag = oldtag;
    set(draw_fig,'UserData',ud);   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   
   if nargin == 0
      how_many = -1;
      b = [];
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Adjusted by ginput_OH
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   elseif isempty(arg1)
      how_many = -1;
      b = [];
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   else       
      how_many = arg1;
      b = [];
      if  ischar(how_many) ...
            || size(how_many,1) ~= 1 || size(how_many,2) ~= 1 ...
            || ~(fix(how_many) == how_many) ...
            || how_many < 0
         error('MATLAB:ginput:NeedPositiveInt', 'Requires a positive integer.')
      end
      if how_many == 0
         ptr_fig = 0;
         while(ptr_fig ~= fig)
            ptr_fig = get(0,'PointerWindow');
         end
         scrn_pt = get(0,'PointerLocation');
         loc = get(fig,'Position');
         pt = [scrn_pt(1) - loc(1), scrn_pt(2) - loc(2)];
         out1 = pt(1); y = pt(2);
      elseif how_many < 0
         error('MATLAB:ginput:InvalidArgument', 'Argument must be a positive integer.')
      end
   end
   
   % Suspend figure functions
   state = uisuspend(fig);
   
   toolbar = findobj(allchild(fig),'flat','Type','uitoolbar');
   if ~isempty(toolbar)
        ptButtons = [uigettool(toolbar,'Plottools.PlottoolsOff'), ...
                     uigettool(toolbar,'Plottools.PlottoolsOn')];
        ptState = get (ptButtons,'Enable');
        set (ptButtons,'Enable','off');
   end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Adjusted by MYGINPUT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    set(fig,'pointer',strpointertype);  % modified MYGINPUT   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Adjusted by ginput_OH
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(ud.pts)
        set(draw_fig,'WindowButtonMotionFcn',@motion)
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   
   fig_units = get(fig,'units');
   char = 0;

   % We need to pump the event queue on unix
   % before calling WAITFORBUTTONPRESS 
   drawnow
   
   while how_many ~= 0
       
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Adjusted by ginput_OH
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      if ~first_run
          ud.pts = [pt(1,1),pt(1,2);pt(1,1),pt(1,2)];
          set(draw_fig,'WindowButtonMotionFcn',@motion)
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
       
      % Use no-side effect WAITFORBUTTONPRESS
      waserr = 0;
      try
	keydown = wfbp;
      catch
	waserr = 1;
      end
      if(waserr == 1)
         if(ishghandle(fig))
            set(fig,'units',fig_units);
	    uirestore(state);
            error('MATLAB:ginput:Interrupted', 'Interrupted');
         else
            error('MATLAB:ginput:FigureDeletionPause', 'Interrupted by figure deletion');
         end
      end
        % g467403 - ginput failed to discern clicks/keypresses on the figure it was
        % registered to operate on and any other open figures whose handle
        % visibility were set to off
        figchildren = allchild(0);
        if ~isempty(figchildren)
            ptr_fig = figchildren(1);
        else
            error('MATLAB:ginput:FigureUnavailable','No figure available to process a mouse/key event'); 
        end
%         old code -> ptr_fig = get(0,'CurrentFigure'); Fails when the
%         clicked figure has handlevisibility set to callback
      if(ptr_fig == fig)
         if keydown
            char = get(fig, 'CurrentCharacter');
            button = abs(get(fig, 'CurrentCharacter'));
            scrn_pt = get(0, 'PointerLocation');
            set(fig,'units','pixels')
            loc = get(fig, 'Position');
            % We need to compensate for an off-by-one error:
            pt = [scrn_pt(1) - loc(1) + 1, scrn_pt(2) - loc(2) + 1];
            set(fig,'CurrentPoint',pt);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Adjusted by ginput_OH
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
            if ~first_run && ~isempty(ud.pts)
                set(ud.hline,'Xdata',ud.pts(:,1),'Ydata',ud.pts(:,2), 'Visible','off');
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
         else
            button = get(fig, 'SelectionType');
            if strcmp(button,'open') 
               button = 1;
            elseif strcmp(button,'normal') 
               button = 1;
            elseif strcmp(button,'extend')
               button = 2;
            elseif strcmp(button,'alt') 
               button = 3;
            else
               error('MATLAB:ginput:InvalidSelection', 'Invalid mouse selection.')
            end
         end
         pt = get(gca, 'CurrentPoint');

         how_many = how_many - 1;
         
         if(char == 13) % & how_many ~= 0)
            % if the return key was pressed, char will == 13,
            % and that's our signal to break out of here whether
            % or not we have collected all the requested data
            % points.  
            % If this was an early breakout, don't include
            % the <Return> key info in the return arrays.
            % We will no longer count it if it's the last input.
            break;
         end
         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Adjusted by ginput_OH
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
        first_run = 0;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
         out1 = [out1;pt(1,1)];
         y = [y;pt(1,2)];
         b = [b;button];
      end
   end
   
   uirestore(state);
   if ~isempty(toolbar) && ~isempty(ptButtons)
        set (ptButtons(1),'Enable',ptState{1});
        set (ptButtons(2),'Enable',ptState{2});
   end
   set(fig,'units',fig_units);
   
   if nargout > 1
      out2 = y;
      if nargout > 2
         out3 = b;
      end
   else
      out1 = [out1 y];
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Adjusted by ginput_OH
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
   if ~first_run && ~isempty(ud.pts)
       set(ud.hline,'Xdata',ud.pts(:,1),'Ydata',ud.pts(:,2), 'Visible','off');
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjusted by ginput_OH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function motion(varargin)
   % Copy-Paste from gline.m (case 'motion') rev.  2.12.2.5 (M2009a) 
   set(ud.hline,'Xdata',ud.pts(:,1),'Ydata',ud.pts(:,2), ...
        'linestyle','-', 'linewidth', 1.5, 'Color','r','Visible','on');
   Pt2 = get(ax,'CurrentPoint'); 
   Pt2 = Pt2(1,1:2);    
   ud.pts(2,:) = Pt2;
   set(draw_fig,'UserData',ud);
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function key = wfbp
%WFBP   Replacement for WAITFORBUTTONPRESS that has no side effects.

fig = gcf;
current_char = [];

% Now wait for that buttonpress, and check for error conditions
waserr = 0;
try
  h=findall(fig,'type','uimenu','accel','C');   % Disabling ^C for edit menu so the only ^C is for
  set(h,'accel','');                            % interrupting the function.
  keydown = waitforbuttonpress;
  current_char = double(get(fig,'CurrentCharacter')); % Capturing the character.
  if~isempty(current_char) && (keydown == 1)           % If the character was generated by the 
	  if(current_char == 3)                       % current keypress AND is ^C, set 'waserr'to 1
		  waserr = 1;                             % so that it errors out. 
	  end
  end
  
  set(h,'accel','C');                                 % Set back the accelerator for edit menu.
catch
  waserr = 1;
end
drawnow;
if(waserr == 1)
   set(h,'accel','C');                                % Set back the accelerator if it errored out.
   error('MATLAB:ginput:Interrupted', 'Interrupted');
end

if nargout>0, key = keydown; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

end