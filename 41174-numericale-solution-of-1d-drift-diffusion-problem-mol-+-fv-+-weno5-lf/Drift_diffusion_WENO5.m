%% Solve 1D electrons and ions equations of continuity in drift approximation 
%% with Poisson equation simultaneously.
% Partial differential equation system is (latex notation):
% 1) \frac{\partial n_e}{\partial t} + \frac{\partial \Gamma_e}{\partial x} = 0
% 2) \frac{\partial n_i}{\partial t} + \frac{\partial \Gamma_i}{\partial x} = 0
% 3) \frac{\partial^2 E}{\partial x^2} = \frac{q(n_i - n_e)}{epsilon_0} = 0
% where \Gamma_e = -mu_e n_e E - D_e \frac{\partial n_e}{\partial x} and
%       \Gamma_i = mu_i n_i E - D_i \frac{\partial n_i}{\partial x}
% mu_e and mu_i - constant electrons and ions mobility, D_e and D_i -
% corresponding diffusion coefficients
%% Equations of continuity are solved numerically with MOL + WENO5-LF methods for drift fluxes 
%% simple centered differences for diffusion terms. 
%% As for Poisson equation I use the exact solution of it in 1D with Dirichlet conditions:
% E(x,t) = -V(t)/d - \frac{q}{\epsilon_0 d} \int \limits_0^d \int \limits_0^x
% (n_i - n_e) dx' dx + \frac{q}{\epsilon_0} \int \limits_0^x (n_i - n_e) dx'
% where V(t) is anode potential, d - gap length, q - electron charge
%% For futher information on WENO and MOL numerical methods see 
% WENO5 formulas from paper by S. Gottlieb, J. S. Mullen, S. J. Ruuth " A
% fifth order flux implicit WENO method" // Journal of Scientific Computing
% (2006), Vol. 27, Issue 1-3, pp 271-287.
% MOL (Method of Lines) is completely given in the book by W. Schiesser and 
% G. Griffiths "A compendium of partial differential equation models" //
% Cambridge University Press (2009)
function Drift_diffusion_WENO5
close all; clc;

%% Global variables
   global X nx t_end n0 mu_e mu_i D_e D_i gammma

%% Gas parameters (pressure [Torr], drift [cm^2/s/V] and diffusion [cm^2/s] coefficients)
   p = 760.0;  mu_e = 4.5e+5/p;  D_e = 2.9e+5/p;
               mu_i = 4.5e+3/p;  D_i = 2.9e+3/p;
%% Initial plasma concentration [1/cm^3] and secondary emission constant               
   n0 = 1.0e+11;  gammma = 0.1;
%% Gap length [cm]
   d = 1.0;  
%% End time [s]
   t_end = 6.0e-6;    
%% Time step [s]
   t_step = 20.0e-9;
%% Number of spatial grid points
   nx = 200;      
%% Define uniform spatial grid and time values array
   t = 0.0:t_step:t_end;
   X = linspace(0.0, d, nx);
   
%% Solve MOL ODEs system with WENO5 fluxes using ODE45 solver
   disp('Wait...'); tic;
   [TT, U] = ode45(@eq_sys, t, n0*ones(1,2*nx));
   disp(['Complete after ', num2str(toc/60,0), ' minutes!']);

%% Plot all results   
   figure('units','normalized','outerposition',[0 0 1 1]);
   set(gcf, 'doublebuffer', 'on');
   ne = U(:, 1:nx);   ni = U(:, (nx+1):2*nx);
   for I=1:length(t)   
       subplot(2,1,1)
       plot(X, ne(I, :), 'r-', X, ni(I, :), 'b-', 'LineWidth', 2);
       xlim([0.0 d]); ylim([0 n0*1.1]);
       title(['Concentrations at t = ', num2str(t(I))], 'FontSize', 16);
       xlabel('cm', 'FontSize', 16);   ylabel('cm^{-3}', 'FontSize', 16);
       legend('n_e(x,t)', 'n_i(x,t)', 'Location', 'SouthEast');
       grid on;
       subplot(2,1,2)
       plot(X, Electric_field(X, ne(I, :), ni(I, :), t(I)), 'r-', 'LineWidth', 2);
       title('Electric field strength', 'FontSize', 16);
       xlabel('cm', 'FontSize', 16);   ylabel('V/cm', 'FontSize', 16);
       grid on;
       drawnow; 
   end
  
%% MOL ODEs system for electrons and ions equations of continuity
function [U_t] = eq_sys(t, U)
global X nx mu_e D_e mu_i D_i gammma
% Separate N_e and N_i 
N_e = U(1:nx)';   N_i = U((1+nx):2*nx)';
% Working index range 
I = 3:(nx+2);
dx = X(2)-X(1);

% Find electric field strength from exact solution of 1D Poisson equation
E_field = Electric_field(X, N_e, N_i, t);

% For electrons
% Fill working array with N_e and add "ghost" nodes (two at left + three at right side)
u(1:2) = N_e(1); u(I) = N_e(I-2); u((nx+3):(nx+5)) = N_e(end);

% Fill electrons velocity array (also with ghost nodes incuded)
electron_velocity(1:2) = -mu_e*E_field(1); 
electron_velocity(I) = -mu_e*E_field(I-2);
electron_velocity((nx+3):(nx+5)) = -mu_e*E_field(nx); 

% Lax-Friedrichs (LF) electrons flux splitting routine
a = max(abs(electron_velocity));
Fp = 0.5*( electron_velocity.*u + a*u ); Fm = 0.5*( electron_velocity.*u - a*u );

% WENO5 "right" flux reconstruction (only for convective flux -mu_e*N_e*E_field)
% Smoothness measurements
beta1 = (13.0/12.0)*(Fp(I) - 2.0*Fp(I+1) + Fp(I+2)).^2 + (1.0/4.0)*(3.0*Fp(I) - 4.0*Fp(I+1) + Fp(I+2)).^2;
beta2 = (13.0/12.0)*(Fp(I-1) - 2.0*Fp(I) + Fp(I+1)).^2 + (1.0/4.0)*(Fp(I-1) - Fp(I+1)).^2;
beta3 = (13.0/12.0)*(Fp(I-2) - 2.0*Fp(I-1) + Fp(I)).^2 + (1.0/4.0)*(Fp(I-2) - 4.0*Fp(I-1) + 3.0*Fp(I)).^2;
% Stencil weights
alpha1 = (3.0/10.0)./(eps + beta1).^2;
alpha2 = (3.0/5.0)./(eps + beta2).^2;
alpha3 = (1.0/10.0)./(eps + beta3).^2;
% Numerical fluxes
R_plus(I-1) = alpha1./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fp(I) + 5.0/6.0*Fp(I+1) - 1.0/6.0*Fp(I+2)) ...
            + alpha2./(alpha1 + alpha2 + alpha3).*(-1.0/6.0*Fp(I-1) + 5.0/6.0*Fp(I) + 1.0/3.0*Fp(I+1)) ...
            + alpha3./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fp(I-2) - 7.0/6.0*Fp(I-1) + 11.0/6.0*Fp(I));

% WENO5 "left" flux reconstruction
% Smoothness measurements
beta1 = (13.0/12.0)*(Fm(I+1) - 2.0*Fm(I+2) + Fm(I+3)).^2 + (1.0/4.0)*(3.0*Fm(I+1) - 4.0*Fm(I+2) + Fm(I+3)).^2;
beta2 = (13.0/12.0)*(Fm(I) - 2.0*Fm(I+1) + Fm(I+2)).^2 + (1.0/4.0)*(Fm(I) - Fm(I+2)).^2;
beta3 = (13.0/12.0)*(Fm(I-1) - 2.0*Fm(I) + Fm(I+1)).^2 + (1.0/4.0)*(Fm(I-1) - 4.0*Fm(I) + 3.0*Fm(I+1)).^2;
% Stencil weights
alpha1 = (1.0/10.0)./(eps + beta1).^2;
alpha2 = (3.0/5.0)./(eps + beta2).^2;
alpha3 = (3.0/10.0)./(eps + beta3).^2;
% Numerical fluxes
R_minus(I-1) = alpha1./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fm(I+3) - 7.0/6.0*Fm(I+2) + 11.0/6.0*Fm(I+1)) ...
             + alpha2./(alpha1 + alpha2 + alpha3).*(-1.0/6.0*Fm(I+2) + 5.0/6.0*Fm(I+1) + 1.0/3.0*Fm(I)) ...
             + alpha3./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fm(I+1) + 5.0/6.0*Fm(I) - 1.0/6.0*Fm(I-1));

% Apply physical BCs on numerical fluxes (pay attention to the flux
% direction)
% Secondary emission of elecrons from cathode (to the right of the cathode)
R_plus(1) = -gammma*mu_i*N_i(1)*E_field(1); R_minus(1) = 0;
% Transition conditions for electrons on anode
R_plus(nx+1) = -mu_e*N_e(nx)*E_field(nx); R_minus(nx+1) = 0;

% Calculate diffusion term (\frac{\partial^2 N_e}{\partial x^2}) using second order finite difference
I = 2:(nx-1);
N_e_xx(1) = 0;
N_e_xx(I) = (N_e(I+1) + N_e(I-1) - 2.0*N_e(I))/(dx*dx);
N_e_xx(nx) = 0;

% Construct MOL ODEs system with finite-volume flux derivatives
I = 1:nx;
% Electrons equation of continuity 
U_t(I) = -(R_plus(I+1)+R_minus(I+1)-R_plus(I)-R_minus(I))/dx + D_e*N_e_xx(I);

% For ions
% Fill working array with N_i and add "ghost" nodes (two at left + three at right side)
I = 3:(nx+2);
u(1:2) = N_i(1); u(I) = N_i(I-2); u((nx+3):(nx+5)) = N_i(end);

% Fill ions velocity array (also with ghost nodes incuded)
ion_velocity(1:2) = mu_i*E_field(1); 
ion_velocity(I) = mu_i*E_field(I-2);
ion_velocity((nx+3):(nx+5)) = mu_i*E_field(nx); 

% Lax-Friedrichs (LF) ions flux splitting routine
a = max(abs(ion_velocity));
Fp = 0.5*( ion_velocity.*u + a*u ); Fm = 0.5*( ion_velocity.*u - a*u );

% WENO5 "right" flux reconstruction (only for convective flux mu_i*N_i*E_field)
% Smoothness measurements
beta1 = (13.0/12.0)*(Fp(I) - 2.0*Fp(I+1) + Fp(I+2)).^2 + (1.0/4.0)*(3.0*Fp(I) - 4.0*Fp(I+1) + Fp(I+2)).^2;
beta2 = (13.0/12.0)*(Fp(I-1) - 2.0*Fp(I) + Fp(I+1)).^2 + (1.0/4.0)*(Fp(I-1) - Fp(I+1)).^2;
beta3 = (13.0/12.0)*(Fp(I-2) - 2.0*Fp(I-1) + Fp(I)).^2 + (1.0/4.0)*(Fp(I-2) - 4.0*Fp(I-1) + 3.0*Fp(I)).^2;
% Stencil weights
alpha1 = (3.0/10.0)./(eps + beta1).^2;
alpha2 = (3.0/5.0)./(eps + beta2).^2;
alpha3 = (1.0/10.0)./(eps + beta3).^2;
% Numerical fluxes
R_plus(I-1) = alpha1./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fp(I) + 5.0/6.0*Fp(I+1) - 1.0/6.0*Fp(I+2)) ...
            + alpha2./(alpha1 + alpha2 + alpha3).*(-1.0/6.0*Fp(I-1) + 5.0/6.0*Fp(I) + 1.0/3.0*Fp(I+1)) ...
            + alpha3./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fp(I-2) - 7.0/6.0*Fp(I-1) + 11.0/6.0*Fp(I));

% WENO5 "left" flux reconstruction
% Smoothness measurements
beta1 = (13.0/12.0)*(Fm(I+1) - 2.0*Fm(I+2) + Fm(I+3)).^2 + (1.0/4.0)*(3.0*Fm(I+1) - 4.0*Fm(I+2) + Fm(I+3)).^2;
beta2 = (13.0/12.0)*(Fm(I) - 2.0*Fm(I+1) + Fm(I+2)).^2 + (1.0/4.0)*(Fm(I) - Fm(I+2)).^2;
beta3 = (13.0/12.0)*(Fm(I-1) - 2.0*Fm(I) + Fm(I+1)).^2 + (1.0/4.0)*(Fm(I-1) - 4.0*Fm(I) + 3.0*Fm(I+1)).^2;
% Stencil weights
alpha1 = (1.0/10.0)./(eps + beta1).^2;
alpha2 = (3.0/5.0)./(eps + beta2).^2;
alpha3 = (3.0/10.0)./(eps + beta3).^2;
% Numerical fluxes
R_minus(I-1) = alpha1./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fm(I+3) - 7.0/6.0*Fm(I+2) + 11.0/6.0*Fm(I+1)) ...
             + alpha2./(alpha1 + alpha2 + alpha3).*(-1.0/6.0*Fm(I+2) + 5.0/6.0*Fm(I+1) + 1.0/3.0*Fm(I)) ...
             + alpha3./(alpha1 + alpha2 + alpha3).*(1.0/3.0*Fm(I+1) + 5.0/6.0*Fm(I) - 1.0/6.0*Fm(I-1));

% Apply physical BCs on numerical fluxes (pay attention to the flux
% direction)
% Transition conditions for ions at cathode
R_plus(1) = 0; R_minus(1) = mu_i*N_i(1)*E_field(1);
% Transition conditions for electrons on anode
R_plus(nx+1) = 0; R_minus(nx+1) = 0;

% Calculate diffusion term (\frac{\partial^2 N_e}{\partial x^2}) using second order centered finite difference
I = 2:(nx-1);
N_i_xx(1) = 0;
N_i_xx(I) = (N_i(I+1) + N_i(I-1) - 2.0*N_i(I))/(dx*dx);
N_i_xx(nx) = 0;

% Construct MOL ODEs system with finite-volume flux derivatives
I = 1:nx;
% Ions equation of continuity 
U_t(I+nx) = -(R_plus(I+1)+R_minus(I+1)-R_plus(I)-R_minus(I))/dx + D_i*N_i_xx(I);
U_t = U_t';

%% Electric field strength (exact solution of 1D Poisson equation with
%% space charge density of electrons and ions)
function [E] = Electric_field(x, ne, ni, t)
% Vacuum dielectric permittivity and electron charge
epsilon0 = 8.85e-14;   q = 1.6e-19;

E = - Voltage(t)/x(end) + q/epsilon0*cumtrapz(x, ni - ne) ...
    - q/epsilon0/x(end)*trapz(x, cumtrapz(x, ni - ne));

%% Time-dependent voltage source
function [res] = Voltage(t)
% Voltage amplitude [V]
Umax = 5.0e+3; 
res = Umax;
