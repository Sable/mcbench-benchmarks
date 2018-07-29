function SRC_GUI25
% Modifiable runGUI file
clc;
clear all;
fileName = 'SRCONV.mat';    %USER - ENTER FILENAME
fileData=load(fileName);
temp=fileData(1).temp;

f = figure('Visible','on',...
'Units','normalized',...
'Position',[0,0,1,1],...
'MenuBar','none',...
'NumberTitle','off');

%SENSE COMPUTER AND SET FILE DELIMITER
switch(computer)				
    case 'MACI64',		char= '/';
    case 'GLNX86',  char='/';
    case 'PCWIN',	char= '\';
    case 'PCWIN64', char='\';
    case 'GLNXA64', char='/';
end

% find speech files directory by going up one level and down one level
% on the directory chain; as follows:
    dir_cur=pwd; % this is the current Matlab exercise directory path 
    s=regexp(dir_cur,char); % find the last '\' for the current directory
    s1=s(length(s)); % find last '\' character; this marks upper level directory
    dir_fin=strcat(dir_cur(1:s1),'speech_files'); % create new directory
    start_path=dir_fin; % save new directory for speech files location

Callbacks_SRC_GUI25(f,temp,start_path);    %USER - ENTER PROPER CALLBACK FILE
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% Sampling_Rate_Conversion_gui25 design
% 2 Panels
%   #1 - input parameters
%   #2 - graphics displays
% 2 Graphic Panels
%   #1 - original waveform
%   #2 - sample rate converted waveform
% 1 TitleBox
% 7 Buttons
%   #1 - pushbutton - Speech Directory
%   #2 - popupmenu - Speech Files
%   #3 - pushbutton - Play Original File
%   #4 - editable button - Output File name
%   #5 - popup menu - fs: output sampling rate
%   #6 - pushbutton - Play/Save Converted File
%   #7 - pushbutton - Close GUI