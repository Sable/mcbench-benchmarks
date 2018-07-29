function gEarthCOM(position,view)
%This function will create a COM server running Google Earth and control
%the Google Earth's camera with given properties
% usage: Before using this function, you must create a COM server with this
% command:
% handle = actxserver('googleearth.ApplicationGE');
% position is a vector containing latitude, longitude, and altitude
% view is a vector containing range,tilt, and heading
% altmode and speed will be set in this function
%
% Go to first position
% handle.SetCameraParams(position(1),position(2),position(3),1,...
%    view(1),view(2),view(3),5);
% pause (5)
handle = actxserver('googleearth.ApplicationGE');
newPosition = handle.GetCamera(0);

set (newPosition, 'FocusPointLatitude', position(1));
set (newPosition, 'FocusPointLongitude', position(2));
set (newPosition, 'FocusPointAltitude', position(3));
set (newPosition, 'FocusPointAltitudeMode', 2);
set (newPosition, 'Range', view(1));
set (newPosition, 'Tilt', view(2));
set (newPosition, 'Azimuth', view(3));

handle.SetCamera(newPosition,5);




