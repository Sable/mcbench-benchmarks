function pwr_kml(name,latlon)
%makes a kml file for use in google earth
%input:  name of track, one matrix containing latitude and longitude
%usage:  pwr_kml('track5',latlon)

header=['<kml xmlns="http://earth.google.com/kml/2.0"><Placemark><description>"' name '"</description><LineString><tessellate>1</tessellate><coordinates>'];
footer='</coordinates></LineString></Placemark></kml>';

fid = fopen([name '.kml'], 'wt');
d=flipud(rot90(fliplr(latlon)));
fprintf(fid, '%s \n',header);
fprintf(fid, '%.6f, %.6f, 0.0 \n', d);
fprintf(fid, '%s', footer);
fclose(fid)