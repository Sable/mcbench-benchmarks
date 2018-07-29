function [ FigHdl, SubHdl ] = figmerge( FigLst, SubLoc, DstOpt, DoAxes, ...
    DoOrder )
%
% FIGMERGE Merges a number of figures into subplots within a single figure.
%   This function merges a list of figures from files names or handles into
%   a single figure with several subplots.
%
% Syntax:
%   [ FigHdl, SubHdl ] = figmerge( FigLst, SubLoc, DstOpt, DoAxes )
%
% Input:
%   FigLst - Cell of file paths to open, or list of figure handles.
%   SubLoc - Vector indicating subplots locations [cols rows ] (default is [ 0 2 ]).
%   DstOpt - Subplots distribution option (1 - rows, 2 - columns)
%   DoAxes - Enable/Disable the several axes of the figures to be included.
%   DoOrder - Order the handles before merging.
%
% Output:
%   FigHdl - New figure handle.
%   SubHdl - Subplot handles in new figure.
%
% Examples:
%   % for a set of files
%   figmerge( {'f0.fig'; 'f1.txt'; 'f2.fig'}, [ 2 1 ] )
%   % for all fig files in dir
%   d = dir('*.fig');
%   FigLst = cellstr(char(d.name));
%   figmerge( FigLst, [], true);
%   [ FigHdl, SubHdl ] = figmerge( FigLst, [ 0 4 ] )
%   % for a set of opened figures
%   FigLst = [ 1 2 3 4 ]; % list of figure handles
%   figmerge( FigLst, [ 2 ] )
%   figmerge( FigLst )
%   % for a set of opened figures, and all axes per figure
%   FigLst = [ 1 2 ]; % list of figure handles
%   FigAxsLst = findall(FigLst, 'Type','Axes');
%   figmerge( FigAxsLst )
%   figmerge( FigLst, 2, true )
%
% Author/Location:	Tashi Ravach
% Version/Date:     1.0 (April 15, 2011)
%

    if nargin == 1
        SubLoc = [ 0 2 ];
        DstOpt = 1;
        DoAxes = true;
        DoOrder = true;
    elseif nargin == 2
        DstOpt = 1;
        DoAxes = true;
        DoOrder = true;
    elseif nargin == 3
        DoAxes = true;
        DoOrder = true;
    elseif nargin == 4
        DoOrder = true;
    end

    if isempty(FigLst)
        error('figmerge: list is empty');
    end
    
    if isempty(SubLoc) || ~isempty(find(SubLoc<0, 1)) || sum(SubLoc) == 0
        SubLoc = [ 0 2 ];
    elseif length(SubLoc) == 1
        SubLoc = [ 0 SubLoc ];
    elseif length(SubLoc) > 2
        SubLoc = [ SubLoc(1) SubLoc(2) ];
    end
    SubLoc = ceil(abs(SubLoc)); % force positive integers
    
    % if the list is a cell array of paths, check if files are .fig
    FigLst = FigLst(:);
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

        % define the subplots grid
        FigHdl = figure; % new figure 
        AllFig = length(isfig);
        SubHdl = zeros(AllFig, 1);
        if SubLoc(1) == 0 && SubLoc(2) > 0
            SubLoc(1) = ceil(AllFig / SubLoc(2));
        elseif SubLoc(1) > 0 && SubLoc(2) == 0
            SubLoc(2) = ceil(AllFig / SubLoc(1));
        end
        
        % assign subplots to handles
        if AllFig == 1
            SubHdl = gca(FigHdl);
        else
            for k = 1 : AllFig
                SubHdl(k) = subplot(SubLoc(1), SubLoc(2), k);
            end
        end

        % prepare to inserted in specified order
        if DoOrder == true
            FigLst = sort(FigLst);
        end
        if DstOpt == 1
            try
                PAD = SubLoc(1)*SubLoc(2)-length(SubHdl);
                if mod(length(SubHdl), 2) ~= 0
                    SubHdl = [ SubHdl; NaN*ones(PAD,1) ];
                end
                SubHdl = reshape(SubHdl, SubLoc(2), SubLoc(1))';
                SubHdl = SubHdl(:);
                SubHdl(isnan(SubHdl)) = [];
            catch
            end
        end
        
        % copy from figures to new figure subplot
        for k = 1 : AllFig
            if strcmpi(get(FigLst(isfig(k)), 'Type'), 'Figure')
                OldGca = gca(FigLst(isfig(k))); 
            elseif strcmpi(get(FigLst(isfig(k)), 'Type'), 'Axes')
                OldGca = FigLst(isfig(k)); 
            end
            NewPos = get(SubHdl(k), 'Position');
            delete(SubHdl(k)) % Delete the subplot 
            C = copyobj(OldGca, FigHdl);
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

