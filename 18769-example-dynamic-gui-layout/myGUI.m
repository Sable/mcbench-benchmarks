function myGUI

% myGUI
%
%   This example demonstrates how you can build a GUI with dynamic
%   positioning of UI components (no distortions).
%
%   It is a simple GUI with an axis, slider, and a push button. The slider
%   changes the coefficient in the equation:
%
%       y = sin(C*x) + cos((10-C)*x)
%
%   And it plots the equation. The push button resets the coefficient to 4.
%
%   The figure has a ResizeFcn defined so that every time the figure is
%   resized, it re-positions the components. It keeps the size of the push
%   button the same, and the slider and the axis fill the rest of the
%   screen.
%
%   Try:
%     Resizing the figure window, and notice the size of the UI components.

%   Copyright 2008 The MathWorks, Inc

% Initialize coefficient
coef = 4;

% Build GUI
figH = figure(                ...
  'Units'     , 'Pixels'    , ...
  'ResizeFcn' , @myResizeFcn);
axesH = axes(                 ...
  'Units'     , 'Pixels'    );

sliderH = uicontrol(          ...
  'Style'     , 'Slider'    , ...
  'Units'     , 'Pixels'    , ...
  'Min'       , 0           , ...
  'Max'       , 10          , ...
  'Value'     , coef        , ...
  'Callback'  , @mySliderFcn);
buttonH = uicontrol(          ...
  'Style'     , 'Pushbutton', ...
  'Units'     , 'Pixels'    , ...
  'String'    , 'Reset'     , ...
  'Callback'  , @myButtonFcn);

% Plot
x = 0:.01:10;
plotEquation();

  function myResizeFcn(varargin)
    % Figure resize callback
    %   Adjust object positions so that they maintain appropriate
    %   proportions
    
    fP = get(figH, 'Position');
    
    set(sliderH, 'Position', [10       , 10, fP(3)-130, 25       ]);
    set(buttonH, 'Position', [fP(3)-110, 10, 100      , 25       ]);
    set(axesH  , 'Position', [50       , 85, fP(3)-100, fP(4)-130]);
    
  end

  function mySliderFcn(varargin)
    % Slider callback
    %   Modifies the coefficient
    
    coef = get(varargin{1}, 'Value');
    plotEquation();
    
  end

  function myButtonFcn(varargin)
    % Button callback
    %   Resets the coefficient to "4"
    
    coef = 4;
    set(sliderH, 'Value', coef);
    plotEquation();

  end

  function plotEquation()
    % Plot equation with given coefficient
    
    y = sin(coef*x) + cos((10-coef)*x);
    plot(axesH, x, y);
    title(sprintf('sin(%0.2gx)+cos(%0.2gx)', coef, 10-coef));
    
  end


end