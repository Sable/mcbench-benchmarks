%%vis3d(img, mycmap): a GUI-enabled visualization of the 3D volume img,
%%with an optional colormap argument.  

%{
Joshua Stough
JHU, iacl
June 2012
April 2013

BSD Licence:
Copyright (c) 2013, Joshua Stough
All rights reserved.

Please comment on MATLAB fileexchange if you find this useful. Thank you.

This program offers a visualization of 3D volumes.

Obviously, this is not a new idea. This program might offer over other
programs:
    -change slice via click drag or scroll
    -orthogonal planes are visualized on each projection in a color-coded
    manner, allowing a better sense of where you are in the 3D space.
    -windowing capability
    -changing the colormap
    -neurological coordinate frame

However, after seeing the slice function, I think I must be missing a lot
of built-in functionality, making this program pointless. But I share in any
event as I obviously cannot see all ends (nerd).

References to really good and thoughtful 3D viewer implementations in
matlab (including buttons and all axis flipping that I can't do):
http://www.mathworks.com/matlabcentral/fileexchange/2256-orthoview
http://www.mathworks.com/matlabcentral/fileexchange/764-sliceomatic

For some 3d matrix of double or uint8, call
>> vis3d(img);
or, if you have some multilabel segmentation image, try:
>> vis3d(seg, 'multi');
or, if you want define your own colormap, you can send that instead:
>> mymap = colormap('lines');
>> vis3d(seg, mymap);
lastly, you can customize the figure title:
>> vis3d(seg, '', 'My Figure Title');

Updates/Modifications:
4/13: 
-fixed slice number issue: the out-of-plane slice number was incorrect 
in the initial window.
-changed interaction: now, scrolling changes slice number 
-fixed the 3d volume visualization errors arising from the treatment of 
images versus matrices in matlab.
-fixed tick mark misrepresentation.
-added windowing on the colormap
-added choice of colormap in addition to typical maps.
%}

function [] = vis3d(seg, mycmap, figName)

    %We check for the colormap after we have a figure open.
    if nargin < 3
        figName = 'vis3d: click and scroll/drag vertically (up=closer to eye).'; 
        userSpecFigName = false; %did the user specify the figure name.
    else
        userSpecFigName = true;
    end
    %arg 2 taken care of below.
    

    if ~(isa(seg, 'double') || isa(seg, 'uint8'))
        fprintf('The image is not double or uint8.  You may receive many warnings.\n');
        fprintf('Cast your image to either before sending here.');
    end
   %seg = seg/max(seg(:)); %Make 0-1. 
    segRange = [min(seg(:)) max(seg(:))];
    origSegRange = segRange;
    %segRange is required to ensure that if you view a slice with more or
    %less range, you get colors consistent with other slices.
    
    sizeSeg = size(seg);
    sn = round(sizeSeg/2);
    %slice numbers for the three projections.
    
    titleLines = {'YX view: ', 'YZ view: ', 'XZ view: '};
    %titleColors = {'b', 'r', 'g'};
    titleColors = {[.3 .3 .8], [.8 .3 .3], [.3 .8 .3]};
    
    %The figure handle, with its callbacks.
    mainHandle = figure('Position', [50 50 800 800], ...
        'WindowButtonDownFcn', @buttonDownCallback, ...
        'WindowButtonUpFcn', @buttonUpCallback, ...
        'Name', figName); hold on;
    
    
   
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Adding colormap popupmenu
    colormapText = uicontrol('Style', 'text', 'Position', [300 0 100, 20], ...
        'FontSize', 12, 'FontWeight', 'bold');
    set(colormapText, 'String', 'Colormap:', 'ForegroundColor', [1 1 1]);
    
    
    colormapPopup = uicontrol('Style', 'popupmenu', ...
        'Position', [400 0 200 20], ...
        'Callback', @specifyColormap);
    set(colormapPopup, 'String', {'gray'; 'multi-label'; 'jet'}, ...
        'Value', 1, 'FontSize', 12, 'FontWeight', 'bold');
    
    %define the colormaps.
    %A colormap I find useful for multi-label segmentation images, which is
    %why I made this thing to begin with (and why the image is called seg).
    multi = [0 0 0;
            1 0 1;
            0 .7 1;
            1 0 0;
            .3 1 0;
            0 0 1;
            1 1 1;
            1 .7 0];
    graymap = colormap('gray');
    jetmap = colormap('jet');
    the_cmaps = {graymap; multi; jetmap};
    
    %Is there a user-defined map?
    %Now that we're sure to have a figure open, get a colormap.
    if nargin < 2 || strcmp(mycmap, '')
        mycmap = gray;
    elseif strcmp(mycmap, 'multi')
        mycmap = multi;
        set(colormapPopup, 'Value', 2);
    else
        %User defined a colormap to use.  Set it as current.
        the_cmaps{end+1} =  mycmap;
        set(colormapPopup, 'String', {'gray'; 'multi-label'; 'jet'; 'user-spec'}, ...
        'Value', 4);
    end
    %End of colormap popup menu.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    %flip the matrix to better organize views. This is memory-stupid!!!
    %Please help!
    xyview = seg;
    xzview = seg;
    yzview = seg;
    
    xyview = flipdim(xyview, 1);
    
    xzview = flipdim(xzview, 1);
    xzview = permute(xzview, [3 2 1]);
    %xzview = flipdim(xzview, 2);
    
    yzview = permute(yzview, [1 3 2]);
    yzview = flipdim(yzview, 1);
    
    
    %Now, we plot the three orthogonal slices and try to get the two lines
    %on each slice, which represent the other planes.
    %Notice we are using axis xy, so that the tick marks are correct, that
    %also means we don't need to flip z in yz and xz views...
    handles{1} = subplot(2,2,3); 
    imHandles{1} = imagesc(squeeze(xyview(:,:,sn(3))), segRange); colormap(mycmap); axis image; axis xy;
    %set(handles{1}, 'LooseInset', get(gca,'TightInset')) %made smaller...
    titleHandles{1} = title(handles{1}, 'XY view', 'Color', titleColors{1}, 'FontSize', 14, 'FontWeight', 'bold');
    

    handles{2} = subplot(2,2,1); 
    imHandles{2} = imagesc(squeeze(yzview(sn(1),:,:)), segRange); colormap(mycmap); axis image; axis xy;
    titleHandles{2} = title(handles{2}, 'YZ view', 'Color', titleColors{2}, 'FontSize', 14, 'FontWeight', 'bold');
    %set(handles{2}, 'XDir', 'rev'); 
    %I used reverse here to have appropriate neurological coord, but then I
    %thought, people like to see 'through the eyes of the patient' in
    %coronal (i.e., patient l-r equals l-r in the image).
    
    handles{3} = subplot(2,2,2); 
    imHandles{3} = imagesc(squeeze(xzview(:,sn(2),:)), segRange); colormap(mycmap); axis image; axis xy;
    titleHandles{3} = title(handles{3}, 'XZ view', 'Color', titleColors{3}, 'FontSize', 14, 'FontWeight', 'demi');
    
    
    
    %Making sure the titles all have the initial slice number as well.
    offsliceCoord = [3 1 2];
    for i = 1:3
        set(titleHandles{i}, 'String', sprintf('%s%03d', titleLines{i}, sn(offsliceCoord(i))));
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %lower and upper bound on the intensity window and text box.
    
    %Adding uicontrol elements would remove the toolbar from the figure
    %without this statement.
    set(mainHandle, 'Toolbar', 'figure');
    
    IntWinSliderHandle{1} = uicontrol('Style', 'slider', ...
        'Position', [0 0 200 20], ...
        'Callback', @IntWinBound);
    set(IntWinSliderHandle{1}, 'Value', segRange(1));
    
    IntWinSliderHandle{2} = uicontrol('Style', 'slider', ...
        'Position', [0 25 200 20], ...
        'Callback', @IntWinBound);
    set(IntWinSliderHandle{2}, 'Value', segRange(2));
    
    for i = 1:2
        set(IntWinSliderHandle{i}, 'Min', segRange(1));
        set(IntWinSliderHandle{i}, 'Max', segRange(2));
    end
    
    IntWinTextBound{1} = uicontrol('Style', 'edit', ...
        'Position', [210 0 60 20], ...
        'Callback', @defineBound);
    set(IntWinTextBound{1}, 'String', segRange(1));
    
    IntWinTextBound{2} = uicontrol('Style', 'edit', ...
        'Position', [210 25 60 20], ...
        'Callback', @defineBound);
    set(IntWinTextBound{2}, 'String', segRange(2));
    
    
    IntWinText = uicontrol('Style', 'text', 'Position', [0 50 210 15], ...
        'FontSize', 12, 'FontWeight', 'bold');
    
    set(IntWinText, 'String', 'Windowing', ...
            'ForegroundColor', [1 1 1]);
    %End of intensity windowing elements.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %And the 3D view.
    handles{4} = subplot(2,2,4);
    
    %We're using the slice visualization function here, but it's screwy
    %because the x and y are transposed and axes must be flipped for the
    %appropriate perspective, 
    
    %I wanted the callback to avoid duplicating code, but the camera position
    %is hard to get before slice is called...buttonUpCallback([]); so here
    %is init.
    %due to confusing coordinates for the slice function, we need to
    %permute and flip dimensions...
    visSeg = seg;
    visSeg = permute(visSeg, [2 1 3]);
    %visSeg = flipdim(visSeg, 1);
    %visSeg = flipdim(visSeg, 2);
    flippedx = inline(sprintf('%d - x + 1', size(visSeg, 2))); 
    %The 2nd dimension of the matrix ends up being 'called' x by matlab.
    %wtf?
    
    
    hslc=slice(visSeg, flippedx(sn(1)) ,sn(2),sn(3));
    axis equal; axis vis3d; set(hslc(1:3),'LineStyle','none');
    xlabel 'p-a' ;ylabel 'l-r' ;zlabel 'i-s';
    %set(gca, 'XDir', 'reverse'); 
    %The above XDir didn't work, without screwing up the data.  So, I'll
    %just change the labels...WAIT!: that's wrong because the slice numbers
    %become wrong then.  Have to flip...
    myx = get(gca, 'XTickLabel');
    set(gca, 'XTickLabel', flippedx(str2num(myx)));
    
    title 'Manually enable/disable Rotate3D.'
    %To maintain the 3D perspective throughout.
    camPos3D = get(handles{4}, 'CameraPosition');
    

    %Too many problems trying to regain control from the rotate3d.
    %rotHandle = rotate3d(handles{4}); so it's up to the user.
    rotHandle = rotate3d;
    setAllowAxesRotate(rotHandle, handles{1}, false);
    setAllowAxesRotate(rotHandle, handles{2}, false);
    setAllowAxesRotate(rotHandle, handles{3}, false);
    %End of the 3D view elements
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Generate the lines representing the orthogonal planes.  This part is 
    %so confusing, in part because line will use the bottom
    %left, whereas we're thinking of the top left (image) as being 0,0.
    %But it's mostly my fault, because coordinate systems are so HARD...
    
    lines{1}.x = [1 sizeSeg(2); sn(2) sn(2)]'; 
    lines{1}.y = [sn(1) sn(1); 1 sizeSeg(1)]';
    %the x coords of the horiz and vertical line respectively.
    %the y coords of the horiz and vertical line respectively.
    
    lines{2}.x = [1 sizeSeg(2); sn(2) sn(2)]';
    lines{2}.y = [sn(3) sn(3); 1 sizeSeg(3)]';
    
    lines{3}.x = [1 sizeSeg(1); sn(1) sn(1)]';
    lines{3}.y = [sn(3) sn(3); 1 sizeSeg(3)]';
    
    %We now instantiate the lines.  We also want the line colors to reflect
    %the plane they represent, which is given by the titleColors. The trick
    %is weird though: when we're visualizing the XY plane, the two lines on
    %it are the XZ plane (vertical), and the YZ plane, horizontal.  whew.
    %for each, first is horizontal, next is vertical.
    lineHandles = {};
    subplot(handles{1});
    lineHandles{1}(1) = line(lines{1}.x(:,1), lines{1}.y(:,1), 'Color', titleColors{2}, 'LineWidth', 1);
    lineHandles{1}(2) = line(lines{1}.x(:,2), lines{1}.y(:,2), 'Color', titleColors{3}, 'LineWidth', 1);
    
    subplot(handles{2});
    lineHandles{2}(1) = line(lines{2}.x(:,1), lines{2}.y(:,1), 'Color', titleColors{1}, 'LineWidth', 1);
    lineHandles{2}(2) = line(lines{2}.x(:,2), lines{2}.y(:,2), 'Color', titleColors{3}, 'LineWidth', 1);
    
    subplot(handles{3});
    lineHandles{3}(1) = line(lines{3}.x(:,1), lines{3}.y(:,1), 'Color', titleColors{1}, 'LineWidth', 1);
    lineHandles{3}(2) = line(lines{3}.x(:,2), lines{3}.y(:,2), 'Color', titleColors{2}, 'LineWidth', 1);
    %End of the line crap.  This is really confusing.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    

    %Variables to keep track of mouse motion and which slice is being
    %maniupulated. 
    lastPoint = [];
    whichView = 1;
    
    %At this point, time to define our callbacks.
    
    %This is the callback when the user clicks.  We want to determine which
    %if any projection they clicked on so that further vertical motion can
    %be associated with changing the slice for that projection. 
    function buttonDownCallback(varargin)
        
        p = get(gca, 'CurrentPoint');
        lastPoint = [p(1); p(3)];
        
        %We know where they clicked with respect to the last active axes,
        %determine which axes that was.
        whichView = find(cell2mat(handles) == gca);
        
        if whichView == 4 
            %Can't do anthing with the 3D view, unless it's rotate
            %selection.  The user has to do it themselves.
            %set(rotHandle, 'Enable', 'on', 'ActionPostCallback', @buttonUpOnRotateCallback);
            return
        end
        
        %By getting the camera position on a click, we can maintain the 3d
        %perspective in the case of changing slices.
        camPos3D = get(handles{4}, 'CameraPosition');
        
        %Now determine if they clicked on a valid spot, within the coords
        %of the chosen image/axes.
        xlim = get(gca, 'XLim');
        ylim = get(gca, 'YLim');
        if lastPoint(1) >= xlim(1) && lastPoint(1) <= xlim(2) && ...
                lastPoint(2) >= ylim(1) && lastPoint(2) <= ylim(2)
            %They clicked on a valid point, time to activate the motion
            %callback. Also let's tell them the intensity at the point they
            %click. But we also don't want to remove what they decided to
            %call the main figure. 
            t_img = get(imHandles{whichView}, 'CData');
            p = round(p);
            if userSpecFigName
                set(mainHandle, 'Name', sprintf('%s: Pos: %d %d, Int: %f', ...
                    figName, p(3), p(1), t_img(p(3), p(1))));
            else
                set(mainHandle, 'Name', sprintf('Pos: %d %d, Int: %f', ...
                    p(3), p(1), t_img(p(3), p(1))));
            end
            set(mainHandle, 'WindowButtonMotionFcn', @dragCallback);
            set(mainHandle, 'WindowScrollWheelFcn', @scrollCallback);
            %fprintf('You clicked on %f, %f on gca %f (%d).\n', p(1), p(3), gca, whichView);
        %else
            %fprintf('Oops, you did''t click flippedx(sn(1))a valid point.\n');
        end
    end

    %At this point, it's established that the user clicked on one of the
    %images and is currently dragging.  We will change the image on the
    %relevant slice and update slice info (in the title). 
    %And then, if this works, I'll try the red lines on the other two
    %projections.
    function dragCallback(varargin)
        p = get(gca, 'CurrentPoint');
        motionV = round([p(1); p(3)] - lastPoint);
        if abs(motionV(2)) < 2
            return
        end %Wait until the motion is noticeable.
        
        lastPoint = [p(1); p(3)];
        
        
        newslice = sn(offsliceCoord(whichView)) + round(motionV(2)/2);
        
        updateSliceViz(newslice);
  
    end

    function buttonUpCallback(varargin)
        %Nullify the motion and correct the 3D view.
        %Slice is too easy though, thanks Matlab.  I should be ashamed
        %http://www.mathworks.com/matlabcentral/fileexchange/2256-orthoview
        set(mainHandle, 'WindowButtonMotionFcn', '');
        
        axes(handles{4}); hslc=slice(visSeg, flippedx(sn(1)), sn(2), sn(3));%rotate3d on;
        axis equal; axis vis3d; set(hslc(1:3),'LineStyle','none');
        xlabel 'p-a' ;ylabel 'l-r' ;zlabel 'i-s';
        
        %Same stupid and incorrect label issue.
        myx = get(gca, 'XTickLabel');
        set(gca, 'XTickLabel', flippedx(str2num(myx)));
    
        title 'Manually enable/disable Rotate3D.'
        set(handles{4}, 'CameraPosition', camPos3D);
    end

    %I had problems with 'ActionPostCallback' and so I'm leaving rotation
    %of the 3d plot up to the user clicking on and off the button.
    %function buttonUpOnRotateCallback(varargin)
    %    set(rotHandle, 'ActionPostCallback', '');
    %    set(rotHandle, 'Enable', 'off');
    %end
    
    function scrollCallback(src,evnt)
        %Change whichView's slice by the vertical motion.
        offsliceCoord = [3 1 2];
        %if they're moving xy slice, that's a change in z, etc.
        
        if whichView == 4
            return
        end
        
        if evnt.VerticalScrollCount > 0
            newslice = sn(offsliceCoord(whichView)) - 1;
        else
            newslice = sn(offsliceCoord(whichView)) + 1;
        end
        
        updateSliceViz(newslice);
        
    end


    function updateSliceViz(newslice)
        %Change whichView's slice by the vertical motion.
        
        offsliceCoord = [3 1 2];
        %if they're moving xy slice, that's a change in z, etc.
        
        
        if newslice > 0 && newslice <= sizeSeg(offsliceCoord(whichView))
            sn(offsliceCoord(whichView)) = newslice;
        end
        subplot(handles{whichView});
        
        %This is a tough to comprehend part.  I want to move the lines
        %representing the current plane in the other orthogonal views.
        %I'll be changing line properties accordingly.
        if whichView == 1
            %XY view (axial)
            %imagesc(squeeze(seg(:,:,sn(3))), segRange); axis image; hold on
            %While you don't have to respecify the colormap, you do need to
            %remind imagesc of the appropriate range and ensure the axes
            %are good. In fact, I forgot that with matlab, everything is an
            %object.  Just change the data in the object.
            set(imHandles{1}, 'CData', squeeze(xyview(:,:,sn(3))));
            
            %Moving in z, so change the horizontal lines in the YZ and XZ
            %plots.
            set(lineHandles{2}(1), 'YData', [sn(3) sn(3)]');
            set(lineHandles{3}(1), 'YData', [sn(3) sn(3)]');
            
        elseif whichView == 2
            %YZ view (coronal)
            set(imHandles{2}, 'CData', squeeze(yzview(sn(1),:,:)));
            %imagesc(squeeze(seg(sn(1),:,:)), segRange); axis image
            
            %Moving in x, so change the horizontal line in the XY 
            %(representing front-back) and the vertical in and XZ.
            %plots
            set(lineHandles{1}(1), 'YData', [sn(1) sn(1)]');
            set(lineHandles{3}(2), 'XData', [sn(1) sn(1)]');
        else
            %XZ view (sagittal)
            set(imHandles{3}, 'CData', squeeze(xzview(:,sn(2),:)));
            %imagesc(squeeze(seg(:,sn(2),:)), segRange); axis image 
            
            %Moving in y, so change the vertical line in plot 1 and
            %horizontal line in plot 2.
            set(lineHandles{1}(2), 'XData', [sn(2) sn(2)]');
            set(lineHandles{2}(2), 'XData', [sn(2) sn(2)]');
        end
        %title(handles{whichView}, strcat(titleLines{whichView}, num2str(sn(offsliceCoord(whichView)))),...
        %    'Color', titleColors{whichView});
        %Why recreate the title if all we really want to do is change the
        %string.
        set(titleHandles{whichView}, 'String', ...
            sprintf('%s%03d', titleLines{whichView}, sn(offsliceCoord(whichView))));
    end





    function IntWinBound(varargin)
        %Here we perform the linear intensity windowing on the images.
        %First, determine the window selected by the user and update the
        %text appropriately.
        
        for whichSlider = 1:2
            slider_value = get(IntWinSliderHandle{whichSlider}, 'Value');
            segRange(whichSlider) = slider_value;
            set(IntWinTextBound{whichSlider}, 'String', segRange(whichSlider));
        end
        

        %Now, change the CLim of the four axes.  I couldn't find how to get
        %at just the axes (which have CLim defined), because subplot
        %apparently never returned a handle for my handles cell array.
        %Anyway, looping through the main figure's children did the trick.
        %(For now anyway, until I start using uipanels and such).
        for c = get(mainHandle, 'Children')'
            try
                set(c, 'CLim', segRange);
            catch exception
                continue
            end
        end
        
    end

    function defineBound(varargin)
        for whichBound = 1:2
            bound_str = get(IntWinTextBound{whichBound},'String');
            if strcmp(bound_str, 'max')
                bound_value = max(origSegRange);
            elseif strcmp(bound_str, 'min')
                bound_value = min(origSegRange);
            else
                bound_value = str2double(bound_str);
            end
            set(IntWinTextBound{whichBound},'String', num2str(bound_value));
            segRange(whichBound) = bound_value;
        end
        
        for c = get(mainHandle, 'Children')'
            try
                set(c, 'CLim', segRange);
            catch exception
                continue
            end
        end
    end

    function specifyColormap(hObject, ~)
        choice = get(hObject, 'Value');
        
        colormap(the_cmaps{choice});
        
        
    end




end