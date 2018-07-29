function EditrunGui
% Modifiable runGUI file
clc;
clear all;
fileName = 'zoom_strips_plot.mat';    %USER - ENTER FILENAME
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

% start_path='c:\data\matlab_gui\speech_files';
    
% find speech files directory by going up one level and down one level
% on the directory chain; as follows:
    dir_cur=pwd; % this is the current Matlab exercise directory path 
    s=regexp(dir_cur,'\'); % find the last '\' for the current directory
    s1=s(length(s)); % find last '\' character; this marks upper level directory
    dir_fin=strcat(dir_cur(1:s1),'speech_files'); % create new directory
    start_path=dir_fin; % save new directory for speech files location
    
Callbacks_zoom_strips_plot_GUI25(f,temp,start_path);    %USER - ENTER PROPER CALLBACK FILE
%panelAndButtonEdit(f, temp);       % Easy access to Edit Mode

% Note comment PanelandBUttonCallbacks(f,temp) if panelAndButtonEdit is to
% be uncommented and used
end

% 2 Panels -- one for speech processing parameters, one for graphics
% 1 Graphics Panel -- strips waveform plot
% 1 Text Box
% 8 Buttons
%   #1 - pushbutton - Get Speech Directory (speech_files)
%   #2 - popupmenu - array of speech files from directory speech_files
%   #3 - editable button - starting sample of strips waveform plot
%   #4 - editable button - number of samples per line
%   #5 - popupmenu - samples or seconds for horizontal axis 
%   #6 - pushbutton - Play Speech File
%   #7 - pushbutton - Plot Speech File
%   #8 - pushbutton - Close GUI