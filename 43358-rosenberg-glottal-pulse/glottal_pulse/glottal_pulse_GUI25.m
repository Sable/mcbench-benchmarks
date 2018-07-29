function glottal_pulse_GUI25
% Modifiable runGUI file
clc;
clear all;
fileName = 'glottal_pulse.mat';    %USER - ENTER FILENAME
fileData=load(fileName);
temp=fileData(1).temp;

f = figure('Visible','on',...
'Units','normalized',...
'Position',[0,0,1,1],...
'MenuBar','none',...
'NumberTitle','off');

Callbacks_glottal_pulse_GUI25(f,temp);    %USER - ENTER PROPER CALLBACK FILE
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% glottal_pulse_rev1_gui25 design
% 2 Panels
%   #1 - parameters
%   #2 - graphics
% 2 Graphic Panels
%   #1 - glottal pulse impulse response
%   #2 - glottal pulse frequency response
% 1 TitleBox
% 8 Buttons
%   #1 - editable button - alpha1: rising glottal pulse cycle
%   #2 - editable button - alpha2: falling glottal pulse cycle
%   #3 - editable button - period for periodic excitation
%   #4 - popupmenu - list of vowel sounds for synthesis
%   #5 - pushbutton - Play impulse train
%   #6 - pushbutton - Play glottal pulses
%   #7 - pushbutton - Play vowel sound
%   #8 - pushbutton - Close GUI