function twoFigs(RGB)
%TWOFIGS Demo of nested functions for a GUI application with 2 figures.
%   twoFigs(RGB) creates a figure with an RGB image and a second figure
%   with a masked image for the selected color plane, where the values are
%   1 for pixels that exceed a user set threshold and 0 otherwise.
%
%   Example:
%       load mandrill   % could use earth or clown instead
%       rgb = ind2rgb(X,map);
%       twoFigs(rgb)

%   Copyright 2005 The MathWorks, Inc.

%% Validate and possibly scale input
checkRGB();  % check the RGB input and modify RGB if need be
numPixels = size(RGB,1)*size(RGB,2);  % used in updateResultFig

%% Set up GUI elements
% Create first figure for main image
fig1 = figure;
haxMain = axes('parent',fig1);
image(RGB,'parent',haxMain);
axis off; axis image
% Create threshold uicontrol for threshold value
thresh = uicontrol('style','slider', ...
                   'position',[60 10 256 20], ...
                   'value',0, ...
                   'parent', fig1, ...
                   'callback',@updateResultFig);
uicontrol('style','text', ...
          'position', [20 30 80 20], ...
          'HorizontalAlignment','left',...
          'parent', fig1, ...
          'string', 'threshold');
dispThresh = uicontrol('style','text', ...
                       'position', [20 10 30 20], ...
                       'HorizontalAlignment','left',...
                       'parent', fig1, ...
                       'string', int2str(0));
% Create second figure for displaying masked image
fig2 = figure;
set(fig2,'colormap',gray(2));
haxMask = axes('parent',fig2);
hMask1 = image(true(size(RGB,1),size(RGB,2)),'parent',haxMask);
axis off; axis image
% Create drop-down to choose R,G, or B plane.
RGBdrop = uicontrol('style','popupmenu',...
                    'parent',fig2,...
                    'position',[400,10,80,20],...
                    'string','Red Plane|Green Plane|Blue Plane', ...
                    'value',1, ...
                    'callback',@updateResultFig);
%% finish initialization of GUI
updateResultFig();
%%  Nested functions
    function updateResultFig(varargin)  % needs varargin for callbacks
        % nested function using variables from the parent
        % including numPixels, RGB, and handles to uicontrols
        threshold = get(thresh,'value');
        strThresh = sprintf('%0.3g',threshold);
        set(dispThresh,'string',strThresh)
        RGBdim = get(RGBdrop,'value');
        mask = RGB(:,:,RGBdim) >= threshold;
        set(hMask1,'CData',mask);
        perc = 100*sum(mask(:))/numPixels;
        title(haxMask,sprintf('%d%% above threshold of %s', ...
              round(perc),strThresh));
    end  % updateResultFig
    function checkRGB
        % nested function using/changing variable RGB in the parent
        % Check data and map onto [0 1] interval
        if isinteger(RGB)
            RGB = single(RGB)/single(intmax(class(RGB)));
        else
            RGB = RGB/max(RGB(:));
        end
    end  % checkRGB
%% terminate outermost function
end  % twoFigs
