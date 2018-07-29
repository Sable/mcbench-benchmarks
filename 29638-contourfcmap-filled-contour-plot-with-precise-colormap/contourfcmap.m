function varargout = contourfcmap(x,y,z,clev,cmap,lo,hi,cbarloc)
%CONTOURFCMAP Filled contour plot with specified colors
%
% h = contourfcmap(x,y,z,clev,cmap,lo,hi,cbarloc)
% h = contourfcmap(x,y,z,clev,cmap)
% h = contourfcmap(x,y,z,clev,cmap,lo)
% h = contourfcmap(x,y,z,clev,cmap,lo,hi)
% 
% This function creates a shaded contour map, similar to that created by
% the contourf function.  However, the relationship between a contourf plot
% and it's colormap (i.e. exactly which color corresponds to each contour
% interval), can often be confusing and inconsistent, in my opinion.  This
% function instead allows the user to specify exactly which colors to use
% in each interval, and also to choose colors for regions that exceed the
% contour line limits.
%
% Input variables
%
%   x:          x-coordinates of grid, following size restrictions of surf
%               command 
%
%   y:          y-coordinates of grid, following size restrictions of surf
%               command 
%
%   z:          array of data to be contoured, following size restritions
%               of surf command 
%
%   clev:       vector of length n, contour levels, must be monotonically
%               increasing 
%
%   cmap:       n-1 x 3 colormap array, specifying colors used to shade
%               each contour interval 
%
%   lo:         1 x 3 colormap array, specifying color used for all data
%               falling below the first contour level.  If not included or
%               empty, default will be to white. 
%
%   hi:         1 x 3 colormap array, specifying color used for all data
%               falling above the last contour level.  If not included or
%               empty, default will be to white.
%
%   cbarloc:    string specifying colorbar location (see colorbar),  or a 
%               1 x 4 position vector for colorbar.  If not included, no
%               colorbar will be created.  Note that the colorbar created
%               is not a colorbar object, but just an axis with plotted
%               patches; it is for labeling only and is not linked to the
%               "peer axis" in any way.
%
% Output variables:
%
%   h:          1 x 1 structure
%
%               c:      contour matrix for filled contour plot
%
%               h:      handle to contourgroup
%
%               cbax:   handle to axis of colorbar
%
% Example:
%
% [x,y] = meshgrid(linspace(0,1,100));
% z = peaks(100);
% contourfcmap(x,y,z,[-5 -3 -2:.5:2 3 5],jet(12), ...
%              [.8 .8 .8], [.2 .2 .2], 'eastoutside')
% 

% Copyright 2010 Kelly Kearney

%------------------------
% Parse input
%------------------------

error(nargchk(5,8,nargin));

% Check clev

if ~isvector(clev)
    error('clev must be a vector');
end
nlev = length(clev);

% Check cmap

if size(cmap,2) ~=3 || size(cmap,1) ~= (nlev-1) || any(cmap(:)<0|cmap(:)>1)
    error('cmap must be nlev-1 x 3 colormap array');
end

% Colors for too-low and too-high patches

if nargin < 6 || isempty(lo)
    lo = [1 1 1];
end

if nargin < 7 || isempty(hi)
    hi = [1 1 1];
end

if ~isequal(size(lo),[1 3])
    error('lo must be 1 x 3 colormap array');
end

if ~isequal(size(hi),[1 3])
    error('hi must be 1 x 3 colormap array');
end
    
% Colorbar location

if nargin == 8 && ~isempty(cbarloc)
    pos = {'north', 'south', 'east', 'west', 'northoutside', 'southoutside', 'eastoutside', 'westoutside'};
    if ischar(cbarloc)
        if ~any(strcmp(lower(cbarloc), pos))
            error('Unrecognizd colorbar position');
        end
    elseif ~isequal(size(cbarloc), [1 4]) || any(cbarloc > 1 | cbarloc < 0)
        error('cbarloc must be position string or  1 x 4 normalized position');
    end
    showcb = true;
else
    showcb = false;
end

% Axis

ax = gca;

%------------------------
% Create filled contour 
% plot
%------------------------

[c,h] = contourf(x,y,z,clev);

hpatch = get(h, 'children');

cdata = cell2mat(get(hpatch, 'cdata'));

% Mark too-high contours

isabove = cdata == max(clev);

% Distinguish between too-lo contours and NaN contours

if ~any(isnan(z(:)))
    isbelow = isnan(cdata);
else
    warning('NaN in data; haven''t figured NaN vs lo yet');
    isbelow = isnan(cdata);
end


level = get(h, 'LevelList');
if ~isequal(level, clev)
    error('oops, something new with levels, check this');
end

[tf, idx] = ismember(cdata, clev);

isweirdextra = idx == 0 & ~isbelow & ~isabove; % Why do these show up?!

for ip = 1:length(hpatch)
    if isbelow(ip)
            set(hpatch(ip), 'facecolor', lo);
    elseif isabove(ip)
            set(hpatch(ip), 'facecolor', hi);
    elseif isweirdextra(ip)
        dist = cdata(ip) - clev;
        dist(dist<0) = Inf;
        [blah, imin] = min(dist);
        set(hpatch(ip), 'facecolor', cmap(imin,:));
    else
        set(hpatch(ip), 'facecolor', cmap(idx(ip),:));
    end
end

%------------------------
% Create colorbar
%------------------------

if showcb
    clevcbar = reshape(clev,1,[]);
    height = 0.1 * (max(clevcbar) - min(clevcbar));
    y1 = [clev(1)-height; clev(1); clev(1); clev(1)-height; clev(1)-height]; 
    y2 = [clev(end); clev(end)+height; clev(end)+height; clev(end); clev(end)];

    yp = [y1 [clev(1:end-1); clev(2:end); clev(2:end); clev(1:end-1); clev(1:end-1)] y2];
    xp = [0;0;1;1;0] * ones(1,nlev+1);
    cp = [lo; cmap; hi];   
    cp = permute(cp, [3 1 2]);

    if ~ischar(cbarloc)
        cbarcoord = cbarloc;
        hascbcoord = true;
        if cbarcoord(3)-cbarcoord(1) < cbarcoord(4)-cbarcoord(2)
            isvert = true;
            cbarloc = 'east';
        else
            isvert = false;
            cbarloc = 'south';
        end
    else
        hascbcoord = false;
        if any(strcmp(pos([3 4 7 8]), lower(cbarloc)))
            isvert = true;
        else
            isvert = false;
        end
    end

    if ~isvert
        tmp = xp;
        xp = yp;
        yp = tmp;
    end

    cbax = colorbar(cbarloc);
    axpos = get(ax, 'position');
    cbpos = get(cbax, 'position');

    delete(cbax);
    set(ax, 'position', axpos);

    cbax = axes('position', cbpos);
    set(cbax, 'userdata', 'contourfcolorbar');

    patch(xp,yp,cp);
    if isvert
        set(cbax, 'ytick', clev, 'ylim', minmax(yp), 'xlim', [0 1], 'xtick', []);
    else
        set(cbax, 'xtick', clev, 'xlim', minmax(xp), 'ylim', [0 1], 'ytick', []);
    end
end

if showcb && hascbcoord
    set(cbax, 'position', cbarcoord);
end
    
%------------------------
% Output
%------------------------

hndl.c = c;
hndl.h = h;
if showcb
    hndl.cbax = cbax;
end

if nargout > 0
    varargout{1} = hndl;
end

% Return focus to axis (needed if colorbar created)

axes(ax);


function a = minmax(b)
a = [min(b(:)) max(b(:))];


