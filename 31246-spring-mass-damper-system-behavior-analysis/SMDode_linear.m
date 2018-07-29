function  SMDode_linear(Mass,Damping, Stiffness)
%SMDode_linear.m  Spring-Mass-Damper system behavior analysis for given Mass, Damping and Stiffness values.
%   The system's damper has linear properties. 
%   Solver ode45 is employed; yet, other solvers, viz. ODE15S, ODE23S, ODE23T, 
%   ODE23TB, ODE45, ODE113, ODESET, etc., can be used as well.

%   Sulaymon L. ESHKABILOV
%   $Revision: ver. 01 $  $Date: 2011/02/05 02:00:00 $

% Problem parameters, shared with nested functions.

 if nargin < 1
  % -------- Some default values for parameters: Mass, Damping & Stiffness
  % -------- in case not specified by the user
   Mass = 10;       % [kg]
   Damping=50;      % [Nsec^2/m^2] 
   Stiffness=200;   % [N/m]   
 end

tspan = [0; max(20,5*(Damping/Mass))]; % Several periods
u0 = [0; 1];                           % Initial conditions 
options = odeset('Jacobian',@J);       % Options for ODESETs can be switched off

[t,u] = ode45(@f,tspan,u0,options);

figure;
plot(t,u(:,1),'r*--', t, u(:,2), 'bd:', 'MarkerSize', 2, 'LineWidth', 0.5 );
title(['Spring-Mass-Damper System of 2nd order ODE: ', ' M = ' num2str(Mass),...
   '[kg]' '; D = ' num2str(Damping), '[Nsec^2/m^2]', '; S = ' num2str(Stiffness), '[N/m]']);
xlabel('time t');
ylabel('Displacement & Velocity'); grid on;
axis tight;
% axis([tspan(1) tspan(end) -1.5 1.5]); % Axis limits can be set  
hold on;
Acceleration=-(Damping/Mass)*u(:,2)-(Stiffness/Mass)*u(:,1);
plot(t,Acceleration,'mo--', 'MarkerSize', 2, 'LineWidth', 0.5 );
legend('Displacement', 'Velocity', 'Acceleration');
hold off;
  % -----------------------------------------------------------------------
  % Nested functions: Mass, Damping and Stiffness are provided by the outer function.
  %------------------------------------------------------------------------
  function dudt = f(t,u)
  % Derivative function.  Mass, Damping and Stiffness are provided by the
  % outer function or taken default (example values) 
    dudt = [            u(2);      -(Damping/Mass)*u(2)-(Stiffness/Mass)*u(1) ]; 
  end % 
  % ----------------------------------------------------------------------- 
    
  function dfdu = J(t,u)
  % Jacobian function. Mass, Damping and Stiffness are provided by the outer function.   
    dfdu = [         0                  1
             -(Stiffness/Mass)    -(Damping/Mass)*u(2) ];
  end % 
  % -----------------------------------------------------------------------

end  % SMDode_linear.m
