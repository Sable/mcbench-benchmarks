function saveFigures(figs,file)
%SAVEFIGURES Save multiple figures to a single MATLAB file.
%    SAVEFIGURES, by itself, saves all currently open MATLAB figures to a
%    single .mat file. A file dialog is opened for selecting the filename
%    and path.
%
%    SAVEFIGURES(FIGS) saves all figures with handles FIGS. FIGS is a
%    vector of figure handles. Default: all open figure windows. A dialog
%    is opened for specifying the filename and path.
%
%    SAVEFIGURES(...,FILE) saves figures to a single .mat file called FILE.
%    FILE is a string specifying the filename and, possibly, filepath. If
%    no path is specified the file is saved to the current directory.
%
%
%    Use OPENFIGURES to open the figures in the saved file.
%
%    Examples:
%       % Create some figures
%       f1 = figure; plot(1:10); title('One figure')
%       f2 = figure; plot(sin(1:.1:10)); ylabel('A 2nd figure')
%       f3 = figure; scatter(rand(50,1),rand(50,1)); legend('A 3rd figure')
%
%       % Save the figures to a single file. Three examples:
%       % 1) Save all figures and open a saveas dialog:
%       saveFigures
%       % 2) Save figures f1 and f3 to a file named '2 figures.mat':
%       saveFigures([f1 f3],'2 figures')
%       % 3) Save all open figures to a file named 'all figures.mat':
%       saveFigures([],'all figures')
%
%       % Open the saved figures. Two examples:
%       % 1) Use a file selection dialog to select a file
%       openFigures;
%       % 2) Open figure file '2 figures.mat' containing f1 and f3:
%       openFigures('2 figures.mat');
%
%    Requirements:
%       - The function must be positioned in a folder with full
%       administrator rights.
%
%
%    See also: SAVE, SAVEAS, OPEN, OPENFIG
%
%  Copyright 2013 Søren Preus: <a href="www.fluortools.com">FluorTools.com</a>

%% Default input arguments
if nargin<1 || isempty(figs)
    figs = findobj('type','figure'); % Default is all open figures
end
if nargin<2 || ~ischar(file)
    file = []; % Default is to open a file selection dialog
end

%% Check input
if isempty(figs) % If there are no open figure windows
    error('No figure handles found.')
    return
elseif ismember(0,ishghandle(figs)) % If input contains invalid figure handle
    error('Input contains invalid figure handle.')
    return
end

%% Filepath
if isempty(file)
    [FileName,PathName,chose] = uiputfile('*.mat','Save file',sprintf('%i figures.mat',length(figs))); % Open file dialog
    
    if chose == 0 % If user pressed Cancel
        return
    else
        file = fullfile(PathName,FileName); % Full file path
    end
end

%% Save figures to file
figures = {};
for i = 1:length(figs)
    if ~ishghandle(figs(i)) % Check if item i is a figure handle
        continue
    end
    
    % Save temporary figure
    hgsave(figs(i),'temp.fig');
    
    % Load temporary figure into structure
    figures{i} = load('temp.fig','-mat');
    
    % Delete temporary figure file
    delete('temp.fig')
end

% Save file
save(file,'figures')
