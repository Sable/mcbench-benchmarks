function [u, udot, u2dot] = newmark_int(t,p,u0,udot0,m,k,xi,varargin)
%Newmark's Direct Integration Method
%--------------------------------------------------------------------------
% Integrates a 1-DOF system with mass "m", spring stiffness "k" and damping
% coeffiecient "xi", when subjected to an external load P(t).
% Returns the displacement, velocity and acceleration of the system with
% respect to an inertial frame of reference.
%
% SYNTAX
%       [u, udot, u2dot] = newmark_int(t,p,u0,udot0,m,k,xi,varargin)
%
% INPUT
%       [t] :       Time Vector             [n,1]
%       [p] :       Externally Applied Load [n,1]
%       [u0]:       Initial Position        [1,1]
%       [udot0]:    Initial Velocity        [1,1]
%       [m]:        System Mass             [1,1]
%       [k]:        System Stiffness        [1,1]
%       [xi]:       System Damping          [1,1]
%       [varargin]: Options
%
% OUTPUT
%       [u]:        Displacemente Response   [n,1]
%       [udot]:     Velocity                 [n,1]
%       [u2dot]:    Acceleration             [n,1]
%
%  N = number of time steps
%
% The options include changing the value of the "gamma" and "beta"
% coefficient which appear in the formulation of the method. By default
% these values are set to gamma = 1/2 and alpha = 1/4.
%
% EXAMPLE
% To change nemark's coefficients, say to gamma = 1/3 and alpha = 1/5, 
% the syntax is:
%       [u, udot, u2dot] = newmark_int(t,p,u0,udot0,m,k,xi, 1/3, 1/5)  
%
%==========================================================================
%                     2004 By: Jose Antonio Abell Mena  (ja.abell@gmail.com)
if nargin == 7
    disp('Using default values:');
    disp('    gamma = 1/2');
    disp('    beta  = 1/4');
    gam = 1/2;
    beta = 1/4;
else
    if nargin == 9
        beta = varargin{1};
        gam = varargin{2};
        
    else
        error('Incorrect number of imput arguments');
    end
end
wn = sqrt(k/m);
wd = 2*xi*wn;

dt = t(2) - t(1);
c = 2*xi*wn*m;

kgor = k + gam/(beta*dt)*c + m/(beta*dt^2);
a = m/(beta*dt) + gam*c/beta;
b = 0.5*m/beta + dt*(0.5*gam/beta - 1)*c;

dp = diff(p);
u = zeros(length(t),1); udot = u; u2dor = u;
u(1) = u0;
udot(1) = udot0;
u2dot(1) = 1/m*(p(1)-k*u0-c*udot0);

for i = 1:(length(t)-1)
    deltaP = dp(i) + a*udot(i) + b*u2dot(i);
    du_i = deltaP/kgor;
    dudot_i = gam/(beta*dt)*du_i - gam/beta*udot(i) + dt*(1-0.5*gam/beta)*u2dot(i);
    du2dot_i = 1/(beta*dt^2)*du_i - 1/(beta*dt)*udot(i) - 0.5/beta*u2dot(i);
    u(i+1) = du_i + u(i);
    udot(i+1) = dudot_i + udot(i);
    u2dot(i+1) = du2dot_i + u2dot(i);
end