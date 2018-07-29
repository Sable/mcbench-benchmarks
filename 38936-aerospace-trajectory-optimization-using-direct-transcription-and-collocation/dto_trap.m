% dto_trap.m    June 22, 2013

% trajectory optimization using direct transciption and collocation

% trapezoid collocation, Chebyshev-Gauss-Lobatto
% node placement, and SNOPT NLP algorithm

% Bryson-Ho example - maximize final radial distance

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global nc_total nc_defect ndiffeq nnodes nlp_state ncv

global nlp_control tarray acc beta

pi2 = 2.0 * pi;

% conversion factor - radians to degrees

rtd = 180.0 / pi;

% astronomical unit (kilometers)

aunit = 149597870.691;

% gravitational constant of the sun (km**3/sec**2)

xmu = 132712441933.0;

% time conversion factor

tcf = sqrt(aunit^3 / xmu) / 86400.0;

% number of differential equations

ndiffeq = 3;

% number of control variables

ncv = 1;

% number of discretization nodes

nnodes = 50;

% number of state nlp variables

nlp_state = ndiffeq * nnodes;

% number of control nlp variables

nlp_control = ncv * nnodes;

% total number of nlp variables

nlpv = nlp_state + nlp_control;

% number of state vector defect equality constraints

nc_defect = nlp_state - ndiffeq;

% number of auxilary equality constraints (boundary conditions)

nc_aux = 2;

% total number of equality constraints

nc_total = nc_defect + nc_aux;

% initial mass (kilograms)

mass0 = 4535.9;

% propellant flow rate (kilograms/day)

mdot = 5.85;

% normalized propellant flow rate

beta = (mdot / mass0) * tcf;

% thrust (newtons)

thrmag = 3.781;

% normalized thrust acceleration

acc = 0.001 * (thrmag / mass0) / (xmu / aunit^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial and final times and states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; home;

% initial simulation time

tinitial = 0.0;

% final simulation time

tfinal = 3.32;

% define state vector at initial time

xinitial(1) = 1.0;

xinitial(2) = 0.0;

xinitial(3) = 1.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create time values at nodes
% (Chebyshev-Gauss-Lobatto)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[tarray, w] = cgl(nnodes, tinitial, tfinal);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% upper and lower bounds for nlp state variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:1:nlp_state
    
    xlb(i) = -10.0;

    xub(i) = +10.0;
    
end

% constrain initial boundary conditions
% to be the initial state vector

for i = 1:1:ndiffeq
    
    xlb(i) = xinitial(i);

    xub(i) = xinitial(i);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% upper and lower bounds for nlp control variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = nlp_state + 1:1:nlpv
    
    xlb(i) = -pi;

    xub(i) = +pi;
    
end

xlb = xlb';

xub = xub';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial guess for nlp state variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

j = 0;

for i = 1:1:nlp_state
    
    j = j + 1;

    xg(i) = xinitial(j);

    if (j == ndiffeq)
       j = 0;
    end 
    
end

lgflag = 1;

if (lgflag == 1)
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % compute linear initial guess for state variables
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % initial conditions

   xi1 = xinitial(1);

   xi2 = xinitial(2);

   xi3 = xinitial(3);
   
   % final conditions

   xf1 = 1.525;

   xf2 = 0.0;

   xf3 = sqrt(1.0 / xf1);
   
   % initial and final times

   ti = tinitial;

   tf = tfinal;

   % compute linear guesses
  
   xg1 = dto_guess(ti, tf, xi1, xf1, nnodes);

   xg2 = dto_guess(ti, tf, xi2, xf2, nnodes);

   xg3 = dto_guess(ti, tf, xi3, xf3, nnodes);
      
   % load initial guess array

   j = 1;

   for i = 1: nnodes
       
       xg(j) = xg1(i);

       xg(j + 1) = xg2(i);

       xg(j + 2) = xg3(i);
       
       j = j + 3;
       
   end
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial guess for nlp control variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = nlp_state + 1:1:nlpv
    
    xg(i) = 0.0;
    
end

% transpose initial guess

xg = xg';

% define lower and upper bounds on objective function

flow(1) = -10.0;

fupp(1) = +10.0;

% define lower and upper bounds on defects

for i = 1:1:nc_defect
    
    flow(i + 1) = 0.0;
    
    fupp(i + 1) = 0.0;
    
end

% define lower and upper bounds on final boundary conditions

for i = 1:1:nc_aux
    
    flow(i + nc_defect + 1) = 0.0;
    
    fupp(i + nc_defect + 1) = 0.0;
    
end

flow = flow';

fupp = fupp';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve direct transcription problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set SNOPT file options

snprintfile('dto_trap.out');

snsummary('dto_trap.sum');
       
snscreen('on');

[x, f, inform, xmul, fmul] = snopt(xg, xlb, xub, flow, fupp, 'dtofunc_trap');

snprintfile('off');

snsummary('off');
                                
% print results

clc; home;

fprintf('\n\n         program dto_trap \n');

fprintf('\n    trajectory optimization using');

fprintf('\n direct transcription and collocation \n\n');

fprintf ('\ninitial state vector \n');

fprintf ('\n radius              = %12.8f \n', x(1));
fprintf ('\n radial velocity     = %12.8f \n', x(2));
fprintf ('\n transverse velocity = %12.8f \n', x(3));

fprintf ('\n\nfinal state vector \n');

fprintf ('\n radius               = %12.8f \n', x(nlp_state - 2));
fprintf ('\n radial velocity      = %12.8f \n', x(nlp_state - 1));
fprintf ('\n transverse velocity  = %12.8f \n\n', x(nlp_state));

%%%%%%%%%%%%%%%%%%%%%%%%%
% create trajectory plots
%%%%%%%%%%%%%%%%%%%%%%%%%

npts = 0;

j = 1;

for i = 1:1:nnodes
    
    npts = npts + 1;

    % simulation time

    xplot(i) = tarray(i) * tcf;

    % radius

    yplot2(i) = x(j);

    % radial velocity

    yplot3(i) = x(j + 1);

    % transverse velocity

    yplot4(i) = x(j + 2);

    j = j + 3;
    
end

% polar angle (radians)

theta = cumtrapz(tarray, yplot4./yplot2);

j = 0;

for i = nlp_state + 1:1:nlpv
    
    j = j + 1;
    
    % alpha (degrees)

    yplot1(j) = rtd * x(i);
    
end

% plot results
 
figure(1);

plot(xplot, yplot1, '-*');

title('Trajectory Optimization Using Direct Transcription & Collocation', 'FontSize', 16);

xlabel('simulation time (days)', 'FontSize', 12);

ylabel('thrust angle (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 control.eps

figure(2);

plot(xplot, yplot2, '-*');

title('Trajectory Optimization Using Direct Transcription & Collocation', 'FontSize', 16);

xlabel('simulation time (days)', 'FontSize', 12);

ylabel('radial distance (au)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 rdistance.eps

figure(3);

plot(xplot, yplot3, '-*');

title('Trajectory Optimization Using Direct Transcription & Collocation', 'FontSize', 16);

xlabel('simulation time (days)', 'FontSize', 12);

ylabel('radial velocity (au/day)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 vradial.eps

figure(4);

plot(xplot, yplot4, '-*');

title('Trajectory Optimization Using Direct Transcription & Collocation', 'FontSize', 16);

xlabel('simulation time (days)', 'FontSize', 12);

ylabel('transverse velocity (au/day)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 vtransverse.eps

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create trajectory display
%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
figure(5);

hold on;
    
axis([-1.7 1.7 -1.6 1.6]);
    
plot (0, 0, 'y*');

% create array of polar angles (radians)

t = 0: pi / 50.0: 2.0 * pi;

% plot Earth orbit

plot(xinitial(1) * sin(t), xinitial(1) * cos(t), 'Color', 'b');

% plot destination planet orbit

plot(xf1 * sin(t), xf1 * cos(t), 'Color', 'r');

% plot and label transfer orbit

plot(yplot2.* cos(theta), yplot2.*sin(theta), 'k-');
 
plot(yplot2(1) * cos(theta(1)), yplot2(1) * sin(theta(1)), 'ko');
 
plot(yplot2(end) * cos(theta(end)), yplot2(end) * sin(theta(end)), 'ko');

% label plot and axes

xlabel('X coordinate (AU)', 'FontSize', 12);

ylabel('Y coordinate (AU)', 'FontSize', 12);

title('Trajectory Optimization Using Direct Transcription & Collocation', 'FontSize', 16);

grid;

axis equal;

zoom on;

print -depsc -tiff -r300 trajectories.eps

