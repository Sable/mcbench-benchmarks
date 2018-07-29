%% Simulation of stable domain mode generation in Gunn diode (GD).
%% Code contains numerical solution of drift-diffusion equations system for Gunn diode
%% with ballast load and ideal voltage source. The n-type doping profile for GD
%% has been chosen to make it able to generate. Also specific profiles may be applied
%% successfully as well as another voltage source.
function Run_me
 close all; clear all; clc;

 % Active area length [cm]
 l = 12.5e-4;
 % Temperature potential for GaAs [V]
 phi_t = 0.025;
 % Uniform n-type doping concentration level [1/cm^2]
 N0 = 1.0e+15;
 % Voltage source pulse parameters
 % t1 - rising edge length [s], t2 - leading-edge length [s], 
 % t3 - trailing edge length [s], U0 - voltage amplitude [V]
 t1 = 1e-9; t2 = 1e-9; t3 = 1e-9; U0 = 10.0; 
 % Ballast load [Ohm]
 Rn = 1.0; 
 % Gunn diode diameter [cm]
 d = 300e-4;
 % Number of spatial grid points
 N = 200;
 % Small time step (choose it much less than domain shaping time) [s]
 dt = 1e-13;
 
 A = pi*d^2/4;
 t_end = t1+t2+t3;
 x = linspace(0.0, l, N);
 dx = x(2)-x(1);
 
 % Define sample working n-type doping profile 
 n0 = N0*ones(1, N);
 n0(11:21) = 0.9*N0;

 % Find initial electir field distribution
 E = phi_t*Deriv(x, n0)./n0;

 t = 0; T = 1;    
 
 % Calculate first spatial derivative from n0
 n0_x = Deriv(x, n0);     
 
 % Open maximized figure window
 figure('units','normalized','outerposition',[0 0 1 1]);
 set(gcf, 'doublebuffer', 'on');    

% Main routine 
tic;
while 1
      % Calculate current density for circuit (GD + load + voltage source)
      % from Ohm law
      ia = (Voltage(U0, t1, t2, t3, t) - trapz(x, E))/(A*Rn);    
      % Solve RCD equation on dt step. 
      % Add _mex to Solve_RCD to run MEX instead of M-script      
      E = Solve_RCD(N, ia, dx, dt, E, n0, n0_x, 1);
      current(T) = ia*A;       
      voltage(T) = Voltage(U0, t1, t2, t3, t) - ia*A*Rn;
      
      % Plot electric field and other functions for each 1000th iteration
      if mod(T,ceil(t_end/dt/1000)) == 0
          subplot(2, 2, 1);
          plot(x*1e4, E*1e-3, '-b', 'LineWidth', 4);
          axis([0 l*1e4 min(E)*1e-3 max(E)*1e-3]);
          grid on;
          title(['Electric field E(x,t) distribution at t = ', num2str(floor(t*1e12)), ' ps'], 'FontSize', 16, 'FontWeight', 'bold');
          xlabel('\mu m', 'FontSize', 14, 'FontWeight', 'bold');
          ylabel('kV/cm', 'FontSize', 14, 'FontWeight', 'bold');

          Ex = Deriv(x, E);
          subplot(2, 2, 2);
          plot(x*1e4, Ex, '-r', 'LineWidth', 4);
          grid on;
          title('Inverse space charge distribution \rho(x,t)',  'FontSize', 16, 'FontWeight', 'bold');
          xlabel('\mu m', 'FontSize', 14, 'FontWeight', 'bold');
          ylabel('a.u.', 'FontSize', 14, 'FontWeight', 'bold');
          axis([0 l*1e4 min(Ex) max(Ex)]);

          subplot(2, 2, 3);
          plot((1:(T-1))*dt*1e9, current(1:(T-1)), '-k', 'LineWidth', 4);
          xlim([0 t_end]*1e9);
          title('GD current i_{GD}(t)', 'FontSize', 16, 'FontWeight', 'bold');
          xlabel('ns', 'FontSize', 14, 'FontWeight', 'bold');
          ylabel('Ampere', 'FontSize', 14, 'FontWeight', 'bold');
          grid on;

          subplot(2, 2, 4);
          plot((1:(T-1))*dt*1e9, voltage(1:(T-1)), '-k', 'LineWidth', 4);
          title('GD current u_{GD}(t)', 'FontSize', 16, 'FontWeight', 'bold');
          xlim([0 t_end]*1e9);
          xlabel('ns', 'FontSize', 14, 'FontWeight', 'bold');
          ylabel('Volts', 'FontSize', 14, 'FontWeight', 'bold');
          grid on;
          drawnow;
      end
      
      % Terminate routine after t_end reached
      if ( (t > t_end) && (t_end > 0) ) break; end
      t = t + dt; T = T + 1;      
end
toc
