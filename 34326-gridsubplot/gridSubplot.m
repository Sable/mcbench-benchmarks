function f = gridSubplot(varargin)
% 
% GRIDSUBPLOT   build a figure with subplots given by an figures vector.
%     Only axes are copied. 
% 
% F = GRIDSUBPLOT(FIG_VECTOR) build a figure F with with subplot given
%    by the figures in FIG_VECTOR. There is just one axes per figure
%    (legends is also copy to the subplots figures).
%   - FIG_VECTOR: vector of the handles to the figure objects.
% 
%  
% [...] = GRIDSUBPLOT(OUTERPOSITION_FIG, ...) - OUTERPOSITION_FIG is the
% size and location of the return figure (default the entire screen).
% 
% 
% [...] = GRIDSUBPLOT(..., NUMFIL, NUMCOL) - set the figures into a
%     NUMFIL-by-NUMCOL subplot.
% 
% 
% COPYAXES function version 1.1 (December 2011) is included.
%   url: http://www.mathworks.com/matlabcentral/fileexchange/34314-copyaxes
% 
% EXAMPLE: Six figures are plotted into a figure with 2x3 subplot. The
%   result figure takes up all the screen.
%      
%     numFigures = 6;
%     ax_list = NaN .* ones(1, numFigures);
%     x = 1:0.1:2*pi;
%     for i=1:numFigures
%         fig_list(i) = figure;
%         plot(x, sin(i*x));
%         title(['case ',num2str(i)])% 
%         if (i==2) || (i==3)
%             xlabel('xlabel');
%         end
%         if (i==2) ||(i==4)
%             ylabel('ylabel');
%         end
%         lg(i) = legend(['coef = ',num2str(i)]);
%     end   
% 
%     f = gridSubplot(fig_list, 2,3);
% 
% 
% 
% EXAMPLE: Six figures are plotted into a figure in a subplot. The
%   result figure has size and position the same as the first figure in the input vector.
%       
%     numFigures = 6;
%     ax_list = NaN .* ones(1, numFigures);
%     x = 1:0.1:2*pi;
%     for i=1:numFigures
%         fig_list(i) = figure;
%         plot(x, sin(i*x));
%         title(['case ',num2str(i)])
%         if (i==2) || (i==3)
%             xlabel('xlabel');
%         end
%         if (i==2) ||(i==4)
%             ylabel('ylabel');
%         end
%         lg(i) = legend(['coef = ',num2str(i)]);
%     end
%     
%     f = gridSubplot(get(fig_list(1), 'outerposition'), fig_list);
%     
% 
% tags: figure, grid, position, outerposition
% 
% 
% author: Mar Callau-Zori
% PhD student - Universidad Politecnica de Madrid
% 
% version: 1.0, December 2011.
% 

    % input parameters
    outerposition_fig = [];
    numFil = NaN;
    numCol = NaN;
    switch nargin
        case 1
            fig_vector = varargin{1};
        case 2
            outerposition_fig = varargin{1};
            fig_vector = varargin{2};
        case 3
            fig_vector = varargin{1};
            numFil = varargin{2};
            numCol = varargin{3};
        case 4
            outerposition_fig = varargin{1};
            fig_vector = varargin{2};
            numFil = varargin{3};
            numCol = varargin{4};
        otherwise
            error('gridSubplot:argChk', 'Wrong input arguments');
    end
    
    if isempty(outerposition_fig)
        screen_position    = get(0, 'ScreenSize');
        screen_position(2) = 50; 
        outerposition_fig = [screen_position(1) ...
                            screen_position(2) ...
                            screen_position(3) - screen_position(1) ...
                            screen_position(4) - screen_position(2)];        
    end
    
    if isnan(numFil)
        [numFil, numCol] = compute_NumFig_numClo(length(fig_vector));
    end

    width_ax  = 1 ./ numCol;
    height_ax = 1 ./ numFil;
        
    f = figure;          
    fig_units = get(f, 'units');
    set(f, 'Units',  'pixels');
    set(f, 'outerposition', outerposition_fig);
    set(f, 'Units', fig_units);
            
    ax = NaN .* ones(1, length(fig_vector));
    lg = NaN .* ones(1, length(fig_vector));
    length(fig_vector)
    y_pos = 1-height_ax;
    count = 0;
    for i=1:numFil
        x_pos = 0; 
        for j=1:numCol
            count = count+1;
            ax_vector(count) = findobj(fig_vector(count), 'type', 'axes', 'tag', '');
            lg_vector(count) = findobj(fig_vector(count), 'type', 'axes', 'tag', 'legend');
                       
            ax(count) = subplot(numFil,numCol,count);
            copyaxes(ax_vector(count),ax(count), true);
            
            ax_units = get(ax(count), 'units');
            set(ax(count), 'Units', 'normalized');
            ax_outpos = [x_pos, y_pos, width_ax, height_ax];
            set(ax(count), 'outerposition', ax_outpos);
            set(ax(count), 'Units', ax_units);    
            
            lg(count) = legend('');
            copyaxes(lg_vector(count),lg(count), true, true);
                        
            x_pos = x_pos + width_ax;
            
            if count == length(fig_vector)
                break;
            end
        end
        y_pos = y_pos - height_ax;        
        
        if count == length(fig_vector)
           break;
        end
    end

end

function [numFil, numCol] = compute_NumFig_numClo(numTotal)

    sqrt_total = sqrt(numTotal);
    numFil = floor(sqrt_total);
    numCol = ceil(sqrt_total);
    
    if numFil * numCol < numTotal
        numCol = numCol+1;
    end

end

function copyaxes(source, destination, varargin)
% 
% COPYAXES - copy a handle object axes inpt
% 
% COPYAXES(SOURCE, DESTINATION) - copy axes from SOURCE to DESTINATION
% 
% COPYAXES(..., isInSubplot) - if the destination is in a subplot figure
%       (default false).
% 
% COPYAXES(..., isLegend) - if the axes is a legend (only if isInSubplot is
%       true) (default false)
% 
% 
% EXAMPLE: Copy a axes with plot
% 
%   plot([1:0.1:2*pi], sin([1:0.1:2*pi]));
%   title('sin function')
%   xlabel('x')
%   ylabel('sin(x)')
%   ax = gca;
% 
%   figure;
%   ax_new = axes;
%   copyaxes(ax, ax_new)
% 
% 
% EXAMPLE: Copy a axes with bar
% 
%   bar(rand(10,5),'stacked');
%   title('bar stacket function')
%   xlabel('x label')
%   ylabel('y label')
%   ax = gca;
% 
%   figure;
%   ax_new = axes;
%   copyaxes(ax, ax_new)
% 
% 
% EXAMPLE: Copy a axes and legend (the legend is an axes object)
% 
%   plot([1:0.1:2*pi], sin([1:0.1:2*pi]));
%   title('sin function')
%   xlabel('x')
%   ylabel('sin(x)')
%   lg = legend('sin');
%   ax = gca;
% 
%   figure;
%   ax_new = axes;
%   lg_new = axes;
%   copyaxes(ax, ax_new)
%   copyaxes(lg, lg_new)
% 
% EXAMPLE: Copy an axes with a surface in a subplot. 
%   Colormap is a figure property, not axes property.
% 
%   k = 5;
%   n = 2^k-1;
%   [x,y,z] = sphere(n);
%   c = hadamard(2^k);
%   surf(x,y,z,c);
%   axis equal
%   title('sphere')
%   xlabel('x label')
%   ylabel('y label')
%   zlabel('z label')
%   ax = gca;
%   colormap([1  1  0; 0  1  1])
% 
%   figure;
%   ax_new = subplot(2,2,1);
%   copyaxes(ax, ax_new, true)
%   colormap([1  1  0; 0  1  1])
% 
% 
% 
% tags: figure, copy, axes,
% 
% 
% author: Mar Callau-Zori
% PhD student - Universidad Politecnica de Madrid
% 
% version: 1.1, December 2011
% 

    isInSubplot = false;
    isLegend    = false;        
    
    switch nargin
        case 3
            isInSubplot = varargin{1};
        case 4
            isInSubplot = varargin{1};
            isLegend    = varargin{2};            
        otherwise
            error('ERROR:copyaxes:argChk', 'Wrong input arguments');
    end

    if ~isLegend
        copyobj(get(source, 'Children'), destination);

        title = copyobj(get(source, 'Title'), destination);
        set(destination, 'Title', title);

        xlabel = copyobj(get(source, 'XLabel'), destination);
        set(destination, 'XLabel', xlabel);

        ylabel = copyobj(get(source, 'YLabel'), destination);
        set(destination, 'YLabel', ylabel);

        zlabel = copyobj(get(source, 'ZLabel'), destination);
        set(destination, 'ZLabel', zlabel);
    else
        set(destination, 'string', get(source, 'string'))
    end
    
    properties_str = {  'Units'
                        'ActivePositionProperty'
                        'ALim'
                        'ALimMode'
                        'AmbientLightColor'
                        'Box'
                        'CameraPosition'
                        'CameraPositionMode'
                        'CameraTarget'
                        'CameraTargetMode'
                        'CameraUpVector'
                        'CameraUpVectorMode'
                        'CameraViewAngle'
                        'CameraViewAngleMode'
                        'CLim'
                        'CLimMode'
                        'Color'
                        'CurrentPoint'
                        'ColorOrder'
                        'DataAspectRatio'
                        'DataAspectRatioMode'
                        'DrawMode'
                        'FontAngle'
                        'FontName'
                        'FontSize'
                        'FontUnits'
                        'FontWeight'
                        'GridLineStyle'
                        'Layer'
                        'LineStyleOrder'
                        'LineWidth'
                        'MinorGridLineStyle'
                        'NextPlot'
                        'OuterPosition'
                        'PlotBoxAspectRatio'
                        'PlotBoxAspectRatioMode'
                        'Projection'
                        'Position'
                        'TickLength'
                        'TickDir'
                        'TickDirMode'
                        'TightInset'
                        'View'
                        'XColor'
                        'XDir'
                        'XGrid'
                        'XAxisLocation'
                        'XLim'
                        'XLimMode'
                        'XMinorGrid'
                        'XMinorTick'
                        'XScale'
                        'XTick'
                        'XTickLabel'
                        'XTickLabelMode'
                        'XTickMode'
                        'YColor'
                        'YDir'
                        'YGrid'
                        'YAxisLocation'
                        'YLim'
                        'YLimMode'
                        'YMinorGrid'
                        'YMinorTick'
                        'YScale'
                        'YTick'
                        'YTickLabel'
                        'YTickLabelMode'
                        'YTickMode'
                        'ZColor'
                        'ZDir'
                        'ZGrid'
                        'ZLim'
                        'ZLimMode'
                        'ZMinorGrid'
                        'ZMinorTick'
                        'ZScale'
                        'ZTick'
                        'ZTickLabel'
                        'ZTickLabelMode'
                        'ZTickMode'
                        'BeingDeleted'
                        'ButtonDownFc'
                        'Clipping'
                        'CreateFcn'
                        'DeleteFcn'
                        'BusyAction'
                        'HandleVisibility'
                        'HitTest'
                        'Interruptible'
                        'Selected'
                        'SelectionHighlight'
                        'Tag'
                        'Type'
                        'UIContextMenu'
                        'UserData'
                        'Visible'};


    for i=1:length(properties_str)
        
        if (strcmpi(properties_str{i}, 'position') || strcmpi(properties_str{i}, 'outerposition'))
            
            if ~isInSubplot 
                try
                    set(destination, properties_str{i}, get(source, properties_str{i}));
                catch e
                    if ~strcmpi(e.identifier, 'MATLAB:hg:propswch:FindObjFailed') && ...
                       ~strcmpi(e.identifier, 'MATLAB:hg:g_object:MustBeInSameFigure')
                            rethrow(e);
                    end
                end
                
            elseif isLegend
                % change the reference  
                    try
                        units_dst = get(destination, 'units');
                        units_src = get(source, 'units');
                        set(destination, 'units', 'pixels');
                        set(source, 'units', 'pixels');
                        aux_dst = get(destination, properties_str{i});
                        aux_src = get(source, properties_str{i});
                        aux_dst(3) =  aux_src(3);
                        aux_dst(4) =  aux_src(4);
                        set(destination, properties_str{i}, aux_dst);
                        set(destination, 'units', units_dst);
                        set(source, 'units', units_src);
                    catch e
                        if ~strcmpi(e.identifier, 'MATLAB:hg:propswch:FindObjFailed') && ...
                           ~strcmpi(e.identifier, 'MATLAB:hg:g_object:MustBeInSameFigure')
                                rethrow(e);
                        end
                    end
            end
        else
            try
                set(destination, properties_str{i}, get(source, properties_str{i}));
            catch e
                if ~strcmpi(e.identifier, 'MATLAB:hg:propswch:FindObjFailed') && ...
                   ~strcmpi(e.identifier, 'MATLAB:hg:g_object:MustBeInSameFigure')
                         rethrow(e);
                end
            end
        end
    end
 
end




