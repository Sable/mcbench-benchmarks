% *******************************************************************
% This function was used in project_Nonholonomic.m
% Description: Plot a mobile robot using x,y location, rotation angle,
%              robot width.
% Created by: LengFeng Lee
% MAE 505: Robotic Final Project.
% Date: 4 Dec 2003.
% ********************************************************************

function [RobotBox] = Robotplot(xe, ye, phe, robot_width, linka, linkangle)

% xe, ye is the location of the robot and phe is the angle of x-axis
% of the robot with respect to the base.
Dia = (2*robot_width^2)^0.5; 

Robot(1,1) = xe + Dia*cos(phe + pi/4);
Robot(1,2) = ye + Dia*sin(phe + pi/4);

Robot(1,3) = xe + Dia*cos(phe + 3*pi/4);
Robot(1,4) = ye + Dia*sin(phe + 3*pi/4);

Robot(1,5) = xe + Dia*cos(phe - 3*pi/4);
Robot(1,6) = ye + Dia*sin(phe - 3*pi/4);

Robot(1,7) = xe + Dia*cos(phe - pi/4);
Robot(1,8) = ye + Dia*sin(phe - pi/4);

RobotBox = Robot;
% %Create 4 lines for the Robot Box
% Robot1x = [Robot(1,1) Robot(1,3)];
% Robot1y = [Robot(1,2) Robot(1,4)];
% 
% Robot2x = [Robot(1,3) Robot(1,5)];
% Robot2y = [Robot(1,4) Robot(1,6)];
% 
% Robot3x = [Robot(1,5) Robot(1,7)];
% Robot3y = [Robot(1,6) Robot(1,8)];
% 
% Robot4x = [Robot(1,7) Robot(1,1)];
% Robot4y = [Robot(1,8) Robot(1,2)];
% 
% RobotBox(1,:) = [Robot1x Robot2x Robot3x Robot4x];
% RobotBox(2,:) = [Robot1y Robot2y Robot3y Robot4y];
% 
% % first link
% link1_endx = xe + link(1,1)*cos(phe+linkangle(1,1));
% link1_endy = ye + link(1,1)*sin(phe+linkangle(1,1));
% RoboLink1x = [xe link1_endx];
% RoboLink1y = [ye link1_endy];
% %second link
% link2_endx = link1_endx + link(1,2)*cos(phe+linkangle(1,2)+linkangle(1,1));
% link2_endy = link1_endy + link(1,2)*sin(phe+linkangle(1,2)+linkangle(1,1));
% RoboLink2x = [link1_endx link2_endx];
% RoboLink2y = [link1_endy link2_endy];
% % Plot the Robot
% 
% h1 = plot(Robot1x, Robot1y,'r-','LineWidth',4);
% set(h1,'EraseMode','xor');
% %set(h1,'XData', Robot1x,'YData',Robot1y)
% 
% 
% h2 =plot(Robot2x, Robot2y,'r-','LineWidth',1);
% set(h2,'EraseMode','xor');
% %set(h2,'XData', Robot2x,'YData',Robot2y)
% 
% 
% h3 =plot(Robot3x, Robot3y,'r-','LineWidth',4);
% set(h3,'EraseMode','xor');
% %set(h3,'XData', Robot3x,'YData',Robot3y)
% 
% 
% h4 =plot(Robot4x, Robot4y,'r-','LineWidth',1);
% set(h4,'EraseMode','xor');
% %set(h4,'XData', Robot4x,'YData',Robot4y)
% 
% 
% h5 =plot(RoboLink1x, RoboLink1y, 'b-','LineWidth',1);
% set(h5,'EraseMode','xor');
% %set(h5,'XData', RoboLink1x,'YData',RoboLink1y)
% 
% 
% h6 =plot(RoboLink2x, RoboLink2y, '-ro','LineWidth',1);
% set(h6,'EraseMode','xor');
% %set(h6,'XData', RoboLink2x,'YData',RoboLink2y)
% axis equal
