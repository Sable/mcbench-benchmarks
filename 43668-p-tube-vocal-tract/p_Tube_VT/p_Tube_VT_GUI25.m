function p_Tube_VT_GUI25
% Modifiable runGUI file
clc;
clear all;
fileName = 'p_Tube_VT.mat';    %USER - ENTER FILENAME
fileData=load(fileName);
temp=fileData(1).temp;

f = figure('Visible','on',...
'Units','normalized',...
'Position',[0,0,1,1],...
'MenuBar','none',...
'NumberTitle','off');

Callbacks_p_Tube_VT_GUI25(f,temp);    %USER - ENTER PROPER CALLBACK FILE
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% p_Tube_VT_gui25 design
% 2 Panels
%   #1 - input parameters
%   #2 - graphics displays
% 4 Graphic Panels
%   #1 - VT impulse response
%   #2 - VT frequency response
%   #3 - VT shape
%   #4 - VT reflection coefficients
% 1 TitleBox
% 10 Buttons
%   #1 - popupmenu - set of p areas
%   #2 - editable button - fs: sampling rate for VT
%   #3 - editable button - ls: length (cm) of each VT tube
%   #4 - text button - rL
%   #5 - text button - rG
%   #6 - editable button - output text file
%   #7 - pushbutton - Run
%   #8 - pushbutton - Close GUI