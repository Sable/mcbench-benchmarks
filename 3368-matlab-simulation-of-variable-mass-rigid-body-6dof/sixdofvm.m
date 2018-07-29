function [t,y] = sixdofvm(Forces, Moments, dMass, dInertia, tarray, varargin )
% SIXDOFVM Calculate aircraft variable-mass rigid-body six-degrees-of-freedom 
% equations of motion using MATLAB ODE45 solver.
%
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Inputs:
% =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
% Forces = 3x1 vector of forces in body coordinates
% Moments = 3x1 vectory of moments in body coordinates
% dMass = mass rate of change for the aircraft
% dInertia = 3x3 Inertia Tensor matrix rate of change
% tarray = time series vector
%
% OPTIONAL INPUTS:
% Ipos_i = 3x1 vector of initial position
% Ivel_b = 3x1 vector of initial velocity (body)
% Irates_b = 3x1 vector of initial body rates
% Imass = initial mass of aircraft
% IInertia = initial 3x3 Inertia Tensor matrix
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
% An example of how to call sixdofvm
% 
% Ipos_i = [10 20 100];
% Ivel_b = [30 10 20];
% Ieuler = [0 0 0];
% Irates_b = [1 1 1];
% Imass = 1.0;
% IInertia = eye(3);
% Moments = [1 1 1]';
% Forces = [10 5 8]';
% dmass = -0.01;
% dinertia = -0.01*ones(3);
% tout = 1:100;
% 
% [t_expected,y_expected]=sixdofvm(Forces,Moments,dmass,dinertia,tout,Ipos_i, ...
%                                  Ivel_b,Irates_b,Imass,IInertia,Ieuler);
   
if nargin < 5 
    error('Less than the minimum 5 inputs.')
elseif nargin > 11 
    error('More than maximum 11 inputs.')
else
    switch nargin
    case 5
        Ipos_i = [0 0 0];
        Ivel_b = [0 0 0];
        Irates_b = [0 0 0];
        Imass = 1.0;
        IInertia = eye(3);
        Ieuler = [0 0 0];
    case 6
        Ipos_i = varargin{1};
        Ivel_b = [0 0 0];
        Irates_b = [0 0 0];
        Imass = 1.0;
        IInertia = eye(3);
        Ieuler = [0 0 0];
    case 7
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = [0 0 0];
        Imass = 1.0;
        IInertia = eye(3);
        Ieuler = [0 0 0];
    case 8
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = varargin{3};
        Imass = 1.0;
        IInertia = eye(3);
        Ieuler = [0 0 0];
    case 9
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = varargin{3};
        Imass = varargin{4};
        IInertia = eye(3);
        Ieuler = [0 0 0];
    case 10
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = varargin{3};
        Imass = varargin{4};
        IInertia = varargin{5};
        Ieuler = [0 0 0];
    case 11
        Ipos_i = varargin{1};
        Ivel_b = varargin{2};
        Irates_b = varargin{3};
        Imass = varargin{4};
        IInertia = varargin{5};
        Ieuler = varargin{6};
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

if Imass <= 0
    error('Mass should be a positive non-zero value.')    
else
    y0 = [Irates_b Ivel_b Ipos_i Imass reshape(IInertia,1,9)];
    options = odeset('MaxStep',1/50,'Mass',@masscvm,...
                     'MStateDependence','strong');   
    [t,y] = ode45(@fcvm,tarray,y0,options,Forces,dMass,Moments,dInertia);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dydt = fcvm(t,y,Forces,dMass,Moments,dInertia)

% dydt(1:3) = rates_dot
% dydt(4:6) = accel
% dydt(7:9) = vel
% dydt(10) = dMass
% dydt(11:19) = dInertia
% y(1:3) = rates
% y(4:6) = vel
% y(7:9) = pos
% y(10) = Mass
% y(11:19) = Inertia

dydt = [Moments - cross(y(1:3),reshape(y(11:19),3,3)*y(1:3)) ...
        - dInertia*y(1:3); ... 
        Forces - y(10)*cross(y(1:3),y(4:6)) - dMass*y(4:6); ...
        y(4:6);...
        dMass;...
        reshape(dInertia,9,1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function M = masscvm(t,y,Forces,dMass,Moments,dInertia)

% Compute mass matrix 
M = zeros(19,19);

M(1,1) = y(11);
M(1,2) = y(14);
M(1,3) = y(17);
M(2,1) = y(12);
M(2,2) = y(15);
M(2,3) = y(18);
M(3,1) = y(13);
M(3,2) = y(16);
M(3,3) = y(19);

M(4,4) = y(10);
M(5,5) = y(10);
M(6,6) = y(10);

M(7,7) = 1;
M(8,8) = 1;
M(9,9) = 1;
M(10,10) = 1;
M(11,11) = 1;
M(12,12) = 1;
M(13,13) = 1;
M(14,14) = 1;
M(15,15) = 1;
M(16,16) = 1;
M(17,17) = 1;
M(18,18) = 1;
M(19,19) = 1;

