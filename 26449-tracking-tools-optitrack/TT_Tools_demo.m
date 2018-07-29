function TT_Tools_demo(project_file) 
% TT_Tools_demo(project_file)
%
% This function demonstrates basic functionality of the Tracking Tools API
% from Natural Point (to be used with Optitrack). Before use it is
% essential to have calibrated cameras and created the desirable
% trackable/s and save these in a project file. The project file is then
% passed to the function and the library loaded if need be before
% attempting to plot any data
%
% Input - project_file - a string containing path and filename for the
%               project file that is to be used (default value assigned if
%               not assigned)
%
% Written by Glen Lichtwark, University of Queensland, Australia
% Last updated: 22nd Jan 2010
% Please acknowledge in any academic papers which may utilise this code

if nargin < 1
    project_file = 'C:\Optitrack\LabSpace.ttp';
end

% load the NPTrackingTools library if it is not already loaded
if ~libisloaded('NPTrackingTools')

addpath('C:\Program Files\NaturalPoint\TrackingTools\lib'); % change if necessary
addpath('C:\Program Files\NaturalPoint\TrackingTools\inc'); % change if necessary

[notfound,warnings]=loadlibrary('NPTrackingTools','NPTrackingTools.h');
end

% libfunctionsview NPTrackingTools --> use this to see available functions

% initialise cameras
calllib('NPTrackingTools', 'TT_Initialize');

% load the project file which sets up cameras correctly
calllib('NPTrackingTools', 'TT_LoadProject', project_file);

%define the outputs types from TT_TrackableLocation function
X = 0;Y = 0;Z = 0;
qx = 0;qy = 0;qz = 0;qw = 0;
yaw = 0;pitch = 0;roll = 0;

figure(1)
clf
set(gcf,'Position',[127 73 933 602])

TC = calllib('NPTrackingTools','TT_TrackableCount');

TrackableNum = TC-1; % change this value to view different trackable object (starts at 0)

%loop through and plot the marker positions using frame results
for i = 1:500
    
    M = [];
    
    %update frame and get time stamp
    calllib('NPTrackingTools', 'TT_UpdateSingleFrame');
    D.T(i) = calllib('NPTrackingTools', 'TT_FrameTimeStamp');
    
    %find out how many markers are visible store data for X Y Z coordinates
    %of each
    marker_count = calllib('NPTrackingTools', 'TT_FrameMarkerCount');
    for j = 1:marker_count
        M(j,1) = calllib('NPTrackingTools', 'TT_FrameMarkerX',j-1);
        M(j,2) = calllib('NPTrackingTools', 'TT_FrameMarkerY',j-1);
        M(j,3) = calllib('NPTrackingTools', 'TT_FrameMarkerZ',j-1);
    end
    D.dat(i) = {M};
    
    % find the location of any trackable and plot the XYZ position on one
    % plot and euler angles on another
    
    [X,Y,Z,qx,qy,qz,qw,yaw,pitch,roll] = calllib('NPTrackingTools', 'TT_TrackableLocation',TrackableNum,X,Y,Z,qx,qy,qz,qw,yaw,pitch,roll);
    D.trans_dat(i,:) = [X Y Z];
    D.rot_dat(i,:) = [yaw pitch roll];
    % plot data --> note that this slows the frame rate considerably so
    % only do it every now and again
    if rem(i,4) == 0
        subplot(2,2,2), plot(D.T-D.T(1), D.trans_dat)
        xlabel('Time (s)?')
        ylabel('Object Position (m)?')
        subplot(2,2,4), plot(D.T-D.T(1), D.rot_dat)
        xlabel('Time (s)?')
        ylabel('Object Orientation (deg)?')

        % make 3D plot of marker positions and the trackable position
        if ~isempty(M)
            subplot(1,2,1), plot3(M(:,1),M(:,2),M(:,3),'ko',X,Y,Z,'ro');axis equal
            axis([-0.4 0.4 -0.4 0.4 -0.4 0.4])
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
        end
        drawnow
    end

end

calllib('NPTrackingTools', 'TT_Shutdown')



