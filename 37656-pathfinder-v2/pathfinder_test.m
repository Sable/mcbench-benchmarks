close all
clear all
clc

%Specify start and end points
%WARNING: shortest distance between start and end points to wall must be
%greater than footprint otherwise the start and end positions will outside
%of the valid space for navigation
start_point = [120;35];
end_point = [50;20];

%Specify external boundaries and footprint of of robot
external_boundaries = [0,0;60,0;60,45;45,45;45,59;75.5,40;106,59;106,45;91,45;91,0;151,0;151,105;50,105;0,60];
footprint = 6;

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
inflated_boundaries = boundary_inflation(external_boundaries, footprint);
waypoint_coordinates = pathfinder(start_point, end_point, inflated_boundaries);
toc

external_boundaries_shifted_draw = inflated_boundaries;
external_boundaries_shifted_draw(size(external_boundaries_shifted_draw,1)+1,:) = inflated_boundaries(1,:);
plot(external_boundaries_shifted_draw(:,1), external_boundaries_shifted_draw(:,2), 'Color', 'cyan')

%Plot the chosen path in blue
plot(waypoint_coordinates(:,1), waypoint_coordinates(:,2), 'Color', 'blue')
