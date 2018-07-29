function domain = CreateDomain(Lx, Ly, dx, dy)

% initialize dependant variables
x_intervals = Lx/dx + 1;
y_intervals = Ly/dy + 1;
%x_Step_Interval = (stepX/dx) + 1; 
%y_Step_Interval = (stepY/dy) + 1;

% Create Domain Matrix
domain = zeros(x_intervals,y_intervals);

end