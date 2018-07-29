function hFigBlur = blurFigure(hFig, state)
% blurFigure blurs and prevents interaction on a figure window
%
% Syntax:
%    hFigBlur = blurFigure(hFig, state)
%
% Description:
%    blurFigure(hFig) blurs figure hFig and prevents interaction with it.
%    The only interaction possible is with user-created controls on the
%    blurring panel (see below).
%
%    hFigBlur = blurFigure(hFig) returns the overlaid blurred figure pane.
%    This is useful to present a progress bar or other GUI controls, for
%    user interaction during the blur phase.
%
%    blurFigure(hFig,STATE) sets the blur status of figure hFig to STATE,
%    where state is 'on','off',true or false (default='on'/true).
%
%    blurFigure(hFig,'on') or blurFigure(hFig,true) is the same as:
%    blurFigure(hFig).
%
%    blurFigure(hFig,'off') or blurFigure(hFig,false) is the same as:
%    close(hFigBlur).
%
%    blurFigure('demo') displays a simple demo of the blurring
%
% Input parameters:  (all parameters are optional)
%
%    hFig -  (default=gcf) Handle(s) of the modified figure(s).
%            If component handle(s) is/are specified, then the containing
%            figure(s) will be inferred and used.
%
%    state - (default='on'/true) blurring flag: 'on','off',true or false
%
% Examples:
%    hFigBlur = blurFigure(hFig);       % blur hFig (alternative #1)
%    hFigBlur = blurFigure(hFig,true);  % blur hFig (alternative #2)
%
%    blurFigure(hFig,false);       % un-blur hFig (alternative #1)
%    blurFigure(hFig,'off');       % un-blur hFig (alternative #2)
%    close(hFigBlur);              % un-blur hFig (alternative #3)
%    delete(hFigBlur);             % un-blur hFig (alternative #4)
%
%    blurFigure('demo');           % blur demo with progress bar etc.
%
%    hFigBlur = blurFigure(hFig);  % add a blur with a cancel button
%    uicontrol('parent',hFigBlur, 'string','Cancel', 'Callback','close(gcbf)');
%
% Technical Description:
%    http://UndocumentedMatlab.com/blog/blurred-matlab-figure-window
%
% Bugs and suggestions:
%    Please send to Yair Altman (altmany at gmail dot com)
%
% Warning:
%    This code heavily relies on undocumented and unsupported Matlab functionality.
%    It works on Matlab 7.9 (R2009b) and higher, but use at your own risk!
%
% Change log:
%    2011-03-07: First version posted on Matlab's File Exchange: <a href="http://www.mathworks.com/matlabcentral/fileexchange/?term=authorid%3A27420">http://www.mathworks.com/matlabcentral/fileexchange/?term=authorid%3A27420</a>
%    2011-03-08: Minor fix to the demo
%    2011-10-14: Fix for R2011b
%
% See also:
%    enableDisableFig, setFigTransparency, getJFrame (all of them on the File Exchange)

% Programmed by Yair M. Altman: altmany(at)gmail.com
% $Revision: 1.2 $  $Date: 2011/11/14 03:13:27 $

  % Require Java 1.6.0_10 to run
  if ~usejava('awt')
      error([mfilename ' requires Java to run']);
  elseif ~ismethod('com.sun.awt.AWTUtilities','setWindowOpacity')
      error([mfilename ' requires a newer Java engine (1.6.0_10 minimum) to run']);
  end

  % Set default input parameters values
  if nargin < 1,  hFig = gcf;    end
  if nargin < 2,  state = true;  end

  % Check for demo request
  if ischar(hFig)
      if strcmpi(hFig,'demo')
          f1 = figure;
          try oldWarn = warning('off','MATLAB:uitree:MigratingFunction'); catch, end
          h1 = uitree('root','c:\');  %#ok unused
          drawnow;
          try h1.getTree.expandRow(0); catch, end
          try warning(oldWarn); catch, end
          h2 = uicontrol('string','click me!', 'units','pixel', 'pos',[300,50,100,20]);  %#ok unused
          hax = axes('parent',gcf,'units','pixel','pos',[230,100,300,300]);  %#ok unused
          surf(peaks);
          set(gcf,'ToolBar','figure');  % restore the toolbar that was removed by the uicontrol() call above
          hFigBlurTemp = blurFigure(f1);
          h4 = uicontrol('parent',hFigBlurTemp, 'style','text', 'units','pixel', 'pos',[130,85,390,80], 'string','Processing - please wait...', 'FontSize',12, 'FontWeight','bold','Fore','red','Back','yellow');  %#ok unused
          [h5a,h5b]=javacomponent('javax.swing.JProgressBar',[180,115,310,20],hFigBlurTemp); h5a.setValue(67);  %#ok unused
          h6 = uicontrol('parent',hFigBlurTemp, 'string','Cancel', 'pos',[280,90,100,20], 'Callback','close(gcbf)');  %#ok unused
          return;
      else
          error([mfilename ' requires a figure handle or the string ''demo''']);
      end
  end

  % Check valid state values
  if ischar(state)
      if ~any(strcmpi(state,{'on','off'}))
          error([mfilename ' requires a STATE value of ''on'', ''off'', true or false']);
      else
          state = strcmpi(state,'on');
      end
  elseif ~isscalar(state)
      error([mfilename ' requires a scalar STATE value of ''on'', ''off'', true or false']);
  else
      state = logical(state);
  end

  % Get unique figure handles
  if ~all(ishghandle(hFig))
      error('hFig must be a valid GUI handle or array of handles');
  end
  hFigCell = num2cell(zeros(1,length(hFig)));
  for hIdx = 1 : length(hFig)
      if hFig(hIdx) ~= 0
          hFigCell{hIdx} = ancestor(hFig(hIdx),'figure');
      end
  end
  [unigueHandles,uniqueIdx,foldedIdx] = unique(hFig,'first');  %#ok unused
  hFigBlur_internal = zeros(size(hFig));

  % Loop over all requested figures
  for figIdx = 1 : length(hFigCell)

      % Get the root Java frame
      try
          % The following is only used for the internal sanity checks on the target figure
          jff = getJFrame(hFigCell{figIdx});
      catch
          errMsg = regexprep(lasterr,'Error using [^\n]+\n','');  %#ok
          error(errMsg);
      end

      % If this figure has already been processed - bail out
      if ~ismember(figIdx,uniqueIdx)
          hFigBlur_internal(figIdx) = hFigBlur_internal(foldedIdx(figIdx));
          continue;
      end

      hFigBlurTemp = getappdata(hFigCell{figIdx}, 'blur_hFig');

      % If blurring is requested
      if state

          % If this figure is already blurred, bail out
          if ~isempty(hFigBlurTemp) && ishghandle(hFigBlurTemp),  continue;  end

          % Overlap the current frame with an identical empty figure frame
          hProps = get(hFigCell{figIdx});
          hFigBlur_internal(figIdx) = figure('Units',hProps.Units, 'Pos',hProps.Position, 'Color',hProps.Color, ...
                                             'Menu',hProps.MenuBar, 'Toolbar',hProps.ToolBar, ...
                                             'IntegerHandle','off','HandleVisibility','off', ...
                                             'Name','', 'NumberTitle','off', ...
                                             'DockControls','off','Resize','off');

          % Remove all toolbar sub-components from the new figure
          hToolbar = findall(hFigCell{figIdx},'tag','FigureToolBar');
          if isempty(hToolbar)
              set(hFigBlur_internal(figIdx),'ToolBar','none');  % might be 'auto' without a visible toolbar, so we need this...
          else
              hToolbar = findall(hFigBlur_internal(figIdx),'tag','FigureToolBar');
              hComponents = findall(hToolbar);
              delete(hComponents(2:end));  % keep the toolbar without any sub-components, to preserve the bar area
          end

          % Remove all menubar sub-components from the new figure
          hMenuBar = findall(hFigCell{figIdx},'type','uimenu','visible','on');
          if isempty(hMenuBar)
              set(hFigBlur_internal(figIdx),'Menu','none');  % might be 'figure' without any visible menu item, so we need this...
          else
              hComponents = findall(hFigBlur_internal(figIdx),'type','uimenu');
              set(hComponents,'Label','');  % keep the menubar without any visible sub-components, to preserve the bar area
          end

          % Blur by setting the new frame's opacity to translucent
          jNewFig = getJFrame(hFigBlur_internal(figIdx));
          com.sun.awt.AWTUtilities.setWindowOpacity(jNewFig,0.8);

          % Add a hidden handle to the corresponding figure in each of the figures
          setappdata(hFigBlur_internal(figIdx), 'blur_hFig',hFigCell{figIdx});
          setappdata(hFigCell{figIdx}, 'blur_hFig',hFigBlur_internal(figIdx));

          % Prevent resizing during blur
          setappdata(hFigBlur_internal(figIdx), 'blur_originalResize', hProps.Resize);
          set(hFigCell{figIdx}, 'Resize','off');

          % Prevent closing the figures via the 'X' button
          set(hFigBlur_internal(figIdx), 'CloseRequestFcn',@closeRequestFcn)

          % Attach listeners to the original and new frames: Position, Visibility, Docking, Close
          hFigures = [hFigCell{figIdx}, hFigBlur_internal(figIdx)];
          hLink(1) = linkprop(hFigures,'Units');
          hLink(2) = linkprop(hFigures,'Position');
          hLink(3) = linkprop(hFigures,'Visible');
          hLink(4) = linkprop(hFigures,'WindowStyle');
          hLink(5) = handle.listener(hFigCell{figIdx},'ObjectBeingDestroyed',{@deleteFcn,hFigBlur_internal(figIdx)});
          hLink(6) = handle.listener(hFigBlur_internal(figIdx),'ObjectBeingDestroyed',@unblurFcn);
          hLink(7) = handle.listener(hFigCell{figIdx},findprop(handle(hFigCell{figIdx}),'Visible'),'PropertyPostSet',{@visibilityFcn,hFigBlur_internal(figIdx)});

          % Persist the listener handles in the blur figure's hidden ApplicationData
          setappdata(hFigBlur_internal(figIdx), 'blur_hListeners',hLink);

          % Prevent Mininization
          try
              % This prevents minimization better, but also prevents interaction with
              % any user-generated uicontrols in the blur window - not good!
              %jNewFig.setEnabled(false);

              % This simply restores the window back to place after a minimization
              % - ugly but better than nothing...
              hjNewFig = handle(jNewFig,'CallbackProperties');
              set(hjNewFig, 'WindowIconifiedCallback',@minimizedFcn);
          catch
              % might fail in some future Matlab version - never mind...
          end

          % Prevent direct activation/invocation of the original figure
          try
              hjFig = handle(jff,'CallbackProperties');
              set(hjFig, 'WindowActivatedCallback',{@visibilityFcnHelper,hFigBlur_internal(figIdx)});
          catch
              % might fail in some future Matlab version - never mind...
          end

      else  % Unbluring was requested
          try delete(hFigBlurTemp); catch, end
      end
  end

  % Return the blurring figure pane handle(s), if requested
  if nargout && state
      hFigBlur = hFigBlur_internal;
  end

end  % blurFigure


%% Get the root Java frame (up to 10 tries, to wait for figure to become responsive)
function jframe = getJFrame(hFig)

  drawnow;

  % Ensure that hFig is a non-empty handle...
  if isempty(hFig)
      error(['Cannot retrieve the figure handle for handle ' num2str(hFig)]);
  end

  % Check for the desktop handle
  if hFig == 0
      error('Blurring the Desktop is not supported');
  end

  % Check whether the figure is invisible
  if strcmpi(get(hFig,'Visible'),'off')
      error(['Cannot blur non-visible figure ' num2str(hFig)]);
  end

  % Check whether the figure is docked
  if strcmpi(get(hFig,'WindowStyle'),'docked')
      error(['Cannot blur docked figure ' num2str(hFig)]);
  end

  % Retrieve the figure window (JFrame) handle
  jframe = [];
  maxTries = 10;
  while maxTries > 0
      try
          % Get the figure's underlying Java frame
          jf = get(handle(hFig),'JavaFrame');

          % Get the Java frame's root frame handle
          %jframe = jf.getFigurePanelContainer.getComponent(0).getRootPane.getParent;
          try
              jframe = jf.fFigureClient.getWindow;  % equivalent to above...
          catch
              jframe = jf.fHG1Client.getWindow;  % equivalent to above...
          end
          if ~isempty(jframe)
              break;
          else
              maxTries = maxTries - 1;
              drawnow; pause(0.1);
          end
      catch
          maxTries = maxTries - 1;
          drawnow; pause(0.1);
      end
  end
  if isempty(jframe)
      error(['Cannot retrieve the Java Frame reference for figure ' num2str(hFig)]);
  end
  
end  % getJFrame


%% Close request callback function
function closeRequestFcn(hFig, varargin)
  stk = dbstack(1);
  if ~isempty(stk) && strcmpi(stk(1).file,'close.m')
      delete(hFig);
  else
      % came here by trying to close the figure by clicking the 'X' - ignore!
  end
end  % closeRequestFcn


%% Delete blur figure callback function
function deleteFcn(hObj, eventData, hFig, varargin)  %#ok unused
  delete(hFig);
end  % deleteFcn


%% Restore original resize behavior upon un-bluring
function unblurFcn(hFigBlur, varargin)
  try
      originalResizeMode = getappdata(hFigBlur, 'blur_originalResize');
      hFig = getappdata(hFigBlur, 'blur_hFig');
      set(hFig, 'Resize',originalResizeMode);
  catch
      % never mind...
  end
end  % unblurFcn


%% Minimization callback function
function minimizedFcn(hObj, varargin)
  % Restore to previous position (prevent minimization)
  try hObj.setMinimized(false); catch, end
end  % minimizedFcn


%% Gained-focus callback function
function visibilityFcn(hFig, eventData, hFigBlur, varargin)  %#ok unused
  % Set the blurring window on top
  try
      if strcmpi(eventData.NewValue,'on')
          start(timer('ExecutionMode','singleShot', 'StartDelay',0.05, 'TasksToExecute',1, 'TimerFcn', {@visibilityFcnHelper,hFigBlur}));
      end
  catch
      % never mind...
  end
end  % minimizedFcn


%% visibility helper function
function visibilityFcnHelper(hTimer,hEventData,hFigBlur)  %#ok unused
  try
      jNewFig = getJFrame(hFigBlur);
      %figure(hFigBlur);
      jNewFig.requestFocus;
      com.sun.awt.AWTUtilities.setWindowOpacity(jNewFig,0.8);
      hjNewFig = handle(jNewFig,'CallbackProperties');
      set(hjNewFig, 'WindowIconifiedCallback',@minimizedFcn);
      stop(hTimer)
      delete(hTimer);
  catch
      % never mind...
  end
end  % visibilityFcnHelper
