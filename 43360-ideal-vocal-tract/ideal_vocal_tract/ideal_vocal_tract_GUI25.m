function ideal_vocal_tract_GUI25
% Modifiable runGUI file
clc;
clear all;
fileName = 'ideal_vocal_tract.mat';    %USER - ENTER FILENAME
fileData=load(fileName);
temp=fileData(1).temp;

f = figure('Visible','on',...
'Units','normalized',...
'Position',[0,0,1,1],...
'MenuBar','none',...
'NumberTitle','off');

Callbacks_ideal_vocal_tract_GUI25(f,temp);    %USER - ENTER PROPER CALLBACK FILE
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% ideal_vocal_tract_GUI25 design
% 2 Panels
%   #1 - input parameters
%   #2 - graphics displays
% 6 Graphic Panels
%   #1 - excitation impulses in time
%   #2 - excitation line frequency spectrum
%   #3 - VT impulse response
%   #4 - VT frequency response
%   #5 - periodic vowel in time
%   #6 - periodic vowel spectrum
% 1 TitleBox
% 6 Buttons
%   #1 - popupmenu - vowel choices
%   #2 - editable button - T: pitch period
%   #3 - editable button - N: analysis frame length
%   #4 - popupmenu - log/linear spectrum plot
%   #5 - pushbutton - Run ideal vocal tract
%   #6 - pushbutton - Close GUI