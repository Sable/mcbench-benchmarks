function fighandle=newfig(varargin)
% fighandle = newfig(numfigs,figname,extend,aspect)  create NEW FIGures.
% Tiles the screen with multiple figures starting at the top left hand corner.
% If the specified layout only creates one row, then the figure height is
% chosen to maintain the desired aspect ratio.
%   Examples: 
%       newfig(3,'Title',1+i,2), newfig('Title'), newfig
%       figh=newfig(6); figh=newfig(4,i,1.5); newfig([1,5],-1);
%   "fighandle" is an array of handle numbers for the figures.
%   "numfigs" (first numeric argument) determines the number of figures to create.
%       If numfigs is a vector (rows,columns) then the layout is also specified.
%   "figname" (any argument position) is an optional string for the figures' name.
%   "extend" (second numeric argument) is a complex number indicating how 
%       figures are to be created on multiple monitors, (extended desktop).
%       Examples: +1/-1 is one screen to the right/left,
%                 0 is the primary screen (default),
%                 +i is one screen up,
%                 -1-0.5i is half a screen down and to the left, etc...
%   "aspect" (third numeric argument) is the desired aspect ratio (minimum 
%       horizontal/vertical size of the figure) used for determining the 
%       layout, it is ignored if the layout is specified by numfigs.
%
% NOTES:
% The figures are numbered within this group of figures and not by their
%   figure handles.
% The figures are accessible by their handles. Thus "figure(fighandle(4))" will
%   make the 4th figure from this group of figures the current figure.
% To delete the entire group of figures use "close(fighandle)".

%   Copyright 2006 Mirtech, Inc.
%   created 09/18/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com
% More notes:
% Extended monitors must have the same resolution as the primary monitor.
% The size and layout of the figures is determined by the aspect ratio and
%   the number of figure columns.
% For a large number of figures, the menubar and toolbar are removed to
%   increase figure space.
% Default properties for this particular group of figures may be coded into
%   the code below (near bottom). The following properties are currently set.
%        'Units','pixels', ...
%        'Colormap',gray(256),...
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
% Set the desired default aspect ratio (minimum horizontal/vertical size of the figure).
def_aspect      =1.1;   

menbarlimit     =3;     % no menubar if numrows > menbarlimit
toolbarlimit    =3;     % no toolbar if numrows > toolbarlimit
maxnumrows      =6;     % maximum number of figure rows to create
% ----------------------------------

extend=[];
numfigs=[];  
ftitle=[];
aspect=[];
if nargin~=0,
    count=0;
    for n=1:length(varargin),
        arg=varargin{n};
        if isnumeric(arg),      % note "empty" is also considered to be numeric!
            count=count+1;
            switch count
                case 1
                    numfigs=arg;
                case 2
                    extend=arg;
                case 3
                    aspect=arg;
            end  % switch count
        elseif ischar(arg),
            ftitle=arg;
        end
    end  % for
end  % if nargin
if isempty(numfigs),    numfigs=1;  end
if isempty(ftitle),     ftitle='';  end
if isempty(extend),     extend=0;   end
if isempty(aspect),     aspect=def_aspect;  end
    
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
switch numel(numfigs)
    case 2
        figrows=numfigs(1);
        figcols=numfigs(2);
        numfigs=figrows*figcols;
        if figrows>maxnumrows,
            error ('  Too many figure rows! Maximum is %3.0f',maxnumrows)
        end 
    case 1
        % Determine a layout (figrows,figcols) for numfigs figures.
        figrows=1;
        while numfigs>maxnumfigs(figrows);
            figrows=figrows+1;
            if figrows>maxnumrows,
                error ('  Too many figures are requested! Maximum is %3.0f',maxnumfigs(maxnumrows))
            end    
        end
        figcols=numfigcols(figrows);
    otherwise
        error ('  Number of figures is specified incorrectly!')
end     % switch numel(numfigs)
    
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

% Now create the individual figures.
% Note that the OuterPosition property is preferable to the Position property 
% for setting the figure positions.
figh=ones(1,numfigs);
for n=1:numfigs,
    r=fix((n-1)/figcols)+1;
    c=mod(n-1,figcols)+1;
    pos=[offx+(c-1)*figwidth+1,offy+(figrows-r)*figheight+1,figwidth,figheight];
    if numfigs==1,
        figtitle=ftitle;
    else
        figtitle=['#',int2str(n),'  ',ftitle];
    end
    % Add additional or modify properties as needed.
    figh(n)=figure('Name',figtitle,...
        'Units','pixels',...
        'OuterPosition',pos,...
        'Colormap',gray(256),...
        'NumberTitle','off',...
        'MenuBar',menbar,...
        'ToolBar',tbar);
end
figure(figh(1))             % put focus back onto first figure

if nargout==1,
    fighandle=figh;
end
