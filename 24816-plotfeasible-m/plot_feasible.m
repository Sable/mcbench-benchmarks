function [sorted_vertices, ...
          h_fes, h_bnd, h_fill, h_vert, h_int, h_max, g_labels] = ...
    plot_feasible(A, b, c, lower_b, upper_b, varargin)
% Plot the feasible region of a linear program
%
% file:      	plot_feasible.m, (c) Matthew Roughan, 2009
% created: 	Mon Jun 22 2009 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% Plot the feasible region of the 2D linear program
%           maximize            f = c'*x
%           subject to       A x <= b
% on the region bounded by lower_b and upper_b. Note that the inputs
%     A  is a mx2 matrix, where there are m constraints
%     b  is a mx1 column vector, where there are m constraints
%     c  is a 2x1 column vector
%     lower_b, upper_b are 2x1 column vectors
%
% If the problem includes non-negativity bounds, i.e., 
%               x >= 0 
% which is quite common, then these need to be explicitly included into
% the constraints:  A x <= b, not implicitly through the bounds, which are mainly there to
% allow us to make a nice plot.
%
% The feasible region is filled with lines at a setable angle and separation, much as fill
% would do with a solid colour, though options allow you to fill with a color, or both.
%
% This code is primarily (for me) useful for teaching about linear programming, and only
% works for 2D problems (for the obvious reason that problems with more than two variables
% are hard to plot).
%
% Note that if you want to cross-hatch just call this routine twice, with a change in angle
% of 90 degrees.
% 
% There are a bunch of optional inputs in pairs, as for the plot command
%    'linecolor'         color of feasible region boundary lines (default black)
%    'backgroundcolor'   background color of feasible region (default no background)
%    'linewidth'         width of lines (default 1)
%    'linestyle'         style of the boundary lines
%    'filllinestyle'     style of the fill lines
%    'linesep'           separation of cross-hatch lines (default 1)
%                        if this is set to -1, don't put any fill lines in
%    'lineangle'         angle (in degrees) of cross-hatch lines
%                           the default is to put them along lines of equal values of the
%                           objective function
%    'hold'              hold_n=1 means keep previous plot
%                        hold_n=0 (default) means clear previous figure
%                        use this to plot multiple feasible regions on same plot, or to do
%                        crosshatching.
%
%    'plot_vertices'     if defined indicates that we should plot the vertices of the feasible region
%                        the value will determine the symbol to use to plot the vertices,
%                        e.g., 'rx', or 'o+'
%    'label_vertices'    if not 0, then label the vertices with their position (label_vertices=1)
%                        or value (label_vertices=1) or both (label_vertices=3)
%    'label_vertices_size'  size of vertex labels, default = 12
%    'label_vertices_color' size of vertex labels, default = 'k'
%    'label_vertices_prec'  precision of vertex labels (default = 2 decimal places)
%
%    'plot_intersections' if defined indicates that we should plot the intersection points of boundaries
%                        the value will determine the symbol to use to plot the vertices,
%                        e.g., 'rx', or 'o+'
%                        Note that vertices are also intersection points, and will be double
%                        plotted if used with the plot_vertices option
% 
%    'plot_max'          if not 0, then plot the location of the maximum, using the defined symbol
%
%    'extend_boundaries' if defined, plot each of the constraint lines past the feasible region
%                        using the linewidth and color defined above. The style of the line can
%                        be given as the value, e.g., ':'
%
% OUTPUTS:
%     sorted_vertices = a 2x(n+1) vector of the vertices of the feasible region
%                        note the last one is a repeat of the first to aid in plotting the region
%     
%
%     h_fes    = handles to boundary lines of the linear program
%     h_bnd    = handles to the boundary lines
%     h_fill   = handles to the fill lines
%     h_vert   = handles to the vertices (if plotted)
%     h_int    = handles to the intersection points (if plotted)
%     h_max    = a handle to the plotted maximum point 
%     g_labels = handles to vertex labels if used
% 
% version 0.1, July 22nd 2009
%
% TODO
%     speckled fill
%     testing for boundedness and autosizing the figure
%     plotting bounds with cross-hatch on feasible side
%     at present the code uses the optimization toolkit (through the linprog) function
%       which we use to solve the linear program, but as this is a 2D problem we should be able to
%       remove this dependence with a little work.
%     currently the intersections with upper and lower bounds for plotting are also included
%       in intersection set, and plotted
%     automate ability to put text description of the problem in the window
%

% check sizes of inputs
sA = size(A);
sb = size(b);
if (sA(1) ~= sb(1))
  error('incorrect input sizes\n');
end
if (sA(2) ~= 2)
  error('can only plot for 2 variables\n');
end
n = sA(1); % number of constraints
if (size(upper_b,1) ~=2 | size(upper_b,2) ~= 1)
  error('upper_b is the wrong size\n');
end
if (size(lower_b,1) ~=2 | size(lower_b,2) ~= 1)
  error('lower_b is the wrong size\n');
end

% set default output values
h_fes    = [];
h_bnd    = [];
h_fill   = [];
h_vert   = [];
h_int    = [];
h_max    = [];

% parse the variable input arguments
linecolor = 'k'; 
backgroundcolor = 0;
linewidth = 1;
linestyle = '-';
filllinestyle = '-';
linesep = 1;
% default line angle is so that lines will be iso-objective
if (abs(c(1)) < 1.0e-12)
  lineangle = 90; % degrees
else
  lineangle = atand(c(2)/c(1));
end
hold_n = 0;
plot_vertices = 0;
label_vertices = 0;
label_vertices_size = 12;
label_vertices_color = 'k';
label_vertices_prec = 2;
plot_intersections = 0;
extend_boundaries = 0;
plot_max = 0;
if (length(varargin) > 0)
  % process variable arguments
  for k = 1:2:length(varargin)
    if (ischar(varargin{k}))
      argument = char(varargin{k}); 
      value = varargin{k+1};
      switch argument
       case {'linecolor','lc'}
	linecolor = value;
       case {'backgroundcolor','bgc'}
	backgroundcolor = value;
       case {'linewidth','lw'}
	linewidth = value;
       case {'linestyle','ls'}
	 linestyle = value;
       case {'filllinestyle','fls'}
	 filllinestyle = value;
       case {'linesep','ls'}
	linesep = value;
       case {'lineangle','la'}
	lineangle = value;
       case {'hold'}
	hold_n = value;
       case {'plot_vertices', 'pv'}
	plot_vertices = value;
       case {'label_vertices', 'lv'}
	label_vertices = value;
       case {'label_vertices_size', 'lvs'}
	label_vertices_size = value;
       case {'label_vertices_color', 'lvc'}
	label_vertices_color = value;
       case {'label_vertices_prec', 'lvp'}
	label_vertices_prec = value;
       case {'plot_intersections', 'pi'}
	plot_intersections = value;
       case {'extend_boundaries', 'eb'}
	extend_boundaries = value;
       case {'plot_max', 'pm'}
	 plot_max = value;
       otherwise
	error('incorrect input parameters');
      end
    end
  end
end

% set up the plot region
if (hold_n==0)
  hold off
  plot(lower_b(1), lower_b(2));
end
diff_x = (upper_b(1)-lower_b(1))/20; 
diff_y = (upper_b(2)-lower_b(2))/20; 
set(gca, 'xlim', [lower_b(1)-diff_x upper_b(1)+diff_x]);
set(gca, 'ylim', [lower_b(2)-diff_y upper_b(2)+diff_y]);
hold on
epsilon = 1.0e-14;

% plot the boundary line lines of the linear program across the plot region
if ~(extend_boundaries == 0)
  for i=1:n
    % find end-points of the lines along the boundaries
    constraint = A(i,:);
    k = b(i);
    if (abs(constraint(1)) < epsilon)
      % fprintf('(abs(constraint(1) < epsilon): i = %d\n', i);
      if (lower_b(1)<=k/constraint(2) & k/constraint(2)<=upper_b(1))
	x = [lower_b(1) upper_b(1)];
	y = [1 1] * k/constraint(2);
      else 
	x = [];
	y = [];
      end
    elseif (abs(constraint(2)) < epsilon)
      % fprintf('(abs(constraint(2) < epsilon): i = %d\n', i);
      if (lower_b(2)<=k/constraint(1) & k/constraint(1)<=upper_b(2))
	x = [1 1] * k/constraint(1);
	y = [lower_b(2) upper_b(2)];
      else 
	x = [];
	y = [];
      end
    else
      % compute all four intersections, and decide which is feasible
      % horizontal intercept points
      y_1 = [lower_b(2) upper_b(2)];
      x_1 = (k - constraint(2)*y_1) / constraint(1);
      i_1 = find(lower_b(1)<x_1 & x_1<upper_b(1));
      % vertical intercept points
      x_2 = [lower_b(1) upper_b(1)];
      y_2 = (k - constraint(1)*x_2) / constraint(2);
      i_2 = find(lower_b(2)<y_2 & y_2<upper_b(2));
      
      x = [x_1(i_1) x_2(i_2)];
      y = [y_1(i_1) y_2(i_2)];
    end
    % plot the line
    h_fes(i) = plot(x, y, 'color', linecolor, 'linestyle', extend_boundaries);
  end
end

% find the vertices of the lines, plus the borders
Aex = [A; -eye(2); eye(2)];
bex = [b; -lower_b; upper_b];
m = n + 4;
intersections = [];
vertices = [];
for i=1:m-1
  for j=i+1:m
    M = [Aex(i,:); Aex(j,:)];
    bm = bex([i,j]);
    x = M \ bm;
    intersections = [intersections, x];
    % test for feasibility
    if (A*x <= b)
      vertices = [vertices, x];
    end
  end
end

% find and fill the polygon defined by the vertices
k = convhull(vertices(1,:), vertices(2,:));
sorted_vertices(1,:) = vertices(1,k)';
sorted_vertices(2,:) = vertices(2,k)';
if (backgroundcolor == 0)
  h_bnd = plot(sorted_vertices(1,:), sorted_vertices(2,:),  ...
	       'color', linecolor, 'linewidth', linewidth, 'linestyle', linestyle);
else
  h_bnd = fill(sorted_vertices(1,:), sorted_vertices(2,:), backgroundcolor, ...
	       'edgecolor', linecolor, 'linewidth', linewidth, 'linestyle', linestyle);
end

% plot the intersection points and vertices
if ~(plot_intersections == 0)
  h_int = plot(intersections(1,:), intersections(2, :), plot_intersections);
end

if ~(plot_vertices == 0)
  h_vert = plot(sorted_vertices(1,:), sorted_vertices(2, :), plot_vertices);

  if (label_vertices == 1)
    % write the position of the vertex
    format_str = sprintf('(%%.%.0ff,%%.%.0ff)', label_vertices_prec, label_vertices_prec);
    for i=1:size(sorted_vertices, 2)
      temp = 10^label_vertices_prec;
      x = round(temp*sorted_vertices(1,i))/temp;
      y = round(temp*sorted_vertices(2,i))/temp;
      g_labels(i) = text(x+diff_x/2, y, sprintf(format_str, x, y), ...
			 'fontsize', label_vertices_size, 'color', label_vertices_color);
    end
  elseif (label_vertices == 2)
    % write the value of the vertex
    format_str = sprintf('f = %%.%.0ff', label_vertices_prec);
    for i=1:size(sorted_vertices, 2)
      temp = 10^label_vertices_prec;
      x = sorted_vertices(1,i);
      y = sorted_vertices(2,i);
      f = round(temp* (c' * [x; y]))/temp;
      g_labels(i) = text(x+diff_x/2, y, sprintf(format_str, f), ...
			 'fontsize', label_vertices_size, 'color', label_vertices_color);
    end
  elseif (label_vertices == 3)
    % write the position and value
    % write the position of the vertex
    format_str = sprintf('(%%.%.0ff,%%.%.0ff), f=%%.%.0ff', ...
			 label_vertices_prec, label_vertices_prec, label_vertices_prec);
    for i=1:size(sorted_vertices, 2)
      temp = 10^label_vertices_prec;
      x = sorted_vertices(1,i);
      y = sorted_vertices(2,i);
      f = round(temp* (c' * [x; y]))/temp;
      x = round(temp*x)/temp;
      y = round(temp*y)/temp;
      g_labels(i) = text(x+diff_x/2, y, sprintf(format_str, x, y, f), ...
			 'fontsize', label_vertices_size, 'color', label_vertices_color);
    end
  end

end

% plot the max if needed
if ~(plot_max == 0)
  x_max = linprog(-c, A, b, [], [], lower_b, upper_b);
  h_max = plot(x_max(1), x_max(2), plot_max);
end

% do the fill lines
if (linesep > 0)
  %   find min and max via linprog to see start and end points of lines
  %      add in implicit boundary constraints when do it
  c_line = [cosd(lineangle), sind(lineangle)];
  x_min = linprog(c_line, A, b, [], [], lower_b, upper_b);
  % plot(x_min(1), x_min(2), 'b*');
  
  x_max = linprog(-c_line, A, b, [], [], lower_b, upper_b);
  % plot(x_max(1), x_max(2), 'b*');
  
  distance = sqrt( sum((x_max-x_min).^2)  );
  
  %   draw lines clipping them at the boundaries
  for i=0:linesep:distance
    counter = ceil(i/linesep) + 1;
    
    % sigma = x_min + i*(x_max-x_min)/distance;
    sigma = x_min + i*c_line';
    % plot(sigma(1), sigma(2), '+', 'color', linecolor);
    
    % for each line, consider its intersepts with each possible 
    % boundary, and check whether they are feasible
    edge_vertices = [];
    for j=1:m
      M = [Aex(j,:); c_line];
      d = [bex(j); sum(c_line.*sigma')];
      x = M \ d;
      % test for feasibility
      if (A*x <= b)
	edge_vertices = [edge_vertices, x];
      end
    end
    edge_vertices = round(100*edge_vertices)'/100;
    edge_vertices = unique(edge_vertices, 'rows')';
    if (size(edge_vertices,2) >= 2)
      h_fill(counter) = plot(edge_vertices(1,:), edge_vertices(2,:), ...
			     'color', linecolor, 'linestyle', filllinestyle, 'linewidth', linewidth);
    end
  end
end
