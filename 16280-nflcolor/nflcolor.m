function [outColor] = nflcolor(teamName, colorType)
%NFLCOLOR Return NFL RGB color values by team or city name
%   COLOR = NFLCOLOR(TEAMNAME,COLORTYPE) returns the 3-element RGB
%   color values of an NFL team specified using the team's city name
%   (Buffalo for example) or by the team name (Bills for example).  The
%   type of color returned is determined by COLORTYPE, COLORTYPE must
%   either be 'team' for the primary team color or 'name for the color used
%   on jersy names.  If COLORTYPE is omitted, the primary team color is
%   output.  Inputs are not case sensitive.  Partial matches are
%   supported.  In cases where more than one match is found, the first
%   match is provided and a warning is generated.
%
%   Examples:
%
%   bengalsBlack = nflcolor('bengals', 'team');
%   bengalsOrange = nflcolor('bengals','name');
%   bengalsOrange = nflcolor('cinci','name');
%   dolphinAqua = nflcolor('miami');
%
%  Color values are from the following web site...
%  http://en.wikipedia.org/wiki/Template:Infobox_NFL_player#Team_colors
%
%  Note:  Giants fans may wish to edit this function and claim New York for
%  themselves. As written, the fuction gives Jets colors when New York is
%  provided as the team name.
%

% Define nfl colors, column 3 is team color, column 4 is name color
nflData = ...
    {'buffalo',        'bills',     '0f4589', 'ffffff';
    'miami',          'dolphins',  '005e6a', 'ffffff';
    'new england',    'patriots',  '0d254c', 'd6d6d6';
    'new york',       'jets',      '313f36', 'ffffff';
    'baltimore',      'ravens',    '2a0365', 'd0b239';
    'cincinnati',     'bengals',   '000000', 'f03a16';
    'cleveland',      'browns',    'de6108', '312821';
    'pittsburgh',     'steelers',  '000000', 'f1c500';
    'houston',        'texans',    '001831', 'ffffff';
    'indianapolis',   'colts',     '003b7b', 'ffffff';
    'jacksonville',   'jaguars',   '00576e', 'd0b239';
    'tennessee',      'titans',    '648fcc', '0d254c';
    'denver',         'broncos',   '10274c', 'df6109';
    'kansas city',    'chiefs',    'b20032', 'f2c800';
    'oakland',        'raiders',   '000000', 'c4c8cb';
    'san diego',      'chargers',  '08214a', 'eec607';
    'dallas',         'cowboys',   'c5ced6', '000080';
    'new york',       'giants',    '192f6b', 'ffffff';
    'philadelphia',   'eagles',    '003b48', 'c4c8cb';
    'washington',     'redskins',  '7d0008', 'ffbe26';
    'chicago',        'bears',     '03182f', 'df6108';
    'detroit',        'lions',     '005da6', 'c4c8cb';
    'green bay',      'packers',   '213d30', 'ffcc00';
    'minnesota',      'vikings',   '3b0160', 'f0bf00';
    'atlanta',        'falcons',   'bd0d18', '000000';
    'carolina',       'panthers',  '000000', '0088d4';
    'new orleans',    'saints',    '000000', 'c9b074';
    'tampa bay',      'buccaneers','b20032', 'ffffff';
    'arizona',        'cardinals', '870619', 'ffffff';
    'st louis',       'rams',      '0d254c', 'c9b074';
    'saint louis',    'rams',      '0d254c', 'c9b074';
    'st. louis',      'rams',      '0d254c', 'c9b074';
    'san francisco',  '49ers',     '840026', 'c9b074';
    'seattle',        'seahawks',  '03182f', '4eae17'};

idx=strmatch(lower(teamName),nflData(:,1:2));

if isempty(idx)
    error('Team name not found');
end

nEntries = size(nflData,1);
if idx(1)>nEntries
    idx(1) = idx(1)-nEntries;
end

if length(idx)>1
    warning('nflcolor:multipleMatches',['Found multiple matches for %s, ' ...
        'using %s'], teamName, nflData{idx(1),2});
end

if nargin<2
    colorType = 'team';
end

switch lower(colorType)
    case 'team'
        colorHex = nflData{idx(1),3};
    case 'name'
        colorHex = nflData{idx(1),4};
    otherwise
        error('Invalid colorType specified');
end

outColor = [hex2dec(colorHex(1:2)),...
    hex2dec(colorHex(3:4)),...
    hex2dec(colorHex(5:6))]/255;

