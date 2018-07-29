function ge_test1
% This is an example script on how to get data (loacations with altitude, colored image) from GoogleEarth into
% a matlab surface.
% Use this function as a script so comment the first line!
%
% The code was tested with Matlab 2010a an GoogleEarth 6 (actual version) so download it or try your actual
% GE-version:       http://www.google.com/intl/en/earth/index.html
%
% Further help for GoogleEarthAPI you find under:
% http://earth.google.com/comapi/interfaceIApplicationGE.html#9e1c8da5b36e8687fe718f2267224103
%
% You need additional MCFE-files before script will run without errors:
%       http://www.mathworks.com/matlabcentral/fileexchange/5256-pos2dist
%       http://www.mathworks.com/matlabcentral/fileexchange/28357-jmouseemu-mouse-emulator-v2-2
%       http://www.mathworks.com/matlabcentral/fileexchange/28603
%       http://www.mathworks.com/matlabcentral/fileexchange/14584-clipboardimage
%
%  ATTENTION: There is a heavy workaround to get an colored image from GE in line 70 (jmouseemu). Here it is
%  necessery to set the mousepointer in the actual GE-picture, so the x and y pixels must be in it! The
%  problem is, that it will not work in debug mode.
%  Depending of internetconnection speed you must play a little with the pause-times to get all needed data.
%
% Programmed by Sven Koerner: koerner(underline)sven(add)gmx.de
% Date: 2011/07/27 


% open GR
ge_app = actxserver('GoogleEarth.ApplicationGE');   % need GoogleEarth tested with version 6

% wait while initialising
pause(7)

% get camerapostion
camPos = ge_app.GetCamera(0);

% teleport to location
camPos.FocusPointLatitude           = 51.10719595658241;
camPos.FocusPointLongitude          = 13.638689585783112;
camPos.FocusPointAltitude           = 0.0;
camPos.FocusPointAltitudeMode       = 'AbsoluteAltitudeGE';
camPos.Range                        = 11780.53549488341;
camPos.Tilt                         = 0;
camPos.Azimuth                      = 7;  % 0 < Speed <5 --> Speed> 5: Teleport 
ge_app.SetCameraParams(camPos.FocusPointLatitude, camPos.FocusPointLongitude, camPos.FocusPointAltitude, camPos.FocusPointAltitudeMode, camPos.Range, camPos.Tilt, camPos.Azimuth, 6);

% measure x and y - distances
u_li   = ge_app.GetPointOnTerrainFromScreenCoords(-1,-1);    % bottom left
u_re   = ge_app.GetPointOnTerrainFromScreenCoords(1,-1);     % bottom right
o_li   = ge_app.GetPointOnTerrainFromScreenCoords(-1, 1);    % upper_left
dist_u = pos2dist(u_li.Latitude ,u_li.Longitude, u_re.Latitude , u_re.Longitude  ,1);   % distance x  need:  http://www.mathworks.com/matlabcentral/fileexchange/5256-pos2dist
dist_o = pos2dist(u_li.Latitude ,u_li.Longitude, o_li.Latitude , o_li.Longitude  ,1);   % distance y
  
  
%  generate mesh for screencoords from -1 to 1 in each direction
[X,Y] = meshgrid(-1:(1/30):1, -1:(1/30):1);
Z     = NaN(size(X));    % preallocate for altitude-data
% get altitude from GE
for i= 1: 1 : size (X,1)
    for j =1:1: size (X,2)
        pot = ge_app.GetPointOnTerrainFromScreenCoords(X(i,j), Y(i,j) );
        Z(i,j) = pot.Altitude;
    end;
end;

% calculate distance an heigt
X_dist = (X + 1).*0.5.*dist_u;   % distance in km
Y_dist = (Y + 1).*0.5.*dist_o;   % distance in km
Z_dist = Z;                      % heigt in meter


% get a colored image from GE --> heavy workaround!!
jmouseemu([600,500],'normal');      % set actual view active            need: http://www.mathworks.com/matlabcentral/fileexchange/28357-jmouseemu-mouse-emulator-v2-2
inputemu('key_alt','c');            % copy image to clipboard           need: http://www.mathworks.com/matlabcentral/fileexchange/28603
pause(2);                           % wait for image in clipboard       
[imdata] = clipboardimage('jpg');   % get image from clipboard;         need: http://www.mathworks.com/matlabcentral/fileexchange/14584-clipboardimage
 
% Convert to indexed image
[X2, map2] = rgb2ind(imdata, 256);  % not more than 256 because of uint8 is necessary

% Create surface plot an texture it with image
figure('Color', [1 1 1 ]);
surface(X_dist,Y_dist,Z_dist,flipud(X2),'FaceColor','texturemap','EdgeColor','none', 'CDataMapping','direct')
colormap(map2);
xlim([0 dist_u]);
ylim([0 dist_o]);
view([-12,72]);
box on
grid on





























