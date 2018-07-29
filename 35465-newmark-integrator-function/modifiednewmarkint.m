function [x, xdot, x2dot] = modifiednewmarkint(M, C, K, R, x0, xdot0, ...
    t, varargin)
%Newmark's Direct Integration Method
%--------------------------------------------------------------------------
% Code written by : - Siva Srinivas Kolukula                              |
%                     Senior Research Fellow                              |
%                     Structural Mechanics Laboratory                     |
%                     Indira Gandhi Center for Atomic Research            |
%                     INDIA
%                   - Hamed Nokhostin                                     |
%                     B.S. Student                                        |
%                     Mechanical Engineering Faculty                      |
%                     K.N.Toosi Uiversity of Technoloygy                  |
%                     I.R.Iran                                            |
% E-mail : allwayzitzme@gmail.com
%          h_nokhostin@yahoo.com                                          |
%-------------------------------------------------------------------------
% PURPOSE
%        ???
% SYNTAX
%        [x, xdot, x2dot] = newmarkint(M, C, K, R, x0, xdot0, t, varargin)
% INPUT
%        [M] :       System Mass              [n,n]
%        [C] :       System Damping           [n,n]
%        [K] :       System Stiffness         [n,n]
%        [R] :       Externally Applied Load  [n,nt]
%        [x0] :      Initial Position         [n,1]
%        [xdot0] :   Initial Velocity         [n,1]
%        [t] :       Time Vector              [1,nt]
%        [varargin]: Options
%
% OUTPUT
%       [x]:        Displacemente Response   [n,nt]
%       [xdot]:     Velocity                 [n,nt]
%       [x2dot]:    Acceleration             [n,nt]
%
%
%  nt = number of time steps
%  n = number of nodes
% The options include changing the value of the "gamma" and "beta"
% coefficient which appear in the formulation of the method. By default
% these values are set to gamma = 1/2 and beta = 1/4.
%
% EXAMPLE
% To change nemark's coefficients, say to gamma = 1/3 and beta = 1/5, 
% the syntax is:
%       [u, udot, u2dot] = newmark_int(t,p,u0,udot0,m,k,xi, 1/3, 1/5)  
%
%-------------------------------------------------------------------------
if nargin == 7
    disp('Using default values:');
    disp('    gamma = 1/2');
    disp('    beta  = 1/4');
    gamma = 1 / 2;
    beta = 1 / 4;
elseif nargin == 9
    gamma = varargin{1};
    beta = varargin{2};
    disp('Using user''s values:');
    disp(['    gamma = ', num2str(alpha)]);
    disp(['    beta  = ', num2str(delta)]);
else
    error('Incorrect number of imput arguments');
end

dt = t(2) - t(1);
nt = fix((t(length(t) )- t(1)) / dt);
n = length(M);

% Constants used in Newmark's integration
a1 = gamma / (beta * dt);
a2 = 1 / (beta * dt ^ 2);
a3 = 1 / (beta * dt);
a4 = gamma / beta;
a5 = 1/(2 * beta);
a6 = (gamma / (2 * beta) - 1) * dt;


x = zeros(n,nt);
xdot = zeros(n,nt);
x2dot = zeros(n,nt);

% Initial Conditions
x(:, 1) = x0;
xdot(:, 1) = xdot0;
%R0 = zeros(n,1);
x2dot(:,1) = M \ (R(:, 1) - C * xdot(:, 1) - K * x(:, 1)) ;

Kcap = K + a1 * C + a2 * M;

a = a3 * M + a4 * C;
b = a5 * M + a6 * C;

% Tme step starts
for i = 1 : nt
    delR = R(:, i) + a * xdot(:, i) + b * x2dot(:, i);
    delx = Kcap \ delR ;
    delxdot = a1 * delx - a4 * xdot(:, i) - a6 * x2dot(:, i);
    delx2dot = a2 * delx - a3 * xdot(:, i) - a5 * x2dot(:, i);
    x(:, i + 1) = x(:, i) + delx;
    xdot(:, i + 1) = xdot(:, i) + delxdot;
    x2dot(:, i + 1) = x2dot(:, i) + delx2dot;
end