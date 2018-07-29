function hfigs = openFigures(file)
%OPENFIGURES Open multiple figures from a single .mat-file
%    OPENFIGURES, by itself, opens a multifigure .mat file saved by
%    SAVEFIGURES. A file selection dialog is opened specifying the file.
%
%    OPENFIGURES(FILE) Opens figures in .mat-file FILE. FILE is a
%    multi-figure MATLAB file saved by SAVEFIGURES.
%
%    HFIGS = OPENFIGURES(...) returns the figure handles in a vector HFIGS.
%
%
%    Use SAVEFIGURES to save the figures to file.
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
if nargin<1 || ~ischar(file) || ~exist(file,'file')
    file = []; % Default is to open a file selection dialog
end

% Initialize vector of figure handles
if nargout>0
    hfigs = [];
end

%% Filepath
if isempty(file)
    [FileName,PathName,chose] = uigetfile('*.mat','Open file','figures.mat'); % Open file selection dialog
    
    if chose == 0 % If user pressed Cancel
        return
    else
        file = fullfile(PathName,FileName); % Full file path
    end
end

% Open file
temp = open(file);

%% Plot figures
if isfield(temp,'figures') && ~isempty(temp.figures)
    for i = 1:length(temp.figures) % Loop all saved figures
        try hgS_070000 = temp.figures{i}.hgS_070000; % Current name
            save('temp.fig','hgS_070000') % Save temporary figure file
        catch err % If error, it could be becayse structure field is altered in new MATLAB version
            hgS_080000 = temp.figures{i}.hgS_080000 % Name in later MATLAB version?
            save('temp.fig','hgS_080000') % Save temporary figure file
        end
        % Open temporary figure file
        if nargout>0
            hfigs(i) = openfig('temp.fig'); % Return handle
        else
            openfig('temp.fig'); % Open without returning handle
        end
    end
    delete('temp.fig') % Delete the temporarily constructed file
    
else % If there is no figures found in file
    display('No figures found in specified file.')
    return
end
