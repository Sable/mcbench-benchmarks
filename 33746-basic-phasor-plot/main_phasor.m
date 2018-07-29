%% Drawing Basic phasor diagram
% This code shows how to draw a basic phasor and use plot window
% simultaneously.
% Here, in this code I have used annotation for drawing arrow.
% Also, to change its X and Y dimension of header, sliders have been
% provided.
% Further you can use this code to do calculate resultant phasor of more than
% two phasors.
% x_cord and y_cord can be made global and used for calculating resultant
% vector.
%% Created by Amol G. Mahurkar
%%
function main_phasor()

clc;clear;close all;

global x_val y_val
x_val = 25;
y_val = 25;

% Starting position of vector
x_start_pos = 0.2;
y_start_pos = 0.2;

% Head position of vector
x_final_pos = 0.5;
y_final_pos = 0.5;

% Creating arrow 
hArr = annotation('arrow',[x_start_pos x_final_pos],[y_start_pos y_final_pos]);

% Creating slider for controlling arrow length
%
% Remember the property 'Value' is the default position on slider
% If you will change final position of vector, this value needs to be
% changed accordingly

uicontrol('Style', 'slider','Min',1,'Max',50,'Value',25,...
'Position', [400 10 120 20],'Callback', {@xslider,hArr},...
'SliderStep',[0.01 0.01]);

uicontrol('Style', 'slider','Min',1,'Max',50,'Value',25,...
'Position', [520 50 20 120],'Callback', {@yslider,hArr},...
'SliderStep',[0.01 0.01]);

% Default position of dot
plot(25,25)
xlim([0 51])
ylim([0 51])
title('Phasor plot')

function xslider(hObj,~,hArr)
global x_val y_val;
x_cord = get(hArr,'X');
x_cord(2) = 0.02*get(hObj,'Value');
x_val = get(hObj,'Value');
fprintf('\nX-Value is %3.2f',x_val);
set(hArr,'X',x_cord);

% Didn't get the significance of dot, but still its moves.. u need to
% observe carefully.. ;)
plot(x_val,y_val)
xlim([0 51])
ylim([0 51])

function yslider(hObj,~,hArr)
global x_val y_val;
y_cord = get(hArr,'Y');
y_cord(2) = 0.02*get(hObj,'Value');
y_val = get(hObj,'Value');
fprintf('\nY-Value is %3.2f',y_val);
set(hArr,'Y',y_cord);

% Didn't get the significance of dot, but still its moves.. u need to
% observe carefully.. ;)
plot(x_val,y_val)
xlim([0 51])
ylim([0 51])