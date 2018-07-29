
% breakxaxes splits data in an axes so that data is in a left and right pane.
%
%   breakXAxes(splitXLim) splitXLim is a 2 element vector containing a range
%   of x values from splitXLim(1) to splitXLim(2) to remove from the axes.
%   They must be within the current xLimis of the axes.
%
%   breakXAxes(splitXLim,splitWidth) splitWidth is the distance to 
%   seperate the left and right side.  Units are the same as 
%   get(AX,'uints') default is 0.015
% 
%   breakXAxes(splitXLim,splitWidth,yOverhang) yOverhang stretches the 
%   axis split graphic to extend past the top and bottom of the plot by
%   the distance set by YOverhang.  Units are the same as get(AX,'units')
%   default value is 0.015
%
%   breakXAxes(AX, ...) performs the operation on the axis specified by AX
%
function breakInfo = breakxaxis(varargin)

    %Validate Arguements
    if nargin < 1 || nargin > 4
       error('Wrong number of arguements'); 
    end

    if isscalar(varargin{1}) && ishandle(varargin{1})
        mainAxes = varargin{1};
        argOffset = 1;
        argCnt = nargin - 1;
        if ~strcmp(get(mainAxes,'Type'),'axes')
           error('Handle object must be Type Axes'); 
        end
    else
        mainAxes = gca;
        argOffset = 0;
        argCnt = nargin;
    end
    
    if (strcmp(get(mainAxes,'XScale'),'log'))
        error('Log X Axes are not supported'); 
    end
    
    if (argCnt < 3)
        yOverhang = 0.015;
    else
        yOverhang = varargin{3 + argOffset};
        if  numel(yOverhang) ~= 1 || ~isreal(yOverhang) || ~isnumeric(yOverhang)
            error('YOverhang must be a scalar number');
        elseif (yOverhang < 0)
            error('YOverhang must not be negative');
        end
        yOverhang = double(yOverhang);
    end
    
    if (argCnt < 2)
        splitWidth = 0.015;
    else
        splitWidth = varargin{2 + argOffset};
        if  numel(yOverhang) ~= 1 || ~isreal(yOverhang) || ~isnumeric(yOverhang)
            error('splitWidth must be a scalar number');
        elseif (yOverhang < 0)
            error('splitWidth must not be negative');
        end
        splitWidth = double(splitWidth);
    end
    
    splitXLim = varargin{1 + argOffset};
    if numel(splitXLim) ~= 2 || ~isnumeric(splitXLim) || ~isreal(yOverhang)
       error(splitXLim,'Must be a vector length 2');
    end
    splitXLim = double(splitXLim);
    
    mainXLim = get(mainAxes,'XLim');
    if (any(splitXLim >= mainXLim(2)) || any(splitXLim <= mainXLim(1)))
       error('splitXLim must be in the range given by get(AX,''XLim'')');
    end
    
    mainPosition = get(mainAxes,'Position');
    if (splitWidth > mainPosition(3) ) 
       error('Split width is too large') 
    end
   
    %We need to create 4 axes
    % leftAxes - is used for the left x axis and left pane data
    % rightAxes - is used to the right x axis and right pane data
    % annotationAxes - is used to display the y axis and title
    % breakAxes - this is an axes with the same size and position as main
    %   is it used to draw a seperator between the left and right side
    

    %Grab Some Parameters from the main axis (e.g the one we are spliting)
    mainXLim = get(mainAxes,'XLim');
    mainYLim = get(mainAxes,'YLim');
    mainPosition = get(mainAxes,'Position');
    mainParent = get(mainAxes,'Parent');
    mainWidth = mainPosition(3); %Positions have the format [left bottom width height]
    %mainXRange = mainXLim(2) - mainXLim(1);
    mainFigure = get(mainAxes,'Parent');
    mainYColor = get(mainAxes,'YColor');
    mainLineWidth = get(mainAxes,'LineWidth');
    figureColor = get(mainFigure,'Color');
    mainYTickLabelMode = get(mainAxes,'YTickLabelMode');
    mainXLabel = get(mainAxes,'XLabel');
    mainXDir = get(mainAxes,'XDir');
    mainLayer = get(mainAxes,'Layer');
    
    %Save Main Axis Z Order
    figureChildren = get(mainFigure,'Children');
    zOrder = find(figureChildren == mainAxes);
    
    %Calculate where axesLeft and axesRight will be layed on screen
    %And their respctive XLimits
    leftXLimTemp = [mainXLim(1) splitXLim(1)];
    rightXLimTemp = [splitXLim(2) mainXLim(2)];

    leftXRangeTemp = leftXLimTemp(2) - leftXLimTemp(1);
    rightXRangeTemp = rightXLimTemp(2) - rightXLimTemp(1);

    leftWidthTemp = leftXRangeTemp / (leftXRangeTemp + rightXRangeTemp) * (mainWidth - splitWidth);
    rightWidthTemp = rightXRangeTemp / (leftXRangeTemp + rightXRangeTemp) * (mainWidth - splitWidth);

    leftStretch = (leftWidthTemp + splitWidth/2) / leftWidthTemp;
    leftXRange = leftXRangeTemp * leftStretch;
    leftWidth = leftWidthTemp * leftStretch;

    rightStretch = (rightWidthTemp + splitWidth/2) / rightWidthTemp;
    rightXRange = rightXRangeTemp * rightStretch;
    rightWidth = rightWidthTemp * rightStretch;
    
    leftXLim = [mainXLim(1) mainXLim(1)+leftXRange];
    rightXLim = [mainXLim(2)-rightXRange mainXLim(2)];
    
    if (strcmp(mainXDir, 'normal')) 
        leftPosition = mainPosition;
        leftPosition(3) = leftWidth; 

        rightPosition = mainPosition;
        rightPosition(1) = mainPosition(1) + leftWidth;
        rightPosition(3) = rightWidth;
    else
        %Left Axis will actually go on the right side a vise versa
        rightPosition = mainPosition;
        rightPosition(3) = rightWidth; 

        leftPosition = mainPosition;
        leftPosition(1) = mainPosition(1) + rightWidth;
        leftPosition(3) = leftWidth;
    end
 
    %Create the Annotations layer, if the Layer is top, draw the axes on
    %top (e.g. after) drawing the left and right pane
    if strcmp(mainLayer,'bottom')
        annotationAxes = CreateAnnotaionAxes(mainAxes,mainParent)
    end
    
    %Create and position the leftAxes. Remove all Y Axis Annotations, the 
    %title, and a potentially offensive tick mark 
    leftAxes = copyobj(mainAxes,mainParent);
    set(leftAxes,'Position', leftPosition, ...
        'XLim', leftXLim, ...
        'YLim', mainYLim, ...
        'YGrid' ,'off', ...
        'YMinorGrid', 'off', ...
        'YMinorTick','off', ...
        'YTick', [], ...
        'YTickLabel', [], ...
        'box','off');
    if strcmp(mainLayer,'bottom')
        set(leftAxes,'Color','none');
    end
    delete(get(leftAxes,'YLabel')); 
    delete(get(leftAxes,'XLabel'));
    delete(get(leftAxes,'Title'));
    
    if strcmp(mainYTickLabelMode,'auto')
        xTick =  get(leftAxes,'XTick');
        set(leftAxes,'XTick',xTick(1:(end-1)));
    end
    
    %Create and position the rightAxes. Remove all Y Axis annotations, the 
    %title, and a potentially offensive tick mark 
    rightAxes = copyobj(mainAxes,mainParent);
    set(rightAxes,'Position', rightPosition, ...
        'XLim', rightXLim, ...
        'YLim', mainYLim, ...
        'YGrid' ,'off', ...
        'YMinorGrid', 'off', ...
        'YMinorTick','off', ...
        'YTick', [], ...
        'YTickLabel', [], ...
        'box','off');
    if strcmp(mainLayer,'bottom')
        set(rightAxes,'Color','none');
    end
    delete(get(rightAxes,'YLabel')); 
    delete(get(rightAxes,'XLabel'));
    delete(get(rightAxes,'Title'));
    
    if strcmp(mainYTickLabelMode,'auto')
        xTick =  get(rightAxes,'XTick');
        set(rightAxes,'XTick',xTick(2:end));
    end

        %Create the Annotations layer, if the Layer is top, draw the axes on
    %top (e.g. after) drawing the left and right pane
    if strcmp(mainLayer,'top')
        annotationAxes = CreateAnnotaionAxes(mainAxes,mainParent);
        set(annotationAxes, 'Color','none');
    end
    
    %Create breakAxes, remove all graphics objects and hide all annotations
    breakAxes = copyobj(mainAxes,mainParent);
    children = get(breakAxes,'Children');
    for i = 1:numel(children)
       delete(children(i)); 
    end
    
    set(breakAxes,'Color','none');
    %Stretch the breakAxes vertically to cover the horzontal axes lines
    orignalUnits = get(breakAxes,'Units');
    set(breakAxes,'Units','Pixel');
    breakPosition = get(breakAxes,'Position');
    nudgeFactor = get(breakAxes,'LineWidth');
    breakPosition(4) = breakPosition(4) +  nudgeFactor;
    set(breakAxes,'Position',breakPosition);
    set(breakAxes,'Units',orignalUnits);

    %Stretch the breakAxes vertically to create an overhang for sylistic
    %effect
    breakPosition = get(breakAxes,'Position');
    breakPosition(2) = breakPosition(2) - yOverhang;
    breakPosition(4) = breakPosition(4) +  2*yOverhang;
    set(breakAxes,'Position',breakPosition);
    
    %Create a sine shaped patch to seperate the 2 sides
    breakXLim = [mainPosition(1) mainPosition(1)+mainPosition(3)];
    set(breakAxes,'xlim',breakXLim);
    theta = linspace(0,2*pi,100);
    yPoints = linspace(mainYLim(1),mainYLim(2),100);
    amp = splitWidth/2 * 0.9;
    xPoints1 = amp * sin(theta) + mainPosition(1) + leftWidthTemp;
    xPoints2 = amp * sin(theta) + mainPosition(1) + mainPosition(3) - rightWidthTemp;
    patchPointsX = [xPoints1 xPoints2(end:-1:1) xPoints1(1)];
    patchPointsY = [yPoints  yPoints(end:-1:1)  yPoints(1)];
    patch(patchPointsX,patchPointsY ,figureColor,'EdgeColor',figureColor,'Parent',breakAxes);

    %Create A Line To Delineate the left and right edge of the patch
    line('xData',xPoints1,'ydata',yPoints,'Parent',breakAxes,'Color',mainYColor,'LineWidth',mainLineWidth);
    line('xData',xPoints2,'ydata',yPoints,'Parent',breakAxes,'Color',mainYColor,'LineWidth',mainLineWidth);

    set(breakAxes,'Visible','off');
    
    %Make the old main axes invisiable
    invisibleObjects = RecursiveSetVisibleOff(mainAxes);

    %Preserve the z-order of the figure
    uistack([leftAxes rightAxes breakAxes annotationAxes],'down',zOrder-1)
    
    %Set the rezise mode to position so that we can dynamically change the
    %size of the figure without screwing things up
    set([leftAxes rightAxes breakAxes annotationAxes],'ActivePositionProperty','Position');
 
    %Playing with the titles labels etc can cause matlab to reposition
    %the axes in some cases.  Mannually force the position to be correct. 
    set([breakAxes annotationAxes],'Position',mainPosition);
    
    %Save the axes so we can unbreak the axis easily
    breakInfo = struct();
    breakInfo.leftAxes = leftAxes;
    breakInfo.rightAxes = rightAxes;
    breakInfo.breakAxes = breakAxes;
    breakInfo.annotationAxes = annotationAxes;
    breakInfo.invisibleObjects = invisibleObjects;
end

function list = RecursiveSetVisibleOff(handle) 
    list = [];
    list = SetVisibleOff(handle,list);
    
end 

function list = SetVisibleOff(handle, list)
    if (strcmp(get(handle,'Visible'),'on'))
        set(handle,'Visible','off');
        list = [list handle];
    end
    
    children = get(handle,'Children');
    for i = 1:numel(children)
        list = SetVisibleOff(children(i),list);
    end
end
    
function annotationAxes = CreateAnnotaionAxes(mainAxes,mainParent)

    %Create Annotation Axis, Remove graphics objects, XAxis annotations
    %(except XLabel) and make background transparent
    annotationAxes = copyobj(mainAxes,mainParent);
    
    set(annotationAxes,'YLimMode','Manual');
    
    children = get(annotationAxes,'Children');
    for i = 1:numel(children)
       delete(children(i)); 
    end

    %Save the xLabelpostion because it will move when we delete xAxis
    %ticks
    xLabel = get(annotationAxes,'XLabel');
    xLabelPosition = get(xLabel,'Position');
    
    set(annotationAxes,'XGrid' ,'off', ...
        'XMinorGrid', 'off', ...
        'XMinorTick','off', ...
        'XTick', [], ...
        'XTickLabel', []);
    
    %Restore the pevious label postition
    set(xLabel,'Position',xLabelPosition);
end


