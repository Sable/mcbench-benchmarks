function [h,h2] = logzplot(varargin)
%Surface plot with log-scaled color and z-axis
%
% SYNTAX
%
%   LOGZPLOT
%   LOGZPLOT(Z)
%   LOGZPLOT(Z,C)
%   LOGZPLOT(X,Y,Z)
%   LOGZPLOT(X,Y,Z,C)
%   LOGZPLOT(...,'PLOTFUN')
%   LOGZPLOT(TriRep,'PLOTFUN')
%   LOGZPLOT(TRI,X,Y,Z,'PLOTFUN')
%   LOGZPLOT(TRI,X,Y,Z,C,'PLOTFUN')
%   LOGZPLOT(...,@PLOTFUN)
%   LOGZPLOT colorbar or LOGZPLOT(...,'colorbar')
%   LOGZPLOT(HANDLE,...)
%   H = LOGZPLOT(...)
%   [H,H2] = LOGZPLOT(...)
%
% DESCRIPTION
%
% LOGZPLOT creates a plot with logarithmic scaling of the z-axis and color
% data.  The plot type can be any of IMAGE, MESH, PCOLOR, SURF, TRISURF or
% TRIMESH, specified as a string or function handle.  The default plot type
% is SURF.  If called without data inputs, LOGZPLOT applies the log-scale
% transformation to an existing surface, patch or image object.  LOGZPLOT
% called with the optional argument 'colorbar' will also create a
% log-scaled colorbar.
%
% LOGZPLOT(Z)
% LOGZPLOT(Z,C)
% LOGZPLOT(X,Y,Z)
% LOGZPLOT(X,Y,Z,C)   Create a log-scaled surface plot using the data in Z
% by first calling SURF() and then transforming the resulting surface
% object.  The optional arguments X and Y specify values for the X and Y
% locations of the elements of Z. If given, X and Y must be specified
% together, and be of the appropriate size for the data in Z.  If the
% optional argument C is given, the surface's color will be based on the
% values in C instead of Z.
%
% LOGZPLOT(...,'PLOTFUN')
% LOGZPLOT(TriRep,'PLOTFUN')
% LOGZPLOT(TRI,X,Y,Z,'PLOTFUN')
% LOGZPLOT(TRI,X,Y,Z,C,'PLOTFUN')
% LOGZPLOT(...,@PLOTFUN)   Use the plotting function specified by the
% string or function handle in PLOTFUN to plot the data. By default, SURF
% is used to generate the plot. Supported plotting functions are SURF,
% MESH, PCOLOR, TRISURF and TRIMESH. The number and type of the data inputs
% depends on the selected plotting function.  
%
% For IMAGE plots, the data inputs must be of the form (C) or (X,Y,C),
% where C is the data used to determine the pixel colors, and X and Y
% specify the scales of the x and y axes.  See the documentation for IMAGE
% for more information.
% 
% For SURF and MESH plots, the data inputs must be of the form
% (Z), (X,Y,Z), or (X,Y,Z,C).  See the documentation for SURF and MESH for
% more information.
%
% For PCOLOR plots, the data inputs must be of the form (C) or (X,Y,C).
% See the documentation for PCOLOR for more information.
%
% For TRISURF and TRIMESH plots, the data must be input either as a TriRep
% object or as (TRI,X,Y,Z,C) where TRI is the triangulation of the data in
% X and Y, Z is the height data, and C is optional color data to be used
% instead of Z to color the plot.  See the documentation for TRISURF and
% TRIMESH for more information
% 
% LOGZPLOT(...,'colorbar')   Additionally creates a log-scaled colorbar.
%
% LOGZPLOT(AX_HANDLE,...)   Uses the existing axes specified by AX_HANDLE
% to create the plot. 
%
% H = LOGZPLOT(...)   Returns the handle of the surface, patch or image
% object that has been transformed.
%
% [H,H2] = LOGZPLOT(...)   In addition to the plot object handle, returns
% the handle of the colorbar.
%
% LOGZPLOT   Calling LOGZPLOT with no arguments will apply a log-scale
% transformation to a surface or patch object located in the current axes.
% The first such object found will be used by LOGZPLOT.  If the object has
% already been transformed by LOGZPLOT, calling LOGZPLOT again will have no
% effect.
%
% LOGZPLOT colorbar
% LOGZPLOT('colorbar')   Additionally create a log-scaled colorbar, or
% scale an existing colorbar attached to the axes of the log-transformed
% plot. The resulting colorbar scale should be accurate to the log-scaled
% data.  See the REMARKS section below for more information.
%
% LOGZPLOT(HANDLE)
% LOGZPLOT(HANDLE,'colorbar')   Transform the surface or patch object
% specified by HANDLE, or, if HANDLE refers to an axes, transform a surface
% or patch object located in the specified axes.
%
% REMARKS
%
% If LOGZPLOT is used to transform an existing surface or patch object, the
% color data ('CData' for surface objects, 'FaceVertexCData' for trisurf
% and trimesh patch objects) must be in indexed form.  LOGZPLOT can not
% transform objects with truecolor (RGB) color data, and will exit with a
% warning if called on an object with truecolor color data.  LOGZPLOT sets
% the object's 'CDataMapping' property to 'scaled'.
%
% LOGZPLOT replaces the original color data, CData, with a transformed
% version, log10(CData).  An additional linear scaling is performed on the
% transformed data so that the scale on a colorbar will have the same range
% as the original data.  
%
% Changing the value of the axes 'CLim' (color limits) property using
% either the CAXIS command or set(ax_handle,'CLim') will alter the mapping
% of the data to the colormap as described in the documentation for the
% CAXIS command. This is a useful technique to highlight different data
% ranges in the plot.  See Example 2 below.
%
% However, as noted above, the log-transformed data does not result in an
% accurate colorbar scale without an additional (linear) transformation.
% To accurately map the color data to the colorbar's scale after a change
% to the axes 'CLim' property, LOGZPLOT attaches a set of listener
% functions to the axes that correct the color data scaling whenever the
% 'CLim' property is changed.  This allows the user to specify 'CLim'
% values in the same units and range as the original data.
%
% The listener functions were written for MATLAB R2010a, and may not
% function correctly on older releases due to changes in the MATLAB
% graphics system. If problems related to the listener functions occur, set
% the parameter 'listenerEnable' to false in the first section of the
% LOGZPLOT code, just below the help text.  This will disable the listener
% functionality and prevent rescaling of the color data after a CLim
% change.
%
% The scaling of the color data performed by LOGZPLOT introduces numerical
% error. The magnitude of the error depends on the range of the original
% data as well as the values of the axes' CLim property.  The error is
% cumulative, so making many changes to the CLim values can potentially
% result in inaccurate color data.
%
% If an object created or modified by LOGZPLOT is located in an axes with
% non-log-scaled indexed color objects (surface, patch, or image), the
% colorbar scale will not be accurate.  To ensure accurate colorbar scales,
% do not combine a LOGZPLOT-scaled object with non-scaled indexed-color
% objects in the same axes.
%
% LOGZPLOT attempts to avoid re-transforming a previously log-scaled 
% plot (from a previous call to LOGZPLOT).  This allows multiple calls
% to LOGZPLOT using the same object, e.g. to add a colorbar after creating
% the plot.
%
% Because MATLAB's OpenGL renderer does not support logarithmic axes, the
% figure's 'Renderer' property must be set to another renderer for proper
% display of the plot.  MATLAB should change the renderer automatically. In
% some cases when using an existing figure for the plot output, the
% renderer will not change automatically, and the log-scale z-axis will not
% display properly.  If this occurs, set the renderer manually using:
%    set(fig_handle,'Renderer','ZBuffer')
% where fig_handle is the handle of the figure in question.  See the
% documentation for 'Figure Properties' for more information.
%
% Compared to other high-level plotting functions, TRIMESH (and to a lesser
% extent TRISURF) offer incomplete support for the specification of an axes
% handle as a target for the plot output in place of gca().  In particular,
% TRIMESH cannot accept an axes handle if the data is specified as a TriRep
% object.  If LOGZPLOT is called with a TriRep object and TRIMESH as the
% plotting function, the plot will be created in the current axes, ignoring
% any axes handle input.
%
% EXAMPLES
%
% % Example 1 - Compare linear and log-scaled surface plots
%
% % Generate some Gaussian data with a small sinusoidal component:
% x = linspace(-10,10,101);
% [X ,Y] = meshgrid(x);
% Z = 5*exp(-(0.82*(X+3.5).^2 + 0.46*(Y-3.5).^2)) + ...
%     0.8*exp(-(0.45*(X-1.5).^2 + 0.95*(Y-1.5).^2)) + ...
%     0.2*exp(-(0.75*(X-4).^2 + 0.85*(Y+1).^2)+(0.7*(X-3)+.3*(Y-1)).^2)+...
%     0.06*exp(-(0.2*(X+2.5).^2 + 0.3*(Y+3.5).^2)) + ...
%     -0.45*exp(-(0.5*(X+3.3).^2 + 1.5*(Y-2.5).^2)) + ...
%     0.0015*sin(2.6*X+1.1*Y-0.2*X.*Y) + ...
%     0.0009*sin(1.3*X+2.1*Y+0.12*X.*Y);
%
% % Scale the data so its range is 1 to 30000:
% minz = 1;
% maxz = 3e4;
% Z = (maxz-minz)*(Z-min(Z(:)))./(max(Z(:))-min(Z(:))) + minz;
% 
% % Add a large Gaussian that will swamp the rest of the data:
% Z = Z + 1e6*exp(-2*(X.^2 + (Y-4).^2));
%
% % Linear z-axis with linear color scale:
% figure(1)
% set(1,'position',[254 335 642 471])
% colormap(jet(64))
% h = surf(X,Y,Z); colorbar
% title('Linear Z-scale and Coloring')
% % Almost all of the surface's detail is hidden because both the height
% % scale and color scale are dominated by the single prominent feature of
% % the data. 
%
% % Log-scale z-axis with linear color scale:
% % Use SURF, then change the z-axis scaling using set(gca,'ZScale','log').
% figure(2)
% set(2,'position',[254 335 642 471])
% colormap(jet(64))
% h = surf(X,Y,Z); colorbar
% set(gca,'ZScale','log')
% title('Log Z-scale with Linear Coloring')
% % Note how the log-scale z-axis improves the visibility of the small
% % elevation features of the surface. However, the coloring of the surface
% % is not ideal - the variation in color is still concentrated near the
% % top of the surface due to the linear color scale.
%
% % Log-scale plot using LOGZPLOT to achieve both log-scale z-axis and
% % log-scale color:
% figure(3)
% set(3,'position',[254 335 642 471])
% colormap(jet(64))
% logzplot(X,Y,Z,'colorbar')
% title('Logarithmic Z-scale and Coloring')
% % The plot created by LOGZPLOT shows the advantage of using log-scaled
% % color in addition to the log-scaled z-axis.  
%
% % Example 2 - Multiple calls to LOGZPLOT, changing the 'CLim' property
%
% % (Using the X,Y,Z data from Example 1)
% figure(4)
% colormap(jet(64))
%
% % Make a surface using pcolor:
% pcolor(X,Y,Z); shading flat
%
% % Call logzplot to transform to the pcolor plot to log-scale:
% logzplot
%
% % Call logzplot again to add a log-scale colorbar:
% logzplot colorbar
%
% % Use the CAXIS command to set the axes CLim parameter (color limits) to
% % highlight the lower range of the data.  The colorbar scale should 
% % adjust to the new limits:
% caxis([1 70])
%
% % Call CAXIS again with different CLim values, to highlight the middle
% % range of the data:
% caxis([40 8000])
%
% % One more call to CAXIS to reset the color limits:
% caxis auto
%
%
% See also SURF, MESH, PCOLOR, TRISURF, TRIMESH, CAXIS, IMAGE
%

% $$FileInfo
% $Filename: logzplot.m
% $Path: $toolboxroot/
% $Product Name: logzplot
% $Product Release: 1.2
% $Revision: 1.2.8
% $Toolbox Name: Custom Plots Toolbox
% $$
%
% Copyright (c) 2010-2012 John Barber.
%
% Release History:
% v 1.0 : 2010-Nov-08
%       - Initial release
% v 1.1 : 2010-Nov-30
%       - Added support for TRISURF and TRIMESH plots
%       - Improved memory performance
%       - Improved speed of axes CLim change listener function
%       - Improved colorbar support
% v 1.2 : 2012-May-30
%       - Added support for plots using IMAGE
%       - Added colorbar handle output
%       - Fixed CLim equality test bug
%       - Code cleanup (variable/function names changed, etc.)


%% Defaults and initial values

% Listener enable flag:
% Disable if listener function causes errors
% -- false = disabled
% -- true = enabled (default)
listenerEnable = true;  
% listenerEnable = false;  % Uncomment this line to disable listener

% Supported plotting functions:
plotFunList = {'surf','pcolor','mesh','trisurf','trimesh','image'};

% Default values:
% hSurf = [];  
% hAx = [];   
% pcolorFlag = false;    
inputHandle = [];
colorbarFlag = false;
plotFun = @surf;
x = [];
y = [];
z = [];
CData = [];
tr = [];
triRep = [];
badInput = false;
plotFlag = false;

%% Parse inputs
if ~isempty(varargin)
    
    % Get char arrays and make indices of other classes
    chars = varargin(cellfun(@ischar,varargin));
    numIdx = cellfun(@isnumeric,varargin);
    fHandleIdx = cellfun(@(x)(isa(x,'function_handle')),varargin);
    scalarIdx = cellfun(@isscalar,varargin);
    emptyIdx = cellfun(@isempty,varargin);
    cellIdx = cellfun(@iscell,varargin);
    triRepIdx = cellfun(@(x)(isa(x,'TriRep')),varargin);
    
    % Make an index of non-empty non-scalar arrays
    numIdx = numIdx & ~scalarIdx & ~emptyIdx;
    numIdx = find(numIdx);
    
    % Make a cell array with just the function handles
    fHandles = varargin(fHandleIdx);
    
    % Detect an HG handle if it was given
    handleList = cell2mat(varargin(scalarIdx & ~fHandleIdx & ...
        ~emptyIdx & ~cellIdx));
    inputHandle = handleList(find(ishghandle(handleList),1));
    inputHandle((end-length(inputHandle)+2):end) = [];
    
    % Test for 'colorbar' and 'plot function name' inputs
    k = 1;
    while k <= length(chars)
        switch lower(chars{k})
            case 'colorbar'
                colorbarFlag = true;
                k = k + 1;
            case plotFunList
                plotFun = str2func(chars{k});
                k = k + 1;
            otherwise
                k = k + 1;
        end
    end
    
    % If a valid function handle was input, take it
    if ~isempty(fHandles) && ...
            any(strcmp(func2str(fHandles{end}),plotFunList))
        plotFun = fHandles{end};
    end
    
    % Get the data to be plotted, otherwise, exit with an error   
    switch func2str(plotFun)
        case 'image'
            % For image plots, valid inputs are 1 (CData) or 3 (x,y,CData)
            switch length(numIdx)
                case 1
                    z = varargin{numIdx};
                    x = 1:size(z,2);
                    y = 1:size(z,1);
                    plotFlag = true;
                case 3
                    x = varargin{numIdx(1)};
                    y = varargin{numIdx(2)};
                    z = varargin{numIdx(3)};
                    plotFlag = true;
                otherwise
                    badInput = true;
            end
            
        case {'surf','mesh','pcolor'}
            % For surface plots, valid inputs are 1 (z), 2 (z,CData),
            % 3 (x,y,z), or 4 (x,y,z,CData)
            switch length(numIdx)
                case 0
                    % 
                    plotFlag = false;
                case 1
                    z = varargin{numIdx};
                    x = 1:size(z,2);
                    y = 1:size(z,1);
                    plotFlag = true;
                case 2
                    z = varargin{numIdx(1)};
                    CData = varargin{numIdx(2)};
                    x = 1:size(z,2);
                    y = 1:size(z,1);
                    plotFlag = true;
                case 3
                    x = varargin{numIdx(1)};
                    y = varargin{numIdx(2)};
                    z = varargin{numIdx(3)};
                    plotFlag = true;
                case 4
                    x = varargin{numIdx(1)};
                    y = varargin{numIdx(2)};
                    z = varargin{numIdx(3)};
                    CData = varargin{numIdx(4)};
                    plotFlag = true;
                otherwise
                    badInput = true;
            end     
            
        case {'trisurf','trimesh'}
            % For trisurf/trimesh, valid inputs are 1 (TriRep object),
            % 4 (tr,x,y,z) or 5 (tr,x,y,z,CData)
            if find(triRepIdx)
                triRep = varargin{triRepIdx};
                plotFlag = true;
                % Force LOGZPLOT to use gca for trimesh because it does not
                % properly utilize an axes handle input when called with
                % TriRep input
                if ~isempty(inputHandle) && ...
                        strcmp(func2str(plotFun),'trimesh')
                    msgid = [mfilename ':IgnoreInputHandle'];
                    msgtext = ['trimesh does not properly support axes' ...
                        ' handle input.  Using gca() for plot output.'];
                    warning(msgid,msgtext)
                    inputHandle = gca;
                end
            else
                if length(numIdx) == 4
                    tr = varargin{numIdx(1)};
                    x = varargin{numIdx(2)};
                    y = varargin{numIdx(3)};
                    z = varargin{numIdx(4)};
                    plotFlag = true;
                elseif length(numIdx) == 5
                    tr = varargin{numIdx(1)};
                    x = varargin{numIdx(2)};
                    y = varargin{numIdx(3)};
                    z = varargin{numIdx(4)};
                    CData = varargin{numIdx(5)};
                    plotFlag = true;
                else
                    badInput = true;
                end
            end
    end
    
    % Exit with an error if the inputs didn't work out
    if badInput
        msgid = [mfilename ':InvalidInputs'];
        msgtext = ['Invalid input.  Type ' ...
            'help ' mfilename ' for correct syntax'];
        error(msgid,msgtext)
    end

end % Done parsing input arguments

%% Make/modify plot

% Get handles:
[hFig,hAx,hSurf,priorFlag] = getHandles(inputHandle,plotFlag);

if priorFlag
    % Surface is already scaled, so just call the colorbar subfunction,
    % then exit:
    if colorbarFlag
        hCbar = LogZPlotColorbar(hFig,hAx);
    end
    
    % Set return values and exit
    if nargout > 0
        h = hSurf;
    end
    if nargout > 1
        h2 = hCbar;
    end
  
    return
end

if ~plotFlag
    % Determine the plot type and get its CData
    
    switch get(hSurf,'Type')
        case 'surface'
            CDataName = 'CData';
            % To determine if it is a pcolor plot, check if the ZData is
            % all zeros
            pcolorFlag = all(all(get(hSurf,'ZData')==0));
        case 'patch'
            CDataName = 'FaceVertexCData';
            pcolorFlag = false;
        case 'image'
            CDataName = 'CData';
            pcolorFlag = true; % avoid setting ZScale
    end
    
    % Now get the CData to work on
    CData = get(hSurf,CDataName);
    
    % If the CData is RGB, we don't know what to do, so throw a warning
    if size(CData,3) == 3;
        msgid = [mfilename ':TrueColorCData'];
        msgtext = ['The CData of the surface object is truecolor. ' ...
            'The surface will not be transformed'];
        warning(msgid,msgtext)
        
        % Set return values and exit
        if nargout > 0
            h = [];
        end
        if nargout > 1
            h2 = [];
        end
        
        return
    end
    
else % plotFlag == true
    % Make a plot with the user-suppled data
    
    % If we didn't get any CData as an input, use the ZData
    if isempty(CData)
        CData = z;
    end
    
    % Handle different plot types
    switch func2str(plotFun)
        case {'surf','mesh'}
            CDataName = 'CData';
            pcolorFlag = false;
            hSurf = plotFun(hAx,x,y,z,CData);
        case 'pcolor'
            CDataName = 'CData';
            pcolorFlag = true;
            hSurf = plotFun(hAx,x,y,CData);
        case {'trisurf','trimesh'}
            CDataName = 'FaceVertexCData';
            pcolorFlag = false;
            if isempty(triRep)
                hSurf = plotFun(tr,x,y,z,CData(:),'Parent',hAx);
            elseif strcmp(func2str(plotFun),'trimesh')
                % Workaround for broken axes handle support in trimesh
                hSurf = plotFun(triRep);
            else
                hSurf = plotFun(triRep,'Parent',hAx);
            end
            CData = get(hSurf,CDataName);
        case 'image'
            CDataName = 'CData';
            pcolorFlag = true; 
            if isvector(x), x2 = x; else x2 = x(1,:); end
            if isvector(y), y2 = y; else y2 = y(:,1); end
            hSurf = plotFun(x2,y2,CData,'Parent',hAx);
            set(hAx, 'YDir','normal')
    end
       
    % Clear x,y,z now that we're done with them.  We are clearing z
    % _before_ we modify CData.  This way, when CData <= z from the 
    % assignment statement a few lines above, MATLAB won't need to create
    % a second copy of the data in memory.
    clear x y z tr triRep

end

% Get rid of (CData <= 0) and (CData == Inf)
CData(CData<=0) = NaN;
CData(CData==Inf) = NaN;

% Find min/max 
minC = min(CData(:));
maxC = max(CData(:));

% Convert data to log space
CData = log10(CData);

% Normalize the log scaled CData to have the same range as the ZData so 
% that the colorbar scale will be correct
CData = minC + (maxC-minC)*(CData-log10(minC))/(log10(maxC/minC));

% Now set the CData of the surface to the normalized CData
set(hSurf,CDataName,CData)

% Make sure we are in 'scaled' CDataMapping mode
set(hSurf,'CDataMapping','scaled')

% Set a flag so we'll know the surface has already been transformed
setappdata(hSurf,'LogZPlotTransformedCData',true)

% Set the Z scale to 'log' if it isn't a pcolor plot
if ~pcolorFlag
    set(hAx,'ZScale','log')
end

% Call the colorbar subfunction
hCbar = []; 
if colorbarFlag
    hCbar = LogZPlotColorbar(hFig,hAx);
end

% Store the CData range and set up the listeners
if listenerEnable
   
    setappdata(hSurf,'LogZPlotCLim',[minC maxC])
    setappdata(hSurf,'LogZPlotCLimOriginal',[minC maxC]);
    try
        fh = @(src,event)CLimChange(src,event,hAx,hSurf,true,CDataName);
        
        hCLimModeListener = handle.listener(handle(hAx),...
            findprop(handle(hAx),'CLimMode'), 'PropertyPreSet',...
            {@CLimModeChange,hAx,fh});
        
        hCLimListener = handle.listener(handle(hAx), ...
            findprop(handle(hAx),'CLim'), 'PropertyPostSet', ...
            {@CLimChange,hAx,hSurf,false,CDataName});
        
        listenerHandles = [hCLimModeListener; hCLimListener];
        setappdata(hSurf,'LogZPlotListeners',listenerHandles)
        
    catch %#ok<CTCH>
    end
        
end

% Set return values and exit
if nargout > 0 
    h = hSurf;
end
if nargout > 1
    h2 = hCbar;
end 

end % End of function logzplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CLimChange(src,evnt,hAx,hSurf,autoFlag,CDataName) %#ok<INUSL>
% Listener function to update hSurf.CData with the proper scaling whenever
% hAx.CLim changes.  Executed post-set.

% Get old and new CLim values
priorCLim = getappdata(hSurf,'LogZPlotCLim');
newCLim = get(hAx,'CLim');

% autoFlag is set when this function is called by the CLimMode pre-set 
% listener, signifying that we are going back to 'auto' mode and need to
% scale the data to the original limits.  This handles the case where
% CLimMode is reset after having been set to manual.
if autoFlag
    newCLim = getappdata(hSurf,'LogZPlotCLimOriginal');
end

% If newCLim and priorCLim are the same, no need to do anything
if abs(priorCLim(1) - newCLim(1)) < 10*eps(priorCLim(1)) ...
   && abs(priorCLim(2) - newCLim(2)) < 10*eps(priorCLim(2))
    return
end

% Warn and don't scale data if CLim is <= 0
if any(newCLim<=0)
    msgid = [mfilename ':NegativeCAxisLimit'];
    msgtext = [mfilename ' only supports positive CLim values.  ' ...
               'Colorbar scale will not be accurate.'];
    warning(msgid,msgtext)
    return
end

% Chop up priorCLim
pL = priorCLim(1);
pH = priorCLim(2);

% Chop up newCLim
nL = newCLim(1);
nH = newCLim(2);

% There are two parts to the transformation: 1) Undo the previous
% normalization (restore CData to its original values) 2) Normalize the
% CData to the new CLim.  They are shown here separately, but computed
% in-place in one step by computing the constants K1 and K2 below.

% 1) Undo the previous normalization to priorCLim:
% CData = (CData-pL)*(log10(pH/pL)/(pH-pL)) + log10(pL);

% 2) Normalize CData to new CLim:
% CData = nL+(nH-nL)*(CData-log10(nL))/log10(nH/nL);

% Compute renormalization constants K1,K2
K1 = nL+(nH-nL)/(log10(nH/nL))*(log10(pL)-log10(nL)-pL*log10(pH/pL)/(pH-pL));
K2 = (nH-nL)*log10(pH/pL)/(log10(nH/nL)*(pH-pL));

% Update the surface with the new CData
set(hSurf,CDataName,K1+K2*get(hSurf,CDataName));

% Write the new CLim to appdata:
setappdata(hSurf,'LogZPlotCLim',newCLim);

end % End of function logzplot/CLimChange
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CLimModeChange(src,evnt,hAx,fhCLimChange)  %#ok<INUSL>
% Listener function to reset the CData using fhCLimChange whenever
% the CLimMode is changed back to 'auto'.  This needs to happen _before_
% the CLimMode is actually changed so that the auto-mode axes refresh uses
% the correct (new) limits instead of basing them on the old CData.

if strcmp(get(hAx,'CLimMode'),'manual')
    fhCLimChange(0,0)
end

end % End of function logzplot/CLimModeChange
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hFig,hAx,hSurf,priorFlag] = ...
                getHandles(inputHandle,plotFlag)
% Given an input handle and plotFlag, get figure, axes, surface handles and
% priorFlag.  

% Default return value unless we find a flag on the surface object
priorFlag = false;

% Return empty for hSurf if plotFlag == true
hSurf = [];

if ~isempty(inputHandle)
    % If we were given a handle, determine its type and then get the other
    % handles we need
    switch lower(get(inputHandle,'Type'))
        case 'axes'
            hAx = inputHandle;
            hFig = ancestor(hAx,'figure');
        case {'surface','patch','image'}
            hSurf = inputHandle;
            hAx = ancestor(hSurf,'axes');
            hFig = ancestor(hSurf,'figure');
        otherwise
            msgid = [mfilename ':InvalidInputHandle'];
            msgtext = ['Input handle must refer to a valid axes or '...
                'surface object'];
            error(msgid,msgtext);
    end
else
    % No input handle so use the current figure and axes
    hFig = gcf;
    hAx = gca;
end

if ~plotFlag
    % If necessary, try to find a surface object
    if isempty(hSurf)
        hSurf = findobj(hAx,'Type','surface','-or','Type','patch',...
            '-or','Type','image');
    end
    
    % If we couldn't find one, or found more than one, exit
    if isempty(hSurf)
        msgid = [mfilename ':NoSurfaceObject'];
        msgtext = 'Could not locate a surface object to transform';
        error(msgid,msgtext);
    elseif length(hSurf) > 1
        msgid = [mfilename ':MultipleSurfaceObjects'];
        msgtext = [mfilename ' only supports one surface object per axes'];
        error(msgid,msgtext)
    end
    
    % Check for prior logzplot transformation
    priorFlag = getappdata(hSurf,'LogZPlotTransformedCData');

end

end % End of function logzplot/getHandles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hCbar = LogZPlotColorbar(hFig,hAx,hCbar)

if nargin == 2
    % See if there are existing colorbars in the figure
    hCbar = findobj(hFig,'tag','Colorbar');
end

% We only want to modify a colorbar whose peer axes is hAx.  To check this,
% use the not fully documented handle() and h.axes property.  Best to wrap
% this in a try block and do nothing if it fails.
try
    for k = length(hCbar):-1:1
        hTestAx = handle(hCbar(k));
        if (double(hTestAx.axes) ~= hAx)
            hCbar(k) = [];
        end
    end
catch   %#ok<CTCH>
    hCbar = [];
end

% For multiple colorbars, call this function recursively for each one
if length(hCbar) > 1
    for k = 1:length(hCbar)
        LogZPlotColorbar(hFig,hAx,hCbar(k));
    end 
    return
end

% If there isn't a colorbar, make it now 
if isempty(hCbar)
    hCbar = colorbar('peer',hAx);
end

switch get(hCbar,'Location')
    case {'East','West','EastOutside','WestOutside'}
        scaleName = 'YScale';
    case {'North','South','NorthOutside','SouthOutside'}
        scaleName = 'XScale';
end

% Set the colorbar axes scale to 'log'
set(hCbar,scaleName,'log')
    
end % End of function logzplot/LogZPlotColorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%