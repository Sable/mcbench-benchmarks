function varargout = pulldown(varargin)

%PULLDOWN Standalone pulldown menus with title.
%   [A, B, C, ...] = PULLDOWN(TITLE, X, Y, Z, ...) will invoke simple
%   pulldown menus with title TITLE, and lists of choices in cell arrays,
%   X, Y, Z, ..., and provides the choice index for list X in A, the choice
%   index for list Y in B, etc.
%
%   CHOICES = PULLDOWN(TITLE, X, Y, Z, ...) does the same thing, except
%   CHOICES is a numerical array containing all the individual choice
%   indices from X, Y, Z, etc.
%
%   [...] = PULLDOWN(..., V) does the same thing, but will initialize the
%   pulldown menus to the values in vector V.  V may have fewer or more
%   choices than the number of pulldown menus.
%
%   Examples
%   --------
%       [letter, number] = pulldown('Test', {'A', 'B', 'C'}, num2cell(1:5))
%
%       choices = pulldown('Mission', {'117', '116', '115', '121', '114'})
%
%       % initialize to choices 'B' and 4
%       choices = pulldown('Test', {'A', 'B', 'C'}, num2cell(1:5), [2 4])
%
%   See also UICONTROL, UIWAIT, GET, SET, VARARGIN.
%
%   Version 1.2 Kevin Crosby

% DATE      VER  NAME          DESCRIPTION
% 01-23-07  1.0  K. Crosby     First Release.  Promoted from sub-function.
% 07-11-07  1.1  K. Crosby     Added initial settings for pulldown.
% 07-23-07  1.2  K. Crosby     Changed to modal.

% Contact: Kevin.L.Crosby@gmail.com


m = zeros(1, nargin-1); % maximums
n = 0; % number of pulldowns
while n < nargin-1 && iscell(varargin{n+2})
  arg = n + 2;
  n = n + 1;
  m(n) = length(varargin{arg});
  if ~iscellstr(varargin{arg})
    varargin{arg} = cellstr(num2str(cell2mat(varargin{arg})'))';
  end % if ~iscellstr(varargin{arg})
end % while n
m(n+1:end) = [];

u = ones(1, n); % defaults
k = nargin - n - 1; % number of default overrides
switch k
  case 0
    % do nothing
  case 1
    l = length(varargin{end});
    u(1:min(n, l)) = varargin{end}(1:min(n, l));
  otherwise
    u(1:min(n, k)) = [varargin{n+2:end}];
end % switch k

% ensure within bounds
u = round(u); % ensure integers
u(u < 1) = 1; % force minimum to be 1
u(u > m) = m(u > m); % force maximum to be m

h = 1 / (n+1);
x = .15;      % figure width
y = .02*(n+1); % figure height

popup = zeros(1, n);

fig = figure('MenuBar', 'none', 'Resize', 'off', 'CloseRequestFcn', '', ...
  'Name', varargin{1}, 'NumberTitle', 'off', 'ToolBar', 'none', ...
  'WindowStyle', 'modal', ...
  'Units', 'normalized', 'Position', [.5-x/2 .5-y/2 x y]);
for p = 1:n
  popup(p) = uicontrol('Parent', fig, 'Style', 'popupmenu', ...
    'Units', 'normalized', 'Position', [0 (n+1-p)*h 1 h], ...
    'String', varargin{p+1}, 'Value', u(p), 'Callback', {@callbackfcn, p});
end
uicontrol('Parent', fig, 'Style', 'pushbutton', ...
  'Units', 'normalized', 'Position', [0 0 1 h], ...
  'String', 'OK', 'Callback', 'closereq');
set(0, 'UserData', u); % default choices
uiwait(fig);
choices = get(0, 'UserData');

% the following was added while promoting to a function
switch nargout
  case {0, 1}
    varargout = num2cell(choices, 2);
  otherwise
    varargout = num2cell(choices);
end % switch nargout


% call back function
function callbackfcn(src, eventdata, p) % src, eventdata, varargin ...

if isempty(eventdata) || ~isstruct(eventdata)
  eventdata.Key = '';
end % isempty(eventdata) || ~isstruct(eventdata)

u = get(0, 'UserData');
u(p) = get(src, 'Value');
set(0, 'UserData', u);
