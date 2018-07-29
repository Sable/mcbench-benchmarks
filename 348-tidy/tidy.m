% tidy [(position)]
% arranges the command window, editor window, and other specified windows
% neatly on screen.  easily customised by editing script.
% choose the command window position from
%   tidy bottom
%   tidy top
%   tidy left
%   tidy right
%   tidy compact
%   tidy (defaults to bottom)
% should work under win95/98/NT/2000, tested on win2000 only
% should work using any version of MATLAB, tested using MATLAB5/6 only

function tidy(pos,extra)

% also can be used as a shortcut to MoveWindow for special cases
if nargin==2
    MoveWindow(pos,extra)
    return;
end

if nargin==0, pos='bottom'; end

switch pos
case {'top','bottom','left','right'}
    disp('tidying desktop...');
    compact=0;
case {'compact'}
    disp('tidying desktop...');
    pos='bottom';
    compact=1;
otherwise
    help tidy
    disp(['Unrecognised position "' pos '".']);
    return;
end

% all windows starting with the supplied title are matched, but
% typically only the first one encountered is moved.
% a '*' as the last character of a window title means move all
% of the windows that match.  typically this might be used
% as below - 'Figure No. *' will move all figure windows that
% have not had their captions altered.
% the command window should probably be last in the list since
% whichever is last in the list has the focus after these
% operations.
MoveWindow('Figure No. *',SecondDivision(Opposite(pos)));
MoveWindow('Figure No. 2',FirstDivision(Opposite(pos)));
MoveWindow('Microsoft Visual C++',Opposite(pos));
MoveWindow('D:\*',SecondDivision(Opposite(pos)));
MoveWindow('d:\*',SecondDivision(Opposite(pos)));
MoveWindow('E:\*',FirstDivision(Opposite(pos)));
MoveWindow('e:\*',FirstDivision(Opposite(pos)));
MoveWindow('Workspace',SecondDivision(Opposite(pos)));
if compact
    MoveWindow('MATLAB',FirstDivision(pos));
    MoveWindow('ALTOUT',SecondDivision(pos));
else
    MoveWindow('MATLAB',pos);
    MoveWindow('ALTOUT',SecondDivision(Opposite(pos)));
end

function opp=Opposite(pos)
if strcmp(pos,'top') opp='bottom'; end
if strcmp(pos,'bottom') opp='top'; end
if strcmp(pos,'left') opp='right'; end
if strcmp(pos,'right') opp='left'; end
if strcmp(pos,'topleft') opp='bottomright'; end
if strcmp(pos,'topright') opp='bottomleft'; end
if strcmp(pos,'bottomleft') opp='topright'; end
if strcmp(pos,'bottomright') opp='topleft'; end

function div=FirstDivision(pos)
if strcmp(pos,'top') div='topleft'; end
if strcmp(pos,'bottom') div='bottomleft'; end
if strcmp(pos,'left') div='topleft'; end
if strcmp(pos,'right') div='topright'; end

function div=SecondDivision(pos)
if strcmp(pos,'top') div='topright'; end
if strcmp(pos,'bottom') div='bottomright'; end
if strcmp(pos,'left') div='bottomleft'; end
if strcmp(pos,'right') div='bottomright'; end
