function [t,y] = sixdof(Forces, Moments, Mass, Inertia, tarray, varargin )
% SIXDOF  Calculate aircraft fixed-mass rigid-body six-degrees-of-freedom 
% equations of motion using MATLAB ODE45 solver.
%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Inputs:
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Forces = 3x1 vector of forces in body coordinates
% Moments = 3x1 vectory of moments in body coordinates
% Mass = fixed mass of the aircraft
% Inertia = 3x3 Inertia Tensor matrix
% tarray = time series vector
%
% OPTIONAL INPUTS:
% Ipos_i = 3x1 vector of initial position
% Ivel_b = 3x1 vector of initial velocity (body)
% Irates_b = 3x1 vector of initial body rates
% Ieuler = 3x1 vector of initial euler angles
%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Outputs:
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% t = simulation time
% y(1:3) = body rates
% y(4:6) = velocity in body coordinates
% y(7:9) = position in body coordinates
%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% An example of how to call sixdof
% 
% Ipos_i = [10 20 100];
% Ivel_b = [30 10 20];
% Ieuler = [0 0 0];
% Irates_b = [1 1 1];
% mass = 1.0;
% inertia = eye(3);
% Moments = [1 1 1]';
% Forces = [10 5 8]';
% tout = 1:100;
% 
% [t_expected,y_expected]=sixdof(Forces,Moments,mass,inertia,tout,Ipos_i, ...
%                                  Ivel_b,Irates_b,Ieuler);

if nargin < 5 
    error('Less than the minimum 5 inputs.')
elseif nargin > 9 
    error('More than maximum 9 inputs.')
else
    switch nargin
    case 5
        Ipos_i = [0 0 0];
        Ivel_b = [0 0 0];
        Irates_b = [0 0 0];
        Ieuler = [0 0 0];
    case 6
        Ipos_i = varargin{1};
        Ivel_b = [0 0 0];
        Irates_b = [0 0 0];
        Ieuler = [0 0 0];
    case 7
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = [0 0 0];
        Ieuler = [0 0 0];
    case 8
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = varargin{3};
        Ieuler = [0 0 0];
    case 9
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = varargin{3};
        Ieuler = varargin{4};
        % convert Ipos_i into body coordinates
        cph = cos(Ieuler(1));
        sph = sin(Ieuler(1));
        cth = cos(Ieuler(2));
        sth = sin(Ieuler(2));
        cps = cos(Ieuler(3));
        sps = sin(Ieuler(3));
        
        dcm = [cth*cps              cth*sps              -sth;...
               sph*sth*cps-cph*sps  sph*sth*sps+cph*cps  sph*cth; ...
               cph*sth*cps+sph*sps  cph*sth*sps-sph*cps  cph*cth];
        Ipos_i = dcm*Ipos_i;
    end   
end

if Mass <= 0
    error('Mass should be a positive non-zero value.')    
else
    y0 = [Irates_b Ivel_b Ipos_i];
    options = odeset('MaxStep',1/50); % set max step size to Simulink's
    [t,y] = ode45(@f,tarray,y0,options,Forces,Mass,Moments,Inertia);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dydt = f(t,y,Forces,Mass,Moments,Inertia)

% dydt(1:3) = rates_dot
% dydt(4:6) = accel
% dydt(7:9) = vel
% y(1:3) = rates
% y(4:6) = vel
% y(7:9) = pos

dydt = [inv(Inertia)*(Moments - cross(y(1:3),Inertia*y(1:3))); ... 
        Forces/Mass - cross(y(1:3),y(4:6)); ...
        y(4:6)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
