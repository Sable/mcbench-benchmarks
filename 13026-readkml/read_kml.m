function [lat,lon,z] = read_kml(fileName)
%READ_KML reads a Google Earth kml file into Matlab
% Reads in lat,lon,z from a simple path file.
%
%  All the data in the data file must EITHER be on one line, for example:
%   -73.6513,40.4551,0 -73.3905,40.5214,0 -73.0589,40.5956,0
% OR each point must be on its own line, for example:
%   -73.237171, 40.627311, 0.0 
%   -73.242945, 40.626360, 0.0 
%
%  I have tried to make this code as robust as possible, but it may still
%  crash if there is a space in the wrong place in the data file.
%
% Example:
%   [lat,lon,z] = read_kml('test.kml');
%
% where test.kml looks like:
% <?xml version="1.0" encoding="UTF-8"?>
% <kml xmlns="http://earth.google.com/kml/2.1">
% <Placemark>
% 	<name>test_length</name>
% 	<description>junk</description>
% 	<LineString>
% 		<tessellate>1</tessellate>
% 		<coordinates>
% -73.65138440596144,40.45517368645169,0 -73.39056199144957,40.52146569128411,0 -73.05890757388369,40.59561213913959,0 -72.80519929505505,40.66961872411046,0 -72.61180114704385,40.72997510603909,0 -72.43718187249095,40.77509309196679,0 </coordinates>
% 	</LineString>
% </Placemark>
% </kml>
% afarris@usgs.gov 2006 November

%% open the data file and find the beginning of the data
fid=fopen(fileName);
if fid < 0
    error('could not find file')
end
done=0;
while done == 0
    junk = fgetl(fid);
    f=findstr(junk,'<coordinates>');
    if isempty(f) == 0
        done = 1;
    end
end
ar = 1;
% junk either ends with the word '<coordinates>' OR 
% some data follows the word '<coordinates>'  
if (f + 13) >= length(junk)  
    % no data on this line
    % done2 is set to zero so the next loop will read the data
    done2 = 0;
else
    % there is some data in this line following '<coordinates>'
    clear f2
    f2=findstr(junk,'</coordinates>');
    if isempty(f2) == 0
        %all data is on this line
        alldata{ar} = junk(f+13:f2-1);
        % done2 is set to one because the next loop does not need to run
        done2 = 1;
    else
        % only some data is on this line
        alldata{ar} = junk(f+13:end);
        ar = ar + 1;
        % done2 is set to zero so the next loop will read the rest of the data
        done2 = 0;
    end
end

%% Read in the data
while done2 == 0
    % read in line from data file
    junk = fgetl(fid);
    f=findstr(junk,'</coordinates>');
    if isempty(f) == 1 
        % no ending signal, just add this data to the rest 
        alldata{ar} = junk;
        ar = ar + 1;
    else
        % ending signal is present
        if f < 20
            % </coordinates> is in the begining of the line, ergo no data 
            % on this line; just end the loop
            done2 = 1;
        else 
            % the ending signal (</coordinates>) is present: remove it, 
            % add data to the rest and signal the end of the loop
            f2 = strfind(junk,'</coordinates>');
            alldata{ar} = junk(1:f2-1);
            ar = ar + 1;
            done2 = 1;
        end
    end
end

%% get the data into neat vectors
% either all the data is on one line, or each point is on its own line
f = strfind(alldata{1}(:)',',');
if length(f) > 2
    % more than one coordinate on each line, this is hard b/c there is no
    % comma between points (just commans between lon and lat, and between 
    % lat and z)  ie;  -70.0000,42.0000,0 -70.1000,40.10000,0 -70.2,....
    %
    %  I have to divide the string into Latitude, Longitude and Z values 
    % using the locations of both commas and spaces.
    %  
    % turn alldata into regular vector so it is easier to work with
    data = cell2mat(alldata);
    % now find all commas
    fComma = strfind(data, ',');
    % find all spaces
    fSpace = strfind(data,' ');
    a=1;
    fC = 1;
    % have to do first point seperately b/c line may not begin with a space
    lon(a) = str2num(data(1:fComma(fC)-1));
    lat(a) = str2num(data(fComma(fC)+1:fComma(fC+1)-1));
    z(a) = str2num(data(fComma(fC+1)+1:fSpace(1)-1));
    a=a+1;
    fS=1;
    % go thru all the points in the line
    for fC = 3: 2: length(fComma)
        lon(a) = str2num(data(fSpace(fS)+1:fComma(fC)-1));
        lat(a) = str2num(data(fComma(fC)+1:fComma(fC+1)-1));
        if fS  < length(fSpace)
            z(a) = str2num(data(fComma(fC+1)+1:fSpace(fS+1)-1 ));
        else
            % have to handle last point seperatly b/c line may not end with
            % a space
            z(a) = str2num(data(fComma(fC+1)+1:end ));
        end
        a=a+1;
        fS=fS+1;
    end
 else
    %each point is on its own line
    for i = 1 : size(alldata,2)
        fComma = strfind(alldata{i}(:)',',');
        lon(i) = str2num(alldata{i}(1:fComma(1)-1));
        lat(i) = str2num(alldata{i}(fComma(1)+1:fComma(2)-1));
        z(i) = str2num(alldata{i}(fComma(2)*1:end));
    end
 end

fclose(fid);
[a,b]=size(lat);
lat=reshape(lat,max(a,b),min(a,b));
lon=reshape(lon,max(a,b),min(a,b));
z=reshape(z,max(a,b),min(a,b));
