function composite_vocal_tract_GUI25
% Modifiable runGUI file
clc;
clear all;
fileName = 'composite_vocal_tract.mat';    %USER - ENTER FILENAME
fileData=load(fileName);
temp=fileData(1).temp;

f = figure('Visible','on',...
'Units','normalized',...
'Position',[0,0,1,1],...
'MenuBar','none',...
'NumberTitle','off');

Callbacks_composite_vocal_tract_GUI25(f,temp);    %USER - ENTER PROPER CALLBACK FILE
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% composite_vocal_tract_rev1_gui25 design
% 2 Panels
%   #1 - input parameters
%   #2 - graphics displays
% 2 Graphic Panels
%   #1 - vowel impulse response
%   #2 - components of composite VT frequency response
% 1 TitleBox
% 6 Buttons
%   #1 - popupmenu - set of vowels for synthesis
%   #2 - editable button - iperiod: pitch period
%   #3 - editable button - fsd: synthesis sampling rate
%   #4 - pushbutton - plot VT components and vowel impulse response
%   #5 - pushbutton - play vowel sound
%   #6 - pushbutton - Close GUI