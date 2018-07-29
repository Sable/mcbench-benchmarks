function fighandle=tilefig(varargin)  
% fighandle = tilefig(figs,figname,extend,layout)  TILE 1 or more FIGures.
% Tiles the screen for existing figures starting at the top left hand corner.
%   Examples:
%           tilefig, tilefig([1,2,3],'Title',1+i), tilefig('Title'), 
%           figh=tilefig([2:12]); figh=tilefig([3,4],i); tilefig(5,-1,[2,3])
%   "fighandle" is an output array of handle numbers for the figures.
%   "figs" (first numeric input) is a vector of handles of the figures to be tiled. 
%       Default value is 0 which tiles all open figures.
%   "figname" (any argument position) is an optional string for each figure's name.
%       If not specified then figure names are retained, to erase names use ' '.
%   "extend" (second numeric input)is a complex number specifying how figures
%       are to be created on the extended desktop. 
%       Examples: +1/-1 is one screen to the right/left,
%                 0 is the primary screen (default),
%                 +i is one screen up,
%                 -1-0.5i is half a screen down and to the left, etc...
%   "layout" (third numeric input) is a vector (rows,columns) specifying the 
%       screen layout or a single number specifying the aspect ratio.
%       If not specified then the optimal layout will be determined.
%       If the specified layout only creates one row, then the figure
%       height is chosen to maintain the default aspect ratio.
%       The aspect ratio is the minimum horizontal/vertical figure size. 
% NOTES:
% Figures are tiled in the order they are specified in "figs".
% The figures are numbered within this group of figures and not by their
%   figure handle.
% The figures are accessible by their handles. Thus "figure(fighandle(4))" 
%   will make the 4th figure from this group of figures the current figure.
% To delete the entire group of figures use "close(fighandle)".

%   Copyright 2006 Mirtech, Inc.
%   created 09/18/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com
%   Inspired by "Tilefigs" by Charles Plum  
% More notes:
% Will work with docked figures, will ignore modal figures.
% Extended monitors must have the same resolution as the primary monitor.
% The size and layout of the figures is determined by the aspect ratio and
%   the number of figure columns.
% For a large number of figures, the menubar and toolbar are removed to
%   increase figure space.
% Default properties for this group of figures may be coded into the code
%   below. The following properties are currently set.
%        'Units','pixels', ...
%        'NumberTitle','off',...
%        'MenuBar',menbar,...       (depends on number of figures)
%        'ToolBar',tbar             (depends on number of figures)

% --------- Key Constants -----------
% To allow for user or OS borders set the appropriate value in pixels.
% For example one might want to set the bottomborder for the taskbar.
topborder       =0;
bottomborder    =0;
rightborder     =0;
leftborder      =0;
% Border properties for figures - Adjust if needed.
% determined by the difference between OuterPosition and Position values.
% GETFIGDIM can return these values for your system.  
figureborder    =5;     %#ok
titleheight     =26;
menbarheight    =21;
toolbarheight   =27;
minfigwidth     =125;
% Set the default aspect ratio (minimum horizontal/vertical size of the figure).
def_aspect      =1.1;   

menbarlimit     =3;     % no menubar if numrows > menbarlimit
toolbarlimit    =3;     % no toolbar if numrows > toolbarlimit
maxnumrows      =6;     % maximum number of figure rows to create
% ----------------------------------

extend=[];
figs=[];  
ftitle=[];
layout=[];
getname=1;
if nargin~=0,
    count=0;
    for n=1:length(varargin),
        arg=varargin{n};
        if isnumeric(arg),      % note "empty" is also considered to be numeric!
            count=count+1;
            switch count
                case 1
                    figs=arg;
                case 2
                    extend=arg;
                case 3
                    layout=arg;
            end  % switch count
        elseif ischar(arg),
            ftitle=arg;
            getname=0;
        end  % if ~isempty
    end  % for
end  % if nargin
if isempty(figs),       figs=0;     end
if isempty(ftitle),     ftitle='';  end
if isempty(extend),     extend=0;   end
if isempty(layout)||numel(layout)==2,     
    aspect=def_aspect;
elseif numel(layout)==1,
    aspect=layout;
    layout=[];
else
    error ('  Layout cannot have more than 2 elements!')
end

% alternative methods to find all of the figures.
% Second method should be more foolproof.
% allhands=get(0,'Children');
allhands=findobj('Type','figure');
% Note that figures without visible handles will not be tiled.
if figs==0,
    figs=sort(allhands);
else
    [tmp,indx]=intersect(figs,allhands);    %#ok  only tile figures that do exist
    figs=figs(sort(indx));                  % this keeps the order of the figures
end
numfigs=numel(figs);
% Check WindowStyle property on figures
m=0;
for n=1:numfigs,
    m=m+1;
    winstyle=get(figs(m),'WindowStyle');
    if strcmpi(winstyle,'modal'),           % Cannot maximize this figure.
        figs(m)=[];
        m=m-1;
    elseif strcmpi(winstyle,'docked'),      % Docked figures need to be undocked.
        set(figs(m),'WindowStyle','normal');
        drawnow
    end
end
numfigs=numel(figs);

% Get screen dimensions. Note that multiple monitors are assumed to have
% the same resolution.
set(0,'Units','pixels');
scnsize=get(0,'ScreenSize');
scnwidth=scnsize(3)-leftborder-rightborder;
scnheight=scnsize(4)-topborder-bottomborder;

% Try to determine the best layout for the number of figures.
% Calculate the number of figure columns for different number of rows
% based upon the screen size to maintain square figures
numfigcols=zeros(1,maxnumrows);
for n=2:maxnumrows,
    barheight=((menbarlimit-n)>=0)*menbarheight+((toolbarlimit-n)>=0)*toolbarheight;
    numfigcols(n)=fix(scnwidth/((scnheight/n - barheight-titleheight)*aspect));
% Note that the figure size is created with a minimum aspect ratio. 
end
% For one row of figures use the same size figure as for two rows.
numfigcols(1)=numfigcols(2);
maxnumfigs=(1:maxnumrows).*numfigcols;

% Calculate offsets for multiple monitors.
offx=scnsize(3)*real(extend)+leftborder;
offy=scnsize(4)*imag(extend)+bottomborder;

% Determine layout from numfigs
if isempty(layout),
    % Determine a layout (figrows,figcols) for numfigs figures.
    figrows=1;
    while numfigs>maxnumfigs(figrows);
        figrows=figrows+1;
        if figrows>maxnumrows,
            error ('  Too many figures are requested! Maximum is %3.0f',maxnumfigs(maxnumrows))
        end    
    end
    figcols=numfigcols(figrows);
else
    figrows=layout(1);
    figcols=layout(2);
    if figrows>maxnumrows,
        error ('  Too many figure rows! Maximum is %3.0f',maxnumrows)
    end 
end     % isempty(layout)
    
% For a large number of figures, the menu and tool bars are turned off to
% conserve space.
if figrows > toolbarlimit,
    tbar='none';
else
    tbar='figure';
end
if figrows > menbarlimit,
    menbar='none';
else
    menbar='figure';
end

figwidth=scnwidth/figcols;
if figwidth < minfigwidth
    figcols=fix(scnwidth/minfigwidth);
    figrows=ceil(numfigs/figcols);
    if figrows>maxnumrows,
        error ('  Too many figure rows! Maximum is %3.0f',maxnumrows)
    end 
    figwidth=scnwidth/figcols;
end

% For a single row of figures calculate height based upon aspect ratio.
if figrows==1,
    figheight=figwidth/aspect + menbarheight + toolbarheight + titleheight;
    figrows=scnheight/figheight;    % It's ok if figrows is not integer.
else
    figheight=scnheight/figrows;
end

% Now move the individual figures.
% Note that the OuterPosition property is preferable to the Position property 
% for setting the figure positions.
for n=numfigs:-1:1,
    r=fix((n-1)/figcols)+1;     % calculate row number
    c=mod(n-1,figcols)+1;       % calculate column number
    pos=[offx+(c-1)*figwidth+1,offy+(figrows-r)*figheight+1,figwidth,figheight];
    if getname,
        ftitle = get(figs(n),'Name');
        % remove #xx if it exists
        if ~isempty(ftitle) && ftitle(1)=='#',
            [tmp,ftitle]=strtok(ftitle);    %#ok
            ftitle=strtrim(ftitle);         
        end
    end
    if numfigs==1,
        figtitle=ftitle;
    else
        figtitle=['#',int2str(n),'  ',ftitle];
    end
    % Move figure and modify properties as needed.
    set(figs(n),'Name',figtitle,...
        'Units','pixels', ...
        'OuterPosition',pos,...
        'NumberTitle','off',...
        'MenuBar',menbar,...
        'ToolBar',tbar);
    figure(figs(n))             % bring figure to front.
end

if nargout==1,
    fighandle=figs;
end
