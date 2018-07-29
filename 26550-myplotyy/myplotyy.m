function [ax,hLine,hText] = myplotyy(M,varargin)
%Function plots Data in a Struct M to different axes in one figure
%x-axes are equal, y-axes can be stacked
%
%11/2/2010, Version 1.2
%
%Run the example as further explanation
%
%function [ax,hLine,hText] = myplotyy(M,varargin)
%wants
%  M: Struct, Data, Format: x(1) y(2) dy_lower(3)  dy_upper(3)
%       dy_lower, and dy_upper are OPTIONAL. If given, a confidence
%       interval is plotted. This does not work with logarithmic y-scale.
%       e.g. M.tsi, size(tsi) = [2 20]
%  varargin: Number in braces is dimension of parameter!
%     boolLeftRight(1): 0=all y-axes on left side
%                       1=y-axes alternating left right [1]
%     boolGGInt(1): 0=plot complete x-interval
%                1=plot common x-interval [1]
%     YLabel(n), XLabel(1):  Label, y is Cell
%     DisplayName(n): Name of Line
%     YLabelRotation(n): Angle of YLabel
%     boolYScaleLog(n): 0=linear
%                       1=logarithmic [0]
%     LineColors(nx3): colors of lines
%     LineStyle(n): Style der Linie: -,--,-.,:
%       Marker(n): 
%     AxesShift(n): distance of x-axes to base x-axes,
%                   normalised coordinates
%     ScaleFactor(n): Size of y-axis relative to figure
%                     normalised coordinates [0 1]
%     BoolYDirReversed(n):  y-axis reversed
%     BoolLineLabel(1): label lines with DisplayName 
%                       0 = off
%                       1 = each single line has its own legend
%                       2 = one legend for all lines [0]
%
%returns
%  ax(n): Handle of axes-objects
%  hLine(n): Handle of plottet lines
%  hTxt(n): Handle of TextLabels
%
%
% Example:
%     x1=0:20;
%     x2=-10:15;
%     x3=10:25;
%     y1=(10*sin(x1)).^6;
%     y2=cos(x2);
%     y3=sin(x3).*cos(x3);
%     y2err = 0.1*abs(y2);
%     y3err_lower = 0.2*ones(size(y3));
%     y3err_upper = 0.4*ones(size(y3));
%     M.data1 = [x1; y1];
%     M.data2 = [x2; y2; y2err];
%     M.data3 = [x3; y3; y3err_lower; y3err_upper];
%     [ax,hLine,hText] = myplotyy(M,...
%         'Xlabel','x',...
%         'Ylabel',{'y1=(10*sin(x))^6' 'y2=cos(x)' 'y3=sin(x)*cos(x)'},...
%         'YLabelRotation',[90 -90 90],...
%         'ScaleFactor',[0.25 0.4 0.6],...
%         'AxesShift',[0 0.2 0.4],...
%         'BoolYDirReversed',[0 1 0],...
%         'BoolLineLabel',2,...
%         'boolYScaleLog',[1 0 0],...
%         'boolGGInt',0,...
%         'LineStyle',{'-' '--' ':'},...
%         'LineColors',lines(3));


if nargin==0
    help myplotyy
    return
end

%Default values
ninBoolLeftRight = 1;
ninBoolGGInt = 1;
ninColors = lines(length(fieldnames(M)));
ninAxesShift = (0:length(fieldnames(M))-1)/length(fieldnames(M))';
ninScaleFactor = ones(length(fieldnames(M)),1)/length(fieldnames(M));
ninXLabel = [];
ninYLabel = fieldnames(M);
ninDisplayName = [];
ninBoolLineLabel = 0;
ninYLabelRotation = nan;
ninBoolYDirReversed = zeros(length(fieldnames(M)),1);
ninBoolYScaleLog = zeros(length(fieldnames(M)),1);
ninLineStyle = '-';

%varargin Args
for varargin_idx = 1:2:length(varargin)
    switch lower(cell2mat(varargin(varargin_idx)))
        case 'boolleftright'
            ninBoolLeftRight = cell2mat(varargin(varargin_idx+1));
        case 'boolggint'
            ninBoolGGInt = cell2mat(varargin(varargin_idx+1));
        case 'xlabel'
            ninXLabel = varargin(varargin_idx+1);
        case 'ylabel'
            ninYLabel = varargin{varargin_idx+1};
        case 'displayname'
            ninDisplayName = varargin{varargin_idx+1};
        case 'boollinelabel'
            ninBoolLineLabel = cell2mat(varargin(varargin_idx+1));
        case 'ylabelrotation'
            ninYLabelRotation = varargin{varargin_idx+1};
            if length(ninYLabelRotation)==1
                ninYLabelRotation = ones(length(fieldnames(M)),1)*ninYLabelRotation;
            end
        case 'linecolors'
            ninColors = cell2mat(varargin(varargin_idx+1));
        case 'axesshift'
            ninAxesShift = cell2mat(varargin(varargin_idx+1));
        case 'scalefactor'
            ninScaleFactor = cell2mat(varargin(varargin_idx+1));
        case 'boolydirreversed'
            ninBoolYDirReversed = cell2mat(varargin(varargin_idx+1));
        case 'boolyscalelog'
            ninBoolYScaleLog = cell2mat(varargin(varargin_idx+1));
        case 'linestyle'
            ninLineStyle = varargin(varargin_idx+1);
        otherwise
            warning(['Arg unknown: ' cell2mat(varargin(varargin_idx))])
    end
end
if isempty(ninDisplayName) & ~isempty(ninYLabel)
    ninDisplayName = ninYLabel;
end

if isnan(ninYLabelRotation)
    if ninBoolLeftRight==1
        ninYLabelRotation = ones(length(fieldnames(M)),1) * 90;
        ninYLabelRotation(2:2:end) = ninYLabelRotation(2:2:end)*-1;
    else
        ninYLabelRotation = ones(length(fieldnames(M)),1) * 90;
    end
end

%Axes position
AXPOSALL = [0.13000000000000   0.11000000000000   0.77500000000000   0.81500000000000];

% for linkaxes, maximal time interval in all time series
x_min = [];
x_max = [];

%Axes Object for entire figure, parent
%set all colors white
axes;
set(gca,'XTickLabel',[],'XTick',[],...
   'YTickLabel',[],'YTick',[],...
   'Box','off',...
   'XColor','w',...
   'YColor','w',...
   'POSITION',AXPOSALL)
fields = fieldnames(M);


%Plot order in such a way that only the bottom x-axes is visible
[mS nS] = size(ninScaleFactor);
[mA nA] = size(ninAxesShift);
if mS~=mA & (mS==nA & mA==nS)
    ninAxesShift = ninAxesShift';
end
[B,IX] = sort(ninScaleFactor + ninAxesShift);
if ninBoolLeftRight==1
    %y-axes left right
    [B,IXY] = sort(ninAxesShift);
end

ax = nan(length(fields),1);
hyl = nan(length(fields),3);

%run through single time series
for fields_idx = 1:length(fields)
    %Plot-Reihenfolge beachten
    fields_idx = IX(fields_idx);
    %load data
    data = eval(['M.' cell2mat(fields(fields_idx))]);

    x = data(1,:);
    y = data(2,:);
    
    %if y-errors are given
    if length(data(:,1))==3
        dy_lower = data(3,:);
        dy_upper = data(3,:);
    elseif length(data(:,1))==4
        dy_lower = data(3,:);
        dy_upper = data(4,:);
    else
        dy_lower = NaN;
        dy_upper = NaN;
    end
    
    if ninBoolYDirReversed(fields_idx)==0
        ninYDir = 'normal';
    else
        ninYDir = 'reverse';
    end
    if ninBoolYScaleLog(fields_idx)==0
        ninYScale = 'linear';
    else
        ninYScale = 'log';
    end


    if fields_idx == 1
        x_min = min(x);
        x_max = max(x);
        %Position  init
        pos(1) = AXPOSALL(1);
        pos(2) = AXPOSALL(2) + ninAxesShift(fields_idx) * AXPOSALL(4);%/length(fields);
        pos(3) = AXPOSALL(3);
        pos(4) = ninScaleFactor(fields_idx) * AXPOSALL(4);%/(length(fields));
        ax(fields_idx) = axes('Position',pos,...
            'XAxisLocation','bottom',...
            'YAxisLocation','left',...
            'YDir',ninYDir,...
            'YScale',ninYScale,...
            'Color','none',...
            'XColor','k','YColor',ninColors(fields_idx,:), ...
            'box','off');
        ylabel(cell2mat(ninYLabel(fields_idx)),...
            'Rotation',ninYLabelRotation(fields_idx));
        xlabel(ninXLabel);

    else
        if ninBoolGGInt==0
            if min(x)<x_min
                x_min = min(x);
            end
            if max(x)>x_max
                x_max = max(x);
            end
        else
            if min(x)>x_min
                x_min = min(x);
            end
            if max(x)<x_max
                x_max = max(x);
            end
        end
        %left, static
        pos(1) = AXPOSALL(1);
        %top
        pos(2) = AXPOSALL(2) + ninAxesShift(fields_idx) * AXPOSALL(4);%/length(fields);
        %width, static
        pos(3) = AXPOSALL(3);
        %height, static
        pos(4) = ninScaleFactor(fields_idx) * AXPOSALL(4);%/(length(fields));
        if ninBoolLeftRight == 1
            if mod(IXY(fields_idx),2)==1
                yaxislocation = 'left';
            else
                yaxislocation = 'right';
            end
        else
            yaxislocation = 'left';
        end
        ax(fields_idx) = axes('Position',pos,...
            'XAxisLocation','top',...
            'YAxisLocation',yaxislocation,...
            'YDir',ninYDir,...
            'YScale',ninYScale,...
            'Color','none',...
            'XColor','w','YColor',ninColors(fields_idx,:),...
            'XTickLabel',[],...
            'XTick',[],...
            'box','off');
        ylabel(cell2mat(ninYLabel(fields_idx)),...
            'Rotation',ninYLabelRotation(fields_idx));
        
                
    end % End: if fields_idx==1

    % one legend for all lines, if ninBoolLineLabel==2
    if fields_idx == length(fields) & ninBoolLineLabel==2
        fields_legend = fieldnames(M);
        for fields_legend_idx = 1:length(fields_legend)
            hold on
            hLegendOnly=plot(1,1,'.',...
                'MarkerSize',0.0001,...
                'DisplayName',ninDisplayName(fields_legend_idx),...
                'Color',ninColors(fields_legend_idx,:));
            if isstr(ninLineStyle)==1
                set(hLegendOnly,'LineStyle',ninLineStyle)
            else
                set(hLegendOnly,'LineStyle',cell2mat(ninLineStyle{1}(fields_legend_idx)))
            end
        end
        hText = legend('show');
        set(hText,'Color','w')
        hold off
    end
    
    if ~isnan(dy_lower)
        ciplot(y-dy_lower,y+dy_upper,x);
        set(ax(fields_idx),...,
            'YAxisLocation',yaxislocation,...
            'YDir',ninYDir,...
            'YScale',ninYScale,...
            'Color','none',...
            'XColor','w','YColor',ninColors(fields_idx,:),...
            'XTickLabel',[],...
            'XTick',[],...
            'box','off');
        h=get(ax(fields_idx),'Ylabel');
        set(h,'String',cell2mat(ninYLabel(fields_idx)),...
            'Rotation',ninYLabelRotation(fields_idx));

    end
    hLine(fields_idx) = line(x,y,'Parent',ax(fields_idx));
    set(hLine(fields_idx),'Color',ninColors(fields_idx,:))
    set(hLine(fields_idx),'Tag',cell2mat(ninDisplayName(fields_idx)));

    if isstr(ninLineStyle)==1
        set(hLine(fields_idx),'LineStyle',ninLineStyle);
    else
        set(hLine(fields_idx),'LineStyle',cell2mat(ninLineStyle{1}(fields_idx)));
    end
      
end% End: for fields_idx

%link x-axes
linkaxes(ax,'x')

%scale x-axes
if x_min<x_max
    for ax_idx = 1:length(ax)
        set(ax(ax_idx),'Xlim',[x_min x_max])
    end
else
    warning('x_min>=x_max, recommended: boolGGInt=0')
end

for fields_idx=1:length(fields)
    if ninBoolLeftRight == 1
        if mod(IXY(fields_idx),2)==0
            hyl = get(ax(fields_idx),'ylabel');
            set(hyl,'verticalalignment','bottom')
        end
    end
end

%% Make legend
if ninBoolLineLabel==1 % each line has its own legend
    h = helpdlg('Set DisplayNames, marked Bold and Colored');
    uiwait(h)
    %DisplayName mnit Mouse setzen
    for fields_idx = 1:length(fields)
        %Plot-Reihenfolge beachten
        fields_idx = IX(fields_idx);
        set(hLine,'Color',[0.5 0.5 0.5])
        tmp_linewidth = get(hLine(fields_idx),'LineWidth');
        set(hLine(fields_idx),'LineWidth',10);
        set(hLine(fields_idx),'Color',ninColors(fields_idx,:));
        hText(fields_idx) = gtext(ninDisplayName(fields_idx));
        set(hText(fields_idx),'Color',[0.5 0.5 0.5]);
        set(hText(fields_idx),'Units','normalized');
        set(hLine(fields_idx),'LineWidth',tmp_linewidth);
    end
    for fields_idx = 1:length(fields)
        set(hLine(fields_idx),'Color',ninColors(fields_idx,:));
        set(hText(fields_idx),'Color',ninColors(fields_idx,:));
    end
else
    hText = NaN;
end


function ciplot(lower,upper,x,colour)
% ciplot(lower,upper)       
% ciplot(lower,upper,x)
% ciplot(lower,upper,x,colour)
%
% Plots a shaded region on a graph between specified lower and upper confidence intervals (L and U).
% l and u must be vectors of the same length.
% Uses the 'fill' function, not 'area'. Therefore multiple shaded plots
% can be overlayed without a problem. Make them transparent for total visibility.
% x data can be specified, otherwise plots against index values.
% colour can be specified (eg 'k'). Defaults to blue.

% Original by Raymond Reynolds 24/11/06
%
% adjusted: for edges, colour, and alpha

if length(lower)~=length(upper)
    error('lower and upper vectors must be same length')
end

if nargin<4
    colour = [0.8 0.8 0.8]; %gray 
end

if nargin<3
    x=1:length(lower);
end

% convert to row vectors so fliplr can work
if find(size(x)==(max(size(x))))<2
x=x'; end
if find(size(lower)==(max(size(lower))))<2
lower=lower'; end
if find(size(upper)==(max(size(upper))))<2
upper=upper'; end

h=fill([x fliplr(x)],[upper fliplr(lower)],colour);
set(h,'EdgeColor','none');
%set(h,'FaceAlpha',0.9);
