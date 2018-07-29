clc, close all, clear all


% x=[2 7 10 12 15 20 25]; v=16; %OK

% x=[-1 0 7 10 12 15 20 25]; v=1; %OK

% x=[-2 2 7 10 12 15 20 25]; v=0; %OK

x=[-2 2 7 10 12 15 20 25]; v=14; %OK

[i,cv] = searchclosest(x,v)

% % --------------------------------------------

% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------