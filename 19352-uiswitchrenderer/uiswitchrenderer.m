function uiswitchrenderer(hFig)
% UISWITCHRENDERER adds a pushtool to the figure toolbar for the direct renderer choosing.
%
% UISWITCHRENDERER
%     adds the pushtool to the current figure.
%
% UISWITCHRENDERER(hFig)
%     adds the pushtool to the figure with handle hFig.
%
% UISWITCHRENDERER('auto')
%     adds the pushtool to the each new created figure automatically.
%
% UISWITCHRENDERER('remove')
%     remove the automatically adding of pushtools to new figures.
%
% See also: ALWAYSONTOP (in FileExchange)
%
% Version: v1.2
% last update: 21-Mar-2010
% Author: Elmar Tarajan [MCommander@gmx.de]

% Two reasons to set the renderer yourself are
%  * To make your printed or exported figure look the same as it did on the
%    screen. The rendering method used for printing and exporting the figure
%    is not always the same method used to display the figure.
%
%  * To avoid unintentionally exporting your figure as a bitmap within a vector
%    format. For example, high-complexity MATLAB plots typically render using
%    OpenGL or Z-buffer. If you export a high-complexity figure to the EPS or
%    EMF vector formats without specifying a rendering method, either OpenGL or
%    Z-buffer might be used, each of which creates bitmap graphics. Storing a
%    bitmap in a vector file can generate a very large file that takes a long
%    time to print. If you use one of these formats and want to make sure that
%    your figure is saved as a vector file, be sure to set the rendering method
%    to Painter's.

persistent lh_add
%
if nargin == 0
   hFig = gcf;
end% if
%
if ishandle(hFig)
   add_pushtool(hFig)
else
   switch hFig
      case 'auto'
         lh_add = addlistener(0,'ObjectChildAdded',@(a,b) add_pushtool(gcf));
      case 'remove'
         if ~isempty(lh_add)
            delete(lh_add)
         end% if
   end% switch
end% if

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function add_pushtool(hFig)
%-------------------------------------------------------------------------------
hToolbar = findall(hFig,'Type','uitoolbar');
if ~isempty(hToolbar) && isempty(findall(hFig,'Type','uipushtool','Tag','uiswitchrenderer'))
   %
   hPush = uipushtool(...
      'parent',hToolbar, ...
      'separator','on', ...
      'HandleVisibility','off', ...
      'TooltipString','Current Renderer', ...
      'tag','uiswitchrenderer');
   update_pushtool(hFig,hPush);
   %
   addlistener(hFig,'Renderer','PostSet',@(a,b) update_pushtool(gcf,hPush));
end% if
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_pushtool(hFig,hPush)
%-------------------------------------------------------------------------------
if ~ishandle(hPush)
   return
end% if
%
switch lower(get(hFig,'renderer'))
   case 'opengl'
      img = [ ...
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN 0.3 0.3 0.4 NaN 0.3 0.3 0.4 NaN 0.3 0.3 0.4 0.3 NaN NaN 0.3
         0.3 0.7 NaN 0.3 0.4 0.3 0.7 0.3 0.4 0.3 0.7 0.7 0.3 0.3 NaN 0.3
         0.3 0.7 NaN 0.3 0.4 0.3 0.7 0.3 0.4 0.3 0.3 0.4 0.3 0.7 0.3 0.3
         0.3 0.7 NaN 0.3 0.4 0.3 0.3 0.4 0.7 0.3 0.7 0.7 0.3 0.7 0.7 0.3
         0.7 0.3 0.3 0.4 0.7 0.3 0.7 0.7 0.7 0.3 0.3 0.4 0.3 0.7 NaN 0.3
         NaN 0.7 0.7 0.7 NaN 0.7 0.7 NaN NaN NaN 0.7 0.7 0.7 0.7 NaN 0.7
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN 0.3 0.3 0.3 0.3 0.3 0.3 0.3 NaN 0.3 0.3 0.3 NaN NaN NaN NaN
         0.3 0.3 0.3 0.7 0.7 0.7 0.7 0.7 0.7 0.3 0.3 0.3 0.7 NaN NaN NaN
         0.3 0.3 0.3 0.7 NaN 0.3 0.3 0.3 NaN 0.3 0.3 0.3 0.7 NaN NaN NaN
         0.3 0.3 0.3 0.7 NaN NaN 0.3 0.3 0.7 0.3 0.3 0.3 0.7 NaN NaN NaN
         0.3 0.3 0.3 0.7 NaN NaN 0.3 0.3 0.7 0.3 0.3 0.3 0.7 NaN 0.3 0.3
         0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.3 0.3 0.3
         NaN 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 NaN 0.7 0.7 0.7 0.7 0.7 0.7
         ];
      next = 'zbuffer';
      %
   case 'zbuffer'
      img = [ ...
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 NaN NaN NaN
         NaN NaN NaN NaN 0.3 0.3 0.7 0.7 0.3 0.3 0.3 0.7 NaN NaN NaN NaN
         NaN NaN NaN NaN NaN 0.7 0.7 0.3 0.3 0.3 0.7 NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN 0.3 0.3 0.3 0.7 NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN 0.3 0.3 0.3 0.7 NaN 0.3 0.3 NaN NaN NaN NaN
         NaN NaN NaN NaN 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.7 NaN NaN NaN
         NaN NaN NaN NaN NaN 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         0.4 0.3 0.3 0.4 NaN 0.3 0.4 0.0 0.4 0.3 0.4 0.3 0.3 0.4 0.3 0.3
         0.4 0.7 0.3 0.4 0.7 0.3 0.4 0.7 0.4 0.7 0.4 0.7 NaN 0.4 0.7 0.3
         0.4 0.3 0.7 0.4 0.7 0.3 0.4 0.0 0.4 0.3 0.4 0.3 NaN 0.4 0.3 0.3
         0.4 0.7 0.3 0.4 0.4 0.3 0.4 0.7 0.4 0.7 0.4 0.7 0.7 0.4 0.3 0.7
         0.4 0.3 0.3 0.7 0.3 0.7 0.3 0.7 0.3 0.7 0.3 0.3 0.3 0.4 0.7 0.3
         NaN 0.7 0.7 NaN 0.7 NaN 0.7 NaN 0.7 NaN 0.7 0.7 0.7 0.7 NaN 0.7
         ];
      next = 'painters';
      %
   case 'painters'
      img = [ ...
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN 0.3 NaN NaN NaN NaN NaN NaN
         0.0 0.3 0.3 NaN NaN 0.3 0.3 NaN 0.6 0.7 0.6 0.3 NaN NaN 0.3 NaN
         0.0 0.7 NaN 0.4 0.3 0.7 0.7 0.3 NaN 0.3 0.6 0.3 0.3 NaN 0.3 0.7
         0.0 0.7 NaN 0.4 0.3 0.7 NaN 0.3 0.7 0.3 0.7 0.3 0.7 0.3 0.3 0.7
         0.0 0.3 0.3 0.7 0.3 0.3 0.3 0.3 0.7 0.3 0.7 0.3 0.7 0.7 0.3 0.7
         0.0 0.7 0.7 NaN 0.3 0.7 NaN 0.3 0.6 0.3 0.6 0.3 0.7 NaN 0.3 0.7
         NaN 0.7 NaN NaN NaN 0.7 NaN NaN 0.7 0.7 0.7 0.7 0.7 NaN NaN 0.7
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.4 0.3 0.3 0.3 NaN NaN 0.3 0.3 0.3
         NaN 0.7 0.3 0.7 0.4 0.7 0.7 0.7 0.3 0.7 0.7 0.3 0.4 0.7 0.7 0.7
         NaN NaN 0.3 0.7 0.4 0.3 0.3 NaN 0.3 0.7 NaN 0.3 0.7 0.3 0.3 NaN
         NaN NaN 0.3 0.7 0.4 0.7 0.7 0.7 0.3 0.3 0.3 0.7 NaN 0.7 0.7 0.3
         NaN NaN 0.3 0.7 0.4 0.3 0.3 0.4 0.3 0.7 0.5 0.3 0.6 0.3 0.3 0.7
         NaN NaN NaN 0.7 NaN 0.7 0.7 0.7 0.7 0.7 NaN 0.7 0.7 0.7 0.7 NaN
         ];
      next = 'opengl';
      %
   case 'none'
      img = [ ...
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         0.3 NaN NaN 0.3 NaN 0.3 0.3 0.3 NaN 0.4 NaN NaN 0.3 0.4 0.3 0.3
         0.3 0.3 NaN 0.3 0.4 0.7 0.7 0.7 0.3 0.4 0.3 NaN 0.3 0.4 0.7 0.7
         0.3 0.7 0.3 0.3 0.4 0.7 NaN NaN 0.3 0.4 0.7 0.3 0.3 0.4 0.3 NaN
         0.3 0.7 0.7 0.3 0.4 0.7 NaN 0.7 0.3 0.4 0.7 0.7 0.3 0.4 0.7 0.7
         0.3 0.7 NaN 0.3 0.7 0.3 0.3 0.3 0.7 0.4 0.7 NaN 0.3 0.4 0.3 0.3
         NaN 0.7 NaN NaN 0.7 0.7 0.7 0.7 NaN 0.7 0.7 NaN 0.7 0.7 0.7 0.7
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
         ];
      next = 'opengl';
      %
end% switch
%
set(hPush, ...
   'cdata',repmat(img,[1 1 3]), ...
   'clickedcallback',sprintf('set(gcbf,''renderer'',''%s'')',next), ...
   'tooltipstring',sprintf('Current Renderer - %s',lower(get(hFig,'renderer'))))
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% I LOVE MATLAB! You too? :) %%%