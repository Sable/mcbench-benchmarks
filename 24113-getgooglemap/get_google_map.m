function [XX YY M Mcolor] = get_google_map(lat, lon, varargin)
%% Gets a google map using the Google Static Maps API
% 
% REQUIREMENTS:
% 1)  deg2utm() (Conversion from degrees to UTM coordinates, found on
% MATLAB Central. 
%
% 2)  THIS FUNCTION REQUIRES A GOOGLE MAPS API KEY! (READ ON)
% To query and return a Google Map using the Google Static Map API, Google
% requires that you have a valid MAPS API KEY. The key is free and only
% requires a Google account and a valid domain (e.g. http://ccom.unh.edu )
% from which your queries will come. Note, this last requirement places
% serious limitations on the portability of this function, as it is
% necessarily tied to a domain and therefore (usually) a physical location.
% 
% A Google Maps API Key may be obtained here: 
% http://code.google.com/apis/maps/signup.html
%
% Once you obtain your key, replace the text assigned to the MAPS_API_KEY
% variable below with your own.
%
% USAGE:
%
% [XX YY M Mcolor] = get_google_map( latitude, longitude, ...
%                              Property, Value,...
%                              Property, Value)
%
% PROPERTIES:
%    Height (640)      Height of the image in pixels (max 640)
%    Width  (640)      Width of the image in pixels (max 640)
%    Zoom (15)         Zoom Level (1-19) Zoom of 15 = ~3.4m/pixel.
%    MapType ('satellite')  Type of map to return. Any of [roadmap, mobile,
%                           satellite, terrain, hybrid, mapmaker-roadmap,
%                           mapmaker-hybrid) See the Google Maps API for
%                           more information.
%    Marker            The marker argument is a text string with fields
%                      conforming to the Google Maps API. The following are
%                      valid examples:
%                      '43.0738740,-70.713993' (dflt midsize orange marker)
%                      '43.0738740,-70.713993,blue' (midsize blue marker)
%                      '43.0738740,-70.713993,yellowa' (midsize yellow
%                      marker with label "A")
%                      '43.0738740,-70.713993,tinyredb' (tiny red marker
%                      with label "B")
%
% RESULTS:
%    XX                Estimate of Easting pixel coordinates in UTM
%    YY                Estimate of Northing pixel coordinates in UTM
%    M                 Image data matrix (height x width)
%    Mcolor            Image colormap
%
% EXAMPLE:
%
%    % Get the map
%    [XX YY M Mcolor] = get_google_map(43.0738740,-70.713993);
%    % Plot the result
%    surf(XX,YY,M,'edgecolor','none'); view(0,90);
%    colormap(Mcolor)
%    
%    
%
% References:
% http://code.google.com/apis/maps/documentation/staticmaps
%
% KNOWN BUGS AND ISSUES:
% 1) MAP Bounds. The bounds reported by this function are an approximation
% based on repeated trials, as there is no way (to my knowledge) in which
% to query Google for the bounds of the map image exactly. This method is
% potentially ripe with errors. For example, it may not produce correct
% bounds at latitudes far from 40 degrees N/S where it was calibrated. 
% 2) No provision has been programmed to handle locations near the date
% line, nor boundaries between UTM zones. Images that cross these will
% likely produce improper bounds.
% 
% * Val Schmidt
% * University of New Hampshire
% * Center for Coastal and Ocean Mapping
% * 2009

% Google Maps Key for http://ccom.unh.edu
MAPS_API_KEY = ['ABQIAAAAqBqn7dm-6ws6RLEK9XaSDxQ6n5qvme' ...
    '0SKJPROylIC_z_Oi6EeBT9ewTITS1Q_3k2gpPkop2Yf8f_9A'];

% HANDLE ARGUMENTS

height = 640;
width = 640;
zoomlevel = 15;
maptype = 'satellite';

markeridx = 1;
markerlist = {};
if nargin > 2
    for idx = 1:2:length(varargin)
        switch lower(varargin{idx})
            case 'height'
                height = varargin{idx+1};
            case 'width'
                width = varargin{idx+1};
            case 'zoom'
                zoomlevel = varargin{idx+1};
            case 'maptype'
                maptype = varargin{idx+1};
            case 'marker'
                markerlist{markeridx} = varargin{idx+1};
                markeridx = markeridx + 1;
            otherwise
                error(['Unrecognized variable: ' varargin{idx}])
        end
    end
end


if zoomlevel <1 || zoomlevel > 19
    error('Zoom Level must be > 0 and < 20.')
end

if mod(zoomlevel,1) ~= 0
    zoomlevel = round(zoomlevel)
    warning(['Zoom Level must be an integer. Rounding to '...
        num2str(zoomlevel)]);
end

% ESTIMATE BOUNDS OF IMAGE:
%
% Normally one must specify a center (lat,lon) and zoom level for a map.
% Zoom Notes:
% ZL: 15, hxw = 640x640, image dim: 2224.91 x 2224.21 (mean 2224.56)
% ZL: 16, hxw = 640x640, image dim: 1128.01m x 1111.25m (mean 1119.63)
% This gives an equation of roughly (ZL-15)*3.4759 m/pix * pixels
% So for an image at ZL 16, the LHS bound is 
% LHS = centerlonineastings - (zl-15) * 3.4759 * 640/2;
[lonutm latutm zone] = deg2utm(lat,lon);
Hdim = (2^15/2^zoomlevel) * 3.4759 * width;
Vdim = (2^15/2^zoomlevel) * 3.4759 * height;

ell = lonutm - Hdim/2;
nll = latutm - Vdim/2;
eur = lonutm + Hdim/2;
nur = latutm + Vdim/2;

YY = linspace(nll,nur,height);
XX = linspace(ell,eur,width);

% CONSTRUCT QUERY URL
preamble = 'http://maps.google.com/staticmap';
location = ['?center=' num2str(lat,10) ',' num2str(lon,10)];
zoom = ['&zoom=' num2str(zoomlevel)];
size = ['&size=' num2str(width) 'x' num2str(height)];
maptype = ['&maptype=' maptype ];
markers = '&markers=';
for idx = 1:length(markerlist)
    if idx < length(markerlist)
            markers = [markers markerlist{idx} '%7C'];
    else
            markers = [markers markerlist{idx}];
    end
end
format = '&format=gif';
key = ['&key=' MAPS_API_KEY];
sensor = '&sensor=false';
url = [preamble location zoom size maptype format markers key sensor];

% GET THE IMAGE
filename = urlwrite(url,'tmp.gif');
[M Mcolor] = imread(filename);
M = cast(M,'double');

% CLEAN UP
delete(filename);
