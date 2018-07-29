function ParamStruct = QuarterCarInit(side)
%% SLAGeometryData
%
% This file contains all the kinematic and dynamic parameters
% necessary to define the LEFT FRONT double wishbone - or short
% long arm - suspension corner for a generic automobile. 
% This file needs to be loaded before running a simulation
% with the quarter car suspension model in SLASuspension.mdl
% All parameters are defined using SI units.
% 
% The MathWorks
% Author: Guy Rouleau
% Date: November 2008

if strcmp(side,'left')
    D = -1;
elseif strcmp(side,'right')
    D=1;
else
    error('Input must be left or right')
end


%% General Vehicle Parameters
Vehicle.HalfTrack = 1;                          % m
Vehicle.RideHeight = 0.3;                       % m
%% Frame parameters

Frame.Mass = 300;                               % kg
Frame.Inertia = eye(3);
Frame.CG = [0 0 Vehicle.RideHeight];            % m WRT World
Frame.LCAFrontMount = [-0.1 D*0.54 -0.15];       % m WRT Frame CG
Frame.LCARearMount = [0.1 D*0.54 -0.15];         % m WRT Frame CG
Frame.UCAFrontMount = [-0.1 D*0.65 0.1];         % m WRT Frame CG
Frame.UCARearMount = [0.1 D*0.65 0.1];           % m WRT Frame CG
Frame.SteeringBar = [-0.2 D*0 .05];
Frame.ShockMount = [ 0 D*.67 .25];
%% UCA Parameters
UCA.CG = [0.1 D*0.20 0];             % Position of CG relative to UCA Front Mount Attach Point
UCA.RearMount = [0.20 D*0 0];        % Position of Rear Mount Attach Point relative to UCA Front Mount Attach Point
UCA.Spindle = [0 D*0.35 0];          % Position of Spindle Attach Point relative to UCA Front Mount Attach Point
UCA.Mass = 2;
UCA.Inertia = 0.1*eye(3);

%% Lower Control Arm Parameters
LCA.CG =        [0.1 D*0.20 0];             % Position of CG relative to LCA Front Mount Attach Point
LCA.RearMount = [0.20 D*0 0];        % Position of Rear Mount Attach Point relative to LCA Front Mount Attach Point
LCA.Spindle =   [0 D*0.43 0];          % Position of Spindle Attach Point relative to LCA Front Mount Attach Point
LCA.ShockMountPoint = [0.1 D*0.20 0];
LCA.Mass = 3;    
LCA.Inertia = 0.1*eye(3);

%% Spindle Parameters
Spindle.Mass = 5;               % kg
Spindle.Inertia = 0.1*eye(3);
Spindle.CG = [0 D*0 -0.1 ];
Spindle.LowerAttachPoint  = [ 0 D*0 -0.2];
Spindle.DirRodAttachPoint = [ -0.1 D*0 0];
Spindle.WheelAttachPoint  = [ 0 D*0.05 -0.1];

%% Tire parameters
Tire.Mass = 20;                                 % kg
Tire.Inertia = 0.1*eye(3);
Tire.Radius = 0.3;                              % m
Tire.offset = D*0.1;
Tire.YaxisCoeff = 250000;
Tire.MaxContactForce = 10000;
% Tire.Stiffness = 250000;                        % N/m
% Tire.Damping = 500;                             % N-s/m


%% Shock Absorber Properties
Shock.Mass = 10;                % kg
Shock.InitAxis = (Frame.LCAFrontMount + LCA.ShockMountPoint) - Frame.ShockMount; 
Shock.InitAxisNormalized = Shock.InitAxis/norm(Shock.InitAxis);


%% Total Corner Mass
Vehicle.Mass = Frame.Mass + UCA.Mass + ...
                    LCA.Mass + Shock.Mass + ...
                    Spindle.Mass + Tire.Mass;
                
                
%% Suspension Bumps dynamics
Shock.bump.c = 3500;          % N-s/m
Shock.bump.k = 1500000;        % N/m
Shock.bump.Compression = -0.1;
Shock.bump.Extension = -0.04;

%% Spring
Shock.spring.k1 = 75000;
Shock.spring.k2 = 0;

%% shock
Shock.cpos = 7500;
Shock.cneg = 7500;

%% Spring Initial deformation

zAxis = [0 0 1];
theta = acos(dot(zAxis,-Shock.InitAxisNormalized));
Fs = (Frame.Mass*9.81 * LCA.Spindle(2) / LCA.ShockMountPoint(2))/cos(theta) ;
Shock.InitDef = Fs/Shock.spring.k1;


%% Ground
Ground.k = 1000000;
Ground.c = 1000;

%% Reassignment
ParamStruct.Vehicle     = Vehicle;
ParamStruct.Frame       = Frame;
ParamStruct.LCA         = LCA;
ParamStruct.UCA         = UCA;
ParamStruct.Spindle     = Spindle;
ParamStruct.Tire        = Tire;
ParamStruct.Shock       = Shock;
ParamStruct.Ground      = Ground;

