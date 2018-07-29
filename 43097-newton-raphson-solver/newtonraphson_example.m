%% newton raphson example
% Find the Darcy friction factor for pipe flow using the Colebrook
% equation.
fprintf('\n**************************************************\n')
fprintf('NON-LINEAR SYSTEM OF EQUATIONS - PIPE FLOW EXAMPLE\n')
fprintf('**************************************************\n')
%% References:
% * http://en.wikipedia.org/wiki/Darcy_friction_factor_formulae
% * http://en.wikipedia.org/wiki/Darcy%E2%80%93Weisbach_equation
% * http://en.wikipedia.org/wiki/Moody_chart
% * http://www.mathworks.com/matlabcentral/fileexchange/35710-iapwsif97-functional-form-with-no-slip
%% inputs:
p = 0.68; % [MPa] water pressure (100 psi)
dp = -0.068*1e6; % [Pa] pipe pressure drop (10 psi)
T = 323; % [K] water temperature
D = 0.10; % [m] pipe hydraulic diameter
L = 100; % [m] pipe length
roughness = 0.00015; % [m] cast iron pipe roughness
rho = 1./IAPWS_IF97('v_pT',p,T); % [kg/m^3] water density (988.1 kg/m^3)
mu = IAPWS_IF97('mu_pT',p,T); % [Pa*s] water viscosity (5.4790e-04 Pa*s)
Re = @(u) rho*u*D/mu; % Reynolds number
%% governing equations
% Use Colebrook and Darcy-Weisbach equation to solve for pipe flow.

% friction factor (Colebrook eqn.)
residual_friction = @(u, f) 1/sqrt(f) + 2*log10(roughness/3.7/D + 2.51/Re(u)/sqrt(f));
% pressure drop (Darcy-Weisbach eqn.)
residual_pressdrop = @(u, f) rho*u^2*f*L/2/D + dp;
% residuals
fun = @(x) [residual_friction(x(1),x(2)), residual_pressdrop(x(1),x(2))];
%% solve
x0 = [1,0.01]; % initial guess
fprintf('\ninitial guess: u = %g[m/s], f = %g\n',x0) % display initial guess 
options = optimset('TolX',1e-12); % set TolX
[x, resnorm, f, exitflag, output, jacob] = newtonraphson(fun, x0, options);
fprintf('\nexitflag: %d, %s\n',exitflag, output.message) % display output message
%% results
fprintf('\nOutputs:\n')
properties = {'Pressure','Pressure-drop','Temperature','Diameter','Length', ...
    'roughness','density','viscosity','Reynolds-number','speed','friction'};
units = {'[Pa]','[Pa]','[C]','[cm]','[m]','[mm]','[kg/m^3]','[Pa*s]','[]','[m/s]','[]'};
values = {p*1e6,dp,T-273.15,D*100,L,roughness*1000,rho,mu,Re(x(1)),x(1),x(2)};
fprintf('%15s %10s %10s\n','Property','Unit','Value')
results = [properties; units; values];
fprintf('%15s %10s %10.4g\n',results{:})
%% comparison
% solve using Haaland
Ntest = 10;
u0 = linspace(x(1)*0.1, x(1)*10, Ntest); % [m/s]
Re0 = Re(u0);
f0 = (1./(-1.8*log10((roughness/D/3.7)^1.11 + 6.9./Re0))).^2;
u0 = sqrt(-dp/rho./(f0*L/2/D));
% plot
plot(u0, f0, '-', u0, x(2)*ones(1,Ntest), '--', x(1)*ones(1,Ntest), f0, '--')
grid
title('Pipe flow solution using Haaland equation.')
xlabel('water speed, u [m/s]'),ylabel('friction factor, f')
legend('f_{Haaland}',['f = ',num2str(x(2))], ['u = ',num2str(x(1)),' [m/s]'])
%% LSQ Curve Fitting
fprintf('\n**********************************************\n')
fprintf('LEAST SQUARES CURVE FITTING WITH NEWTONRAPHSON\n')
fprintf('**********************************************\n')
% independent variables
[x,y] = meshgrid(0:10,0:10);
% bivariate distribution
bivar = @(x1,x2,sig,u1,u2)1/2/pi/sig^2*exp(-1/2*(((x1-u1).^2+(x2-u2).^2)/sig));
sigma = 3; ux = 4; uy = 5; % std dev, x & y means
z = bivar(x,y,sigma,ux,uy); % dist
% plot
figure,contour(x,y,z),hold('all')
title('lsq curve-fitting bivariate pdf with newtonraphson')
xlabel('x-coord'),ylabel('y-coord') % axes titles
grid,colorbar % show colorbar and grid
z_meas = z + (2*rand(11)-1)/1e4; % measured data
% fitting function
lsqfitfun = @(c)z_meas-bivar(x,y,c(1),c(2),c(3));
% fit coefficients to fun
c0 = [1,2,3]; % initial guess
fprintf('\ninitial guess: sigma = %g, ux = %g, uy = %g\n',c0) % display initial guess 
options = optimset('TolX',1e-12); % set TolX
[c, ~, ~, exitflag, output] = newtonraphson(lsqfitfun, c0, options);
fprintf('\nexitflag: %d, %s\n',exitflag, output.message) % display output message
fprintf('\ncurve-fit coefficients: sigma=%g, ux=%g, uy=%g\n',c)
lines = plot(repmat(c(2),1,11),0:10,'--',0:10,repmat(c(3),1,11),'--', ...
    c(2),c(3),'o');
set(lines,'LineWidth',2);
legend('bivariate distribution','u_x','u_y','center')