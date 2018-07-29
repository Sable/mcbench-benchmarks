function [latb,lonb] = bufferm2(varargin) %lat,lon,dist,direction,npts,outputformat)
%BUFFERM2 Computes buffer zone around a polygon
%
% [latb,lonb] = bufferm2(lat,lon,dist,direction)
% [latb,lonb] = bufferm2(lat,lon,dist,direction,npts)
% [latb,lonb] = bufferm2(lat,lon,dist,direction,npts,outputformat)
% [xb,  yb]   = bufferm2('xy',x,y,dist,direction,npts,outputformat)
%
% This function was originally designed as a replacement for the Mapping
% Toolbox function bufferm, which calculates a buffer zone around a
% polygon. The original bufferm function had some serious bugs that could
% result in incorrect buffer results and/or errors, and was also very slow.
% As of R2006b, those bugs have been fixed.  However, this version still
% maintains a few advantages over the original: 
%
%   - Can be applied to polygons in either geographical space (as in
%   bufferm) or in cartesian coordinates.
%
%   - Better treatment of polygon holes.  The original function simply
%   filled in all holes; this version trims or pads holes according to the
%   buffer width given.
%
% Input and output format is identical to bufferm unless the 'xy' option is
% specified, so it can be used interchangeably.
%
% Input variables:
%
%   lat:            Latitude values defining the polygon to be buffered.
%                   This can be either a NaN-delimited vector, or a cell
%                   array containing individual polygonal contours (each of
%                   which is a vector). External contours should be listed
%                   in a clockwise direction, and internal contours (holes)
%                   in a counterclockwise direction.
%
%   lon:            Longitude values defining the polygon to be buffered.
%                   Same format as lat. 
%
%   dist:           Width of buffer, in degrees of arc along the surface
%                   (unless 'xy' is used, in which case units correspond to
%                   x-y coordinates)
%
%   direction:      'in' or 'out'
%
%   npts:           Number of points used to contruct the circles around
%                   each polygon vertex.  If omitted, default is 13. 
%
%   outputformat:   'vector' (NaN-delimited vectors), 'cutvector'
%                   (NaN-clipped vectors with cuts connecting holes to the
%                   exterior of the polygon), or 'cell' (cell arrays in
%                   which each element of the cell array is a separate
%                   polygon), defining format of output.  If omitted,
%                   default is 'vector'.
%
%   'xy':           If first input is 'xy', then data will be assumed to
%                   lie on a cartesian plane rather than on a sphere.  Use
%                   x and y coordinates as first two inputs rather than lat
%                   and lon.  Units of x, y, and distance should be the
%                   same.
%
% Output variables:
%
%   latb:           Latitude values for buffer polygon
%
%   lonb:           Longitude values for buffer polygon
%
% Example:
%
%   load conus
%   tol = 0.1; % Tolerance for simplifying polygon outlines
%   [reducedlat, reducedlon] = reducem(gtlakelat, gtlakelon, tol);
%   dist = 1;  % Buffer distance in degrees
%   [latb, lonb] = bufferm2(reducedlat, reducedlon, dist, 'out');
%   figure('Renderer','painters')
%   usamap({'MN','NY'})
%   geoshow(latb, lonb, 'DisplayType', 'polygon', 'FaceColor', 'yellow')
%   geoshow(gtlakelat, gtlakelon,...
%                       'DisplayType', 'polygon', 'FaceColor', 'blue')
%   geoshow(uslat, uslon)
%   geoshow(statelat, statelon)
%
% See also:
%   
%   bufferm, polybool

% Copyright 2010 Kelly Kearney

%---------------------------
% Check input
%---------------------------

error(nargchk(3,7,nargin));

% Determine if geographic or cartesian

if ischar(varargin{1}) && strcmp(varargin{1}, 'xy')
    geo = false;
    param = varargin(2:end);
else
    geo = true;
    param = varargin;
end

% Set defaults if not provided as input

nparam = length(param);

if geo
    [lat, lon, dist] = deal(param{1:3});
else
    [lon, lat, dist] = deal(param{1:3}); % lon = x, lat = y for mental clarity, will switch back at end
end

if nparam < 4
    direction = 'out';
else
    direction = param{4};
end

if nparam < 5
    npts = 13;
else
    npts = param{5};
end

if nparam < 6
    outputformat = 'vector';
else
    outputformat = param{6};
end

% Check format and dimensions of input

if ~ismember(direction, {'in', 'out'})
    error('Direction must be either ''in'' or ''out''.');
end

if ~ismember(outputformat, {'vector', 'cutvector', 'cell'})
    error('Unrecognized output format flag.');
end

if ~isnumeric(dist) || numel(dist) > 1
    error('Distance must be a scalar.')
end

if ~isnumeric(npts) || numel(npts) > 1
    error('Number of points must be a scalar.')
end

if iscell(lat)
    for il = 1:numel(lat)
        if ~isvector(lat{il}) | ~isvector(lon{il}) | ~isequal(length(lat{il}), length(lon{il}))
            error('Lat (or x) and lon (or y) must be vectors or cells of vectors with identical dimensions');
        end
        lat{il} = lat{il}(:);
        lon{il} = lon{il}(:);
    end
else
    if ~isvector(lat) || ~isvector(lon) || ~isequal(length(lat), length(lon))
        error('Lat (or x) and lon (or y) must be vectors or cells of vectors with identical dimensions');
    end
    lat = lat(:);
    lon = lon(:);
end
    
%---------------------------
% Split polygon(s) into 
% separate faces 
%---------------------------

if iscell(lat)
    [lat, lon] = polyjoin(lat, lon);  % In case multiple faces in one cell.
end

[latcells, loncells] = polysplit(lat, lon);

%---------------------------
% Create buffer shapes
%---------------------------

plotflag = 0;

if plotflag
    
    Plt.x = lon;
    Plt.y = lat;
    
end

latcrall = cell(0);
loncrall = cell(0);

for ipoly = 1:length(latcells)
    
    % Circles around each vertex
    
    if geo
        [latc, lonc] = calccircgeo(latcells{ipoly}, loncells{ipoly}, dist, npts);
    else
        [lonc, latc] = calccirccart(loncells{ipoly}, latcells{ipoly}, dist, npts);
    end
    
    % Rectangles around each edge
    
    if geo
        [latr, lonr] = calcrecgeo(latcells{ipoly}, loncells{ipoly}, dist);
    else
        [lonr, latr] = calcreccart(loncells{ipoly}, latcells{ipoly}, dist);
    end
    
    % Union of circles and rectangles
    
    if plotflag
        Plt.rectx = lonr;
        Plt.recty = latr;
        Plt.circx = lonc;
        Plt.circy = latc;
    end
    
    [latc, lonc] = multipolyunion(latc, lonc);
    [latr, lonr] = multipolyunion(latr, lonr);
    
    if plotflag
        Plt.rectcombox = lonr;
        Plt.rectcomboy = latr;
        Plt.circcombox = lonc;
        Plt.circcomboy = latc;
    end
    
    [loncr, latcr] = polybool('+', lonr, latr, lonc, latc);
    
    % Union of new circle/rectangle combo with that from other faces
    
    [loncrall, latcrall] = polybool('+', loncrall, latcrall, loncr, latcr);
    
    % Plotting (for debugging only)
    
    if plotflag 
        
        Plt.allx = loncrall;
        Plt.ally = latcrall;
        
        if ipoly == 1
            figure;
            plot(Plt.x, Plt.y, 'k', 'linewidth', 2);
            hold on
        end
        
        plot(cat(2, Plt.rectx{:}), cat(2, Plt.recty{:}), 'b');
        plot(cat(2, Plt.circx{:}), cat(2, Plt.circy{:}), 'r');
        plot(Plt.allx{1}, Plt.ally{1}, 'g', 'linewidth', 2);
        
    end
    
end

%---------------------------
% Calculate union/difference
%---------------------------

switch direction
    case 'out'
        [lonb, latb] = polybool('+', loncells, latcells, loncrall, latcrall);
    case 'in'
        [lonb, latb] = polybool('-', loncells, latcells, loncrall, latcrall);
end

if plotflag
    [Plt.yfinal, Plt.xfinal] = polyjoin(latb, lonb);
    plot(Plt.xfinal, Plt.yfinal, 'linestyle', '--', 'color', [0 .5 0], 'linewidth', 2);
end

%---------------------------
% Reformat output
%---------------------------

if ~geo
    y = latb; % Switch, since cartesion uses opposite order
    x = lonb;
    latb = x;
    lonb = y;
end

switch outputformat
    case 'vector'
        [latb, lonb] = polyjoin(latb, lonb);
    case 'cutvector'
        [latb, lonb] = polycut(latb, lonb);
    case 'cell'
end


%**************************************************************************

function [latc, lonc] = calccircgeo(lat, lon, radius, npts)
% lat and lon: n x 1 vectors
% radius: scalar

radius = ones(length(lat),1) * radius;
[latc, lonc] = scircle1(lat, lon, radius, [], [], [], npts);
latc = num2cell(latc, 1);
lonc = num2cell(lonc, 1);

function [latr, lonr] = calcrecgeo(lat, lon, halfwidth)
% lat and lon: n x 1 vectors
% halfwidth: scalar

range = halfwidth * ones(length(lat)-1, 1);

az = azimuth(lat(1:end-1), lon(1:end-1), lat(2:end), lon(2:end));

[latbl1,lonbl1] = reckon(lat(1:end-1), lon(1:end-1), range, az-90);
[latbr1,lonbr1] = reckon(lat(1:end-1), lon(1:end-1), range, az+90);
[latbl2,lonbl2] = reckon(lat(2:end),   lon(2:end),   range, az-90);
[latbr2,lonbr2] = reckon(lat(2:end),   lon(2:end),   range, az+90);

latr = [latbl1 latbl2 latbr2 latbr1 latbl1]';
lonr = [lonbl1 lonbl2 lonbr2 lonbr1 lonbl1]';
latr = num2cell(latr, 1);
lonr = num2cell(lonr, 1);
        
function [latu, lonu] = multipolyunion(lat, lon)
% lat and lon are n x 1 cell arrays of vectors

latu = lat{1};    
lonu = lon{1};

for ip = 2:length(lat)
    [lonu, latu] = polybool('+', lonu, latu, lon{ip}, lat{ip});
end
[latu, lonu] = polysplit(latu, lonu);


function [xc, yc] = calccirccart(x, y, radius, npts)

ang = linspace(0, 2*pi, npts+1);
ang = ang(end-1:-1:1);
xc = bsxfun(@plus, x, radius * cos(ang));
yc = bsxfun(@plus, y, radius * sin(ang));
xc = num2cell(xc', 1);
yc = num2cell(yc', 1);

% if ~ispolycw(x,y)
%     [xc,yc] = poly2ccw(xc,yc);
% end

function [xrec, yrec] = calcreccart(x, y, halfwidth)

dx = diff(x);
dy = diff(y);
   
is1 = dx >= 0 & dy >= 0;
is2 = dx < 0 & dy >= 0;
is3 = dx < 0 & dy < 0;
is4 = dx >= 0 & dy < 0;

ish1 = dy == 0 & dx > 0;
ish2 = dy == 0 & dx < 0;


theta = zeros(5,1);
theta(is1 | is3) = atan(dy(is1 | is3)./dx(is1 | is3));
theta(is2 | is4) = -atan(dy(is2 | is4)./dx(is2 | is4));

[xl,xr,yl,yr] = deal(zeros(size(dx)));

xl(is1) = -halfwidth * sin(theta(is1));
xr(is1) =  halfwidth * sin(theta(is1));
yl(is1) =  halfwidth * cos(theta(is1));
yr(is1) = -halfwidth * cos(theta(is1));

xl(is2) = -halfwidth * sin(theta(is2));
xr(is2) =  halfwidth * sin(theta(is2));
yl(is2) = -halfwidth * cos(theta(is2));
yr(is2) =  halfwidth * cos(theta(is2));

xl(is3) =  halfwidth * sin(theta(is3));
xr(is3) = -halfwidth * sin(theta(is3));
yl(is3) = -halfwidth * cos(theta(is3));
yr(is3) =  halfwidth * cos(theta(is3));

xl(is4) =  halfwidth * sin(theta(is4));
xr(is4) = -halfwidth * sin(theta(is4));
yl(is4) =  halfwidth * cos(theta(is4));
yr(is4) = -halfwidth * cos(theta(is4));

xrec = [xl+x(1:end-1) xl+x(2:end) xr+x(2:end) xr+x(1:end-1) xl+x(1:end-1)];
yrec = [yl+y(1:end-1) yl+y(2:end) yr+y(2:end) yr+y(1:end-1) yl+y(1:end-1)];

xrec = num2cell(xrec, 2);
yrec = num2cell(yrec, 2);




    
    

