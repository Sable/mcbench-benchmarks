function sliderHandle = superSlider(varargin)

% SUPERSLIDER creates a more flexible slider, that allows for
% multiple slides, in place of the uicontrol('Style', 'Slider')
%
%   Developed to imitate a consistant, system independent version 
%   of matlab's slider object, with the added capability of creating
%   multiple slides along a single body.
%
%   NOTE: This program was executed using functions rather than the more
%   intuitive use of classes, due to known slow matlab object oriented
%   processing time/ high system overhead. This means that there are few
%   applicable getters and setters, so properties should be handled upon
%   initiation of the function.
%   
%   FORMAT: superSlider(handle, 'Property', Value)
%           Calling superSlider alone creates a basic slider with default
%           settings
%
%   PROPERTIES: 
%   > handle: figure that the slider is placed in, otherwise it defaults to 
%     gcf (use superSlider(figure) to generate a new window + slider)
%   > position: [left bottom width height], uses normalized units
%   > value: an array of length numSliders, containing the starting
%   position of each slide.
%   > tagName: Reference name of the slider object (return val alternative)
%   > min: starting value of the slider
%   > max: ending value of the slider
%   > stepSize: how much space between each arrow/slider click
%   > numSlides: the number of slides to create 
%   > discrete: true/false - whether the slide is limitted to certain steps
%   > controlColor: color of the selectable controls [r g b] 
%   > backgroundColor: color of the body of the slider [r g b]
%   > callback: a function that gets executed when the slider is used. It
%   is included in single quotations: superSlider('callback',
%   'functionName(Variables)');
%
%   DATA RETRIEVAL:
%   The return value of the function sliderHandle, is the parent to all the 
%   slides and contains the values of each one in an array.
%   The value of the slides and the active slide can be found respectively 
%   in the rows of the matrix stored in userData, accessed as follows:
%   > infoMatrix = get(sliderHandle, 'UserData')     which returns: 
%                       [loc1, loc2, ...]            absolute location
%                       [ 0/1   0/1  ...]            a 1 indicates active
%   To get the handles to the slides (in ascending order):
%   > allSlides = get(sliderHandle, 'Children'); (empty if there was no
%   room for a visible slide in the given slider area)
%
%   Use of this code is encouraged for any interested party, but please 
%   keep my name or cite me!
%   Created by: Danielle Ripsman 
%               August 27, 2013
%               danielle.ripsman@mail.utoronto.ca
    
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*- 

props = []; % Object to contain the slider preferences
parts = []; %Object to contain slider features

% Sort out the handle/parent situation
if nargin > 0 
    if ishandle(varargin{1})
        props.parent = varargin{1};
    else 
        props.parent = gcf;
    end
end

% Match up inputs to their respective variable names
for ii = 1:nargin - 1 
    if ischar(varargin{ii})
        switch lower(varargin{ii}) % Keeping things case insensitive
            case 'position'
                props.position = varargin{ii+1};
            case 'value'
                props.value = varargin{ii+1};
            case 'tagname'
                props.tagName = varargin{ii+1};
            case 'min'
                props.min = varargin{ii+1};
            case 'max'
                props.max = varargin{ii+1};
            case 'stepsize'
                props.stepSize = varargin{ii+1};
            case 'numslides'
                props.numSlides = varargin{ii+1};
            case 'discrete'
                props.discrete = varargin{ii+1};
            case 'controlcolor'
                props.controlColor = varargin{ii+1};
            case 'backgroundcolor'
                props.backgroundColor = varargin{ii+1};
            case 'callback'
                props.callback = varargin{ii+1};
        end
        ii = ii + 1;
    end
end

% Check + complete inputs
props = getDefaults(props); 

%Find the size of the figure, in terms of pixels
[parts.pixWidth, parts.pixHeight] = getPixSize(props.parent); 

% Determine the location and alignment of the slider components
[props, parts] = sliderLayout(props, parts);

% Body component
propsBod = makeBodySpecs(props, parts);
[sliderHandle, props.largeEnough] = makeSliderComponent(propsBod, false);
clear('propsBod'); 

% Arrow components
[propsDec, propsInc] = makeArrowSpecs(sliderHandle, props, parts);
decreaseHandle = makeSliderComponent(propsDec, true); % Left arrow button 
increaseHandle = makeSliderComponent(propsInc, true);% Right arrow button
clear('propsDec'); clear('propsInc');

% Tagname for the uicontrol, acting as the slider handle
if isfield(props, 'tagName'); set(sliderHandle, 'tag', props.tagName); end

% Make sure the whole slider is deleted when the handle's deleted
set(sliderHandle, 'deleteFcn', {@grabArrows, decreaseHandle, increaseHandle});

% Determining a permissible number of slides
if ~isfield(props, 'numSlides') || ~props.largeEnough || props.numSlides < 1
    props.numSlides = 1; 
end
props.numSlides = floor(props.numSlides); % In case a non-integer gets by

% Creating all requested/granted slides dynamically
sliderHandle = makeSlides(sliderHandle, props);

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function props = getDefaults(props)
if ~isfield(props, 'parent')
    props.parent = gcf;
end
if ~isfield(props, 'position')
    props.position = [.1 .1 .2 .04]; 
end
if ~isfield(props, 'controlColor')
    props.controlColor = [.85 .85 .85];
end
if ~isfield(props, 'backgroundColor')
    props.backgroundColor = [1 1 1]; 
end
if ~isfield(props, 'value'); 
    props.value = []; 
else
    props.value = sort(props.value);
end
if ~isfield(props, 'min')
    props.min = 0; 
end
if ~isfield(props, 'max') || props.max <= props.min
    props.max = props.min + 1; 
end
if ~isfield(props, 'stepSize') || props.stepSize <= 0
    props.stepSize = props.max - props.min; 
end
if ~isfield(props, 'discrete')
    props.discrete = false; 
end
if ~isfield(props, 'callback')
    props.callback = ''; 
end

% Keep the arrows visible, by matching light to dark text/background
if sum(props.controlColor) < 1.5
    props.textColor = [1 1 1]; 
else
    props.textColor = [0 0 0]; 
end

% Other auto illustration details
props.borderwidth = 1; %how many pixels wide to make the borders
props.shadow = [.1 .1 .1];
props.highlight = [.65 .65 .65];
props.secondHighlight = [.4 .4 .4];

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function [pixWidth, pixHeight] = getPixSize(fig)
% Pixel size, since some built-in features are measured in pixels 
preserveUnits = get(fig, 'units'); 
set(fig, 'units', 'pixels');
figSize = get(fig, 'position');
pixWidth = figSize(3);
pixHeight = figSize(4);
set(fig, 'units', preserveUnits); %return object to initial units
    
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function [props, parts] = sliderLayout(props, parts)
position = props.position;

% Configuration details of the slider, based on the input position
if position(3) >= position(4)      
    % Make a HORIZONTAL slider:
    parts.dSymbol = '<';
    parts.iSymbol = '>';  
    props.hzn = true;
    constDir = 4; % Height of the component = the slider height
    constPix = parts.pixWidth;
    varDir = 3; % Width is adjustable
    varPix = parts.pixHeight;
else
    % Make a VERTICAL slider:
    parts.dSymbol = 'v';
    parts.iSymbol = '^';
    props.hzn = false;
    constDir = 3; % Width of the component = the slider width
    constPix = parts.pixHeight;
    varDir = 4; % Height is adjustable
    varPix = parts.pixWidth;   
end

% Try to create square buttons
if 2*position(constDir)*varPix < position(varDir)*constPix  
    size = position(constDir)*varPix/constPix;
else
    size = position(varDir)/2;
end    

% Allocate the remaining area properly between the components
posDecreaseArrow = position;
posDecreaseArrow(varDir) = size;
posBody = position;
posBody(varDir-2) = posBody(varDir-2) + size - props.borderwidth/constPix;
posBody(varDir) = posBody(varDir) - 2*size + 2*props.borderwidth/constPix;
posIncreaseArrow = position;
posIncreaseArrow(varDir-2) = posIncreaseArrow(varDir-2)+posIncreaseArrow(varDir)-size;
posIncreaseArrow(varDir) = size;

% Asign to structure for easier passing
parts.posDArrow = posDecreaseArrow;
parts.posBody = posBody;
parts.posIArrow = posIncreaseArrow;

props.constDir = constDir;
props.varDir = varDir;

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function [propsBod] = makeBodySpecs(props, parts)
propsBod = props; 
propsBod.position = parts.posBody; 
propsBod.sym = '';
propsBod.bcolor = props.backgroundColor; 
propsBod.color = props.backgroundColor;
propsBod.shadowcolor = props.highlight;
propsBod.callback = '';

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function [propsDec, propsInc] = makeArrowSpecs(sliderHandle, props, parts)
% For the decrease arrow:
propsDec = props; 
propsDec.position = parts.posDArrow; 
propsDec.sym = parts.dSymbol;
propsDec.bcolor = props.secondHighlight; 
propsDec.color = props.controlColor;
propsDec.shadowcolor = props.shadow;
propsDec.callback = {@arrowCallback, sliderHandle, props, -1};

% For the increase arrow:
propsInc = props; 
propsInc.position = parts.posIArrow; 
propsInc.sym = parts.iSymbol;
propsInc.bcolor = props.secondHighlight; 
propsInc.color = props.controlColor;
propsInc.shadowcolor = props.shadow;
propsInc.callback = {@arrowCallback, sliderHandle, props, 1};


% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function [panel, largeEnough] = makeSliderComponent(props, uiOverlay)       
% If the middle of the slide is unused, it shouldn't cause errors.
largeEnough = false; 
width = props.borderwidth;

% Panel background for better visual
panel = uipanel('parent', props.parent,...
            'Units','normalized',...
            'backgroundColor', props.bcolor,...
            'bordertype', 'beveledout',...
            'shadowcolor', props.shadowcolor,...
            'highlightcolor', props.highlight,...
            'borderWidth', width,...
            'Position',props.position,...
            'Visible', 'on');

[pixWidth, pixHeight] = getPixSize(panel); 

% Set inner region, so the button region doesn't interfere with the frame
innerPos = [0+width/pixWidth, 0+width/pixHeight,...
            1-2*width/pixWidth, 1-2*width/pixHeight];

        
if innerPos(3) > 0 && innerPos(4)>0
   largeEnough = true;
   if uiOverlay 
   % Clickable+text component of the button
   uicontrol('Parent', panel,...
             'Units','normalized',...
             'Style','text',...
             'Enable', 'inactive',...
             'FontUnits', 'Normalized',...
             'FontName', 'Webdings',...
             'FontSize', .6,...
             'HorizontalAlignment', 'center',...
             'Position', innerPos,...
             'ForegroundColor', props.textColor,...
             'background', props.color,...
             'String', props.sym,...
             'FontWeight', 'bold',...
             'Hittest', 'on',...
             'buttonDownFcn', props.callback); 
   end
end

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function grabArrows(hObject, eventData, ar1, ar2)
% Ensures the entire slider is erased as a single object
if ishandle(ar1)
    delete(ar1);
end
if ishandle(ar2)
    delete(ar2);
end
    
% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
    
function sliderHandle = makeSlides(sliderHandle, props)
%if there's enough room for slides
if props.largeEnough 
    propsSlide = makeSlideSpecs(sliderHandle, props);
    propsSlide.position = zeros(1, 4);
    numStepsAbs = (props.max - props.min)/props.stepSize + 1;
    numSlots = numStepsAbs + props.numSlides - 1;
    size = 1/numSlots;
    
    varPos = props.varDir - 2; %width/height component of position array (3/4)
    propsSlide.position(props.varDir) = size;
    propsSlide.position(props.constDir) = 1;
    
    sliderRef = zeros(2, props.numSlides); 
    % sliderRef stores slide info - [loc1, loc2, ...]
    %                               [ 0/1   0/1  ...]
    
    for ii = 1:props.numSlides
        if isempty(props.value) 
            % Fit all sliders on in a row, if unspecified
            propsSlide.position(varPos) = (ii - 1)/numSlots;
        else 
            dist = (props.value(ii) - props.min)*size/props.stepSize;
            propsSlide.position(varPos) = dist + (ii - 1)*size;
        end
        slideHandle = makeSliderComponent(propsSlide, true);
        loc = get(slideHandle, 'position');
        sliderRef(1, ii) = (loc(varPos) - size*(ii - 1))/size*props.stepSize + props.min;
    end
    
    % Reference the children in ascending order:
    slideRef = get(sliderHandle, 'Children'); 
    set(sliderHandle, 'Children', fliplr(slideRef')');
    set(sliderHandle, 'userData', sliderRef);
    
    slideSelect(get(slideRef(props.numSlides), 'Children'), sliderHandle, props);
    
    clear('propsSlide');
else 
    if isempty(props.value); props.value = props.min; end
    set(sliderHandle, 'userData', [props.value; 1]);
end

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function [propsSlide] = makeSlideSpecs(sliderHandle, props)
propsSlide = props; 
propsSlide.parent = sliderHandle;
propsSlide.sym = '';
propsSlide.bcolor = props.secondHighlight; 
propsSlide.color = props.controlColor;
propsSlide.shadowcolor = props.shadow;
propsSlide.callback = {@slideDrag, sliderHandle, props};

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function arrowCallback(hObject, eventData, sliderHandle, props, direction)
set(hObject, 'backgroundcolor', props.textColor);

if props.largeEnough
    slides = get(sliderHandle, 'Children');
    activityMatrix = get(sliderHandle, 'userData');
    activeSlide = slides(activityMatrix(2,:)>0);
    index = find(activityMatrix(2,:));
    
    location = get(activeSlide, 'Position');

    size = location(props.varDir);
    varPos = props.varDir - 2;

    location(varPos) = location(varPos) + direction*size;

    % Keep the slide in bounds
    location = inBounds(location, varPos, index, size, slides);

    set(activeSlide, 'Position', location);
    sliderRef = get(sliderHandle, 'userData');
    sliderRef(1, index) = (location(varPos) - size*(index - 1))/size*props.stepSize + props.min;
    set(sliderHandle, 'userData', sliderRef);
else
    location = get(sliderHandle, 'userData');
    varPos = 1;
    location(varPos) = location(varPos) + direction*props.stepSize;
    postSlide = props.max;
    preSlide = props.min;
    if location(varPos) < preSlide; location(varPos) = preSlide; end
    if location(varPos) > postSlide; location(varPos) = postSlide; end
    set(sliderHandle, 'userData', location);
end

try % Optional user callback function
   eval(props.callback);
end

pause(.02); %pause for button color effect
set(hObject, 'backgroundcolor', props.controlColor);

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function location = inBounds(location, varPos, index, size, slides)
% makes sure the slide doesn't exceed its bounds, or surrounding slides
if index == 1
    preSlide = 0; 
else
    presliderPos = get(slides(index - 1), 'Position');
    preSlide = presliderPos(varPos) + size;
end

if index == length(slides)
    postSlide = 1 - size;
else
    postsliderPos = get(slides(index + 1), 'Position');
    postSlide = postsliderPos(varPos) - size;
end

% Keep slider in bounds
if location(varPos) < preSlide; location(varPos) = preSlide; end
if location(varPos) > postSlide; location(varPos) = postSlide; end

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function slideDrag(hObject, eventData, sliderHandle, props)
% Tracks where the slide was selected, for consistent dragging
oldUnits = get(gcf, 'units');
set(gcf, 'units', 'pixels');
grabpoint = get(gcf,'CurrentPoint');
set(get(hObject, 'parent'), 'userData', grabpoint);
set(gcf, 'units', oldUnits);

% Handles the slide highlighting/selection update
slideSelect(hObject, sliderHandle, props);

% Uses the figure callback mechanisms to control the interactive slide placement
oldMotionFunction = get(gcf, 'WindowButtonMotionFcn');
set(gcf, 'WindowButtonMotionFcn', {@motionUpdate, sliderHandle, get(hObject, 'parent'), props});
set(gcf, 'WindowButtonUpFcn', {@stopDragging, oldMotionFunction, oldUnits});

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function slideSelect(slideHandle, sliderHandle, props)
set(slideHandle, 'backgroundcolor', props.controlColor);
allSlides = get(get(get(slideHandle, 'parent'), 'parent'), 'Children');
sliderRef = zeros(1, length(allSlides));
for ii = 1:length(allSlides) %Goes through all slides, order: largest to smallest
    if get(allSlides(ii), 'Children') ~= slideHandle
        set(get(allSlides(ii), 'Children'), 'backgroundcolor', props.textColor);
    else
        sliderRef(ii) = 1;
    end
    sliderInfo = get(sliderHandle, 'userData');
    sliderInfo(2,:) = sliderRef;
    set(sliderHandle, 'userData', sliderInfo);
end

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function motionUpdate(hObject, eventData, sliderHandle, slideHandle, props)
[pixWidth, pixHeight] = getPixSize(sliderHandle);
oldUnits = get(gcf, 'units');
set(gcf, 'units', 'pixels');
newPoint = get(gcf, 'currentPoint');
position = get(slideHandle, 'position');
grabPoint = get(slideHandle, 'userData');

size = position(props.varDir);
varPos = props.varDir - 2;
if props.hzn; convertPix = pixWidth; else convertPix = pixHeight; end

step = (newPoint(varPos) - grabPoint(varPos))/convertPix;
original = position(varPos);

if ~props.discrete %if intermediate points are allowed:
    position(varPos) = position(varPos) + step;
else
    round(step/size);
    position(varPos) = position(varPos) + round(step/size)*size;
end
    
sliderRef = get(sliderHandle, 'userData');
index = find(sliderRef(2,:));
slides = get(sliderHandle, 'Children');

position = inBounds(position, varPos, index, size, slides);

shift = (position(varPos) - original)*convertPix;
newPoint(varPos) = grabPoint(varPos) + shift;

newPosAbs = (position(varPos) - size*(index - 1))/size*props.stepSize;
sliderRef(1, index) = newPosAbs + props.min;

set(sliderHandle, 'userData', sliderRef);
set(slideHandle, 'position', position);
set(slideHandle, 'userData', newPoint);

set(gcf, 'units', oldUnits);

try % Optional user callback function
    eval(callback);
end

% -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

function stopDragging(hObject, eventData, oldMotionFunction, oldUnits)
set(gcf, 'WindowButtonMotionFcn', oldMotionFunction, 'units', oldUnits);


