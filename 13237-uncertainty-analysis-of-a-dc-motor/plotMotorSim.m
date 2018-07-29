function h = plotMotorSim(design,x,varargin)
%PLOTMOTORSIM Plot the DC Motor Simulation Status.
%   H = PLOTMOTORSIM(DESIGN) creates and displays the design points to test
%   for the Central Composit Design for the DC Motor.  Design is a N x 2
%   matrix where the columns are Voltage and Interial Load.
%
%   PLOTMOTORSIM(DESIGN,X,'LABEL') adds a progress bar to the plot and
%   updates the design plot according to the progress on the design.  X
%   is a numeric value representing the run (row in DESIGN) being
%   processed.

createPlot = 0;
createWaitBar = 0;
updatePlot = 0;
updateWaitBar = 0;
fcd = false;

switch nargin
    case 0
        error('At least on input is required')
        
    case 1 %create design plot and table
        switch size(design,2)
            case 2
                createPlot = 1;
            case 3
                createPlot = 1;
                design = design(:,2:end);
            otherwise
                error('Design must be N x 2 or N x 3')
        end
        
    case 2 % create/update progress bar with nolabel
        ax = findobj(allchild(0),'Tag','CCDPLOT');

        if isempty(ax)
            createPlot = 1;
        else
            updatePlot = 1;
        end

        wb = findobj(allchild(0),'Tag','CCDWAIT');
        if isempty(wb)
            createWaitBar = 1;
        else
            updateWaitBar = 1;
        end
        name = '';
        
    case 3 % create progress bar with label
        ax = findobj(allchild(0),'Tag','CCDPLOT');

        if isempty(ax)
            createPlot = 1;
        else
            updatePlot = 1;
        end

        wb = findobj(allchild(0),'Tag','CCDWAIT');
        if isempty(wb)
            createWaitBar = 1;
        else
            updateWaitBar = 1;
        end
        name = varargin{1};
    case 4 % is this a face centered design
        fcd = varargin{2};
    otherwise %update/add progressbar
        error('Do not know what to do?  Seek help!')
end

if createPlot
    % Create the figure
    figure1 = figure;

    %         % Create axes for plot
    %         axes1 = axes('Position',[0.13 0.2714 0.775 0.6536],'Parent',figure1);
    %         box('on');
    %         hold('all');

    % Create the Central Composit Design(2) plot
    plot(design(:,1),design(:,2),'bo')
    hold on
    xlabel('Voltage (V)')
    ylabel('Inertial Load (kg m^2)')
    title('Central Composite Design, 2 Factors')

    % plot axis points
    minD = min(design);
    maxD = max(design);
    center = (maxD - minD)/2 + minD;
    plot([minD(1) maxD(1)],[center(2) center(2)],'b--')
    plot([center(1) center(1)],[minD(2) maxD(2)],'b--')
    
    % plot design box if not face centerd
    if fcd
        for i = 1:size(design,2)
            indx = find(design == minD(i));
            design(indx) = NaN;
            indx = find(design == maxD(i));
            design(indx) = NaN;
        end
    end
    minD = min(design);
    maxD = max(design);
    xmin = minD(1);
    xmax = maxD(1);
    ymin = minD(2);
    ymax = maxD(2);
    plot([xmin xmax xmax xmin xmin],[ymin ymin ymax ymax ymin],'b-')
    
    % nudge axes a bit
    xy = axis;
    xdelta = range(xy(1:2))*0.1;
    ydelta = range(xy(3:4))*0.1;
  
    axis(xy + [-xdelta xdelta -ydelta ydelta])
    
    hold off

    % Tag the plot for future reference
    set(gca,'Tag','CCDPLOT')
elseif updatePlot
    if x == 0
        % do nothing
    else
        ax = findobj(allchild(0),'Tag','CCDPLOT');
        lpt = findobj(ax,'Tag','lastPoint');
        if ~isempty(lpt)
            delete(lpt)
        end
        cpt = findobj(ax,'Tag','currentPoint');
        if ~isempty(cpt)
            delete(cpt);
        end
        
        axes(ax)
        hold on        
        plot(design(1:(x-1),1),design(1:(x-1),2),'o',...
            'MarkerEdgeColor','g','MarkerFaceColor','g',...
            'MarkerSize',10,'Parent',ax,'Tag','lastPoint')
        plot(design(x,1),design(x,2),'o',...
            'MarkerEdgeColor','r','MarkerFaceColor','r',...
            'MarkerSize',12,'Parent',ax,'Tag','currentPoint')
        hold off
    end
end

if createWaitBar
    % update the plot axis to accomodate the status bar
    if isempty(ax)
        ax = findobj(allchild(0),'Tag','CCDPLOT');
    end
    set(ax,'Position',[0.13 0.2714 0.775 0.6536])
    
    % Create Waitbar
    hw = axes('Position', [0.13 0.02619 0.775 0.04048],...
        'XLim', [0 100], ...
        'YLim', [0 1], ...
        'Box', 'on', ...
        'XTick', [], ...
        'YTick', [], ...
        'XTickLabel', [], ...
        'YTickLabel', []);
    title(name,'Parent',hw)

    x = x * 100 / size(design,1);
    xpatch = [0 x x 0];
    ypatch = [0 0 1 1];
    xline = [100 0 0 100 100];
    yline = [0 0 1 1 0];

    p = patch(xpatch,ypatch,'r','EdgeColor',get(gca,'XColor'),'EraseMode','none');   
    set(hw,'Tag','CCDWAIT')
    
elseif updateWaitBar
    x = x * 100 / size(design,1);
    f = findobj(allchild(0),'Tag','CCDWAIT');
    p = findobj(f,'Type','patch');
        
    xpatch = [0 x x 0];
    set(p,'XData',xpatch);
   
    hTitle = get(f,'title');
    set(hTitle,'string',name);
end

drawnow;

if nargout >= 1
    h = figure1;
end