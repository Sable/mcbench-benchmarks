function h = makescale(varargin)
%MAKESCALE creates a scale for map data.
%
%   MAKESCALE creates a scale on the current axis based on the current axis
%       limits. The scale is made to occupy 1/5th of the map. It is placed
%       in the southeast corner of the map. The units will either be in
%       milimeters, meters or kilometers, depending on the size of the map.
%
%   MAKESCALE(H_AXIS) creates a scale on the axis specificed by the handle
%       H_AXIS based on the its axes limits. H_AXIS must be a scalar.
%
%   MAKESCALE(SCALE) creates a scale made to occupy 1/SCALE of the map.
%       SCALE must be a scalar, and is bounded to be between 1.1 and 10. If
%       a larger value is passed in, 10 will be used. If a smaller value is
%       passed in, 1.1 will be used.
%
%   MAKESCALE(LOCATION) places the scale in the location specified by
%       LOCATION. Acceptable values for location are as follows
%           'northeast'     'ne'
%           'northwest'     'nw'
%           'southeast'     'se'
%           'southwest'     'sw'
%           'north'         'n'
%           'south'         's'
%
%   MAKESCALE('units',UNITS) changes the units systems from SI to imperical
%       units. UNITS should be either 'si' or 'imp.' The units displayed
%       are automatically switched between milimeters, meters, and
%       kilometers for the SI system, or between inches, feet, and statuate
%       miles for the imperical system.
%
%   H = MAKESCALE(...) outputs H, a 3x1 containing the handles of the of 
%       box, line, and text.
%
%   Any number of these input sets may be passed in any order.
%
%   The map scale will automatically be updated as the figure is zoomed,
%       panned, resized, or clicked on. It will not, however, be updated
%       upon using the commands "axis", "xlim", or "ylim" as these do not
%       have callback functionality.
%
%   Example:
%       load conus
%       figure
%       plot(uslon,uslat);
%       makeScale
%
%   Example: Placed in the south
%       load conus
%       figure
%       plot(uslon,uslat);
%       makeScale('south')
%
%   Example: Half the size of the Window
%       load conus
%       figure
%       plot(uslon,uslat);
%       makeScale(2,'south')
%
%   Example: Use Imperical Units
%       load conus
%       figure
%       plot(uslon,uslat);
%       makeScale(2,'south','units','imp')
%
%   Example: Zooming In
%       load conus
%       figure
%       plot(uslon,uslat);
%       makeScale(2,'south')
%       zoom(2)
%
%   Note: This assumes axis limits are in degrees. The scale is sized
%       correctly for the center latitude of the map. As the size of 
%       degrees longitude change with latitude, the scale becomes invalid 
%       with very large maps. Spherical Earth is assumed. Ideally, the map
%       will be proportioned correctly in order to reflect the relationship
%       between a degree latitude and a degree longitude at the center of 
%       the map.
%
% By Jonathan Sullian - October 2011

% Check to make sure the correct number of inputs are passed in.
error(nargchk(0,5,nargin,'struct'));

% Parse Inputs
[anum,latlim,lonlim,scale,location,units] = parseInputs(varargin{:});
if ~isreal(scale)
    error('MAKESCALE:ScaleVal','SCALE must be a real number')
end

% Bound the scale
if scale < 1.1 || scale > 10
    warning('MAKESCALE:ScaleVal','SCALE has been capped to be between 1.1 and 10 for readability.')
end
scale = min(max(scale,1.1),10);
earthRadius = 6371000;

% Get the distance of the map
mlat = mean(latlim);
if abs(mlat) > 90;
    d = 0;
else
    d = earthRadius.*cosd(mlat).*deg2rad(diff(lonlim));
end
dmax = d/1.1;
dmin = d/10;
dlat = diff(latlim);
dlon = diff(lonlim);

% Calculate the distance of the scale bar
rnd2 = floor(log10(d/scale))-1;
dscale = round2(d/scale,10^rnd2);

% Cap it
if dscale > dmax;
    rnd2 = rnd2 - 1;
    dscale = round2(dmax,10^rnd2);
end
if dscale < dmin
    rnd2 = rnd2 - 1;
    dscale = round2(dmin,10^rnd2);
end

% Make the text string
if strcmpi(units,'si')
    if d > 1e3*scale
        dst = num2str(dscale/1e3);
        lbl = ' km';
    elseif d > scale
        dst = num2str(dscale);
        lbl = ' m';
    else
        dst = num2str(dscale*1e3);
        lbl = ' mm';
    end
else
    if d > scale/0.000621371192
        rnd2 = floor(log10(d/scale*0.000621371192))-1;
        dscale = round2(d/scale*0.000621371192,10^rnd2);
        dst = num2str(dscale);
        lbl = ' mi';
        dscale = dscale/0.000621371192;
    elseif d > scale*0.3048
        rnd2 = floor(log10(d/scale/0.3048))-1;
        dscale = round2(d/scale/0.30482,10^rnd2);
        dst = num2str(dscale);
        lbl = ' ft';
        dscale = dscale*.3048;
    else
        rnd2 = floor(log10(d/scale/0.3048*12))-1;
        dscale = round2(d/scale/0.30482*12,10^rnd2);
        dst = num2str(dscale);
        lbl = ' in';
        dscale = dscale/12*.3048;
    end
end

% Get the postions
d1 = [-0.02 0.05];
issouth = 0;
iseast = 0;
iswest = 0;
switch lower(location)
    case {'southeast','se'}
        issouth = 1;
        iseast = 1;
    case {'northeast','ne'}
        iseast = 1;
    case {'southwest','sw'}
        issouth = 1;
        iswest = 1;
    case {'northwest','nw'}
        iswest = 1;
    case {'north','n'}
    case {'south','s'}
        issouth = 1;
end

if issouth
    slat = latlim(1)+0.05*diff(latlim);
else
    slat = latlim(end)-0.08*diff(latlim);
end

if iseast
    slon = lonlim(end)-0.05*diff(lonlim);
    slon = [slon slon-rad2deg(dscale./(earthRadius.*cosd(mlat)))];
    slat = [slat slat];
elseif iswest
    slon = lonlim(1)+0.05*diff(lonlim);
    slon = [slon slon+rad2deg(dscale./(earthRadius.*cosd(mlat)))];
    slat = [slat slat];
    slon = fliplr(slon);
else
    slon = mean(lonlim);
    slon = slon + [-rad2deg(dscale./(earthRadius.*cosd(mlat)))/2 rad2deg(dscale./(earthRadius.*cosd(mlat))/2)];
    slat = [slat slat];
    slon = fliplr(slon);
end

% Get the box location
blat = [slat([2 1])+[d1(1)*dlat d1(2)*dlat] slat([1 2])+[d1(2)*dlat d1(1)*dlat]];
blat = blat([2:4 1]);
blon = [slon+[0.02*dlon -0.02*dlon] slon([2 1])+[-0.02*dlon 0.02*dlon]];

% Delete Old Scale
aold = gca;
axes(anum);
ch = get(anum,'Children');
isOldScale = strcmpi(get(ch,'Tag'),'MapScale');
delete(ch(isOldScale));

% Make the scale
washold = ishold;
hold on
hbox = patch(blon,blat,'w');
set(hbox,'Tag','MapScale');
hline = plot(slon,slat,'k','LineWidth',3);
set(hline,'Tag','MapScale');
units_axis = get(gca,'Units');
set(gca,'Units','Inches')
pos = get(gca,'OuterPosition');
sz = mean(pos(4));
htext = text(mean(blon),mean(blat)+.01*dlat,[dst lbl],'HorizontalAlignment','center','FontSize',sz*2.3);
hzoom = zoom;
hpan = pan(gcf);
set(htext,'Tag','MapScale')
set(gca,'Units',units_axis);

% Set Resizer/Zoom/Pan/Click Callbacks
set(gcf,'ResizeFcn',{@ChangeTextSize,gca,htext});
set(hzoom,'ActionPostCallback',{@remakeZoomPanClick,anum,location,scale,units});
set(hpan,'ActionPostCallback',{@remakeZoomPanClick,anum,location,scale,units});
set(anum,'ButtonDownFcn',{@remakeZoomPanClick,anum,location,scale,units});
axes(aold);

% Output Handles
if nargout > 0
    h = [hbox; hline; htext];
end

% Restore Hold Off
if ~washold
    hold off
end

% Change the text font on figure resize.
function ChangeTextSize(~,~,anum,htext)
units = get(anum,'Units');
set(anum,'Units','Inches')
pos = get(anum,'OuterPosition');
sz = mean(pos(4));
set(htext,'FontSize',sz*2.3);
set(anum,'Units',units);

function remakeZoomPanClick(~,~,anum,location,scale,units)
makescale(anum,location,scale,'units',units);

function x = round2(x,base)
x = round(x./base).*base;

function [anum,latlim,lonlim,scale,location,units] = parseInputs(varargin)
% Default Values
anum = gca;
scale = 5;
location = 'se';
units = 'si';

% Loop through number of arguments in
ii = 1;
while ii <= length(varargin)
    
    % Either a axis number, or a scale value
    if isscalar(varargin{ii}) && isnumeric(varargin{ii})
        
        % Is it a non-root handle?
        if ishandle(varargin{ii}) && varargin{ii} ~= 0
            
            % Check if it is an axis number, not a figure number
            pos = get(varargin{ii},'ActivePositionProperty');
            if strcmpi(pos,'outerposition')
                anum = varargin{1};
                ii = ii + 1;
                continue;
            end
        end
        
        % Scale Value
        scale = varargin{ii};
        ii = ii + 1;
    
    % Locations
    elseif ischar(varargin{ii})
        if strcmpi(varargin{ii},'units')
            units = varargin{ii+1};
            ii = ii + 2;
        else
            locs = {'northeast','ne','north','n','southeast','se','south',...
                's','southwest','sw','northwest','nw'};
            if ~ismember(lower(varargin{ii}),locs)
                locOut = 'northeast, ne, north, n, southeast, se, south, s, southwest, sw, northwest, nw';
                error('MAKESCALE:LOCS',['LOCATION must be one of the following: ' locOut])
            end
            location = varargin{ii};
            ii = ii + 1;
        end
    end
end

% Get limits
latlim = get(anum,'YLim');
lonlim = get(anum,'XLim');