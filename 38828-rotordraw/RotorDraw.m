%% "Spirograph" Code
%  Jonathan Jamieson - September 2013
%  unigamer@gmail.com
%  www.jonathanjamieson.com

% This is the main script. Run it in Matlab and then mess around with
% the "User Configurable Parameters". By default arm at the bottom
% is arm "a" and the left arm is arm "b". The "c" coordinates denote
% the position of the rotating platform.

%% User Configurable Parameters -------------------------------------------
% a - arm a parameters
% b - arm b parameters
% c - parameters of the rotating disc where the paper would be

% Time-span
t=1:0.01:900;

% The positions of the local coordinate systems in the global one
xa = 18; 
ya = 2.5;

xb = 6.5;
yb = 12;

xc = 18;
yc = 12;

% The positions of where the arms are mounted to the rotating discs
A_x_local =-1.8;
A_y_local = 0.2;

B_x_local = 3;
B_y_local = 1;

% The angular speeds of the rotating discs
A_omega = -3*5;
B_omega = 1*5;
C_omega = 0.22*5;

% The lengths of the arms
La = 8;
Lb = 13;

% The distance between where the two rods join and the pen
extension = 1; 

% Radii of the discs
ra = 2; % The "r" parameters are only
rb = 4; % used for the purpose of
rc = 6; % visualisation, not calculation

% End of User Configurable Parameters -------------------------------------

%% Graphical Stuff
scrsz = get(0,'ScreenSize');  % Get screen size
figure('Name','The drawing','Position',[scrsz(1)+scrsz(3)/4 scrsz(2)+scrsz(4)/6 scrsz(3)/2 scrsz(4)/1.5]);
hold on
title('The Plot');
axis equal
 
field_size = 30;
xlim(gca, [0 field_size]);
ylim(gca, [0 field_size]);

L1_handle = line([0 0],[0 0],'Color','red','LineWidth',2);
L2_handle = line([0 0],[0 0],'Color','red','LineWidth',2);
P_handle = line([0 0],[0 0],'Color','red','LineWidth',2);

PlotCircle(xa,ya,ra);
PlotCircle(xb,yb,rb);
PlotCircle(xc,yc,rc);

pen_log = zeros(numel(t),2); % Pre-allocate the matrix, this speeds stuff up and is good practice.

%% Main Loop
% This loop is executed for each time-step

try
  for loop_counter=1:1:numel(t)
    
    %% Calculate the position of the pen at the current time-step
    current_time=t(loop_counter);
    [A_x_global,A_y_global] = Local2Global(A_x_local,A_y_local,xa,ya,current_time*A_omega);
    [B_x_global,B_y_global] = Local2Global(B_x_local,B_y_local,xb,yb,current_time*B_omega);
    [C_x_global,C_y_global] = Calculate_Point_C(A_x_global,B_x_global,A_y_global,B_y_global,La,Lb); % This is the intersection of two circles
    [P_x_global,P_y_global ] = CalculatePenPosition(A_x_global,A_y_global,C_x_global,C_y_global,extension);
    [C_x_local,C_y_local] = Global2Local(P_x_global,P_y_global,xc,yc,current_time*C_omega); 
   
    pen_log((loop_counter),:) = [C_x_local,C_y_local]; % Update the pen_log with the new pen position
    
    %% Create a temporary matrix with the global position of each pen point generated so far
    % at the current time. Since the local coordinate system is rotating a new set of temporary coordinates need to be generated each time step.
    pen_log_temp = zeros(loop_counter,2);
    
    for loop_plot=1:1:loop_counter;
        
        [temp_x temp_y] = Local2Global(pen_log(loop_plot,1),pen_log(loop_plot,2),xc,yc,current_time*C_omega);

        pen_log_temp(loop_plot,:) = [temp_x temp_y];
    end
    
    if loop_counter ~= 1; % Don't try and delete on the first iteration because nothing will have been plotted yet
            delete(h_plot);
    end
    
    %% Redraw everything for the current time-step
    h_plot = plot(pen_log_temp(:,1),pen_log_temp(:,2),'Color','magenta');

    set(L1_handle,'XData',[A_x_global  C_x_global],'YData',[A_y_global C_y_global]);
    set(L2_handle,'XData',[B_x_global  C_x_global],'YData',[B_y_global C_y_global]);
    set(P_handle,'XData',[C_x_global  P_x_global],'YData',[C_y_global P_y_global]);

    refresh
    pause(0.000001);
    
  end

    %% Check figure hasn't been closed
    catch E
    if ~strcmp(E.identifier, 'MATLAB:class:InvalidHandle')
        pen_log = pen_log(any(pen_log,2),:); % Delete unused pen_log entries
        x = pen_log(:,1); % Make a vector from the first column
        y = pen_log(:,2); % Make a vector from the second column
        clearvars -except x y % Delete all variables except the coordinates generated in the drawing process. Uncomment this if you wish to debug something.
        break
     
    end
end

% comet(x,y) % Uncomment this function if you want an animated plot at the end of the drawing
% plot (x,y) % Uncomment this function if you want a plot at the end of the drawing

