%% Bonus Examples
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

%% Bonus 1: Please
% If it doesn't work, try saying "please".

please = @(f) feval(curly({fprintf('Since you asked nicely...\n'), f}, 2));

% Example:
please(@why)

%% Bonus 2: Anonymous Do-While
% In the examples, we didn't show how to create a do-while loop
% anonymously. Here it is.

dowhile = @(x0, cont, fcn, cleanup) recur(... % Make the recursion.
    @(f, x) use(fcn(x), @(z) ...              %   Run the fcn, save as z.
                iif(cont(z), @() f(f, z), ... %   Continue?
                    true,    cleanup(z))),... % Stop, clean up.
    x0);                                      % Initial state

% Create a function to draw sets of numbers until it draws n positive
% numbers in a row.
draw_until_all_positive = @(n) dowhile([], ...               % No x0
                                       @(x) any(x < 0), ...  % Until all >0
                                       @(~) randn(1, n), ... %   Draw set
                                       @(x) x);              % Return set
                          
fprintf('Draw numbers until we get 5 positive numbers in a row.\n');
draw_until_all_positive(5)

%% Bonus 3: A Large Program
% This is probably not the world's best example of good programming
% practices, but it does serve to illustrate that entire programs *can* be
% built with anonymous functions (whether or not they *should* be built
% this way or whether this is the best way to do it are very different 
% questions).
% 
% This example uses most of the techniques developed in the 
% functional_programming_examples (though it uses the .m versions instead 
% of the anonymous versions), including |forloop|, |iif|, |last|, |use|, 
% |recur|, |tern|, and |void|. Creating this example also served to prompt 
% me to make functions that simplify programming this way.

% Set up the figure.
figure(1);
clf();
set(1, 'Color', 'k');
axis([-20 20 0 25], 'off');
set(gca(), 'Position', [0 0 1 1]);
hold('on');

% Create some constants.
nf = 6;       % Number of fireworks
np = 100;     % Number of particles per firework
n  = nf * np; % Total number of particles
dt = 1/24;    % Time step

% Create some fireworks.
create_fireworks = @() forloop([], nf, @(p,~) ...
    use(2*randn, rand, @(x, y) ...
    [p repmat([2*x, -5*y, 5*x, 20*y+30]', 1, np)]));

% Plot the fireworks.
random_color = @() 1./(1+exp(-20*(rand(1, 3)-0.4))); % It's a sigmoid fcn.
create_plot = @(x0) forloop([], nf, @(h,~) ...
    [h plot(x0(1,:), x0(2,:), '.', 'Color', random_color())]);
limit = @(x) min(max(x, 0), 1);
update_plot = @(x, h, k) forloop([], nf, @(~,z) ...
    void(@() set(h(z), 'XData', x(1, np*(z-1)+1:np*z), ...
                       'YData', x(2, np*(z-1)+1:np*z), ...
                       'Color', limit(1.03-1e-3*k) * get(h(z),'Color'))));

% Propagate the fireworks' particles. At k == 25, make them explode.
explode  = @(x) x + [zeros(2, n); 5*randn(2, n)];
Phi      = expm(dt*[0 0 1 0; 0 0 0 1; 0 0 -1 0; 0 0 0 -1]);
g        = repmat([0 -dt*9.81 0 -0.5*9.81*dt^2]', 1, n);
update_x = @(k, x) Phi * tern(k==25, @() explode(x), @() x) + g;

% Functions to change callback and show text.
set_callback = @(cb) void(@() set(gcf, 'WindowButtonDownFcn', cb));
show_text    = @() text(0, 1, 'Click for fireworks.', ...
                        'HorizontalAlignment', 'center', ...
                        'Color', 'w');

% Create the anonymous program.
fireworks = @() recur(@(self) {...                 % To reference itself.
    set_callback([]), ...                          % Clear the callback.
    void(@() delete(findobj('Type', 'text'))), ... % Delete the text.
    use(create_fireworks(), @(x0) ...              % Create positions, x0.
    use(create_plot(x0),    @(h) ...               % Plot, keep handle, h.
    {forloop(x0, 100, @(x,k) ...                   % Loop from k=1:100.
             last(update_plot(x,h,k), ...          %   Update plot.
                  void(@() pause(dt)), ...         %   Wait.
                  {update_x(k,x)})), ...           %   Update state.
	 void(@() delete(h))} ...                      % Delete fireworks.
    )), ...                                        % (End of x0, h scope.)
	show_text(), ...                               % Create text again.
    set_callback(@(~, ~) self(self))});            % Restore callback.

% Execute the anonymous program, which will also attach 'fireworks' to the
% button click callback.
fireworks();
