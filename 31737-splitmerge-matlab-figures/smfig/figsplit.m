function [ FigHdl, SubHdl ] = figsplit( FigLst, DoAxes )
%
% FIGSPLIT Splits a number of figures into figures with a single plot.
%   This function splits a list of figures from files names or handles into
%   a several figures with a single plot.
%
% Syntax:
%   [ FigHdl, SubHdl ] = figsplit( FigLst, SubLoc, DoAxes )
%
% Input:
%   FigLst - Cell of file paths to open, or list of figure handles.
%   DoAxes - Enable/Disable the several axes of the figures to be included.
%
% Output:
%   FigHdl - Handles to new figures.
%   SubHdl - Handles to new figures axes.
%
% Examples:
%   % for a set of files
%   figsplit( {'f0.fig'; 'f1.txt'; 'f2.fig'} )
%   % for all fig files in dir
%   d = dir('*.fig');
%   FigLst = cellstr(char(d.name));
%   figsplit( FigLst, true);
%   [ FigHdl, SubHdl ] = figsplit( FigLst )
%   % for a set of opened figures
%   FigLst = [ 1 2 3 4 ]; % list of figure handles
%   figsplit( FigLst )
%   % for a set of opened figures, and all axes per figure
%   FigLst = [ 1 2 ]; % list of figure handles
%   FigAxsLst = findall(FigLst, 'Type','Axes');
%   figsplit( FigAxsLst )
%   figsplit( FigLst, true )
%
% Author/Location:	Tashi Ravach
% Version/Date:     1.0 (April 20, 2011)
%

    if nargin == 1
        DoAxes = true;
    end
    
    % if the list is a cell array of paths, check if files are .fig
    isfig = 1:length(FigLst);
    if iscell(FigLst)
        
        % validate path file list by taking valid indexes
        for k = 1 : length(FigLst)
            if ~(exist(FigLst{k}, 'file') && ...
                    strcmpi(FigLst{k}(end-3:end), '.fig'))
                isfig(k) = 0; % invalid file names to ignore
            end
        end
        isfig = isfig(isfig > 0);

        % open each figure and take handles, then hide them
        AllFig = length(isfig);
        AllFigHdl = zeros(AllFig, 1);
        for k = 1 : AllFig
            AllFigHdl(k) = open(FigLst{isfig(k)});
            set(AllFigHdl(k), 'Visible', 'off');
        end
        FigLst = AllFigHdl;
        
    else
        AllFigHdl = [];
    end
        
    if ishandle(FigLst) % same process if input is opened figures
        
        % validate handle list by taking valid indexes
        for k = 1 : length(FigLst)
            if ~ishandle(FigLst(k))
                isfig(k) = 0; % invalid handles to ignore
            end
        end  
        isfig = isfig(isfig > 0);
        
        % if all axes are expected, find them and update indexes
        if DoAxes == true
            FigLst = findall(FigLst(isfig), 'Type', 'Axes', 'Tag', '');
            isfig = 1:length(FigLst);
        end

        % define the figure handle variables
        AllFig = length(isfig);
        FigHdl = zeros(AllFig, 1);
        SubHdl = zeros(AllFig, 1);
        FigLst = sort(FigLst);

        % copy from figures to new figure subplot
        for k = 1 : AllFig
            if strcmpi(get(FigLst(isfig(k)), 'Type'), 'Figure')
                OldGca = gca(FigLst(isfig(k))); 
            elseif strcmpi(get(FigLst(isfig(k)), 'Type'), 'Axes')
                OldGca = FigLst(isfig(k)); 
            end
            FigHdl(k) = figure;
            SubHdl(k) = gca(FigHdl(k));
            NewPos = get(SubHdl(k), 'Position');
            delete(SubHdl(k)) % Delete the subplot 
            C = copyobj(OldGca, FigHdl(k));
            set(C, 'Position', NewPos);
        end
        
    end
    
    % in case the input where closed figures, close them back
    if ~isempty(AllFigHdl)
        for k = 1 : length(AllFigHdl)
            close(AllFigHdl(k));
        end
    end
    
end

