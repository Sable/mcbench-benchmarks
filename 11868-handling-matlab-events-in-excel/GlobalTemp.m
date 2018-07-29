function GlobalTemp
% GLOBALTEMP Explore global temperature history

% Load the topographical data for the globe
load('topo.mat', 'topo', 'topomap1');

% Load the temperature anomaly data
global MonthlyTempAnom DataCount StartYear StartMonth %#ok -- lint warning
load TempAnomData1880

% Create a unit sphere with 50 facets. This sphere is the Earth.
[x,y,z] = sphere(50);

% Establish initial viewing and lighting parameters. Use Phong shading and
% texture mapping to wrap the topo map data around the sphere.

props.AmbientStrength = 0.2;
props.SpecularColorReflectance = .5; 
props.SpecularStrength = .01;
props.DiffuseStrength = .5;
props.FaceColor= 'texture';
props.EdgeColor = 'none';
props.FaceLighting = 'phong';
props.CData = topo;

% Draw the sphere, with the topo data texture mapped to the surface.
surface(x,y,z,props);
axis square
axis off
axis equal
set(gcf, 'Name', 'Global Temperature History');

% http://en.wikipedia.org/wiki/List_of_metropolitan_areas_by_population
% http://www.getty.edu/research/conducting_research/vocabularies/tgn
[names,pop,lat,lng]=textread('Cities.csv', '%s%d%f%f', 'delimiter',',');
cities.names = names;
cities.population = pop;
cities.lat = lat;
cities.lng = lng;
names = cities.names(1:49);
ctrl = uicontrol('style','listbox','units','normalized', ...
            'position',[.01,.1,.2,.8], 'string', names, ...
            'Callback', @LocateCity, 'UserData', cities, ...
            'Tag', 'CityList');
set(ctrl, 'Value', round(rand * 48) + 1);
DataCount = FindTempData;
LocateCity(ctrl, []);

% Analyze the data and determine where temperature anomalies have been
% recorded. Draw a marker in the center of the 5x5 degree grid mark if good
% data is available for that area.
function count = FindTempData
global MonthlyTempAnom
[rows, cols] = size(MonthlyTempAnom{1});
count = zeros(rows, cols);
for i=1:length(MonthlyTempAnom)
    monthData = MonthlyTempAnom{i};
    for row = 1:rows
        for col = 1:cols
            if ~isnan(monthData(row, col))
                count(row, col) = count(row, col) + 1;
            end
        end
    end 
end 

function [x, y, z, cdata] = CreateMarkerSphere(rgb)
% Create a smaller marker sphere. This sphere will be used
% to mark the location of the given latitude and longitude
% on the Earth.
[x,y,z] = sphere(10);
x = x / 30;
y = y / 30;
z = z / 30;

% Color the sphere as indicated by the input color
cdata = zeros([size(z), 3]);
cdata(:,:,1) = rgb(1);
cdata(:,:,2) = rgb(2);
cdata(:,:,3) = rgb(3);

% Compute the row and column into which a given latitude and longitude
% falls.
function [row, col] = ComputeGridPoint(lat, lng)
if lat > 0, row = 18 - (lat / 5) + 1; else row = 18 + (-lat / 5); end
if lng < 0, col = (lng / 5) + 37; else col = 36 + (lng / 5); end
row = int32(row);
col = int32(col);

% Given a latitude and longitude, compute the coordinates of a grid (of a
% given size) surrounding it.
function [rows, cols] = ComputeGrid(lat, lng, sq)
global DataCount
rows = zeros(1, sq*2+1);
cols = zeros(1, sq*2+1);
[rowMax, colMax] = size(DataCount);
[originRow, originCol] = ComputeGridPoint(lat, lng);

for i=1:(sq*2)+1
    rows(i) = (originRow - sq - 1) + i;
    cols(i) = (originCol - sq - 1) + i;
    if rows(i) < 0, rows(i) = rowMax + rows(i); end
    if cols(i) < 0, cols(i) = colMax + cols(i); end
    
    if rows(i) > rowMax, rows(i) = rows(i) - rowMax; end
    if cols(i) > colMax, cols(i) = cols(i) - colMax; end
end

% Plot the data markers on the 3 x 3 grid surrounding the current
% location. Only plot markers where there is actual data.
function PlotDataMarkers(lat, lng)
global DataCount MonthlyTempAnom

% Find and delete the previous marker(s), if any
marker = findobj(gca, 'Tag', 'DataMarker');
for i=1:length(marker)
    delete(marker(i));
end

[xloc, yloc, zloc, cdata] = CreateMarkerSphere([.0902, .749, 0.3569]);

[rows, cols] = ComputeGrid(lat, lng, 2);

for row = rows
    for col = cols
        if (DataCount(row, col) > (length(MonthlyTempAnom)/2)) || ...
           (row == rows(3) && col == cols(3))
       
            lat = 90 - ((row - 1) * 5) - 2.5;
            lng = -180 + ((col - 1) * 5) + 2.5;
            % Turn the latitude and longitude into three-dimensional
            % Cartesian coordinates.
            [xoffset,yoffset,zoffset]=ComputeMapCoords(lat,lng);
            mxloc = xloc+xoffset;
            myloc = yloc+yoffset;
            mzloc = zloc+zoffset;
            ud.row = row;
            ud.col = col;
            ud.lat = lat;
            ud.lng = lng;
            s = surface(mxloc, myloc, mzloc, cdata, ...
                        'EdgeColor', 'none', ...
                        'ButtonDownFcn', @MarkerCallback, ...
                        'Tag', 'DataMarker', 'UserData', ud);
            if row == rows(3) && col == cols(3)
               set(s, 'CData', [], 'FaceColor', 'red'); 
               set(s, 'Tag', 'LocationMarker');
            end
        end
    end
end

function [x,y,z]=ComputeMapCoords(lat,lng)

% The origin of the latitude/longitude system is the intersection of the
% prime meridian and the equator (in the Gulf of Guinea, just below the
% bulge of Africa, on the Atlantic side of the continent). But the origin
% of the sphere's coordinate system (the longitude axis) is on the other side 
% of the Earth, somewhere in the Taklamakan desert in China. Adjust the
% longitude so the origin is in the correct place.
lng = lng + 180;

% Convert latitude and longitude, which come in as degrees, to radians, which 
% is what MATLAB's trigometric functions expect.
latrad = lat.*(pi/180);
longrad = lng.*(pi/180);

% Compute Earth-centered X, Y, and Z that correspond to the given latitude
% and longitude.
x = cos(latrad).*cos(longrad);
y = cos(latrad).*sin(longrad);
z = sin(latrad);

% Compute the sphereical angle between two points specified by
% latitude and longitude. If the points are represented as vectors,
% the dot product of the vectors is the cosine of the angle.
function a = SphericalAngle(lat1, lng1, lat2, lng2)
[x y z] = ComputeMapCoords(lat1, lng1);
v1 = [x y z];   % Convert cell array to array of doubles
[x y z] = ComputeMapCoords(lat2, lng2);
v2 = [x y z];   % Convert cell array to array of doubles
a = acos(dot(v1, v2));

function LocateCity(obj, eventdata)
% Find the previous marker(s), if any
marker = findobj(gca, 'Tag', 'LocationMarker');

[xloc, yloc, zloc, cdata] = CreateMarkerSphere([1, 0, 0]);

% Lookup the city's latitude and longitude in the user data
city = get(obj, 'Value');
data = get(obj, 'UserData');
lat = data.lat(city);
lng = data.lng(city);

% Turn the latitude and longitude into three-dimensional Cartesian
% coordinates.
[xoffset,yoffset,zoffset]=ComputeMapCoords(lat,lng);

% If there was just one marker, get its position. We only want to rotate
% the globe if the new mark is more than 45 degrees from the old one.
rotateGlobe = true;
if length(marker) == 1
    ud = get(marker, 'UserData');
    old_lat = ud.lat;
    old_lng = ud.lng;
    a = SphericalAngle(lat, lng, old_lat, old_lng);
    if  a <= (pi / 4)
        rotateGlobe = false;
    end
end

% Remove the previous markers from the globe
for i=1:length(marker)
    delete(marker(i));
end

for i=1:length(lat)
    
    % Stop processing if we encounter a NaN in the input array
    if (isnan(lat(i))), break, end;
    
	% Translate the marker sphere to the computed X, Y, Z position (this is
	% very easy to do since the marker is originally located at the origin 
	% -- simply add the X, Y, and Z values of the position to the corresponding 
	% X, Y and Z coordinate of the marker sphere.
	mxloc = xloc+xoffset(i);
	myloc = yloc+yoffset(i);
	mzloc = zloc+zoffset(i);
	
	% Draw a lovely red marker sphere at the given latitude and longitude. Must
	% turn off drawing of patch edges, or else the black from the patch edges
	% will swamp the patch red color and make the sphere look black.
    ud.lat = lat(i);
    ud.lng = lng(i);
%	surface(mxloc, myloc, mzloc, cdata, 'EdgeColor', 'none', ...
%           'ButtonDownFcn', @MarkerCallback, 'Tag', 'LocationMarker', ...
%           'UserData', ud);

    PlotDataMarkers(lat(i), lng(i));

end


% Set the viewpoint, if necessary
if rotateGlobe
    SetView(xoffset(1), yoffset(1), zoffset(1));
end

function SetView(x, y, z)
% Set the viewpoint directly above the first marker sphere.
if (isnan([x y z]))
    view([-146, 32]);
else
    view([x y z]*3);
end

% Force the camera angle to a value that causes the displayed globe to more
% or less fill up the axis. This value was discovered by experimentation.
set(gca, 'CameraViewAngle', 6.6);

function [latStr, lngStr] = position2str(lat, lng)
if lat > 0
    latStr = sprintf('%5.2f N', lat);
else
    latStr = sprintf('%5.2f S', -lat);
end
if lng > 0
    lngStr = sprintf('%5.2f W', lng);
else
    lngStr = sprintf('%5.2f E', -lng);
end

function xLabels = ComputeXLabels(xValues)
    labelCount = 7;
    
    labels(1) = xValues(1);
    labels(labelCount) = xValues(end);
    labelSpacing = (labels(labelCount) - labels(1)) / (labelCount - 1);
    for k = 2 : labelCount - 1
        labels(k) = labels(k - 1) + labelSpacing;
    end
    xLabels{1} = labels;
    xLabels{2} = cellstr(datestr(xLabels{1}, 'mmmyyyy'));

function MarkerCallback(obj, eventdata)
global DataCount MonthlyTempAnom
f = gcf;
set(f, 'Pointer', 'watch');
drawnow;
ud = get(obj, 'UserData');

city = 'Unknown';
cityCtrl = findobj(gcf, 'Tag', 'CityList');
if ~isempty(cityCtrl)
    cities = get(cityCtrl, 'UserData');
    selection = get(cityCtrl, 'Value');
    city = cities.names{selection};
end

DisplayLocation(city, ud.lat, ud.lng);
if DataCount(ud.row, ud.col) > (length(MonthlyTempAnom)/2)
    [latStr, lngStr] = position2str(ud.lat, ud.lng);
    [xValues, localAnomData, fitData] = ComputeTempData(ud);
    xData{1} = xValues;
    xData{2} = ComputeXLabels(xValues);
    
    PlotTempData(city, xData, localAnomData, fitData, ...
                 latStr, lngStr);
else
    [latStr lngStr] = position2str(ud.lat, ud.lng);
    disp(['No temperature data available for ' latStr ' ' lngStr]);
end

set(f, 'Pointer', 'arrow');

function [xlabelData, localAnomData, fitData] = ComputeTempData(ud)
global MonthlyTempAnom StartMonth StartYear

% Can't preallocate, because we don't know how many NaNs will be in the
% data set.
localAnomData=[];
x = [];
xlabelData = [];
for i=1:length(MonthlyTempAnom)
    monthData = MonthlyTempAnom{i};
    if ~isnan(monthData(ud.row, ud.col))
        localAnomData(end+1) = monthData(ud.row, ud.col);
        x(end+1) = i;
        year = double(StartYear + int32(floor((i - 1) / 12)));
        month = mod(double(StartMonth) - 1 + i - 1, 12) + 1;
        xlabelData(end+1) = datenum(year, month, 1);
    end
end
[p, s, mu] = polyfit(xlabelData, localAnomData, 4);
fitData = polyval(p, xlabelData, [], mu);

