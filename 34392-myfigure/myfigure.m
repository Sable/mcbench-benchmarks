function varargout=myfigure(varargin)
%
% myfigure(num) sets figure num to the active figure (creates new figure
%  if necessary), does not raise figure to front unless newly created
%
% myfigure (no arg) creates a new figure (same as matlab figure command)
%
% h=myfigure(num) sets figure num to active, returns handle to figure
%
% this shortcut replacement for matlab's figure command allows rapid 
% switching between figures w/o speed slow down caused by raising window 
% to the front everytime it is active. figures can be plotted to even
% when iconified. handy when rapidly switching between figures.
%
%  - if there no input figure number num, creates a new figure which is
%     raised to front and made active
%  - if num is specified and figure does not exist, creates figure which
%     is raised to front and made active
%  - if figure num already exits, this function makes it active (current)
%     but does not raise it to the front
%
% optionally returns figure handle of newly active figure

% written DGL at BYU 30 Dec 2011

if nargin>0 % if num argument specified
  num=cell2mat(varargin(1));
  if ~isnumeric(num)
    error('Argument to myfigure must be numeric');
  end
  if ~ishandle(num) % if figure does not exist
    figure(num);    % create new figure
  else % set figure num as active      
    set(0,'CurrentFigure',num);
  end
else % create new figure if num not specified
  figure();
end

if nargout==1 % return handle to figure if output argument specified
  varargout={gcf()}; % return handle to currently active figure
end
