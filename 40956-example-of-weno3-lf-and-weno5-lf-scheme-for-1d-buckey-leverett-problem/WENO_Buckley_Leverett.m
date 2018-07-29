%% Example demonstrating MOL-WENO3-LF and MOL-WENO5-LF schemes
%% from J. Comp. Phys. 126, pp. 202-228 (1996) by Jiang and Shu
%% "Efficient Implementation of Weighted ENO Schemes"
function WENO_Buckley_Leverett
close all; clc;
global dx

% Spatial variable interval (-1, 1) from (8.1) example 2
x = linspace(-1.0, 1.0, 80);
N = length(x);
dx = x(2)-x(1);

% Initial conditions for 1D Buckey-Leverett problem
u0(1:N) = 0.0;
u0((N/4):(N/2)) = 1.0;

% Time interval (as in Example 2)
t = linspace(0.0, 0.4, 100);

% Solve MOL ODEs system for WENO3-LF and WENO5-LF schemes with RKF45 solver
tic;
[ZZ, u1] = ode45(@MOL_WENO3, t, u0);
[ZZ, u2] = ode45(@MOL_WENO5, t, u0);
toc

% Plot each solution
for I=1:100
    plot(x, u0, 'b-', x, u1(I,:), 'ro', x, u2(I,:), 'k-', 'LineWidth', 2);
    legend('Initial', 'MOL + WENO3-LF', 'MOL + WENO5-LF', 'Location', 'NorthEast');
    axis([x(1) x(end) 0 1.1]);
    grid on;
    pause(0.01)
    drawnow;
end

%% Buckey-Leverett flux F(u)
function res = Flux(u)
res = 4*u.^2./(4*u.^2+(1-u).^2);

%% Exact expression for partial derivative from F(u) by u
function res = Jacobian(u)
res = 8*u.*(1-u)./(5*u.^2-2*u+1).^2;

%% MOL ODEs for semi-discrete Buckley-Leverett equation with WENO3 flux
%% reconstruction
function [res] = MOL_WENO3(t, u)
global dx

N = length(u);   I = 2:(N+1);

% Preallocate memory and add ghost nodes at the ends
U(1) = u(1); U(I) = u(I-1); U(N+2) = u(end); U(N+3) = u(end);
alpha1 = zeros(size(U)); alpha2 = zeros(size(U)); 
R_minus = zeros(size(U)); R_plus = zeros(size(U)); 

% Lax-Friedrichs (LF) flux splitting
a = max(abs(Jacobian(U)));
Fp = 0.5*( Flux(U) + a*U ); Fm = 0.5*( Flux(U) - a*U );

% WENO3 "right" flux reconstruction
alpha1(I) = (1/3)./(eps + (Fp(I)-Fp(I-1)).^2).^2;   alpha2(I) = (2/3)./(eps + (Fp(I+1)-Fp(I)).^2).^2;
omega1 = alpha1./(alpha1 + alpha2);  omega2 = alpha2./(alpha1 + alpha2);
R_plus(I) = omega1(I).*(3/2*Fp(I) - 1/2*Fp(I-1)) + omega2(I).*(1/2*Fp(I) + 1/2*Fp(I+1));

% WENO3 "left" flux reconstruction
alpha1(I) = (1/3)./(eps + (Fm(I+2)-Fm(I+1)).^2).^2;   alpha2(I) = (2/3)./(eps + (Fm(I+1)-Fm(I)).^2).^2;   
omega1 = alpha1./(alpha1 + alpha2);  omega2 = alpha2./(alpha1 + alpha2);
R_minus(I) = omega1(I).*(3/2*Fm(I+1) - 1/2*Fm(I+2)) + omega2(I).*(1/2*Fm(I) + 1/2*Fm(I+1));

% Combine fluxes and find finite volume spatial derivative
res(I-1) = -(R_plus(I)+R_minus(I)-R_plus(I-1)-R_minus(I-1))/dx;
res = res';

%% MOL ODEs for semi-discrete Buckley-Leverett equation with WENO5 flux
%% reconstruction
function [res] = MOL_WENO5(t, u)
global dx

N = length(u);   I = 3:(N+2);

% Preallocate memory and add ghost nodes at the ends
U(1) = u(1); U(2) = u(1); U(I) = u(I-2); U(N+3) = u(end); U(N+4) = u(end); U(N+5) = u(end);
alpha1 = zeros(size(U)); alpha2 = zeros(size(U)); alpha3 = zeros(size(U));
beta1 = zeros(size(U)); beta2 = zeros(size(U)); beta3 = zeros(size(U));
R_minus = zeros(size(U)); R_plus = zeros(size(U)); 

% Lax-Friedrichs (LF) flux splitting
a = max(abs(Jacobian(U)));
Fp = 0.5*( Flux(U) + a*U ); Fm = 0.5*( Flux(U) - a*U );

% WENO5 "right" flux reconstruction
beta1(I) = (13.0/12.0)*(Fp(I) - 2.0*Fp(I+1) + Fp(I+2)).^2 ...
         + (1.0/4.0)*(3.0*Fp(I) - 4.0*Fp(I+1) + Fp(I+2)).^2;
beta2(I) = (13.0/12.0)*(Fp(I-1) - 2.0*Fp(I) + Fp(I+1)).^2 ... 
         + (1.0/4.0)*(Fp(I-1) - Fp(I+1)).^2;
beta3(I) = (13.0/12.0)*(Fp(I-2) - 2.0*Fp(I-1) + Fp(I)).^2 ...
         + (1.0/4.0)*(Fp(I-2) - 4.0*Fp(I-1) + 3.0*Fp(I)).^2;

alpha1(I) = (3.0/10.0)./(eps + beta1(I)).^2;
alpha2(I) = (3.0/5.0)./(eps + beta2(I)).^2;
alpha3(I) = (1.0/10.0)./(eps + beta3(I)).^2;

omega1 = alpha1./(alpha1 + alpha2 + alpha3);
omega2 = alpha2./(alpha1 + alpha2 + alpha3);
omega3 = alpha3./(alpha1 + alpha2 + alpha3);

R_plus(I) = omega1(I).*(1.0/3.0*Fp(I) + 5.0/6.0*Fp(I+1) - 1.0/6.0*Fp(I+2)) ...
          + omega2(I).*(-1.0/6.0*Fp(I-1) + 5.0/6.0*Fp(I) + 1.0/3.0*Fp(I+1)) ...
          + omega3(I).*(1.0/3.0*Fp(I-2) - 7.0/6.0*Fp(I-1) + 11.0/6.0*Fp(I));

% WENO5 "left" flux reconstruction
beta1(I) = (13.0/12.0)*(Fm(I+1) - 2.0*Fm(I+2) + Fm(I+3)).^2 ...
         + (1.0/4.0)*(3.0*Fm(I+1) - 4.0*Fm(I+2) + Fm(I+3)).^2;
beta2(I) = (13.0/12.0)*(Fm(I) - 2.0*Fm(I+1) + Fm(I+2)).^2 ...
         + (1.0/4.0)*(Fm(I) - Fm(I+2)).^2;
beta3(I) = (13.0/12.0)*(Fm(I-1) - 2.0*Fm(I) + Fm(I+1)).^2 ...
         + (1.0/4.0)*(Fm(I-1) - 4.0*Fm(I) + 3.0*Fm(I+1)).^2;

alpha1 = (1.0/10.0)./(eps + beta1).^2;
alpha2 = (3.0/5.0)./(eps + beta2).^2;
alpha3 = (3.0/10.0)./(eps + beta3).^2;

omega1 = alpha1./(alpha1 + alpha2 + alpha3);
omega2 = alpha2./(alpha1 + alpha2 + alpha3);
omega3 = alpha3./(alpha1 + alpha2 + alpha3);

R_minus(I) = omega1(I).*(1.0/3.0*Fm(I+3) - 7.0/6.0*Fm(I+2) + 11.0/6.0*Fm(I+1)) ...
           + omega2(I).*(-1.0/6.0*Fm(I+2) + 5.0/6.0*Fm(I+1) + 1.0/3.0*Fm(I)) ...
           + omega3(I).*(1.0/3.0*Fm(I+1) + 5.0/6.0*Fm(I) - 1.0/6.0*Fm(I-1));

% Combine fluxes and find finite volume spatial derivative
res(I-2) = -(R_plus(I)+R_minus(I)-R_plus(I-1)-R_minus(I-1))/dx;
res = res';
