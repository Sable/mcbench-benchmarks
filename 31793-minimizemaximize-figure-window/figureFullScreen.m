function hOutFigure=figureFullScreen(varargin)
%% figureFullScreen
% Similar to figure function, but allowes turning the figure to full screen, or back to
% deafult dimentions. Based on hidden Matlab features described at
% http://undocumentedmatlab.com/blog/minimize-maximize-figure-window/
%
%% Syntax
% figureFullScreen;
% figureFullScreen(hFigure);
% figureFullScreen(hFigure,isMaximise);
% hFigure=figureFullScreen;
% hFigure=figureFullScreen(hFigure);
% hFigure=figureFullScreen(hFigure,isMaximise);
% figureFullScreen(hFigure,'PropertyName',propertyvalue,...);
% figureFullScreen(hFigure,isMaximise,'PropertyName',propertyvalue,...);
% hFigure=figureFullScreen(hFigure,'PropertyName',propertyvalue,...);
% hFigure=figureFullScreen(hFigure,isMaximise,'PropertyName',propertyvalue,...);
%
%% Description
% This functions wrpas matlab figure function, allowing the user to set the figure size to
% one of the two following states- full screen or non full screen (figure default). As
% figure function results with non-maximized dimentions, the default in this function if
% full screen figure (otherwise there is no reason to use this function). It also can be
% used to resize the figure, in a manner similar to clicking the "Maximize"/"Restore down"
% button with the mouse. 
% All Figure Properties acceoptable by figure function are supported by this function as
% well.
%
%% Input arguments (defaults exist):
%  hFigure- a handle to a figure.
%  isMaximise- a flag, which sets figure to full screen when true, and to default size
%           when false (can be used to toggle figure size).
%  Figure Properties- vriety of properties described at matlab Help.
%
%% Output arguments
%  hOutFigure- a handle to a figure.
%
%% Issues & Comments 
% - Currently results in a warning message that (curently desabled), which implies that
% this functionality will not be supported n future matlab rleeases. - Resulted with an
% error which is overriden if some time passes between handle initisialization and feature
% setting- so pause(0.3) is used.
%
%% Example
% figure('Name','Default figure size');
% plotData=peaks(50);
% surf(plotData);
% title('Default figure size','FontSize',14);
% 
% figureFullScreen('Name','Full screen figure size');
% surf(plotData);
% title('Full screen figure size','FontSize',14);
%
%% See also
%  - figure
%
%% Revision history
% First version: Nikolay S. 2011-06-07.
% Last update:   Nikolay S. 2011-06-14.
%
% *List of Changes:*

%% Organize inputs
if nargin==0
   hInFigure=figure;
   isMaximise=true;
else
   isFigureParam=true(1,nargin);
   for iVarargin=1:min(2,nargin) % we asusme figure handle and isMaximise are amoung the 
      % first two inputs
      currVar=varargin{iVarargin};
      if ishandle(currVar(1)) && strcmpi(get(currVar,'Type'),'figure')
         hInFigure=currVar; % a handle 
         isFigureParam(iVarargin)=false;
      elseif islogical(currVar) % I assume 
         isMaximise=currVar;
         isFigureParam(iVarargin)=false;
      end % if ishandle(currVar) && strcmpi(get(currVar,'Type'),'figure')
   end % for iVarargin=1:nargin
   
   figureParams=varargin(isFigureParam);
   if isempty(figureParams)
      % Default value of some figure property- this will save some if condiiton in the
      % code later on
      figureParams={'Clipping','on'}; 
   end
end % if nargin==0

if exist('hInFigure','var')~=1
   hInFigure=figure(figureParams{:});
end

if exist('isMaximise','var')~=1
   isMaximise=true;
end
   
%% Actually the code (yep, as simple as that)
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame'); % disable warning message
jFrame = get(hInFigure,'JavaFrame');
pause(0.3);    % unless pause is used error accures orm time to time. 
               % I guess jFrame takes some time to initialize
set(jFrame,'Maximized',isMaximise);
warning('on','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame'); % enable warning message
                                    % to prevent infualtion of additional places in Matlab
figure(hInFigure); % make hInFigure be the current one
if nargout==1 
   hOutFigure=hInFigure; % prepare output figure handle, if needed
end
