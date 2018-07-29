function [varargout] = legendGrid(varargin)
% 
% LEGENDGRID Display legend in a grid mode.
%  
%     LEGENDGRID(H,string1,...,stringN, numHandlesPerColumn) 
%           numHandlesPerColumn is a 1-by-M matrix with sum(numHandlesPerColumn) = N (number of handles)
%           The location by default is 'SouthOutside'.
%  
%     LEGENDGRID(AX, ...) 
% 
%     LEGENDGRID(..., strTitles) 
% 
%     LEGENDGRID(..., 'name1', value1, 'name2', value2, ...)
%           can use as parameters 'fontSize', 'markerSize' and 'lineWidth'
% 
%     Examples:
%         x = 0:.2:12;
%         h = plot(x,bessel(1,x),x,bessel(2,x),x,bessel(3,x));
%         str_legend = {'First','Second','Third'};
%         numHandlesPerColumn = [1 1 1];
%         lg = legendGrid(h, str_legend, numHandlesPerColumn, ...
%                 'LineWidth', 2, 'fontSize', 20);
%  
%         b = bar(rand(10,5),'stacked'); colormap(summer); hold on
%         x = plot(1:10,5*rand(10,1),'marker','square','markersize',12,...
%                  'markeredgecolor','y','markerfacecolor',[.6 0 .6],...
%                  'linestyle','-','color','r','linewidth',2); hold off
%         legendGrid([b,x],'Carrots','Peas','Peppers','Green Beans',...
%                   'Cucumbers','Eggplant', [3 3])
% 
%         b = bar(rand(10,5),'stacked'); colormap(summer); hold on
%         x = plot(1:10,5*rand(10,1),'marker','square','markersize',12,...
%                  'markeredgecolor','y','markerfacecolor',[.6 0 .6],...
%                  'linestyle','-','color','r','linewidth',2); hold off
%         legendGrid(b,'Carrots','Peas','Peppers','Green Beans',...
%                   'Cucumbers', [3 2])
%               
%         b = bar(rand(10,5),'stacked'); colormap(summer); hold on
%         x = plot(1:10,5*rand(10,1),'marker','square','markersize',12,...
%                  'markeredgecolor','y','markerfacecolor',[.6 0 .6],...
%                  'linestyle','-','color','r','linewidth',2); hold off
%           legendGrid([b,x],'Carrots','Peas','Peppers','Green Beans',...
%                   'Cucumbers','Eggplant', [2 2 2])
%               
%    Author: Mar Callau Zori
%    Date:   7/20/2012
%    version: 1.0


    % input parameters
    [ax, h, str_lg, numHandlesPerColumn, ...
        strTitles, fontSize, markerSize, lineWidth] = extractInput(varargin{:});

    %% delete older legend or legendGrid
    f     = get(ax, 'parent');
    
    old_lg = findobj(f, 'tag', 'legend');
    if ~isempty(old_lg)
        delete(old_lg)
    end
    
    old_ax = findobj(f, 'tag', 'lgGrid_axes');
    if ~isempty(old_ax)
        delete(old_ax)
    end
    
    old_lg = findobj(f, 'tag', 'lgGrid');
    if ~isempty(old_lg)
        delete(old_lg)
    end
    
    
    % legend handle and string
    numC  = length(numHandlesPerColumn);
    ax_lg = NaN .* ones(1, numC);
    lg    = NaN .* ones(1, numC);
    h_lg  = cell(1, numC);

    for i=1:numC
        indx_info = sum(numHandlesPerColumn(1:i-1))+1:sum(numHandlesPerColumn(1:i));
        % copy handles to axes legend
        ax_lg(i)  = axes('visible','off', 'parent', f, 'tag', 'lgGrid_axes');
        h_lg{i} = copyobj(h, ax_lg(i));
        
        % set legend
        lg(i)      = legend(h_lg{i}(indx_info), str_lg(indx_info));
        set(lg(i) , 'tag', 'lgGrid');        
    end
    
    %% change properties
    if isnan(fontSize) 
        object_handles = findall(ax);
        indx           = isprop(object_handles, 'fontSize');
        if nnz(indx)>0
            if nnz(indx)==1
                fontSize   = get(object_handles(indx), 'fontSize');
            else
                fontSize   = max(cell2mat(get(object_handles(indx), 'fontSize')));
            end
        end
    end
    if isnan(markerSize) 
        object_handles = findall(ax);
        indx           = isprop(object_handles, 'markerSize');
        if nnz(indx)>0
            if nnz(indx)==1
                markerSize   = get(object_handles(indx), 'markerSize');
            else
                markerSize     = max(cell2mat(get(object_handles(indx), 'markerSize')));
            end
        end
    end
    if isnan(lineWidth) 
        object_handles = findall(ax);
        indx           = isprop(object_handles, 'lineWidth');
        if nnz(indx)>0
            if nnz(indx)==1
                lineWidth   = get(object_handles(indx), 'lineWidth');
            else
                lineWidth      = max(cell2mat(get(object_handles(indx), 'lineWidth')));
            end
        end
    end
    
    for i=1:numC
        object_handles = findall(lg(i));
        for j=1:length(object_handles)
            if isprop(object_handles(j), 'fontSize')
                set(object_handles(j), 'fontSize', fontSize);
            end
            if isprop(object_handles(j), 'markerSize')
                set(object_handles(j), 'markerSize', markerSize);
            end
            if isprop(object_handles(j), 'lineWidth')
                set(object_handles(j), 'lineWidth', lineWidth);
            end
        end
    end        
            
    
    %% legend position
    unit_ax  = get(ax, 'units');
    set(ax, 'units', 'normalized')
    
    outpos_ax = get(ax, 'outerposition');          
    outerpos_lg = cell2mat(get(lg, 'outerposition'));
    minX = max(0, (1-sum(outerpos_lg(:,3)))/2);
    
    for i=1:numC
        set(h_lg{i}, 'Visible', 'off');
        set(lg(i), 'units', 'normalized')
        
        outerpos_lg    = get(lg(i), 'outerposition');
        outerpos_lg(1) = minX;
        outerpos_lg(2) = outpos_ax(2);        
        set(lg(i), 'outerposition', outerpos_lg)
        
        minX = minX + outerpos_lg(3);
    end
    
    
    %% axes position
    pos_ax      = get(ax, 'position');    
    tig_ax      = get(ax, 'tightInset');       
    outerpos_lg = cell2mat(get(lg, 'outerposition'));
    
    diff_pos2 = max(outerpos_lg(:,4)) + 1.2*tig_ax(2) - pos_ax(2);
    pos_ax(2) = max(outerpos_lg(:,4)) + 1.2*tig_ax(2);
    pos_ax(4) = pos_ax(4) - diff_pos2;
    set(ax, 'position', pos_ax)
           
    set(ax, 'units', unit_ax);
    

    %% 
    if nargout>0
        varargout{1} = lg;
    end
    
end


function [ax, h, str_lg, numHandlesPerColumn, ...
        strTitles, fontSize, markerSize, lineWidth] = extractInput(varargin)
   
    % axes, ax
    if ~isempty(varargin) && length(varargin{1})==1 && ishandle(varargin{1})
        ax = varargin{1};
        varargin = varargin(2:end);
    else
        ax = gca;
    end
    
    % handles vector, h
    if ~isempty(varargin) && isnumeric(varargin{1})
        h = varargin{1};
        varargin = varargin(2:end);
        numH = length(h);
    else
        error('stat:extractInput:wrongInput', 'A matrx with the handle is needed');
    end
    
    % strings, str_l. A cell of string or a list of strings
    if ~isempty(varargin) && (iscell(varargin{1}) || ischar(varargin{1}) )
        if iscell(varargin{1})
            str_lg = varargin{1};
            varargin = varargin(2:end);
        else
            
            if length(varargin)<numH
                error('stat:extractInput:wrongInput', 'The strings to the legend are needed');
            else
                str_lg = cell(1, numH);
                for i=1:numH
                    if ischar(varargin{1})
                        str_lg{i} = varargin{1};
                        varargin = varargin(2:end);
                    else
                        error('stat:extractInput:wrongInput', 'The strings to the legend are needed');
                    end                
                end
            end
        end
    else
        error('stat:extractInput:wrongInput', 'The strings to the legend are needed');
    end
    
    % numHandlesPerColumn, a vector
    if ~isempty(varargin) && isnumeric(varargin{1}) 
        numHandlesPerColumn = varargin{1};
        varargin = varargin(2:end);
        if sum(numHandlesPerColumn) ~=numH
            error('stat:extractInput:wrongInput', 'The numHandlesPerColumn must be sum the number of handles');
        end
        numColumns = length(numHandlesPerColumn);
    else
        error('stat:extractInput:wrongInput', 'The numHandlesPerColumn must be numeric');
    end
    
    % strTitles (optional)
    if ~isempty(varargin) && iscell(varargin{1}) && length(varargin{1})>=1 && ischar(varargin{1}{1})
        strTitles = varargin{1};
        varargin = varargin(2:end);
        if length(strTitles) ~=numColumns
            error('stat:extractInput:wrongInput', 'The strTitles must be a length of the number of columns');
        end
    else
        strTitles = {};
    end        
    
    % PARAMETERS: fontSize, markerSize, lineWidth (in any order)
    if ~isempty(varargin)
        names          = {'fontSize' 'markerSize', 'lineWidth'};
        defaultValues  = { NaN       NaN           NaN};
        [fontSize, markerSize, lineWidth, varargin] = getParameters(names,defaultValues,varargin{:}) ;
    else
        fontSize = NaN;
        markerSize = NaN;
        lineWidth  = NaN;
    end
end

function [varargout] = getParameters(names,defaultValues,varargin)
% 
%GETPARAMETERS GEt parameters from pairs  name(str), value 
% 
%   [A1,A2,...,NOTUSEDVARARGIN] = GETPARAMETERS(NAMES, DEFAULTVALUES, 'NAME1', VAL1, 'NAME2',VAL2,..)
%       Input parameters:
%           - NAMES of the valid parameters.
%           - DEFAULTVALUES, defualt value to each parameter name.
%           - 'NAME1', VAL1, maiing parameter NAME1 has the value VAL1.
%       Output parameters:
%           - Aj, the variable Aj stores the VALi, where NAMEi is equal to NAMES{j}.
%           - NOTUSEDVARARGIN, not used varargin omponent 
% 
%       names          = {'color' 'linestyle', 'linewidth'}
%       defaultValues  = {    'r'         '_'          '1'}
%       varargin       = {{'linewidth' 2 'nonesuch' [1 2 3] 'linestyle' ':'}}
%       [c,ls,lw, varargin_out] = getParameters(names,defaultValues,varargin{:})    
% 
% 
%   Author: Mar Callau-Zori
%   Date: 07/20/2012

    numP = length(names);
    varargout = cell(1, numP+1);
    
    indx_str     = find(cellfun(@(x) ischar(x), varargin)); 
    varargin_str = varargin(indx_str);
    
    % find each parameter name
    pos_delete_varargin = [];
    for i=1:numP
        indx = cellfun(@(x) strcmpi(x, names{i}), varargin_str);
        if nnz(indx)==0
            varargout{i} = defaultValues{i};
        else
            varargout{i} = varargin{indx_str(indx)+1};
            pos_delete_varargin = [pos_delete_varargin, indx_str(indx) indx_str(indx)+1];
        end
    end
            
    varargout{end} = varargin(setdiff(1:length(varargin), pos_delete_varargin));
end




