%% Implicit (Euler) finite-difference solver for main Gunn diode equation 
%% (1D reaction-convection-diffusion equation)
%% To improve performance it may be compiled into MEX file with MATLAB Coder
%% without any changes.
% List of parameters:
% N - number of space uniform grid points,
% ja - defined from circuit Gunn diode current density,
% dx - cell size of uniform grid,
% dt - time step,
% n0 and n0_x - n-type doping profile and its first derivative
% respectively,
% border - set 0 for zero Dirichlet condition and 1 to zero Neumann conditions. 
function out = Solve_RCD(N, ja, dx, dt, E, n0, n0_x, border)
 % Euler's method absolute tolerance
   eps = 1.0e-2;
 % Vacuum absolute dielectric permittivity [F/cm]
   epsilon0 = 8.85e-14;
 % Electron charge [C]
   q = 1.6e-19;
 % GaAs relative permittivity
   epsilon_a = 12.5;   epsilon = epsilon0*epsilon_a;
 % Constant diffusion coefficient of electrons in GaAs
   D = 200.0;
 % Saturation electric field strength
   Em = 4000.0;   
 % Drift velocity in saturation fields values
   v_nas = 1.0e+7;
 % Electrons mobility in a weak electric fields
   mu_n = 8000.0;
  
 % Initial variables
   I = 2:(N-1);  E_n = E;  E_n_1 = E;  E_new = zeros(1, N);  
   J = zeros(1, N);  delta = 10.0;
 
 % Main iteration routine of Euler's implicit method
 while (delta > eps)
     % Drift velocity approximation
     Velocity = (mu_n.*E_n_1(I) + v_nas*(E_n_1(I)/Em).^4)./(1.0 + (E_n_1(I)/Em).^4);
     % Compute the source term for RCD equation
     J(I) = ( ja + q*D*n0_x(I) - q*n0(I).*Velocity )/epsilon;
     E_new(I) = E_n(I)/(1+2*D*dt/dx^2) + E_n_1(I+1).*(D*dt/dx^2-0.5*Velocity*dt/dx)/(1+2*D*dt/dx^2) ...
              + E_n_1(I-1).*(D*dt/dx^2+0.5*Velocity*dt/dx)/(1+2*D*dt/dx^2) + J(I)*dt/(1+2*D*dt/dx^2);
     
     if (border == 0)
         % Zero Dirichlet BCs. Good for doping profile with contacting
         % inhomogeneities 
         E_new(1) = 0;   E_new(N) = 0;
     else
         % Zero Neumann BCs. Good for doping profile containing only
         % active region
         E_new(1) = E_new(2);   E_new(N) = E_new(N-1);
     end
     
     % Discrepancy control               
     delta = max(abs(E_new - E_n_1));   E_n_1 = E_new;
 end

 out = E_n_1; 