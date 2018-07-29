function volvisGUI(x,y,z,v)
% volvisGUI Interactive volume visualization.
%
%   Example:
%   [x,y,z,v] = flow;
%   volvisGUI(x,y,z,v)

%   Copyright 2007 The MathWorks, Inc.

%% Initalize visualization
figure;
s = volumeVisualization(x,y,z,v);
s.addSlicePlane(s.xMin);

%% Add uicontrol
hSlider = uicontrol(...
    'Units','normalized', ...
    'Position',[.75 .05 .2 .05], ...
    'Style','slider', ...
    'Min',s.xMin, ...
    'Max',s.xMax, ...
    'Value',s.xMin, ...
    'Callback',@updateSliderPosition);

%%
    function updateSliderPosition(varargin)
        s.deleteLastSlicePlane();
        x = get(hSlider,'Value');
        s.addSlicePlane(x);
    end

end

