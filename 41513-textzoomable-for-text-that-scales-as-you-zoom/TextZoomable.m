function txtHandle = TextZoomable(x,y,varargin)
% txtHandle = FixedSizeText(x,y,varargin)
% 
% Adds text to a figure in the normal manner, except that this text
% grows/shrinks with figure scaling and zooming, unlike normal text that
% stays at a fixed font size during figure operations. Note it scales with
% figure height - for best scaling use 'axis equal' before setting up the
% text.
%
% All varargin{:} arguments will be passed directly on to the text
% function (text properties, etc.)
%
% (doesn't behave well with FontUnits = 'normalized')
%
% example:
% 
% figure(1); clf;
% rectangle('Position', [0 0 1 1]);
% rectangle('Position', [.25 .25 .5 .5]);
% 
% th = TextZoomable(.5, .5, 'red', 'color', [1 0 0], 'Clipping', 'on');
% th2 = TextZoomable(.5, .1, 'blue', 'color', [0 0 1]);
%
%
% Ken Purchase, 4-25-2013
%
%

    % create the text
    txtHandle = text(x,y,varargin{:});

    % detect its size relative to the figure, and set up listeners to resize
    % it as the figure resizes, or axis limits are changed.
    hAx = gca;
    hFig = get(hAx,'Parent');
    
    fs = get(txtHandle, 'FontSize');
    ratios = fs * diff(get(hAx,'YLim')) / max(get(hFig,'Position') .* [0 0 0 1]);
    
    
    % append the handles and ratios to the user data - repeated calls will
    % add each block of text to the list
    ud = get(hAx, 'UserData');
    if isfield(ud, 'ratios')
        ud.ratios = [ud.ratios(:); ratios];
    else
        ud.ratios = ratios;
    end
    if isfield(ud, 'handles')
        ud.handles = [ud.handles(:); txtHandle];
    else
        ud.handles = txtHandle;
    end
    
    set(hAx,'UserData', ud);
    localSetupPositionListener(hFig,hAx);
    localSetupLimitListener(hAx);

end


%% Helper Functions

function fs = getBestFontSize(imAxes)
    % Try to keep font size reasonable for text
    hFig = get(imAxes,'Parent');
    hFigFactor = max(get(hFig,'Position') .* [0 0 0 1]);  
    axHeight = diff(get(imAxes,'YLim'));
    ud = get(imAxes,'UserData');  % stored in teh first user data.
    fs = round(ud.ratios * hFigFactor / axHeight);    
    fs = max(fs, 3);
end

function localSetupPositionListener(hFig,imAxes)
    % helper function to sets up listeners for resizing, so we can detect if
    % we would need to change the fontsize
    PostPositionListener = handle.listener(hFig,'ResizeEvent',...
        {@localPostPositionListener,imAxes});
    setappdata(hFig,'KenFigResizeListeners',PostPositionListener);
end

function localPostPositionListener(~,~,imAxes) 
    % when called, rescale all fonts in image
    ud = get(imAxes,'UserData');
    fs = getBestFontSize(imAxes);
    for ii = 1:length(ud.handles)
        set(ud.handles(ii),'fontsize',fs(ii),'visible','on');
    end   
end

function localSetupLimitListener(imAxes)
    % helper function to sets up listeners for zooming, so we can detect if
    % we would need to change the fontsize
    hgp     = findpackage('hg');
    axesC   = findclass(hgp,'axes');
    LimListener = handle.listener(imAxes,[axesC.findprop('XLim') axesC.findprop('YLim')],...
        'PropertyPostSet',@localLimitListener);
    hFig = get(imAxes,'Parent');
    setappdata(hFig,'KenAxeResizeListeners',LimListener);
end

function localLimitListener(~,event)
    % when called, rescale all fonts in image
    imAxes = event.AffectedObject;
    ud = get(imAxes,'UserData');
    fs = getBestFontSize(imAxes);
    for ii = 1:length(ud.handles)
        set(ud.handles(ii),'fontsize',fs(ii),'visible','on');
    end
end
