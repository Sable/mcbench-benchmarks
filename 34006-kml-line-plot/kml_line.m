function kml_line(lon, lat, varargin)
% KML_LINE    Draw nan-separated lines (or single line) onto Google Earth.
%
% Syntax:
%     KML_LINE(LON, LAT) writes nan-separated lines specified
%     in LON and LAT to an output file, doc.kml
%     KML_LINE(LON, LAT, NAME) writes nan-separated lines specified
%     in LON and LAT to an output file, NAME.kml
%     KML_LINE(LON, LAT, NAME, COLOR) writes lines same as above but with
%     MATLAB color value (default is 'w').
%     KML_LINE(LON, LAT, NAME, WIDTH) writes lines same as above but with
%     width WIDTH (default is 1).
%     KML_LINE(LON, LAT, NAME, COLOR, WIDTH) writes lines same as above but
%     with width WIDTH and color COLOR.
%
% Input:
%     LON: 1-D array of longitude line values. Separate lines are separated
%     by a NaN. Must correspond to LAT.
%     LAT: 1-D array of latitude line values. Separate lines are separated
%     by a NaN. Must correspond to LON.
%     NAME: String name of output file (without the .kml extension)
%     COLOR: MATLAB color (default is 'w'), supports vector colors.
%     WIDTH: int or float width value (default is 1)
%
% Output:
%     This function creates a kml file called NAME.kml in the current
%     working directory
%
% Examples:
%     % four different ways of calling kml_line:
%     load('palau_coastline.mat');
%     kml_line(lon_coast, lat_coast, 'palau_coastline');
%     kml_line(lon_coast, lat_coast, 'palau_coastline', 'r');
%     kml_line(lon_coast, lat_coast, 'palau_coastline', 1.5);
%     kml_line(lon_coast, lat_coast, 'palau_coastline', 'magenta', 2);
%

%
% Cameron Sparr - Nov. 31, 2011
% cameronsparr@gmail.com
%
    if nargin > 2
        name = varargin{1};
        % defensive programming:
        if ~ischar(name)
            error('NAME must be a string!');
        end
    else
        name = 'doc';
    end
    
    % color and linestyle property stuff:
    color = ge_color('w');
    width = 1;
    for k = 2:length(varargin)
        property = varargin{k};
        if ischar(property)
            color = ge_color(property);
        else
            if length(property) > 1
                color = ge_color(property);
            else
                width = property;
            end
        end
    end
    

    kmlfile = fopen([name, '.kml'], 'w');
    kml_begin(kmlfile, name, color, width);
    line_begin(kmlfile);
    for i = 1:length(lon)
        if isnan(lon(i))
            line_end(kmlfile); 
            line_begin(kmlfile);
        else
            templon = num2str(lon(i),10);
            templat = num2str(lat(i),10);
            fprintf(kmlfile, [templon, ',', templat, ',0 ']);
        end
    end
    line_end(kmlfile); 


    kml_end(kmlfile);
end

function kml_begin(kmlfile, name, color, width)
    fprintf(kmlfile, '<?xml version="1.0" encoding="UTF-8"?>\n');
    fprintf(kmlfile, '<kml xmlns="http://www.opengis.net/kml/2.2"');
    fprintf(kmlfile, ' xmlns:gx="http://www.google.com/kml/ext/2.2"');
    fprintf(kmlfile, ' xmlns:kml="http://www.opengis.net/kml/2.2"');
    fprintf(kmlfile, ' xmlns:atom="http://www.w3.org/2005/Atom">\n');
    fprintf(kmlfile, '<Document>\n');
    fprintf(kmlfile, ['	<name>',name,'.kml</name>\n']);
    
    fprintf(kmlfile, '	<Style id="linestyle">\n');
    fprintf(kmlfile, '			<LineStyle>\n');
    fprintf(kmlfile, '				<color>#FF');
    fprintf(kmlfile, color);
    fprintf(kmlfile, '</color>\n');
    fprintf(kmlfile, '				<width>');
    fprintf(kmlfile, num2str(width));
    fprintf(kmlfile, '</width>\n');
    fprintf(kmlfile, '			</LineStyle>\n');
    fprintf(kmlfile, '	</Style>\n');
end

function kml_end(kmlfile)
    fprintf(kmlfile, '</Document>\n');
    fprintf(kmlfile, '</kml>\n');
    fclose(kmlfile);
end

function line_begin(kmlfile)
    fprintf(kmlfile, '	<Placemark>\n');
    fprintf(kmlfile, ['		<name>untitled</name>\n']);
    fprintf(kmlfile, '		<styleUrl>#linestyle</styleUrl>\n');
    fprintf(kmlfile, '		<LineString>\n');
    fprintf(kmlfile, '			<tessellate>1</tessellate>\n');
    fprintf(kmlfile, '			<altitudeMode>clampToSeaFloor</altitudeMode>\n');
    fprintf(kmlfile, '			<gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>\n');
    fprintf(kmlfile, '			<coordinates>\n');
    fprintf(kmlfile, '				');
end

function line_end(kmlfile)
    fprintf(kmlfile, '\n');
    fprintf(kmlfile, '			</coordinates>\n');
    fprintf(kmlfile, '		</LineString>\n');
    fprintf(kmlfile, '	</Placemark>\n');
end

function clrstr=ge_color(c,varargin)
%Jarrell Smith
%3/4/2008
    opacity=1;
    cspec=[0,0,0];

    nargchk(nargin,1,2);
    if nargin==2,
       mode='both';
       opacity=varargin{1};
       if length(opacity)>1 || ~isnumeric(opacity),
          error('Opacity must be numeric and length 1')
       elseif opacity>1 || opacity<0,
          error('Opacity must be between 0-1')
       end
    else
       mode='color';
    end
    if ischar(c), %process as color
       switch lower(c)
          case {'y','yellow'}
             cspec=[1,1,0];
          case {'m','magenta'}
             cspec=[1,0,1];
          case {'c','cyan'}
             cspec=[0,1,1];
          case {'r','red'}
             cspec=[1,0,0];
          case {'g','green'}
             cspec=[0,1,0];
          case {'b','blue'}
             cspec=[0,0,1];
          case {'w','white'}
             cspec=[1,1,1];
          case {'k','black'}
             cspec=[0,0,0];
          otherwise
             error('%s is an invalid Matlab ColorSpec.',c)
       end
    elseif isnumeric(c) && ndims(c)==2, %Determine if Color or Opacity
       if  all(size(c)==[1,1]), %Input is Opacity
          if c>1 || c<0
             error('Opacity must be scalar quantity between 0 to 1')
          end
          opacity=c;
          mode='opacity';
       %color
       elseif all(size(c)==[1,3]) %Input is Color
          if any(c<0|c>1)
             error('Numeric ColorSpec must be size [1,3] with values btw 0 to 1.')
          end
          cspec=c;
       else
          error('Incorrect size of first input argument.  Size must be [1,3] or [1,1].')
       end
    else
       error('Incorrect size of first input argument.  Size must be [1,3] or [1,1].')
    end
    opacity=round(opacity*255); %transparency (Matlab format->KML format)
    cspec=round(fliplr(cspec)*255); %color (Matlab format->KML format)
    switch mode
       case 'color'
          clrstr=sprintf('%s%s%s',dec2hex(cspec,2)');
       case 'opacity'
          clrstr=sprintf('%s',dec2hex(opacity,2));
       case 'both'
          clrstr=sprintf('%s%s%s%s',dec2hex(opacity,2),dec2hex(cspec,2)');
    end
end