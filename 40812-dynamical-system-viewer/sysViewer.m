function h = sysViewer(oPar, cPar, fcn, typ, varargin)
%sysViewer Dynamical system graphical interface.
%   h = sysViewer(oPar, cPar, fcn, typ) builds a GUI for viewing the
%   effects of parameter changes on a one- or two-dimensional dynamical
%   system.
%
%   oPar and cPar are two-column cell arrays that define the order
%   parameter and control parameter(s), respectively. The first column
%   contains parameter names (strings to be typeset in latex). The second
%   column contains 1x2 vectors of parameter's range. This vector defines
%   plot axes limits for the order parameter and slider limits for the
%   control parameters.
%
%   The system is defined by the function handle fcn. For one-dimensional
%   systems, this should be a function with two inputs and one output. The
%   first input is system state, which will be a scalar in a one-
%   dimensional system. The second input is a vector of control parameter
%   values. The output of fcn can be either the rate of change of the order
%   parameter (in which case fcn is the flow equation), or the system
%   potential (in which case fcn is the potential function). Which function
%   is supplied can be indicated by the last input typ, one of the strings
%   'flow' or 'potential'. If typ is empty or omitted, 'flow' is the
%   default.
%
%   For two-dimensional systems defined with a flow, fcn should be a cell
%   array containing two function handles, each outputting the rate of
%   change along one dimension. Each function should take three inputs; the
%   first two are scalar values of the order parameters, the third is a
%   vector of control parameters. For two-dimensional systems defined with
%   a potential, fcn should take inputs as above and output a scalar.
%
%   The output h is a struct containing handles to the graphics objects in
%   the GUI. Intended only for advanced tweaking or troubleshooting. 
%
%   sysViewer(..., defs) initializes the parameter sliders with the default
%   values in vector defs.
%
%   sysViewer(..., 'vectorize') speeds up computation for functions that
%   cannot be evaluated with a vector. In fact, any number of trailing
%   arguments will be passed to chebfun. See CHEBFUN for more options 
%   (CHEBFUN2 and CHEBFUN2V for two-dimensional options).
%
% --------
% Examples:
%   ------
%   One-dimensional
%   ---
%   sysViewer({'\phi' [-pi pi]}, ...
%             {'b/a' [0 1]; '\Delta\omega' [-2 2]}, ...
%             @(x,c) c(2)*x-cos(x)-c(1)*cos(2*x), ...
%             'potential');
%
%   sysViewer({'\phi' [-pi pi]}, ...
%             {'b/a' [0 1]; '\Delta\omega' [-2 2]}, ...
%             @(x,c) c(2)-sin(x)-2*c(1)*sin(2*x), ...
%             'flow');
%
%   sysViewer({'\phi' [-pi pi]}, ...
%             {'b/a' [0 1]; '\Delta\omega' [-2 2]; 'c' [0 .5]; 'd' [0 .5]}, ...
%             @(x,c) c(2)*x-cos(x)-c(1)*cos(2*x)+c(3)*sin(x)+c(4)*sin(2*x), ...
%             'potential');
%
%   sysViewer({'\phi' [-pi pi]}, ...
%             {'b/a' [0 1]; '\Delta\omega' [-2 2]; 'c' [0 .5]; 'd' [0 .5]}, ...
%             @(x,c) c(2)-sin(x)-2*c(1)*sin(2*x)+c(3)*cos(x)+2*c(4)*cos(2*x), ...
%             'flow');
%   ------
%   Two-dimensional
%   ---
%   sysViewer('x' [-5 5]; '\dot{x}' [-5 5]}, ...
%             [{'\alpha'; '\beta'; '\delta'} repmat({[-5 5]}, 3, 1)], ...
%             {@(x,dx,r) dx, @(x,dx,r) -r(1).*x.^3 - r(2).*x - r(3).*dx}, ...
%             'flow')
%
%--------
% Dependencies (if missing, user will be prompted to download and install):
%   <a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/27758-gui-layout-toolbox')">GUI Layout Toolbox</a>
%   <a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/13845-sliderpanel')">sliderPanel</a>
%   <a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/10743-uibutton-gui-pushbuttons-with-better-labels')">uibutton</a>
%   Chebfun:
%   -  <a href="matlab:web('http://www.mathworks.com/matlabcentral/fileexchange/23972')">Stable version</a> (one-dimensional systems only)
%   -  <a href="matlab:web('http://www2.maths.ox.ac.uk/chebfun/chebfun2/')">Alpha release</a> (required for viewing two-dimensional systems)
%   (as of March 14 2013)

%--------
% Henry S. Harrison
%
% Center for the Ecological Study of Perception and Action
% University of Connecticut
% henry.harrison@uconn.edu
% henry.schafer.harrison@gmail.com
%
% TO DO
%  - annottate 2D plots
%  - make into an app; wizard to set inputs?
%  - re-docking broken
%  - remove lAx
%  - prevent blinking
%  - make plots expand upon undocking sliders
%  - make tspan customizable/adaptive
%  - replace 2d annotations
%  - label 2d fixed pts?
%  - 3D vector fields
%  - some 2D systems get caught up in singularities
%  - some trajectories won't generate
%
% v1.1.1   3/14/2013
% - cleaned up dependency messages for chebfun
% - added dialog to inform user of plotting solution trajectories
% - added legend for 2D flow
%
% v1.1     3/8/2013
% - fixed stems overlapping label boxes
% - two dimensions!
%
% v1       6/7/2012
%  - added current state line to bifurcation diagram
%
% v0.9.6   5/26/2012
%  - improved bifurcation diagram generation
%  - added option to use parrallel computing toolbox
%
% v0.9.5   5/25/2012
%  - bifurcation diagrams!
%
% v0.9.1   5/22/2012
%  - fixed error that occurred when figure was updated too fast, by making
%    the sliders not interruptible
%  - no longer relabel axes with every update
%
% v0.9     5/21/2012
%  - revamped computations to take advantage of chebfun package
%  - revamped GUI to display flow and potential together
%  - made control panel undockable
%  - included requireFEXpackage to install dependencies
%
% v0.6.2   5/18/2012
%  - fixed overlapping label stems
%
% v0.6.1   2/20/2012
%  - improved method of determining fixed points in flow diagram
%
% v0.6     2/19/2012
%  - added text edit boxes for control parameters using sliderPanel
%
% v0.5.1   2/18/2012
%  - improved fixed point and lambda estimation using Adaptive Robust
%    Numerical Differentation (at some expense of speed)
%
% v0.5.0   2/15/2012
%  - initial version

%Globals
tbarBuffer     = 39;  % px
sldrHeight     = 20;  % px
sldrPad        = 50;  % px
sPanelPad      = 20;  % px
xAxisNudge     = 10;  % px
yAxisNudge     = 12;  % px
lblMargin      = 3;   % px
txtPad         = 10;  % px
axPadding      = 100; % px
axSpacing      = 0;   % px
lAxHeight      = 200; % px
titleBarHeight = 35;  % px
fSize                = 14;  % pt
fSizeLabel           = 12;  % pt
fSizeFixPt           = 12;  % pt
pLineWidth           = 2;   % pt
zLineWidth           = 1;   % pt
lblLineWidth         = 1;   % pt
fixedPtSize          = 10;  % pt
fixedPtWidth         = 2;   % pt
biDiagramWidth       = 2;   % pt
biDiagramCurValWidth = 1;   % pt
nullclineWidth       = 1;   % pt
quiverLineWidth      = .5;  % pt
quiverMarkerSize     = 1.5; % pt
solLineWidth         = .5;  % pt
solMarkerSize        = 1.5; % pt
sldrWidth    = .25;       % proportion of screensize
maxArrowSize = .05;       % proportion of range
minArrowSize = .01;       % proportion of range
sliderStep   = [.005 .1]; % proportion of range
biRes        = 500;
tspan = [0 20 2];
tspanSliderStep = [.1/20 1/20];
latexFlag = true;
warnSim   = true;
anyDefs   = false;
font                 = 'Times New Roman';
fixedPtColor         = 'r';
fixedPtBgColor       = 'w';
bgColor              = 'w';
halfStableLineSpec   = '*';
arrowColor           = 'k';
biDiagramRepStyle    = ':';
biDiagramColor       = 'r';
biDiagramCurValStyle = 'k:';
xNullclineStyle      = 'k:';
yNullclineStyle      = 'k--';
quiverLineStyle      = 'bo-';
quiverColor          = 'b';
solColor             = 'k';
saddleStyle          = 'r*';
stableStyle          = 'ro';
stableFill           = 'r';
unstableStyle        = 'ro';
unstableFill         = 'w';
centerStyle          = 'r.';
solLineStyle         = 'k';
solStartStyle        = 'ko';
defType              = 'flow';
waitPtr              = 'watch';
normPtr              = 'arrow';
tspanStr             = 'Solution Length:';
scrsz     = get(0, 'ScreenSize');
sldrWidth = sldrWidth*scrsz(3);
dependencies = {'uiextras.HBox', 27758, 'class'; ...
                'sliderPanel'  , 13845, 'file'; ...
                'chebfun'      , 23972, 'file'; ...
                'uibutton'     , 10743, 'file'};

% Check inputs
assert((isempty(cPar) || (iscell(cPar) && size(cPar,2) == 2)) && ...
    iscell(oPar) && size(oPar,2) == 2, ...
    'sysViewer:badParams', ['OPAR and CPAR must be cell arrays with' ...
    ' 2 columns.']);
cellfun(@(x) assert(ischar(x), 'sysViewer:badParamName', ...
    ['The first column of OPAR and CPAR must contain strings ' ...
    '(parameter names).']), oPar(:,1));
cellfun (@(x) assert(isnumeric(x) && numel(x) == 2, ...
    'sysViewer:badParamRange', ['The second column of OPAR and ' ...
    'CPAR must contain vectors of length 2 (parameter ranges).']), ...
    oPar(:,2));
if ~isempty(cPar)
    cellfun(@(x) assert(ischar(x), 'sysViewer:badParamName', ...
        ['The first column of OPAR and CPAR must contain strings ' ...
        '(parameter names).']), cPar(:,1));
    cellfun (@(x) assert(isnumeric(x) && numel(x) == 2, ...
        'sysViewer:badParamRange', ['The second column of OPAR and ' ...
        'CPAR must contain vectors of length 2 (parameter ranges).']), ...
        cPar(:,2));
end

O = size(oPar,1);
C = size(cPar,1);
if ~exist('typ', 'var') || isempty(typ), typ = defType; end
assert(any(strncmpi(typ, {'flow' 'potential'}, length(typ))), ...
        'sysViewer:badType', 'TYP must be ''Flow'' or ''Potential''.');
if iscell(fcn)
    assert(all(cellfun(@(f) isa(f, 'function_handle'), fcn)), ...
        'sysviewer:badfunction', ['Each element of fcn must be a ' ...
        'function handle']);
    if numel(fcn) == 1
        fcn = fcn{1};
    elseif numel(fcn) == 2
        assert(O == 2, 'sysviewer:badfunction', ['Too many elements ' ...
            'in cell array fcn.']);
        assert(~strncmpi(typ, 'potential', length(typ)), ...
            'sysviewer:badfunction', ...
            'A fcn with multiple outputs cannot describe a potential');
    end
else
    assert(isa(fcn, 'function_handle'), 'sysviewer:badfunction', ...
        ['fcn must be a function handle or cell array of function ' ...
        'handles.']);
    assert(strncmpi(typ, 'potential', length(typ)) || O == 1, ...
        'sysviewer:badfunction', ['The flow in dimensions > 1 must be ' ...
        'defined with a cell array.']);
end
if O == 1
else
    assert(O<3, 'sysViewer:tooManyDims', ['Only systems with two or ' ...
        'fewer order parameters are currently supported.']);
    if strncmpi(typ, 'flow', length(typ))
        typ = 'flow2';
    else
        typ = 'pot2';
    end
end
if exist('varargin', 'var') && ~isempty(varargin) && isnumeric(varargin{1})
    defs = varargin{1};
    assert(numel(defs) == C, 'sysViewer:badNumDefaults', ['Parameter ' ...
        'defaults (input defs) must have the same length as the ' ...
        'number of control parameters.']);
    arrayfun(@(i) assert(cPar{i,2}(1) <= defs(i) ...
        && defs(i) <= cPar{i,2}(2), 'sysViewer:defaultOutOfRange', ...
        sprintf('Element #%u of defs is out of range given in cPar{%u,2}.', ...
        i, i)), 1:C);
    anyDefs = true;
    varargin(1) = [];
end
    
% Check dependencies
n = size(dependencies, 1);
for i = 1:n %#ok<*FORPF>
   % read function name and FEX package ID
   dep_fun  = dependencies{i,1};                       
   dep_pack = dependencies{i,2};
   dep_kind = dependencies{i,3};
   % if the function does not exist in your Matlab path,
   % downloaded and install the FEX package containing that function.
   if ~exist(dep_fun, dep_kind)
       if strcmp(dep_fun, 'chebfun')
           helpdlg({['Chebfun package not found. Also, chebfun2 is required ' ...
               'for viewing 2-D systems, and is only available as an ' ...
               'alpha release (as of 3/14/2013). With the stable ' ...
               'version, only 1-D systems can be viewed.'] '' ...
               'The alpha release can be found at ' ...
               'http://www2.maths.ox.ac.uk/chebfun/chebfun2/'
               'The stable  release can be found at ' ...
               'http://www.mathworks.com/matlabcentral/fileexchange/23972' ...
               '' ['The automatic installer will install the stable ' ...
               'release. Press NO on the next dialog if you would ' ...
               'prefer the alpha with chebfun2.']}, 'Chebfun help');
       else
           P = requireFEXpackage(dep_pack);
           if isempty(P)
               error('sysViewer:missingDependency',  ...
                   ['Dependency missing; install failed or was aborted ' ...
                   '(Mathworks.com File Exchange ID# %u).'], dep_pack);
           end
       end
   end
end

% Check chebfun2
if O>1
    assert(exist('chebfun','file')>0,'sysViewer:missingChebfun2', ...
        ['Missing chebfun2 package, ' ...
        '2-D functions will not be available. ' ...
        'You may download chebfun2 at ' ...
        'http://www2.maths.ox.ac.uk/chebfun/chebfun2/ \n\n' ...
        'Note that you may have to delete your existing chebfun installation. ' ...
        'As of March 14 2013, chebfun2 is only available as an ' ...
        'alpha release. With the stable version, ' ...
        'sysviewer can only display one-dimensional systems.'])
end
    
% Create figure using GUI Layout Toolbox
h.f = figure( ...
    'Name'           , 'System Viewer', ...
    'OuterPosition'  , scrsz + [0 tbarBuffer 0 -tbarBuffer], ...
    'MenuBar'        , 'figure', ...
    'ToolBar'        , 'figure', ...
    'Color'          , bgColor, ...
    'CloseRequestFcn', @closeFcn, ...
    'Visible'        , 'off');
h.split = uiextras.HBox( ...
    'Parent'         , h.f, ...
    'Units'          , 'normalized', ...
    'Position'       , [0 0 1 1], ...
    'BackgroundColor', bgColor);
h.leftSplit = uiextras.VBox( ...
    'Parent'         , h.split, ...
    'Units'          , 'normalized', ...
    'Position'       , [0 0 1 1], ...
    'BackgroundColor', bgColor);
h.sBox = uiextras.BoxPanel( ...
    'Parent'         , h.leftSplit, ...
    'Title'          , 'Control parameters', ...
    'FontName'       , font, ...
    'FontSize'       , fSize, ...
    'Units'          , 'normalized', ...
    'Position'       , [0 0 1 1], ...
    'BackgroundColor', bgColor, ...
    'DockFcn'        , @dockPanel);
h.sPanel = uiextras.VBox( ...
    'Parent'         , h.sBox, ...
    'Units'          , 'normalized', ...
    'Position'       , [0 0 1 1], ...
    'Padding'        , sPanelPad/2, ...
    'Spacing'        , sPanelPad, ...
    'BackgroundColor', bgColor);
h.axPanel = uipanel( ...
    'Parent'         , h.split, ...
    'Units'          , 'normalized', ...
    'Position'       , [0 0 1 1], ...
    'BackgroundColor', bgColor);
h.axSplit = uiextras.VBox( ...
    'Parent'         , h.axPanel, ...
    'Units'          , 'normalized', ...
    'Position'       , [0 0 1 1], ...
    'BackgroundColor', bgColor, ...
    'Padding'        , axPadding, ...
    'Spacing'        , axSpacing);
h.fAx = axes( ...
    'Parent'         , double(h.axSplit), ...
    'FontName'       , font, ...
    'FontSize'       , fSize, ...
    'Units'          , 'normalized', ...
    'Position'       , [0 0 1 1], ...
    'NextPlot'       , 'replacechildren', ...
    'XLim'           , oPar{1,2}, ...
    'xAxisLocation'  , 'top');
if O == 1
    h.lAx = axes( ...
        'Parent'          , double(h.axSplit), ...
        'Units'           , 'normalized', ...
        'Position'        , [0 0 1 1], ...
        'NextPlot'        , 'replacechildren', ...
        'Visible'         , 'off', ...
        'XLim'            , oPar{1,2}, ...
        'YLim'            , [-1 1]);
    h.pAx = axes( ...
        'Parent'         , double(h.axSplit), ...
        'FontName'       , font, ...
        'FontSize'       , fSize, ...
        'Units'          , 'normalized', ...
        'Position'       , [0 0 1 1], ...
        'NextPlot'       , 'replacechildren', ...
        'XLim'           , oPar{1,2});
    h.sAx = axes( ...
        'Parent'         , h.axPanel, ...
        'Units'          , 'Normalized', ...
        'Position'       , [0 0 1 1], ...
        'XLim'           , [0 1], ...
        'YLim'           , [0 1], ...
        'Visible'        , 'off', ...
        'NextPlot'       , 'replacechildren');
    h.axSplit.Sizes = [-1 lAxHeight -1];
    linkaxes([h.fAx h.lAx h.pAx], 'x');
    h.axLink = linkprop([h.fAx h.lAx h.pAx h.sAx], {'NextPlot'});
elseif strcmpi(typ, 'pot2')
        h.pAx = axes( ...
        'Parent'         , double(h.axSplit), ...
        'FontName'       , font, ...
        'FontSize'       , fSize, ...
        'Units'          , 'normalized', ...
        'Position'       , [0 0 1 1], ...
        'NextPlot'       , 'replacechildren', ...
        'XLim'           , oPar{1,2});
    h.axSplit.Sizes = [-1 -1];
end
if O == 2
    set(h.fAx, ...
        'YLim'           , oPar{2,2}, ...
        'ButtonDownFcn'  , @flowClickFcn);
end
h.split.Sizes = [sldrWidth + 2*sldrPad -1];

% Create sliders
if C > 0
    h.cSlider = nan(C, 1);
    h.cEdit   = h.cSlider;
    h.cPanel  = h.cSlider;
    h.cLabel  = h.cSlider;
    panelOpt.Units = 'pixels';
    sliderOpt.Callback      = @update;
    sliderOpt.Units         = 'pixels';
    sliderOpt.Position      = [sldrPad 3*sldrPad/4 sldrWidth sldrHeight];
    sliderOpt.SliderStep    = sliderStep;
    sliderOpt.Enable        = 'off';
    sliderOpt.Interruptible = 'off';
    sliderOpt.BusyAction    = 'cancel';
    editOpt.FontSize = fSizeLabel;
    editOpt.FontName = font;
    editOpt.Enable   = 'off';
    % Each control parameter gets a sliderPanel
    for i = 1:C
        sliderOpt.min    = cPar{i,2}(1);
        sliderOpt.max    = cPar{i,2}(2);
        if anyDefs
            sliderOpt.value = defs(i);
        else
            sliderOpt.value  = (cPar{i,2}(2) + cPar{i,2}(1))/2;
        end
        [h.cSlider(i), h.cPanel(i), h.cEdit(i)] = sliderPanel( ...
            h.sPanel, panelOpt, sliderOpt, editOpt, {...
            {'FontSize'   , fSizeLabel, ...
            'FontName'   , font, ...
            'String'     , sprintf('$\\,\\,\\,\\,%s=$', cPar{i,1})} ...
            {'String'     , ''} });
        % We have to get handles for the labels manually
        h.cLabel(i) = findobj(get(h.cPanel(i), 'Children'), 'flat', ...
            'String'     , sprintf('$\\,\\,\\,\\,%s=$', cPar{i,1}) );
    end
    set(h.sBox, ...
        'TitleColor'     , get(h.cPanel(1), 'BackgroundColor'));
    % We also have to find the handle for the dock button in order to get its
    % background to match
    set(findall(allchild(double(h.sBox)), ...
        'Tag'            , 'uiextras:BoxPanel:DockButton'), ...
        'BackgroundColor', get(h.cPanel(1), 'BackgroundColor'));
    set(h.sPanel, ...
        'Sizes'          , ones(size(h.cPanel))*(sldrHeight+sldrPad));
    for i = 1:C
        h.cLabel(i) = uibutton(h.cLabel(i), ...
            'Style'      , 'text', ...
            'Interpreter', 'latex');
    end
    
    % try to convert paramter labels from latex to html
    biStrings = cPar(:,1);
    if latexFlag
        biStrings = cellfun(@(x) sprintf('<html>%s</html>', ...
            regexprep(x, '\', '&')), biStrings, ...
            'UniformOutput', false);
    end
end

% 2D flow legend and slider
if O == 2
    sliderOpt.Callback    = [];
    sliderOpt.Enable      = 'on';
    sliderOpt.min         = tspan(1);
    sliderOpt.max         = tspan(2);
    sliderOpt.value       = tspan(3);
    sliderOpt.SliderStep  = tspanSliderStep;
    [h.tSlider, h.tPanel, h.tEdit] = sliderPanel( ...
        h.sPanel, panelOpt, sliderOpt, editOpt, {...
        {'FontSize'      , fSizeLabel, ...
        'FontName'       , font, ...
        'String'         , tspanStr} ...
        {'String'        , ''} });
    h.legAx = axes('Parent', double(h.sPanel), ...
        'Visible'        , 'off', ...
        'NextPlot'       , 'add');
    set(h.sPanel, ...
        'Sizes'          , [ones(size(h.cPanel));1;3].*(sldrHeight+sldrPad));
    h.legPlots(1) = plot(h.legAx, 0, 0, stableStyle, ...
        'MarkerSize'     , fixedPtSize, ...
        'MarkerFaceColor', stableFill);
    h.legPlots(2) = plot(h.legAx, 0, 0, unstableStyle, ...
        'MarkerSize'     , fixedPtSize, ...
        'MarkerFaceColor', unstableFill);
    h.legPlots(3) = plot(h.legAx, 0, 0, saddleStyle, ...
        'MarkerSize'     , fixedPtSize);
    h.legPlots(4) = plot(h.legAx, 0, 0, centerStyle,...
        'MarkerSize'     , fixedPtSize);
    h.legPlots(5) = plot(h.legAx,  [0 0], [1 1], xNullclineStyle, ...
        'LineWidth'      , nullclineWidth);
    h.legPlots(6) = plot(h.legAx,  [0 0], [1 1], yNullclineStyle, ...
        'LineWidth'      , nullclineWidth);
    xlim(h.legAx, [2 3]);
    ylim(h.legAx, [2 3]);
    h.flowLeg = legend(h.legPlots, 'Stable', 'Unstable', 'Saddle', 'Center', ...
        sprintf('$%s=0$ nullcline', oPar{1,1}), ...
        sprintf('$%s=0$ nullcline', oPar{2,1}));
    % Replace with latex strings
    if latexFlag
        set(findobj(get(h.flowLeg, 'Children'), ...
            'Type'           , 'Text'), ...
            'Interpreter'    , 'latex', ...
            'FontSize'       , fSize);
        % Don't know why, needs to be done twice
        set(findobj(get(h.flowLeg, 'Children'), ...
            'Type'           , 'Text'), ...
            'Interpreter'    , 'latex', ...
            'FontSize'       , fSize);
    end
end

% Menu
h.menu.top = uimenu(h.f, ...
    'Enable'         , 'off', ...
    'Label'          , 'sysViewer');
h.menu.bi = uimenu(h.menu.top, ...
    'Label'          , 'Generate Bifurcation Diagram...', ...
    'Callback'       , @bifurcation, ...
    'Interruptible'  , 'off', ...
    'BusyAction'     , 'cancel');
if O > 1 || C == 0
    set(h.menu.bi, ...
        'Enable'     , 'off');
end
hasPar = ~isempty(ver('distcomp'));
if hasPar
    strEn = 'on';
    parOn = logical(matlabpool('size'));
    if parOn, strChk = 'on'; else strChk = 'off'; end
else
    strEn  = 'off';
    strChk = 'off';
    parOn = false;
end
turnedParOn = false;
h.menu.par = uimenu(h.menu.top, ...
    'Label'          , 'Use Parallel Computing', ...
    'Checked'        , strChk, ...
    'Enable'         , strEn, ...
    'Callback'       , @parMenu);

% Construct anonymous parametrize function (freeze), so that going forward
% the flow and potential cases will be unified
% Freeze builds flow and potential chebfuns from a vector of control
% parameter values. Usage:
%   [flow pot] = freeze(params); 
freeze = @(c) parametrize(fcn, [oPar{:,2}], c, typ, varargin);

% Initialize and make figure visible
update(h.f, [], true);
set(h.f, ...
    'ResizeFcn'      , {@update true}, ...
    'Visible'        , 'on');

    function update(~, ~, annotate)
        % Updates plot
        
        % Sometimes update gets called while closing figure...
        if ~ishandle(h.f) || strcmpi(get(h.f, 'BeingDeleted'), 'on')
            return
        end
        
        % Block user input
        if C > 0
            set([h.cSlider; h.cEdit; h.menu.top], ...
                'Enable'         , 'off');
        end
        set(h.f, ...
            'Pointer'        , waitPtr);

        % Get slider values and construct string for the title
        if C > 0
            c = nan(1, C);
            cParStr = [];
            for j = 1:C
                c(j) = get(h.cSlider(j), 'Value');
                if j>1, cParStr = [cParStr ', ']; end %#ok<AGROW>
                cParStr = sprintf('%s$%s=%0.3g$', cParStr, cPar{j,1}, c(j));
            end
        else
            c = [];
        end
        
        % Freeze control parameter values
        [flow, pot] = freeze(c);
        
        if O == 1
            % 1D systems
           
            % Compute fixed points
            flowSlope = diff(flow);
            fixedPts  = roots(flow);
            lambda    = flowSlope(fixedPts);
            
            % Clear axes. Set axes to manual to prevent figure from jumping
            set([h.fAx h.pAx], ...
                'YLimMode'       , 'manual');
            toDelete = allchild([h.fAx h.pAx h.lAx h.sAx]);
            toDelete = vertcat(toDelete{:});
            if exist('annotate', 'var') && annotate
                notToDelete = [];
            else
                notToDelete = [h.fxLbl h.fyLbl h.pxLbl h.pyLbl h.zero];
            end
            delete(setdiff(toDelete, notToDelete));
            
            % Draw functions
            if exist('annotate', 'var') && annotate
                h.zero = plot(h.fAx, oPar{1,2}, [0 0], 'k:', ...
                    'LineWidth'  , zLineWidth);
            end
            set(h.fAx, ...
                'NextPlot'       , 'add');
            h.flow = plot(h.fAx, flow, 'k', ...
                'LineWidth'      , pLineWidth);
            h.pot  = plot(h.pAx, pot, 'k', ...
                'LineWidth'      , pLineWidth);
            
            % Mark fixed points
            h.fRepellers = plot(h.fAx, fixedPts(lambda>0), ...
                zeros(size(fixedPts(lambda>0))), 'o', ...
                'MarkerSize'     , fixedPtSize, ...
                'LineWidth'      , fixedPtWidth, ...
                'Color'          , fixedPtColor, ...
                'MarkerFaceColor', 'w');
            h.pRepellers = plot(h.pAx, fixedPts(lambda>0), ...
                pot(fixedPts(lambda>0)), 'o', ...
                'MarkerSize'     , fixedPtSize, ...
                'LineWidth'      , fixedPtWidth, ...
                'Color'          , fixedPtColor, ...
                'MarkerFaceColor', 'w');
            h.fAttractors = plot(h.fAx, fixedPts(lambda<0), ...
                zeros(size(fixedPts(lambda<0))), 'o', ...
                'MarkerSize'     , fixedPtSize, ...
                'LineWidth'      , fixedPtWidth, ...
                'Color'          , fixedPtColor, ...
                'MarkerFaceColor', fixedPtColor);
            h.pAttractors = plot(h.pAx, fixedPts(lambda<0), ...
                pot(fixedPts(lambda<0)), 'o', ...
                'MarkerSize'     , fixedPtSize, ...
                'LineWidth'      , fixedPtWidth, ...
                'Color'          , fixedPtColor, ...
                'MarkerFaceColor', fixedPtColor);
            h.fHalfStable = plot(h.fAx, fixedPts(lambda==0), ...
                zeros(size(fixedPts(lambda==0))), halfStableLineSpec, ...
                'MarkerSize'     , fixedPtSize, ...
                'LineWidth'      , fixedPtWidth, ...
                'Color'          , fixedPtColor);
            h.pHalfStable = plot(h.pAx, fixedPts(lambda==0), ...
                pot(fixedPts(lambda==0)), halfStableLineSpec, ...
                'MarkerSize'     , fixedPtSize, ...
                'LineWidth'      , fixedPtWidth, ...
                'Color'          , fixedPtColor);
            
            % Info we'll need to draw stems later
            set(h.fAx, ...
                'Units'   , 'normalized', ...
                'YLimMode', 'auto');
            set(h.pAx, ...
                'Units'   , 'normalized', ...
                'YLimMode', 'auto');
            set(h.lAx, ...
                'Units'   , 'normalized');
            fPos = get(h.fAx, 'Position');
            pPos = get(h.pAx, 'Position');
            lPos = get(h.lAx, 'Position');
            fYlim = ylim(h.fAx);
            pYlim = ylim(h.pAx);
            lXlim = xlim(h.lAx);
            
            % Labels will go in lAx
            set(gcf, ...
                'CurrentAxes'    , h.sAx);
            j = 0;
            h.lblTxt  = nan(size(fixedPts));
            h.lblStem = nan(size(fixedPts));
            while numel(fixedPts) > j
                j = j+1;
                
                % Draw stem
                xLblPos = lPos(1) + ...
                    lPos(3)*(fixedPts(j)-lXlim(1))/diff(lXlim);
                yLblPos = [fPos(2) - fPos(4)*fYlim(1)/diff(fYlim) ...
                    pPos(2)+pPos(4)*(pot(fixedPts(j))...
                    - pYlim(1))/diff(pYlim)];
                h.lblStem(j) = plot(h.sAx, [xLblPos xLblPos], ...
                    yLblPos, ':', ...
                    'Color'    , fixedPtColor, ...
                    'LineWidth', lblLineWidth);
                
                % Write text
                h.lblTxt(j) = text(xLblPos, lPos(2) + lPos(4)/2, ...
                    {sprintf('$%s^*\\approx %0.3g$', ...
                    oPar{1,1}, fixedPts(j)) ...
                    sprintf('$\\lambda\\approx %0.3g$', lambda(j))}, ...
                    'Interpreter'        , 'latex', ...
                    'FontName'           , font, ...
                    'FontSize'           , fSizeFixPt, ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment'  , 'middle', ...
                    'EdgeColor'          , fixedPtColor, ...
                    'LineWidth'          , lblLineWidth, ...
                    'Units'              , 'data', ...
                    'BackgroundColor'    , fixedPtBgColor, ...
                    'Margin'             , lblMargin);
                
                % Move text
                set(h.lblTxt(j), ...
                    'Units'              , 'pixels');
                pos = get(h.lblTxt(j), 'Extent');
                set(h.lblTxt(j), ...
                    'HorizontalAlignment', 'left', ...
                    'Position'           , pos(1:2) + [0 fSizeLabel*4/3]);
                
                % Ensure labels don't overlap
                k = j-1;
                while k>0
                    set(h.lblTxt(k), ...
                        'Units'       , 'pixels');
                    lExt = get(h.lblTxt(k), 'Extent');
                    rExt = get(h.lblTxt(j), 'Extent');
                    if  lExt(1)+lExt(3)+txtPad > rExt(1) ...
                            && lExt(2)+lExt(4)+txtPad > rExt(2) ...
                            && rExt(2)+rExt(4)+txtPad > lExt(2)
                        pos = get(h.lblTxt(j), 'Position');
                        pos(2) = pos(2) + lExt(4) + txtPad;
                        set(h.lblTxt(j), ...
                            'Position', pos);
                        k = j-1;
                    else
                        k = k-1;
                    end
                end
            end

            % Draw flow arrows - in the flow axis
            set(h.f, ...
                'CurrentAxes', h.fAx);
            bounds   = [oPar{1,2}(1) fixedPts' oPar{1,2}(2)];
            midPts   = bounds(1:end-1) + diff(bounds)/2;
            vels     = flow(midPts);
            scale    = maxArrowSize * diff(oPar{1,2}) / max(abs(vels));
            minSize  = minArrowSize * diff(oPar{1,2});
            aspect   = diff(oPar{1,2})/diff(ylim(h.fAx));
            h.arrows = arrayfun(@(x,y) fill([x x x+aspect*y/2], ...
                [-y/2 y/2 0], arrowColor), midPts, ...
                sign(vels).*max(scale*abs(vels), minSize));
            
            % Put fixed points above arrows
            uistack(h.arrows, 'bottom');
            
            % Annotate
            h.title = title (h.fAx, cParStr, ...
                'Interpreter', 'latex');
            if exist('annotate', 'var') && annotate
                h.fxLbl = xlabel(h.fAx, sprintf('$%s$', oPar{1,1}), ...
                    'Interpreter', 'latex', ...
                    'Units'      , 'pixels');
                h.pxLbl = xlabel(h.pAx, sprintf('$%s$', oPar{1,1}), ...
                    'Interpreter', 'latex', ...
                    'Units'      , 'pixels');
                h.fyLbl = ylabel(h.fAx, sprintf('$\\dot{%s}$', oPar{1,1}), ...
                    'Interpreter', 'latex', ...
                    'Rotation'   , 0, ...
                    'Units'      , 'pixels');
                h.pyLbl = ylabel(h.pAx, 'Potential $V$', ...
                    'Interpreter', 'latex', ...
                    'Units'      , 'pixels');
                % Adjust
                fxPos = get(h.fxLbl, 'Position');
                pxPos = get(h.pxLbl, 'Position');
                fyPos = get(h.fyLbl, 'Position');
                pyPos = get(h.pyLbl, 'Position');
                fxPos(2) = fxPos(2) + xAxisNudge;
                pxPos(2) = pxPos(2) - xAxisNudge;
                fyPos(1) = fyPos(1) - yAxisNudge;
                pyPos(1) = pyPos(1) - yAxisNudge;
                set(h.fxLbl, ...
                    'Position'   , fxPos);
                set(h.pxLbl, ...
                    'Position'   , pxPos);
                set(h.fyLbl, ...
                    'Position'   , fyPos);
                set(h.pyLbl, ...
                    'Position'   , pyPos);
            end
            
            % Update biDiagram
            if isfield(h, 'biPars')
                if all(find(c~=h.biPars) == h.biIdx)
                    % parameters are same as bifurcation diagram
                    if isfield(h, 'biParValLine') ...
                    && ishandle(h.biParValLine)
                        set(h.biParValLine, ...
                            'XData', c(h.biIdx)*ones(1,2));
                    end
                else % parameters have changed
                    if isfield(h, 'biParValLine') ...
                    && ishandle(h.biParValLine)
                        delete(h.biParValLine);
                    end
                end
            end
            
        elseif O == 2
            % 2D systems
            
            % Clear axes. Set axes to manual to prevent figure from jumping
            set(h.fAx, ...
                'YLimMode'       , 'manual', ...
                'XLimMode'       , 'manual');
            toDelete = allchild(h.fAx);
            if isfield(h, 'pAx') && ishandle(h.pAx)
                toDelete = [toDelete; allchild(h.pAx)];
            end
            if exist('annotate', 'var') && annotate
                notToDelete = [];
            else
                if isfield(h, 'fxLbl')
                    notToDelete = [h.fxLbl h.fyLbl];
                else
                    notToDelete = [];
                end
            end
            delete(setdiff(toDelete, notToDelete));

            % Draw flow field
            set(h.f, ...
                'CurrentAxes'    , h.fAx);
            h.q = quiver(flow, quiverLineStyle, ...
                'LineWidth'      , quiverLineWidth, ...
                'MarkerSize'     , quiverMarkerSize, ...
                'MarkerFaceColor', quiverColor);
            set(h.fAx, ...
                'NextPlot'       , 'add');
            
            % Draw nullclines
            flow_x = flow.xcheb;
            flow_y = flow.ycheb;
            xNull = roots(flow_x);
            yNull = roots(flow_y);
            if ~isempty(xNull)
                h.xNull = plot(xNull, xNullclineStyle, ...
                    'LineWidth' , nullclineWidth);
            end
            if ~isempty(yNull)
                h.yNull = plot(yNull, yNullclineStyle, ...
                    'LineWidth' , nullclineWidth);
            end
            
            % Draw roots
            fixPts = roots(flow);
            if ~isempty(fixPts)
                determinant = jacobian(flow);
                trace = diffx(flow_x) + diffy(flow_y);
                for j = 1:size(fixPts, 1)
                    if determinant(fixPts(j,1),fixPts(j,2)) <= 0
                        plot(fixPts(j,1),fixPts(j,2), saddleStyle, ...
                            'MarkerSize'     , fixedPtSize);
                    elseif trace(fixPts(j,1),fixPts(j,2)) < 0
                        plot(fixPts(j,1),fixPts(j,2), stableStyle, ...
                            'MarkerSize'     , fixedPtSize, ...
                            'MarkerFaceColor', stableFill);
                    elseif trace(fixPts(j,1),fixPts(j,2)) > 0
                        plot(fixPts(j,1),fixPts(j,2), unstableStyle, ...
                            'MarkerSize'     , fixedPtSize, ...
                            'MarkerFaceColor', unstableFill);
                    else
                        plot(fixPts(j,1),fixPts(j,2), centerStyle, ...
                            'MarkerSize'     , fixedPtSize);
                    end
                end
            end

            % Draw potential
            if ~isempty(pot)
                set(h.f, ...
                    'CurrentAxes', h.pAx);
                set(h.pAx, ...
                    'NextPlot'   , 'add', ...
                    'Box'        , 'on');
                h.potSurf = plot(pot);
                
                % Roots
                if ~isempty(fixPts)
                    for j = 1:size(fixPts, 1)
                        if determinant(fixPts(j,1),fixPts(j,2)) <= 0
                            plot3(fixPts(j,1),fixPts(j,2), ...
                                pot(fixPts(j,1),fixPts(j,2)), saddleStyle, ...
                                'MarkerSize'     , fixedPtSize);
                        elseif trace(fixPts(j,1),fixPts(j,2)) < 0
                            plot3(fixPts(j,1),fixPts(j,2), ...
                                pot(fixPts(j,1),fixPts(j,2)), stableStyle, ...
                                'MarkerSize'     , fixedPtSize, ...
                                'MarkerFaceColor', stableFill);
                        elseif trace(fixPts(j,1),fixPts(j,2)) > 0
                            plot3(fixPts(j,1),fixPts(j,2), ...
                                pot(fixPts(j,1),fixPts(j,2)), unstableStyle, ...
                                'MarkerSize'     , fixedPtSize, ...
                                'MarkerFaceColor', unstableFill);
                        else
                            plot3(fixPts(j,1),fixPts(j,2), ...
                                pot(fixPts(j,1),fixPts(j,2)), centerStyle, ...
                                'MarkerSize'     , fixedPtSize);
                        end
                    end
                end
                view(3);
                rotate3d on
                set(h.pAx, ...
                    'NextPlot', 'replacechildren');
            end
            
            % Annotate
%             if ~exist('cParStr', 'var'), cParStr = ''; end
%             h.title = title (h.fAx, cParStr, ...
%                 'Interpreter', 'latex');
%             if exist('annotate', 'var') && annotate
%                 h.fxLbl = xlabel(h.fAx, sprintf('$%s$', oPar{1,1}), ...
%                     'Interpreter', 'latex', ...
%                     'Units'      , 'pixels');
%                 h.fyLbl = ylabel(h.fAx, sprintf('$%s$', oPar{2,1}), ...
%                     'Interpreter', 'latex', ...
%                     'Rotation'   , 0, ...
%                     'Units'      , 'pixels');
%                 % Adjust
%                 fxPos = get(h.fxLbl, 'Position');
%                 fyPos = get(h.fyLbl, 'Position');
%                 fxPos(2) = fxPos(2) + xAxisNudge;
%                 fyPos(2) = fyPos(2) - yAxisNudge;
%                 set(h.fxLbl, ...
%                     'Position'   , fxPos);
%                 set(h.fyLbl, ...
%                     'Position'   , fyPos);
%                 if isfield(h, 'pAx') && ishandle(h.pAx)
%                     h.pxLbl = xlabel(h.pAx, sprintf('$%s$', oPar{1,1}), ...
%                         'Interpreter', 'latex', ...
%                         'Units'      , 'pixels');
%                     h.pyLbl = ylabel(h.pAx, sprintf('$%s$', oPar{2,1}), ...
%                         'Interpreter', 'latex', ...
%                         'Units'      , 'pixels');
%                     h.pzLbl = zlabel(h.pAx, 'Potential $V$', ...
%                         'Interpreter', 'latex', ...
%                         'Units'      , 'pixels');
%                 end
%             end

            % Inform user about plotting solutions
            if warnSim
                choice = questdlg(['Click the flow field to plot ' ...
                    'solutions (a bit buggy).'], 'Plotting Solutions', ...
                    'OK', 'Don''t show this message', 'OK');
                warnSim = ~strcmp(choice, 'Don''t show this message');
            end
            
        end
            
        % Reset axes
        set(h.fAx, ...
            'NextPlot'   , 'replacechildren');
        
        % Unblock user input
        if C > 0
            set([h.cSlider; h.cEdit; h.menu.top], ...
                'Enable'        , 'on');
        end
        set(h.f, ...
            'Pointer'       , normPtr);
        
        % Update appdata
        setappdata(h.f, 'Handles', h);
    end

    function dockPanel(obj, ~, fromCloseRequest)
        % Executes when dock button is presed on a panel
        
        % Fix obj reference if this callback is called via figure close
        if exist('fromCloseRequest', 'var') && fromCloseRequest
            obj = findobj(allchild(obj), ...
                'Tag', 'uiextras:BoxPanel');
            if numel(obj) ~= 1, return; end
        else
            % If callback is called from dock button, we need its parent,
            % the panel
            obj = get(obj, 'Parent');
        end
        
        % Figure out what object to dock
        if isfield(h, 'sBox') && isvalid(h.sBox) && obj == double(h.sBox)
            obj = h.sBox;
        elseif isfield(h, 'bPanel') && isvalid(h.bPanel) ...
            && obj == double(h.bPanel)
            obj = h.bPanel;
        else
            return
        end
        
        % Set the flag
        obj.IsDocked = ~obj.IsDocked;
        
        if obj.IsDocked
            % Return to figure
            newFig = ancestor(obj, 'Figure');
            set(obj, ...
                'Parent'         , h.leftSplit);
            delete(newFig)
            update;
        else
            % Remove from figure
            panelPos = getpixelposition(obj);
            newFig = figure( ...
                'Name'           , get(obj, 'Title'), ...
                'Units'          , 'pixels', ...
                'CloseRequestFcn', {@dockPanel true}, ...
                'DockControls'   , 'off');
            figPos = get(newFig, 'OuterPosition');
            set(newFig, ...
                'OuterPosition'  , [max(figPos(1)-panelPos(3), 0) ...
                                    max(figPos(2)-panelPos(4), 0) ...
                                    panelPos(3:4)]);
            set(obj, ...
                'Parent'         , newFig, ...
                'Units'          , 'normalized', ...
                'Position'       , [0 0 1 1]);
            update;
            figure(newFig);
        end
        
        % Fix panel 
        if numel(h.leftSplit.Children) == 1
            h.leftSplit.Sizes = -1;
        elseif numel(h.leftSplit.Children) == 2
            h.leftSpit.Children = [h.sBox h.bPanel];
            h.leftSplit.Sizes = [numel(h.cPanel)*...
                (sldrHeight+sldrPad+sPanelPad)+titleBarHeight -1];
        end
    end

    function flowClickFcn(~, ~)
        % Plot a trajectory
        
        % Get slider values and construct string for the title
        if C > 0
            c = nan(1, C);
            for j = 1:C, c(j) = get(h.cSlider(j), 'Value'); end
        else
            c = [];
        end
        
        % Freeze control parameter values
        flow = freeze(c);
        
        % Solve
        startPos = get(h.fAx, 'CurrentPoint');
        if numel(startPos) ~= 2
            startPos = startPos(1,1:2);
        end
        [~, sol] = ode45(flow, [0 get(h.tSlider, 'Value')], startPos);
        
        % Plot
        set(h.fAx, 'NextPlot', 'add');
        plot(startPos(1), startPos(2), solStartStyle, ...
            'MarkerSize'     , solMarkerSize, ...
            'MarkerFaceColor', solColor);
        plot(sol, solLineStyle, ...
            'LineWidth'      , solLineWidth);
        set(h.fAx, 'NextPlot', 'replacechildren');
        
    end

    function closeFcn(~, ~)
        % Runs when main figure is closed

        % Close undocked figures
        if isfield(h, 'sBox') && isvalid(h.sBox) ...
                              && ~strcmpi(h.sBox.BeingDeleted, 'on')
            delete(ancestor(h.sBox, 'figure'));
        end
        
        % Close main figure
        if ishandle(h.f), delete(h.f); end
        
        % Parallel may have been turned on independently
        if hasPar
            parOn = logical(matlabpool('size'));
            if parOn && turnedParOn, matlabpool('close'); end
        end
    end

    function bifurcation(~, ~)
        % Updates/generates bifurcation plot
        
        % Dialog box to choose parameter to vary
        if C==1
            cParIdx = 1;
        else
            [cParIdx, ok] = listdlg( ...
                'ListString'   , biStrings, ...
                'SelectionMode', 'single', ...
                'Name'         , 'Generate Bifurcation Diagram', ...
                'PromptString' , {'Select a control parameter to vary.' ...
                                 ['Other parameters will be held at ' ...
                                  'their current values.']});
            if ~ok, return; end
        end
        
        % Block user input
        warnstate = warning('off', 'all');
        set(h.f, ...
            'Pointer', waitPtr);
        set([h.cSlider; h.cEdit; h.menu.top], ...
            'Enable' , 'off');
        
        % Create panel if it doesn't exist
        if ~isfield(h, 'bPanel') || ~isvalid(h.bPanel)
            h.bPanel = uiextras.BoxPanel( ...
                'Parent'         , h.leftSplit, ...
                'Title'          , 'Bifurcation Diagram', ...
                'FontName'       , font, ...
                'FontSize'       , fSize, ...
                'Units'          , 'normalized', ...
                'Position'       , [0 0 1 1], ...
                'BackgroundColor', bgColor, ...
                'DockFcn'        , @dockPanel ,...
                'TitleColor'     , get(h.sBox, 'TitleColor'));
            set(findall(allchild(double(h.bPanel)), ...
                'Tag'            , 'uiextras:BoxPanel:DockButton'), ...
                'BackgroundColor', get(h.sBox, 'TitleColor'));
            h.leftSplit.Sizes = [numel(h.cPanel)*...
                (sldrHeight+sldrPad+sPanelPad)+titleBarHeight -1];
        end
        
        % Create axes if it doesn't exist
        if ~isfield(h, 'bAx') || ~ishandle(h.bAx)
            h.bAx = axes( ...
                'Parent'         , double(h.bPanel), ...
                'FontName'       , font, ...
                'FontSize'       , fSize, ...
                'Units'          , 'normalized', ...
                'OuterPosition'  , [0 0 1 1], ...
                'NextPlot'       , 'add', ...
                'XLim'           , cPar{cParIdx,2}, ...
                'YLim'           , oPar{1,2});
        else
            set(h.bAx, ...
                'XLim'           , cPar{cParIdx,2});
            toDelete = [h.bxLbl; h.byLbl; h.bTitle; allchild(h.bAx)];
            delete(toDelete(ishandle(toDelete)));
        end
        
        % Get slider values
        c = nan(1, C);
        cParStr = [];
        for j = 1:C
            c(j) = get(h.cSlider(j), 'Value');
            if j~=cParIdx
                if (j>1 && cParIdx>1) || j>2
                    cParStr = [cParStr ', ']; %#ok<AGROW>
                end
                cParStr = sprintf('%s$%s=%0.3g$', cParStr, ...
                    cPar{j,1}, c(j));
            end
        end
        
        % Annotate
        h.bxLbl = xlabel(h.bAx, ['$' cPar{cParIdx,1} '$'], ...
            'Interpreter', 'latex', ...
            'Units'      , 'pixels');
        h.byLbl = ylabel(h.bAx, ['$' oPar{1,1} '$'], ...
            'Interpreter', 'latex', ...
            'Units'      , 'pixels', ...
            'Rotation'   , 0);
        h.bTitle = title(h.bAx, cParStr, ...
            'Interpreter', 'latex');
        xLblPos = get(h.bxLbl, 'Position');
        yLblPos = get(h.byLbl, 'Position');
        set(h.bxLbl, ...
            'Position'   , xLblPos - [0 xAxisNudge 0]);
        set(h.byLbl, ...
            'Position'   , yLblPos - [yAxisNudge 0 0]);
        
        % Determine topology of fixed points (sign of lambda) at each value
        % of control parameter, and where it changes (breakPts)
        topo     = cell(biRes, 1);
        fixedPts = cell(biRes, 1);
        cVals = linspace(cPar{cParIdx,2}(1), cPar{cParIdx,2}(2), biRes);
        breakPts   = false(biRes, 1);
        if parOn
            h.dlg = double(...
                msgbox('Scanning system...', '', 'modal'));
            ch = get(h.dlg, 'Children');
            delete(ch(2));
            txt = get(ch(1), 'Children');
            set(txt, ...
                'FontName'           , font, ...
                'FontSize'           , fSize, ...
                'BackgroundColor'    , bgColor, ...
                'VerticalAlignment'  , 'middle');
            set([ch(1) h.dlg], ...
                'Color'          , bgColor);
            set(h.dlg, ...
                'Pointer'        , waitPtr, ...
                'Resize'         , 'off');
            drawnow;
            try
                parfor m = 1:biRes
                    d = c;
                    d(cParIdx) = cVals(m);
                    [flow, ~] = freeze(d);
                    slope = diff(flow);
                    fixedPts{m} = roots(flow);
                    topo{m} = sign(slope(fixedPts{m}));
                end
                for m = 2:biRes
                    if any(topo{m} == 0)
                        breakPts(m)   = true;
                    elseif m > 1 && (numel(topo{m}) ~= numel(topo{m-1}) ...
                            ||  any(topo{m}    ~= topo{m-1}))
                        breakPts(m) = true;
                    end
                end
            catch err
                if ishandle(h.dlg), delete(h.dlg); end
                rethrow(err);
            end
            if ishandle(h.dlg), delete(h.dlg); end
        else
            wait = waitbar(0, 'Scanning system...', ...
                'CreateCancelBtn', 'delete(gcbo)');
            for m = 1:biRes
                if ~ishandle(wait)
                    delete(h.bAx);
                    return
                end
                c(cParIdx) = cVals(m);
                [flow, ~] = freeze(c);
                slope = diff(flow);
                fixedPts{m} = roots(flow);
                topo{m} = sign(slope(fixedPts{m}));
                if m > 1 && any(topo{m} == 0)
                    breakPts(m)   = true;
                elseif m > 1 && (numel(topo{m}) ~= numel(topo{m-1}) ...
                             ||  any(topo{m}    ~= topo{m-1}))
                    breakPts(m) = true;
                end
                waitbar(m/biRes, wait);
            end
            if ishandle(wait), delete(wait); end
        end
        
        % Concatenate roots
        breakPts = unique([1; find(breakPts); biRes]);
        B = numel(breakPts) - 1; 
        attRoots = cell(B, 1);
        repRoots = cell(B, 1);
        domains  = cell(B, 1);
        for k = 1:B
            if breakPts(k)+2 > breakPts(k+1)-1, continue; end
            domains{k} = cVals(breakPts(k)+1:breakPts(k+1)-1);
            allFixedPts = [fixedPts{breakPts(k)+1:breakPts(k+1)-1}];
            attRoots{k} = allFixedPts(topo{breakPts(k)+1}==-1,:);
            repRoots{k} = allFixedPts(topo{breakPts(k)+1}==1,:);
        end

        % Plot!
        h.biAtts = cell(B, 1);
        h.biReps = cell(B, 1);
        for k = 1:B
            if ~isempty(attRoots{k})
                h.biAtts{k} = plot(h.bAx, domains{k}, attRoots{k}, '-', ...
                    'Color'    , biDiagramColor, ...
                    'LineWidth', biDiagramWidth);
            end
            if ~isempty(repRoots{k})
                h.biReps{k} = plot(h.bAx, domains{k}, repRoots{k}, ...
                    biDiagramRepStyle, ...
                    'Color'    , biDiagramColor, ...
                    'LineWidth', biDiagramWidth);
            end
        end
        
        % Add line for current value of control parameter
        h.biParValLine = plot(h.bAx, ...
            get(h.cSlider(cParIdx), 'Value')*ones(1,2), oPar{1,2}, ...
            biDiagramCurValStyle, ...
            'LineWidth', biDiagramCurValWidth);
        h.biPars = c;
        h.biIdx  = cParIdx;
        
        % Allow user input
        set(h.f, ...
            'Pointer', normPtr);
        set([h.cSlider; h.cEdit; h.menu.top], ...
            'Enable' , 'on');
        
        % Update appdata
        setappdata(h.f, 'Handles', h);
        warning(warnstate);
    end

    function parMenu(~, ~)
        % Executes when "Use Parallel Procesing" is selected
        
        % Switch state
        switch get(h.menu.par, 'Checked')
            case 'on'
                turningOn = false;
                set(h.menu.par, ...
                    'Checked', 'off');
            case 'off'
                turningOn = true;
                set(h.menu.par, ...
                    'Checked', 'on');
        end
        
        % Parallel may have been turned on independently
        parOn = logical(matlabpool('size'));
        
        % Turn on or off
        if parOn && ~turningOn
            matlabpool('close');
            parOn = false;
        elseif ~parOn && turningOn
            matlabpool('open');
            parOn = true;
            turnedParOn = true;
        end
        
    end
end

function [flow_cheb, pot_cheb] = parametrize( ...
    fcn, range, params, typ, varargs)
% Converts function handle to chebfun pair, freezing control parameter
% values.

if strncmpi(typ, 'flow', numel(typ))
    flow_cheb = chebfun(@(x) fcn(x, params), range, varargs{:});
    % potential = - integral(flow)
    pot_cheb  = -cumsum(flow_cheb);
elseif strncmpi(typ, 'potential', numel(typ))
    pot_cheb  = chebfun(@(x) fcn(x, params), range, varargs{:});
    % flow = -differential(potential)
    flow_cheb = -diff(pot_cheb);
elseif strcmpi(typ, 'flow2')
    flow_cheb = chebfun2v(@(x,y) fcn{1}(x, y, params), ...
        @(x,y) fcn{2}(x, y, params), range);
    % no potential
    pot_cheb  = [];
elseif strcmpi(typ, 'pot2')
    pot_cheb  = chebfun2(@(x,y) fcn(x, y, params), range);
    % flow = -gradient (potential)
    flow_cheb = -gradient(pot_cheb);
end

end

function AddedPath = requireFEXpackage(FEXSubmissionID)
%Function requireFEXpackage - 
%installs Matlab Central File Exchange (FEX) submission 
%with given ID into the directory chosen by the user.
%A new FEX submissions may use previous FEX submissions as its part.
%The function 'requireFEXpackage' helps in adding those previous
%submissions to the user's MATLAB installation. 
%
% SYNTAX: 
%    AddedPath = requireFEXpackage(FEXSubmissionID)
%
% INPUT: 
%    ID of the required submission to File Exchange 
%
% OUTPUT: 
%    the path to that submission added to the user's MATLAB path.
%
% HOW TO CALL:
%    The command 
%           P = requireFEXpackage(8277)
%    will download and install the package with ID 8277 
%    (namely, nice 'fminsearchbnd' by John D'Errico)
%
% EXAMPLES -- HOW TO USE:
%
% EXAMPLE 1 (using 'exist' command):
%
%     % first, somewhere in the very beginning of your code,
%     % check if the function 'fminsearchbnd' from the FEX package 8277 
%     % is on your MATLAB path, and if it is not there, 
%     % require the FEX package 8277:
%     if ~(exist('fminsearchbnd', 'file') == 2)
%         P = requireFEXpackage(8277);  % fminsearchbnd is part of 8277
%     end
% 
%     % Then just use 'fminsearchbnd' where you need it:
%     syms x
%     RosenbrockBananaFunction = @(x) (1-x(1)).^2 + 100*(x(2)-x(1).^2).^2;
%     x = fminsearchbnd(RosenbrockBananaFunction,[3 3])
%
% EXAMPLE 2 (using 'try-catch' command):
%
%     syms x
%     RosenbrockBananaFunction = @(x) (1-x(1)).^2+100*(x(2)-x(1).^2).^2;
%     try 
%        % if function 'fminsearchbnd' already exists in your MATLAB
%        % installation, just use it:
%        x = fminsearchbnd(RosenbrockBananaFunction,[3 3])
%     catch 
%        % if function 'fminsearchbnd' is not present in your MATLAB
%        % installation, first get the package 8277 (to which it belongs) 
%        % from the MATLAB Central File Exchange (FEX)
%        P = requireFEXpackage(8277);  % fminsearchbnd is part of 8277
%        % and then use that function:
%        x = fminsearchbnd(RosenbrockBananaFunction,[3 3])
%     end
% 
%
% NOTE: on Mac platform, the title of the dialog box for 
% choosing the directory for installing the required FEX package 
% is not shown; this is not a bug, this is how UIGETDIR works on Macs --  
% see the documentation for UIGETDIR
% http://www.mathworks.com/help/techdoc/ref/uigetdir.html
%
% (C) Igor Podlubny, 2011

ID = num2str(FEXSubmissionID);

% Ask user for the confirmation of the installation
% of the required FEX package
yes = ['YES, Install package ' ID];
no = 'NO, do not install';
userchoice = questdlg(['The Matlab function/toolbox, which you are running, ' ... 
    'requires the presence of the package ' ID ... 
    ' from Matlab Central File Exchange.' ...
    'Would you like to install the FEX package ' ID ' now?'] , ...
	['Required package ' ID], ...
	yes, no, yes);

% Handle response
switch userchoice
    case yes,
        install = 1;			
    case no,
        install = 0;
    otherwise,
        install = 0;
end

if install == 1
    baseURL = 'http://www.mathworks.com/matlabcentral/fileexchange/';
    query = '?download=true';

    location = uigetdir(pwd, ['Select the directory for installing the required FEX package' ID ]);
    if location ~= 0
        % download package 'ID' from Matlab Central File Exchange
        filetosave = [location filesep ID '.zip'];
        FEXpackage = [baseURL ID query];
        [~, status] = urlwrite(FEXpackage,filetosave);
        if status==0 
            warndlg(['No connection to Matlab Central File Exchange,' ' or package ' ID ' does not exist.' ... 
                ' Package ' ID ' has not been installed. ' ...
                ' Check you internet settings and the ID of the required package, and try again. '] , ...
                ['No connection to Matlab Central File Exchange' ' or package ' ID ' does not exist'], ...
                'modal');
            AddedPath = '';            
            return
        end
        % unzip the downloaded file to the subdirectory 'ID'
        todir = [location filesep ID];
        % if the directory 'ID' doesn't exist at given location, create it
        if ~(exist([location filesep ID], 'dir') == 7)
            mkdir(location, ID);
        end
        try 
            unzip(filetosave, todir);
            % after unzipping, delete the downloaded ZIP file
            delete(filetosave);
            % prepend the paths to the downloaded package to the MATLAB path
            P = genpath([location filesep ID]);
            path(P,path);
        catch %#ok<CTCH>
            % if the FEX package is not ZIP, then it is a single m-file
            % just move the file to the ID directory
            [~, name, ~] = fileparts(filetosave);
            movefile(filetosave, [todir filesep name '.m']);
            P = genpath([location filesep ID]);
            path(P,path);
        end
    else
        P = '';
    end

    AddedPath = P; 
else
    AddedPath = '';
end


if install == 1,
    % Ask user about reviewing and saving the modified MATLAB path, 
    % and take him to PATHTOOL, if the user wants to save the modified path
    yes = 'YES, I want to review and save the MATLAB path';
    no = 'NO, I don''t want to save the path permanently';
    userchoice = questdlg(['After adding the package ' ID ... 
        ' from Matlab Central File Exchange to your MATLAB installation,' ...
        ' the MATLAB path has been modified accordingly. ', ...
        'Would you like to review and save the modified MATLAB path?'] , ...
        'Review and save the modified MATLAB path for future use?', ...
        yes, no, yes);

    % Handle response
    switch userchoice
        case yes,
            pathtool;			
        case no,
        otherwise,
    end
end
end