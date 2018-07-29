function varargout = setaxes(varargin)
%SETAXES   fixes common problems with MATLAB figures.
%  
%   SETAXES(AX, ...) applies to the axes AX which, when not supplied, defaults to the current axes.
%
%
%    SETAXES('xoffset') [2-D view only] adjusts the axes position in the 
%    horizontal direction to make up for any clipped (left or right) part
%    of the axes based on some default settings.
%
%    SETAXES('yoffset') [2-D view only] adjusts the axes position in the 
%    vertical direction to make up for any clipped (lower or upper) part 
%    of the axes based on some default settings. 
%
%    SETAXES('axesmoveresize', [L B R T]) adds the array [L B -R -T] to the   
%    'OuterPosition' property  of the axes. 
%
%
%    SETAXES('xtick2text', OFFSET) [2-D view only] replaces the tick labels
%    on the X-Axis by text objects where OFFSET is the factor of the axis 
%    height used as the vertical margin from the X-Axis. 
%
%       When not supplied, OFFSET defaults to 0.03. 
%
%    SETAXES('xtick2text',..., PROP1, VALUE1, PROP2, VALUE2, ...)
%       sets the values of the specified properties of the text objects.
%    
%    HT = SETAXES('xtick2text',...) returns in HT the handles of the text objects.
% 
% 
%    SETAXES('ytick2text', OFFSET) [2-D view only] replaces the tick labels
%    on the Y-Axis by text objects where OFFSET is the factor of the axis 
%    width used as the horizontal margin from the Y-Axis. 
%
%       When not supplied, OFFSET defaults to 0.02. 
%
%    SETAXES('ytick2text',..., PROP1, VALUE1, PROP2, VALUE2, ...)
%       sets the values of the specified properties of the text objects.
%    
%    HT = SETAXES('ytick2text',...) returns in HT the handles of the text objects. 
% 
% 
%    SETAXES('xlabelcorner') [2-D view only] places the XLABEL in an 
%    appropriate corner. The most common corner is the right-bottom when
%    the X-Axis is to the bottom and the ticks are increasing from left to
%    right. The corner changes accordingly for other combinations of axes properties.
% 
%    SETAXES('xlabelcorner', PROP1, VALUE1, PROP2, VALUE2, ...)
%    sets the values of the specified properties of the XLabel object.
%
%
%    SETAXES('ylabelcorner') [2-D view only] places the YLABEL in an 
%    appropriate corner. The most common corner is the top-left when the
%    Y-Axis is to the left and the ticks are increasing upward. The corner
%    changes accordingly for other combinations of axes properties. 
% 
%    SETAXES('ylabelcorner', PROP1, VALUE1, PROP2, VALUE2, ...)
%    sets the values of the specified properties of the YLabel object.
% 
% 
%    SETAXES('axesarrows') [2-D view only] adds arrow annotation objects to
%    X- and Y-Axis. The default 'HeadLength' and 'HeadWidth' are both 5. 
%    Line width and Color are inherited from the the corresponfing axis line.
%
%    SETAXES('axesarrows','xx') adds arrow annotation objects to X-Axis only. 
%    SETAXES('axesarrows','yy') adds arrow annotation objects to Y-Axis only. 
%    
%    SETAXES('axesarrows',..., PROP1, VALUE1, PROP2, VALUE2, ...)
%    sets the values of the specified properties of the arrow objects.
%
%    HA = SETAXES('axesarrows',...) returns in HA the handles of the arrow objects.
%
%    Note that since SETAXES('axesarrows',...) changes the axes position property, any
%    annotation objects should be added after SETAXES('axesarrows',...).
%
%=======================================================================
%                   EXAMPLE trying to cover a few features:
%-----------------------------------------------------------------------
%
% figure('Units', 'centimeters', ...
%        'Position', [2 2 8 6], ...
%        'PaperUnits', 'centimeters', ...       
%        'PaperSize', [8 6], ...
%        'PaperPositionMode', 'auto')
% 
% ax = axes('FontSize', 8, ...
%            'LineWidth', 0.4, ...
%            'Box', 'off', ...
%            'TickDir', 'out' );
%     
% hold all
% 
% t = linspace(0,5,51);
% n = 1:49;
% rand('state', sum(100*clock));
% W = [0 cumsum(-log(rand(size(n)))./n)];
% hPlot(1) = stairs(W, [n 50], '-b');
% hPlot(2) = line(t, exp(t), 'LineStyle', '--', 'Color', 'r');
% axis([0 5 0 50])
% 
% xlabel('$T=\mathrm{Exp}(\frac{1}{X})$', 'Interpreter','LaTeX');
% ylabel('$X$', 'Interpreter','LaTeX');
% legend(hPlot, {'sample $n$'; 'mean $\mu(T)$'}, 'Interpreter','LaTeX')
% set(ax, 'XTickLabel', {'$0$';'$\tau_1$';'$\tau_2$'; ...
%                          '$\tau_3$';'$\tau_4$';'$\tau_5$'}, ...
%         'YTickLabel', {'$0$';'$X_1$';'$X_2$';'$X_3$';'$X_4$';'$X_5$'} )
% 
% setaxes('xtick2text')
% setaxes('ytick2text')
% setaxes('ylabelcorner')
% setaxes('yoffset')
% setaxes('axesarrows')
% 
% [xfig,yfig] = dsxy2figxy([1 2], [45 45]);
% har = annotation('doublearrow', xfig , yfig);
% set(har, 'LineWidth', .25, 'Color', 'k', ...
%          'Head1Length', 3.5, 'Head2Length', 3.5, ...
%          'Head1Width', 3.5, 'Head2Width', 3.5, ...
%          'Head1Style', 'vback3', 'Head2Style', 'vback3')
%      
% text(1.5, 48, '$\Delta \tau$', ...
%             'VerticalAlignment', 'bottom', ...
%             'HorizontalAlignment', 'center', 'Interpreter','LaTeX');
% print -dpdf setaxes_example.pdf
%
%
%=========================================================================

% Mukhtar Ullah
% mukhtar.ullah@informatik.uni-rostock.de
% First created: Sep 18, 2008
% Last modified: Oct 18, 2010
%
%=========================================================================

persistent SetAxes_CurrentAxes SetAxes_Functions SetAxes_ValidNames

[ax,argsmain,nIn] = axescheck(varargin{:});

error(nargchk(1, inf, nIn));

if isempty(ax)
    ax = gca;
else
    assert(~strcmp(get(ax,'Tag'),'legend'), 'Legend Axes not supported')
end

% Bring to focus
figure(get(ax, 'Parent'))
set(gcf, 'CurrentAxes', ax)

% first time run or a successive run for a different axes
if isempty(SetAxes_CurrentAxes) ||  ax~=SetAxes_CurrentAxes
    SetAxes_CurrentAxes = ax;
    SetAxes_Functions = {};
end

if isempty(SetAxes_Functions)
    oldaxunits = get(ax, 'Units');
    set(ax, 'Units', 'normalized')
    
    axprop = get(ax, {'Position', ...
        'OuterPosition', ...
        'LooseInset', ...
        'XTick', ...
        'YTick', ...
        'XLim', ...
        'YLim', ...
        'Xlabel', ...
        'Ylabel', ...
        'Title'} );
    set(ax, 'Units', oldaxunits)
    
    numvar = numel(axprop);
    
    axprop  = [axprop, get(ax, {'XAxisLocation', ...
        'YAxisLocation', ...
        'XDir', ...
        'YDir', ...
        'XScale', ...
        'YScale', ...
        'XTickLabelMode', ...
        'YTickLabelMode'} )];
    
    [axpos, outpos, looseinset, xtick, ytick, axlim(1:2), axlim(3:4), ...
        hxlab, hylab, htitle, xxloc, yyloc] = axprop{1:numvar+2};
    
    proptf = num2cell(strcmp(axprop(numvar+1:end), ...
        {'bottom', 'left', 'normal', 'normal', 'log', 'log', 'auto', 'auto'}));
    
    [isxxbottom, isyyleft, isxdirnormal, isydirnormal, ...
        isxxlog, isyylog, autoxticklab, autoyticklab] = proptf{:};
    
    [dxt, dyt, dxtfig, dytfig, xtickroom, ytickroom] = deal(0);
    isxlabelcorner = false;
    isylabelcorner = false;
    
    notxxloc = setdiff({'top', 'bottom'}, xxloc);
    notyyloc = setdiff({'left', 'right'}, yyloc);
    set([hxlab, hylab, htitle], {'Tag'}, {'XLabel'; 'YLabel'; 'Title'})
    xlabpos = get(hxlab, 'Position');
    ylabpos = get(hylab, 'Position');
    
    [axwidth, axheight, ...
        xlabhalign, ylabhalign, xlabvalign, ylabvalign] = falign();
    
    %---------------------------------------------------------------------- 
    
    
        SetAxes_ValidNames = {'axesmoveresize', 'legendmoveresize'};
        
        [az,el]=view(ax);
        camUp = get(ax,'CameraUpVector');      
        if (az==0) && (el==90) && isequal(abs(camUp),[0 1 0]) % Is2D
            SetAxes_ValidNames = [ SetAxes_ValidNames, ...
                { 'xoffset', 'yoffset', ...
                'xtick2text', 'ytick2text', ...
                'xlabelcorner', 'ylabelcorner', 'axesarrows' } ];
        end
        
        SetAxes_Functions = cellfun(@(s) eval(['@', s]), SetAxes_ValidNames, 'UniformOutput', false);
end

funstr = validatestring(argsmain{1}, SetAxes_ValidNames);

fh = SetAxes_Functions{strcmp(funstr, SetAxes_ValidNames)};
nOut = nargout;

switch sprintf('%d',[nIn-1 nOut]>0)
    case '00'
        fh();
    case '10'
        fh(argsmain{2:end});
    case '01'
        [varargout{1:nOut}] = fh();
    otherwise
        [varargout{1:nOut}] = fh(argsmain{2:end});
end

%==========================================================================
    function xoffset()
        if ~isylabelcorner && get(hylab, 'Rotation')==0
            set(hylab, 'HorizontalAlignment', ylabhalign)
        end
        tightinset = get(ax, 'TightInset');
        set(ax, 'LooseInset', max(looseinset, tightinset))
        restoreleftright(hylab)        
    end
%--------------------------------------------------------------------------
    function yoffset()
        tightinset = get(ax, 'TightInset');
        set(ax, 'LooseInset', max(looseinset, tightinset))
        restoreupdown(hxlab)
        restoreupdown(htitle)
    end
%--------------------------------------------------------------------------
    function axesmoveresize(offset)
        if nargin == 0            
            disp('Drag a rectangle in the axes to define OuterPosition:')
            k = waitforbuttonpress;
            if k == 1
                return
            end
            % fig = gcf; if the figure is already in focus
            fig = get(ax, 'Parent');
            oldunits = get(fig, 'Units');
            set(fig, 'Units', 'normalized')
            outpos = rbbox;
            set(fig, 'Units', oldunits)
        else            
            outpos = outpos + [1 1 -1 -1].*offset;
        end
        set(ax, 'OuterPosition', outpos)
        drawnow
        axpos = get(ax, 'Position');
    end   
 %--------------------------------------------------------------------------   
    function hxt = xtick2text(varargin)
        [xtickoffset, pvpairs] = extractoffset(.03, varargin{:});
        hxt = [];
        xticklab = cellstr(get(ax, 'XTickLabel'));
        xticklab = matchticks(xtick, xticklab);
        if ~isempty(xticklab)  
            set(ax, 'XTickLabel', []);
            
            if xor(isxxbottom,isydirnormal)
                yloc = axlim(4) + xtickoffset*axheight;
            else
                yloc = axlim(3) - xtickoffset*axheight;
            end
            
            yloc = yloc(ones(size(xtick)));

            if isyylog
                yloc = 10.^yloc;
                xticklab = append10(xticklab, autoxticklab, pvpairs);
            end

            hxt = text(xtick, yloc, xticklab);
                       
            set(hxt(strncmp('$', xticklab, 1)), 'Interpreter', 'latex')
%             mathtick = ~cellfun(@isempty, ...
%                 regexp(xticklab, '\${1,2}[^\$]*\${1,2}', 'match', 'once'));
%             set(hxt(strncmp(mathtick), 'Interpreter', 'latex')
            
            set(hxt, 'HorizontalAlignment', 'center', ...
                     'VerticalALignment', xlabvalign, pvpairs{:});
            %--------------------------------------------------------------
            oldunits = get(hxt(1), 'Units');
            set(hxt, 'Units', 'normalized')
            xtickext = get(hxt, 'Extent');
            xtickroom = max(cellfun(@(x) x(4), xtickext));
            set(hxt, 'Units', oldunits)
            
            xtickext = get(hxt, 'Extent');
            xlabposnow = get(hxlab, 'Position');
            
            if isxxbottom
                xlabposnow(2) = ...
                    min(cellfun(@(x) x(2), xtickext)) + xtickoffset;
            else
                xlabposnow(2) = ...
                    max(cellfun(@(x) x(2)+x(4), xtickext)) + xtickoffset;
            end
            
            set(hxlab, 'Position', xlabposnow)

        end
    end
%--------------------------------------------------------------------------
    function hyt = ytick2text(varargin)
        [ytickoffset, pvpairs] = extractoffset(.02, varargin{:});           
        hyt = [];
        yticklab = cellstr(get(ax, 'YTickLabel'));
        yticklab = matchticks(ytick, yticklab);
        if ~isempty(yticklab)
            set(ax, 'YTickLabel', []);
            
            if xor(isyyleft,isxdirnormal)
                xloc = axlim(2) + ytickoffset*axwidth;
            else
                xloc = axlim(1) - ytickoffset*axwidth;
            end
            
            xloc = xloc(ones(size(ytick)));
            
            if isxxlog
                xloc = 10.^xloc;
                yticklab = append10(yticklab, autoyticklab, pvpairs);
            end

            hyt = text(xloc, ytick, yticklab);
            
            set(hyt(strncmp('$', yticklab, 1)), 'Interpreter', 'latex')
%             mathtick = ~cellfun(@isempty, ...
%                 regexp(yticklab, '\${1,2}[^\$]*\${1,2}', 'match', 'once'));
%             set(hyt(strncmp(mathtick), 'Interpreter', 'latex')

            set(hyt, 'VerticalAlignment', 'middle', ...
                     'HorizontalALignment', ylabhalign, pvpairs{:})
            %--------------------------------------------------------------
            oldunits = get(hyt(1), 'Units');
            set(hyt, 'Units', 'normalized')
            ytickext = get(hyt, 'Extent');
            ytickroom = max(cellfun(@(x) x(3), ytickext));
            set(hyt, 'Units', oldunits)
            
            ytickext = get(hyt, 'Extent');
            ylabposnow = get(hylab, 'Position');
            
            if isyyleft
                ylabposnow(1) = min(cellfun(@(x) x(1), ytickext));
            else
                ylabposnow(1) = max(cellfun(@(x) x(1)+x(3), ytickext));
            end
            
            set(hylab, 'Position', ylabposnow)

        end
    end
%--------------------------------------------------------------------------
    function xlabelcorner(varargin)        
        if isxxlog
            xlabpos(1:2) = 10.^xlabpos(1:2);
        end        

        set(hxlab, ...
            'Position', xlabpos, ...
            'VerticalALignment', 'middle', ...
            'HorizontalALignment', xlabhalign, varargin{:});

        isxlabelcorner = true;       
        axpos = get(ax, 'Position');
        restoreleftright(hxlab)        
    end
%--------------------------------------------------------------------------
    function ylabelcorner(varargin)
        if isyylog
            ylabpos(1:2) = 10.^ylabpos(1:2);
        end

        set(hylab, ...
            'Position', ylabpos, ...
            'Rotation', 0, ...
            'VerticalALignment', ylabvalign, ...
            'HorizontalALignment', 'center', varargin{:});
        
        isylabelcorner = true;        
        axpos = get(ax, 'Position');
        restoreupdown(hylab)        
    end
%--------------------------------------------------------------------------
    function h = axesarrows(varargin)
        args = varargin;
        xxarrow = true;
        yyarrow = true;
        
        if nargin>0
            switch args{1}
                case 'xx'
                    yyarrow = false;
                    args(1) = [];
                case 'yy'
                    xxarrow = false;
                    args(1) = [];
                otherwise
                    error('Unknown option')
            end
        end
        
       [left, bottom, right, top] = deal(0); 
                
        if xxarrow && ~isxlabelcorner
            if isyyleft
                right = dxtfig;
            else
                left = dxtfig;
            end
        end

        if yyarrow && ~isylabelcorner
            if isxxbottom
                top = dytfig;
            else
                bottom = dytfig;
            end
        end
        
        axesmoveresize([left, bottom, right, top])
        
        if isyyleft
            xxarx = axpos(1)+axpos(3)+[0 dxtfig];
            yyarx = axpos([1 1]);
        else
            xxarx = axpos(1)+[axpos(3) -dxtfig];
            yyarx = axpos([1 1]) + axpos([3 3]);
        end

        if isxxbottom
            yyary = axpos(2)+axpos(4)+[0 dytfig];
            xxary = axpos([2 2]);
        else
            yyary = axpos(2)+[axpos(4) -dytfig];
            xxary = axpos([2 2]) + axpos([4 4]);
        end
        
        if xxarrow
            h(1) = annotation('arrow', xxarx, xxary, ...
                                      'Color', get(ax, 'XColor'));
        end

        if yyarrow
            h(2) = annotation('arrow', yyarx, yyary, ...
                                      'Color', get(ax, 'YColor'));
        end
        
        set(nonzeros(h), 'HeadLength', 5, 'HeadWidth', 5, ...
                         'LineWidth', get(ax, 'LineWidth'), args{:})

    end
  
%==========================================================================
    function restoreupdown(lab)
        withlab = ~isempty(get(lab, 'String')) && ...
                            strcmp(get(lab, 'Visible'), 'on');
        if withlab
            oldunits = get(lab, 'Units');
            set(lab, 'Units', 'normalized')
            labext = get(lab, 'Extent');

            if strcmpi(get(lab, 'Tag'), 'YLabel')
                labext = labext.*axpos([3 4 4 3]);
            else
                labext = labext.*axpos([3 4 3 4]);
            end

            extroom = labext(4);

            if strcmpi(get(lab, 'Tag'), 'XLabel')
                set(lab, 'Visible', 'off')
                keyword = xxloc;
%                 extroom = 1.05*max(extroom, xtickroom*axpos(4));
                extroom = max(extroom, xtickroom*axpos(4));
            else
                keyword = notxxloc;
            end

            tightinset = get(ax, 'TightInset');
            set(lab, 'Visible', 'on', 'Units', oldunits)
            if strcmp(keyword, 'bottom')
                looseinset(2) = max(looseinset(2), tightinset(2) + extroom);
            else
                %                 looseinset(4) = max(looseinset(4), labext(2)+labext(4)-axpos(4));
                looseinset(4) = max(looseinset(4), tightinset(4) + extroom);
            end

            set(ax, 'LooseInset', looseinset)
            axpos = get(ax, 'Position');
        end
    end
%--------------------------------------------------------------------------
    function restoreleftright(lab)
        withlab = ~isempty(get(lab, 'String')) && ...
                                strcmp(get(lab, 'Visible'), 'on');
        if withlab
            oldunits = get(lab, 'Units');
            set(lab, 'Units', 'normalized')
            labext = get(lab, 'Extent');

            if strcmpi(get(lab, 'Tag'), 'YLabel')
                set(lab, 'Visible', 'off')
                labext = labext.*axpos([3 4 4 3]);
                if get(lab, 'Rotation')==90
                    extroom = labext(4);
                else
                    extroom = labext(3);
                end
                extroom = max(extroom, ytickroom*axpos(3));
                keyword = yyloc;
            else
                labext = labext.*axpos([3 4 3 4]);
                extroom = labext(3);
                keyword = notyyloc;
            end
            
%             extroom = 1.05*extroom;

            tightinset = get(ax, 'TightInset');
            set(lab, 'Visible', 'on', 'Units', oldunits)

            if strcmp(keyword, 'left')
                looseinset(1) = max(looseinset(1), tightinset(1) + extroom);
            else
                %                 looseinset(3) = max(looseinset(3), labext(1)+labext(3)-axpos(3));
                looseinset(3) = max(looseinset(3), tightinset(3) + extroom);
            end

            set(ax, 'LooseInset', looseinset)
            axpos = get(ax, 'Position');
        end
    end
%--------------------------------------------------------------------------
    function [ axwidth, axheight, xlabhalign, ylabhalign, ...
                                  xlabvalign, ylabvalign ] = falign()

        if isxxlog
            axlim(1:2) = log10(axlim(1:2));
            xlabpos(1) = log10(xlabpos(1));
        end

        if isyylog
            axlim(3:4) = log10(axlim(3:4));
            ylabpos(2) = log10(ylabpos(2));
        end

        axwidth = diff(axlim(1:2));
        axheight = diff(axlim(3:4));

        dxtfig = .02;
        dxt = max(0.05*axwidth, dxtfig*axwidth/axpos(3));
        dxtfig = dxt*axpos(3)/axwidth;

        dytfig = .02;
        dyt = max(0.05*axheight, dytfig*axheight/axpos(4));
        dytfig = dyt*axpos(4)/axheight;

        if isyyleft
            xlabhalign = 'left';
            ylabhalign = 'right';
            if isxdirnormal
                xlabpos(1) = axlim(2) + 1.5*dxt;
                ylabpos(1) = axlim(1);
            else
                xlabpos(1) = axlim(1) + 1.5*dxt;
                ylabpos(1) = axlim(2);
            end
        else
            xlabhalign = 'right';
            ylabhalign = 'left';
            if isxdirnormal
                xlabpos(1) = axlim(1) - 1.5*dxt;
                ylabpos(1) = axlim(2);
            else
                xlabpos(1) = axlim(2) - 1.5*dxt;
                ylabpos(1) = axlim(1);
            end
        end

        if isxxbottom
            xlabvalign = 'top';
            ylabvalign = 'bottom';
            if isydirnormal
                ylabpos(2) = axlim(4)  + 1.5*dyt;
                xlabpos(2) = axlim(3);
            else
                ylabpos(2) = axlim(3)  + 1.5*dyt;
                xlabpos(2) = axlim(4);
            end
        else
            xlabvalign = 'bottom';
            ylabvalign = 'top';
            if isydirnormal
                ylabpos(2) = axlim(3)  - 1.5*dyt;
                xlabpos(2) = axlim(4);
            else
                ylabpos(2) = axlim(4)  - 1.5*dyt;
                xlabpos(2) = axlim(3);
            end
        end

    end
%--------------------------------------------------------------------------
    function [tickoffset, pvpairs] = extractoffset(tickoffset, varargin)
        pvpairs = varargin;
        npv = nargin - 1;
        if npv>0 && isnumeric(pvpairs{1})
            tickoffset = pvpairs{1};
            pvpairs(1) = [];
            npv = npv - 1;
        end
        
%         validateattributes(npv, {'numeric'}, {'even'})
%         
%         assert((rem(npv,2) == 0), 'Incorrect number of input arguments')

        textpropnames = {'FontAngle', 'FontName', ...
            'FontUnits', 'FontSize', 'FontWeight'};

        textpv = [textpropnames; get(ax, textpropnames)];
        pvpairs = [textpv(:)' pvpairs];
    end
%--------------------------------------------------------------------------
    function ticklab = matchticks(tick, ticklab)
        ntick = numel(tick);
        nticklab = numel(ticklab);
        q = floor(ntick/nticklab);
        r = rem(ntick,nticklab);
        ticklab = ticklab([repmat(1:nticklab, 1, q) 1:r]);
    end
%--------------------------------------------------------------------------
    function ticklab = append10(ticklab, autoticklab, pvpairs)
        if autoticklab
            interpreter = get(0, 'DefaultTextInterpreter');
            if ~isempty(pvpairs)
                tparams = pvpairs(1:2:end-1);
                tvals = pvpairs(2:2:end);
                k = strcmpi('interpreter', tparams);
                if any(k), interpreter = tvals{k}; end            
            end
            if strcmpi(interpreter, 'tex')
                d = '';
            else
                d = '$';
            end
            ticklab = cellfun(@(x) [d '10^{' x '}' d], ticklab, 'UniformOutput', false);
        end
    end

end
