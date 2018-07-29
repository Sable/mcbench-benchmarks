function kml_contour(lon, lat, z, varargin)
% KML_CONTOUR      overlay MATLAB contour lines onto Google Earth
%
% Syntax:
%     KML_CONTOUR(LON,LAT,Z) writes contour lines in the same format as
%     matlab's CONTOUR(LON,LAT,Z) or CONTOURC(LON,LAT,Z).
%     KML_CONTOUR(LON,LAT,Z,N) draws N contour lines, overriding the
%     automatic value
%     KML_CONTOUR(LON,LAT,Z,V) draws LENGTH(V) contour lines at the values
%     specified in the vector V
%     KML_CONTOUR(LON,LAT,Z,[v v]) computes a single contour at the level v
%
% Input:
%     LON: This can be either a matrix the same size as Z or a vector with
%     length the same as the number of columns in Z.
%     LAT: This can be either a matrix the same size as Z or a vector with
%     length the same as the number of rows in Z.
%     Z: Matrix of elevations
%
% Output:
%     This function creates a kml file called 'doc.kml' in the current
%     working directory
%

%
% Cameron Sparr - Nov. 10, 2011
% cameronsparr@gmail.com
%
    
    % STYLES:
    % Edit the width, color, and labelsize as you see fit.
    %       color: MATLAB color value (default is 'w')
    %       width: int or float (default is 1)
    %       labelsize: size of text contour labels (default is 0.9)
    color = ge_color('w');
    width = 1;
    labelsize = 0.9;
    
    % FEEL FREE TO PLAY AROUND WITH THE VALUES SPECIFIED BELOW FOR
    % 'labellimit', 'labelspace', and 'contourlimit'
    %
    % Limit to how many points on a contour line are required for the
    % function to place an altitude label:
    labellimit = round(sqrt(sqrt(numel(z))));
    % Spacing between altitude labels:
    labelspace = labellimit * 8;
    % Contour lines with length below the following limit will not be drawn
    contourlimit = round(labellimit / 3);
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    % output kml file:
    kmlfile = fopen('doc.kml', 'w');
    if size(lon) == size(z)
        matlabel = true;
        [c, h] = contour(lon, lat, z, varargin{:});
        %close(gcf);
    else
        matlabel = false;
        c = contourc(lon, lat, z, varargin{:});
    end
    
    % specifies position in the 'c' matrix returned from MATLAB's CONTOUR
    % function. 
    ind = 1;
    
    % begin writing kml file:
    kml_begin(kmlfile, labelsize, color, width);
    
    while ind < length(c)
        % altitude of current contour line
        zz = c(1,ind);
        % length of current contour line
        s = c(2,ind);
        
        % current contour line
        clon = c(1, ind+1 : ind+s);
        clat = c(2, ind+1 : ind+s);
        
        if ~matlabel
            % come up with my own contour labelling scheme...
            plon = c(1, ind+1);
            plat = c(2, ind+1);
            if s > labellimit
                place_label(kmlfile, plon, plat, zz);
            end

            for j = 1:numel(clon)
                if mod(j, labelspace) == 0
                    place_label(kmlfile, clon(j), clat(j), zz);
                end
            end
        end

        line_begin(kmlfile, zz);
        for i = 1:numel(clon)
            lon = num2str(clon(i), 8);
            lat = num2str(clat(i), 8);
            fprintf(kmlfile, [lon, ',', lat, ',',num2str(zz),' ']);
        end
        line_end(kmlfile);

        % move ind up to the next contour line.
        ind = ind + s + 1;
    end
    
    if matlabel
        disp('Using MATLAB native contour label positions');
        % use matlab positions for contour labels.
        lh = clabel(c,h);
        pos = get(lh, 'position');
        height = get(lh, 'UserData');
        close(gcf);
        for ii = 1:length(pos)
            mlon = pos{ii}(1);
            mlat = pos{ii}(2);
            zzz = height{ii}(1);
            place_label(kmlfile, mlon, mlat, zzz);
        end
    else
        disp('Using proprietary contour label positions');
    end

    
    kml_end(kmlfile);
end




function kml_begin(kmlfile, labelsize, color, width)
    fprintf(kmlfile, '<?xml version="1.0" encoding="UTF-8"?>\n');
    fprintf(kmlfile, '<kml xmlns="http://www.opengis.net/kml/2.2"');
    fprintf(kmlfile, ' xmlns:gx="http://www.google.com/kml/ext/2.2"');
    fprintf(kmlfile, ' xmlns:kml="http://www.opengis.net/kml/2.2"');
    fprintf(kmlfile, ' xmlns:atom="http://www.w3.org/2005/Atom">\n');
    fprintf(kmlfile, '<Document>\n');
    fprintf(kmlfile, '	<name>doc.kml</name>\n');
    
    fprintf(kmlfile, '	<Style id="sn_noicon">\n');
    fprintf(kmlfile, '      <IconStyle>\n');
    fprintf(kmlfile, '          <Icon>\n');
    fprintf(kmlfile, '          </Icon>\n');
    fprintf(kmlfile, '      </IconStyle>\n');
    fprintf(kmlfile, '      <LabelStyle>\n');
    fprintf(kmlfile, '          <scale>');
    fprintf(kmlfile, num2str(labelsize));
    fprintf(kmlfile, '</scale>\n');
    fprintf(kmlfile, '      </LabelStyle>\n');
    fprintf(kmlfile, '	</Style>\n');
    
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

function line_begin(kmlfile, zz)
    fprintf(kmlfile, '	<Placemark>\n');
    fprintf(kmlfile, ['		<name>', num2str(zz),'</name>\n']);
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

function place_label(kmlfile, plon, plat, z)
    z = round(z);
    fprintf(kmlfile, '	<Placemark>\n');
    fprintf(kmlfile, ['		<name>', num2str(z),'</name>\n']);
    fprintf(kmlfile, '		<styleUrl>#sn_noicon</styleUrl>\n');
    fprintf(kmlfile, '		<Point>\n');
    fprintf(kmlfile, '			<altitudeMode>clampToSeaFloor</altitudeMode>\n');
    fprintf(kmlfile, '			<gx:altitudeMode>clampToSeaFloor</gx:altitudeMode>\n');
    fprintf(kmlfile, ['			<coordinates>',num2str(plon, 8),',',num2str(plat, 8),',0</coordinates>\n']);
    fprintf(kmlfile, '		</Point>\n');
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