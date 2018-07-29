function [] = ControlPanel()

% initialize control variables
Lx = 200*10^-3; % billet size
Ly = 200*10^-3;
dx = 01*10^-3;
dy = 01*10^-3;
dt = 0.001;

% Temperature definitions
initial_Temperature = 510+273;
left_Temperature = 65+273;
upper_Temperature = 65+273;
right_Temperature = 65+273;
bottom_Temperature = 65+273;
BC_temperature = left_Temperature;
new_Temperature = BC_temperature;
reference_Temperature = 200+273;

% Secondary variables
boolean = 0; 
timeRequired = 0;
time = 26;

% Material properties
alpha = 6.584*10^-5; % Steel
rho = 2700;
Cp = 900;

courant_Number = alpha*dt/(dx^2);

% Define computational domain (Geometry)

% storage parameters
x_intervals = Lx/dx + 1;
y_intervals = Ly/dy + 1;

% Matrices
T_old =  zeros(x_intervals,y_intervals); % 2-D storage for previous time step
T_new = zeros(x_intervals,y_intervals); % 2-D storage for current time step
%T = zeros((time/dt),x_intervals,y_intervals); % Mega Temperature matrix to stroe in 2-D for each time step, hence 3-D

% Initialize domain
T_old = InitializeSolution(T_old,initial_Temperature,left_Temperature,upper_Temperature,right_Temperature,bottom_Temperature,x_intervals,y_intervals);
T_boundary = zeros(1,time/dt);

% formulation : EXPLICIT scheme
for time_index = 1:1:(time/dt)

    T_new = ExplicitScheme(T_old,alpha,dx,dy,dt,x_intervals,y_intervals);   
    % Introduce the water bath dynaic BC factor
    new_Temperature = CalculatedBathAdjustedBoundaryTemperature(T_new,T_old,x_intervals,y_intervals,dt,rho,Cp,new_Temperature);
    boolean = ExitConditionEvaluation(T_new,reference_Temperature,x_intervals,y_intervals);
    
    if(boolean == 1 && timeRequired == 0)
        timeRequired = time_index;
    end
    
    T_boundary(time_index) = new_Temperature;
    
    T_old = ReInitializeSolution(T_new,new_Temperature,x_intervals,y_intervals);
  
end

T_plot = T_new';
T_plotting = CalculatePlottingMatrix(T_plot,x_intervals,y_intervals); % Plotting matrix

%Contour plot on the 2-D spatial domain
T_constant = initial_Temperature:.001:max([initial_Temperature,left_Temperature,upper_Temperature,right_Temperature,bottom_Temperature]);
[C,h] = contour(T_plotting,T_constant);

end