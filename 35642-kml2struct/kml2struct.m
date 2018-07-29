function kmlStruct = kml2struct(kmlFile)
% kmlStruct = kml2struct(kmlFile)
%
% Import a .kml file as a vector array of shapefile structs, with Geometry, Name,
% Description, Lon, Lat, and BoundaryBox fields.  Structs may contain a mix
% of points, lines, and polygons.
%
% .kml files with folder structure will not be presented as such, but will
% appear as a single vector array of structs.
%
% 

[FID msg] = fopen(kmlFile,'rt');

if FID<0
    error(msg)
end

txt = fread(FID,'uint8=>char')';
fclose(FID);

expr = '<Placemark.+?>.+?</Placemark>';

objectStrings = regexp(txt,expr,'match');

Nos = length(objectStrings);

for ii = 1:Nos
    % Find Object Name Field
    bucket = regexp(objectStrings{ii},'<name.*?>.+?</name>','match');
    if isempty(bucket)
        name = 'undefined';
    else
        % Clip off flags
        name = regexprep(bucket{1},'<name.*?>\s*','');
        name = regexprep(name,'\s*</name>','');
    end
    
    % Find Object Description Field
    bucket = regexp(objectStrings{ii},'<description.*?>.+?</description>','match');
    if isempty(bucket)
        desc = '';
    else
        % Clip off flags
        desc = regexprep(bucket{1},'<description.*?>\s*','');
        desc = regexprep(desc,'\s*</description>','');
    end
    
    geom = 0;
    % Identify Object Type
    if ~isempty(regexp(objectStrings{ii},'<Point', 'once'))
        geom = 1;
    elseif ~isempty(regexp(objectStrings{ii},'<LineString', 'once'))
        geom = 2;
    elseif ~isempty(regexp(objectStrings{ii},'<Polygon', 'once'))
        geom = 3;
    end
    
    switch geom
        case 1
            geometry = 'Point';
        case 2
            geometry = 'Line';
        case 3
            geometry = 'Polygon';
        otherwise
            geometry = '';
    end
    
    % Find Coordinate Field
    bucket = regexp(objectStrings{ii},'<coordinates.*?>.+?</coordinates>','match');
    % Clip off flags
    coordStr = regexprep(bucket{1},'<coordinates.*?>(\s+)*','');
    coordStr = regexprep(coordStr,'(\s+)*</coordinates>','');
    % Split coordinate string by commas or white spaces, and convert string
    % to doubles
    coordMat = str2double(regexp(coordStr,'[,\s]+','split'));
    % Rearrange coordinates to form an x-by-3 matrix
    [m,n] = size(coordMat);
    coordMat = reshape(coordMat,3,m*n/3)';
    
    % define polygon in clockwise direction, and terminate
    [Lat, Lon] = poly2ccw(coordMat(:,2),coordMat(:,1));
    if geom==3
        Lon = [Lon;NaN];
        Lat = [Lat;NaN];
    end
    
    % Create structure
    kmlStruct(ii).Geometry = geometry;
    kmlStruct(ii).Name = name;
    kmlStruct(ii).Description = desc;
    kmlStruct(ii).Lon = Lon;
    kmlStruct(ii).Lat = Lat;
    kmlStruct(ii).BoundingBox = [[min(Lon) min(Lat);max(Lon) max(Lat)]];
end