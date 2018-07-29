% DYNAMICPLOT
%   obj = dynamicplot(genFcn, T)
%    creates a figure that is automatically updated (by calling a 
%    generator function genFcn) every T seconds. genFcn does not take 
%    any arguments, and returns a vector of values to be plotted.
%    obj is a handle to the created object.
%
% Example:
%    d = dynamicplot(@() randn(1,100), 0.5);
%    methods(d)  % shows all the methods
%    help dynamicplot/delete % shows help on an individual method
%
% -------------------------------------------------------------------
%
% The DYNAMICPLOT class demonstrates how to get reference (aka. handle)
% semantics using MATLAB classes. Typically when one modifies a MATLAB 
% object, it needs be returned to the caller:
%       obj = set(obj, 'myParameter', 10.0);
% But with handle semantics, you can simply do this:
%      set(obj, 'myParameter', 10.0);
% This is especially useful with objects that need to be updated 
% autonomously (e.g., acquiring data from a data aquisition device 
% or an instrument).
%
% The handle semantics were accomplished as follows. (1) the constructor 
% defines the instance variables and (2) returns a set of function handles 
% to access these instance variables. Other methods (e.g., set(obj, ...); 
% get(obj, ...)), use the function handles to access and modify the data. 
% This technique also enforces data-hiding with the object. 
% 
% Detailed example of handle semantics:
%
%   d = dynamicplot(@() randn(1,100), 0.5);
%   struct(d)
%   ans = 
%          getLineHandle: @dynamicplot/getLineHandle
%        setUpdatePeriod: @dynamicplot/setUpdatePeriod
%        getUpdatePeriod: @dynamicplot/getUpdatePeriod
%      getMostRecentData: @dynamicplot/getMostRecentData
%         getTimerObject: @dynamicplot/getTimerObject
%     getNumAcquisitions: @dynamicplot/getNumAcquisitions
%        getFigureHandle: @dynamicplot/getFigureHandle
%          checkValidity: @dynamicplot/checkValidity
%            setValidity: @dynamicplot/setValidity
%
%
%   getdata(d) % issue this command several times
%   setUpdatePeriod(d, 0.2)
%   getNumUpdates(d) % issue this several times
%   setLineStyle(d,'color','r');
%
%   % Object assignment respects the handle semantics 
%   d2 = d;  % both d and d2 refer to the same objects
%   pauseDisplay(d);
%   resumeDisplay(d2);
% 
%   % Validity checks can be built into the object itself
%   delete(d); 
%   getdata(d) % will generate an error
%   getdata(d2) % this generates error also
%
%   % It is possible to have multiple objects without any clashes     
%   d1 = dynamicplot(@() randn(1,100), 0.1);
%   d2 = dynamicplot(@() rand(1,100), 0.1);
%   pauseDisplay(d1);
%   getNumUpdates(d1) % issue these a few times
%   getNumUpdates(d2) 
%   resumeDisplay(d1);
%   delete(d1);
%
% 
%  Gautam Vallabha, Oct-30-2007, Gautam.Vallabha@mathworks.com

%  Revision 1.0, Oct-30-2007
%    - File created

function s = dynamicplot(genFcn, period)

% class variables
isValid = true;

hFigure = figure('name', 'Dynamic Plot');
hAxes = axes('position', [0.13 0.11 0.775 0.815]);
hLine = plot(0,0, 'parent', hAxes);

generatorFcn = genFcn;
mostRecentData = [];
numberOfAcquisitions = 0;
updatePeriod = period;

timerObj = timer('period', updatePeriod, ...
                 'executionMode', 'fixedRate', ...
                 'timerFcn', @timerCallback);
start(timerObj);

% The class struct contains only function handles

s.getLineHandle = @getLineHandle;
s.setUpdatePeriod = @setUpdatePeriod;
s.getUpdatePeriod = @getUpdatePeriod;
s.getMostRecentData = @getMostRecentData;
s.getTimerObject = @getTimerObject;
s.getNumAcquisitions = @getNumAcquisitions;
s.getFigureHandle = @getFigureHandle;
s.checkValidity = @checkValidity;
s.setValidity = @setValidity;

s = class(s, 'dynamicplot');

%% -------------------
% These are essentially private get/set methods

    function out = checkValidity()
        out = isValid;
        if ~isValid
            error('Invalid DYNAMICPLOT object');
        end
    end

    function setValidity(newState)
        isValid = logical(newState);
    end

    function out = getFigureHandle()
       out = hFigure;
    end
       
    function out = getNumAcquisitions()
        out = numberOfAcquisitions;
    end

    function out = getTimerObject()
        out = timerObj;
    end

    function out = getLineHandle()
        out = hLine;
    end

    function setUpdatePeriod(newPeriod)
        updatePeriod = newPeriod;
    end

    function out = getUpdatePeriod()
        out = updatePeriod;
    end

    function out = getMostRecentData()
        out = mostRecentData;
    end

%% ------------------- 
    function timerCallback(hobj, eventinfo) %#ok<INUSD>
        mostRecentData = generatorFcn();
        if ~ishandle(hLine)
           % someone deleted the figure, create a new one
           hFigure = figure('name', 'Dynamic Plot');
           hAxes = axes('position', [0.13 0.11 0.775 0.815]);
           hLine = plot(0,0, 'parent', hAxes);
        end
        
        set(hLine, 'xdata', 1:length(mostRecentData), 'ydata', mostRecentData);
        drawnow;
        numberOfAcquisitions = numberOfAcquisitions + 1;
    end
end

