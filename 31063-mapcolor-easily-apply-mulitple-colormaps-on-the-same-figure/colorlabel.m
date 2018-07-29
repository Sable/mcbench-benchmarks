function h=colorlabel(varargin)
% Usage: h=colorlabel([hcb],labstring,[options])
% Given a string "labstring", colorlabel finds the colorbar on the current
% figure and labels the appropriate axis with that string. The handle of
% the axis label is returned as "h". If the figure contains more than one
% colorbar, provide the graphics handle "hcb" of the one that is to be 
% labeled. You many also specify properties for the label object, e.g.,
% colorlabel('x (cm)','FontSize',8,'FontWeight','bold').
%
%   Example:
%      load clown
%      imagesc(X)
%      colorbar
%      colorlabel('pixel brightness')

% Written 7 February 2011 by Douglas H. Kelley, dhk [at] dougandneely.com.

if nargin<1
    error(['Usage: ' mfilename '([hcb],labstring,[options])'])
end
if ischar(varargin{1}) % expect colorlabel(labstring,...)
    labstring=varargin{1};
    hcb=findobj(gcf,'tag','Colorbar','-or','tag','MapColorbar', ...
        '-or','tag','ColorWheel');
    if numel(varargin)<2
        argin=[varargin cell(1,2-numel(varargin))];
    else
        argin=varargin;
    end
    options=argin(2:end);
else % expect colorlabel(hcb,labstring,...)
    hcb=varargin{1};
    labstring=varargin{2};
    if numel(varargin)<3
        argin=[varargin cell(1,3-numel(varargin))];
    else
        argin=varargin;
    end
    options=argin(3:end);
end
if numel(hcb)~=1
    error('Please specify exactly one colorbar.')
end
if ~ishandle(hcb)
    error(['Sorry, ' num2str(hcb) ' is not a valid graphics handle.'])
elseif ~strcmp(get(hcb,'tag'),'Colorbar') && ...
        ~strcmp(get(hcb,'tag'),'MapColorbar') && ...
        ~strcmp(get(hcb,'tag'),'ColorWheel')
    error(['Sorry, ' num2str(hcb) ...
        ' is not a Colorbar, MapColorbar, or ColorWheel.']);
end
if strcmp(get(hcb,'tag'),'Colorbar')
    if strfind(get(hcb,'Orientation'),'Horizontal') % horizontal colorbar
        hh=get(hcb,'xlabel');
    else % vertical colorbar
        hh=get(hcb,'ylabel');
    end
elseif strcmp(get(hcb,'tag'),'MapColorbar') % guess orientation from size of colorbar image
    c0=get(findobj(hcb,'type','image'),'cdata');
    if size(c0,1)<size(c0,2) % guess horizontal 
        hh=get(hcb,'xlabel');
    else % guess vertical 
        hh=get(hcb,'ylabel');
    end
else % ColorWheel: always set title
    hh=get(hcb,'title');
end
if numel(options)>1 || ~isempty(options{:}) % if there are options, ...
    set(hh,'string',labstring,'visible','on',options{:});
else
    set(hh,'string',labstring,'visible','on');
end
if nargout>0
    h=hh; % return handle if requested
end
