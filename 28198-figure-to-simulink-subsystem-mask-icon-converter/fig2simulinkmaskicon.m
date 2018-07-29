function fig2simulinkmaskicon(hFig,colors)
% Creates a mask for simulink subsystem from a given figure. This subsystem is 
% masked with a ICON correspoding to lines on the figure. This is useful to illustrate 
% the behaviour of the subsystem by a icon. 
%
% You can use the simplot command to create it from the actual output. See the 
% documentation of simplot (doc simplot) for further info.
%
% INPUTS:   hFig      - handle to a figure to be used (e.g. gcf)
%           colors    - (OPTIONAL) colors for different lines. 
%                       Supported (default) colors: blue, red, green, magenta, yellow, cyan, black 
%
% OUTPUTS:  Creates a simulink subsystem with a given mask
%           Prints out the Mask/Icon string
%
% Author: Paul Proteus (e-mail: proteus.paul (at) yahoo (dot) com)
% Version: 1.0
% Changes tracker:  13.07.2010  - First version
%
% Example:  h = figure; hold on;
%           plot([0:0.1:10],sin([0:0.1:10]));
%           plot([0:0.5:12],cos([0:0.5:12]));
%           fig2simulinkmaskicon(gcf);
%           fig2simulinkmaskicon(gcf,'yellow');
%           fig2simulinkmaskicon(gcf,{'red','magenta'});

%% Check required inputs
if ~strcmp(get(hFig,'Type'),'figure'),
    % Checking the validity of the figure handle
    error('hFig argument is not a valid figure handle');
end

% Find the lines
hLine = findall(hFig,'type','line');

% Check if there is at least one line
if isempty(hLine),
    % There is no line to be used. Figure has to have at least one.
    error('There are no lines in this figure. Cannot create subsystem mask.');
end

% If the colors are not provided, use the default
if ~exist('colors','var'),
    % define the default colors
    colors = { ...
        'blue',    ...
        'red',     ...
        'green',   ...
        'magenta', ...
        'yellow',  ...
        'cyan',    ...
        'black',   ...
        };
end

% Check if the colors where not provided as a string
if ischar(colors),
    % Make it cell-array for further use
    colors = {colors};
end

%% Initialization
XData = get(hLine,'XData');
YData = get(hLine,'YData');

if ~iscell(XData),
    % In case there is only one line specified in this hLine
    XData  = {XData};
    YData  = {YData};
end

nGraphs = length(XData);

%% Prepare and print out the MASK/ICON string
disp('Copy following lines to the Mask/Icon of the selected subsystem:');
disp('------- START OF COPY SECTION');

allPreparedString = [];
% Loop through all lines in the figure
for idx=1:nGraphs,
    % Color selection
    colorIdx = min(idx,length(colors)); % if too many lines - used the last color
    preparedString = ['color(''' colors{colorIdx} ''');'];
    disp(preparedString);
    
    allPreparedString = [allPreparedString preparedString];
    
    % Plot the line
    preparedString = 'plot(';
    preparedString = [preparedString ...
                      '[' num2str(XData{idx}) '],' ...
                      '[' num2str(YData{idx}) '],'];
    preparedString = [preparedString(1:end-1) ');'];
    % get rid of the too many spaces
    preparedString = regexprep(preparedString, '\s*', ' ');
    
    disp(preparedString);
    allPreparedString = [allPreparedString preparedString];
end

disp('------- END');

%% Create a new simulink subsystem block and set it up
systemName = ['model_fig2simulinkmaskicon_' num2str(round(rand*100000))];
new_system(systemName);
open_system(systemName);

add_block('built-in/SubSystem',[systemName '/SS_Masked']);

% Enlarge it and mask it 
hBlock = get_param([systemName '/SS_Masked'],'handle');
set(hBlock,'Position',[45 35 181 113]);
set(hBlock,'Mask','on');
set(hBlock,'MaskDisplay',allPreparedString);
