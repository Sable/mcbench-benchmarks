close all
clear all
clc

%Specify start and end points
start_point = [100;40]
end_point = [55;40]

%Specify external boundaries
external_boundaries = [0,0;60,0;60,45;45,45;45,59;75.5,40;106,59;106,45;91,45;91,0;151,0;151,105;50,105;0,60];

%Let the external boundaries form a closed polygon for graphical
%visualization purposes
external_boundaries_draw = external_boundaries;
external_boundaries_draw(size(external_boundaries,1)+1,:) = external_boundaries_draw(1,:);

hold on
axis equal

%Plot the boundaries, starting points and end points
plot(external_boundaries_draw(:,1), external_boundaries_draw(:,2), 'Color', 'black')
plot(start_point(1), start_point(2), 'X', 'Color', 'green')
plot(start_point(1), start_point(2), 'O', 'Color', 'green')
plot(end_point(1), end_point(2), 'X', 'Color', 'red')
plot(end_point(1), end_point(2), 'O', 'Color', 'red')

tic
waypoint_coordinates = pathfinder(start_point, end_point, external_boundaries)
toc

%Plot the chosen path
plot(waypoint_coordinates(:,1), waypoint_coordinates(:,2), 'Color', 'blue')