function varargout = use(varargin)

% varargout = use(varargin)
% 
% Very simple function allowing one to "name" a variable without actually
% assigning it in any workspace. This is only expected to be useful in
% anonymous functions.
%
% use( results, @(the_name) ...
%      do something with the_name );
% 
% use(randi(10), ...
%     @(x) {fprintf('We took one random draw and got %d,\n',   x), ...
%           fprintf('But we used %d three times\n',            x), ...
%           fprintf('Without ever saving %d to a variable.\n', x)});
%
% The |use| function can accept multiple inputs too, which all become
% inputs to the function, which is expected to be the final argument.
% 
% firework = @() use(figure(), ...              % Create a new figure.
%                    axes(), ...                % Create some axes.
%                    plot(randn(1, 100), randn(1, 100), 'r.'), ... % Plot.
%                    @(h_figure, h_axes, ~) ... % Refer to figure and axes.
%                        {void(@() set(h_figure, 'Color', 'k')), ...
%                         void(@() set(h_axes, 'Position', [0 0 1 1], ...
%                                               'Visible', 'off'))});
%
% firework();
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    [varargout{1:nargout}] = varargin{end}(varargin{1:end-1});
    
end

