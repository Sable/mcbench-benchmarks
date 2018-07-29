function p = parameters(settings)
% function p = parameters creates symbolic motorcycle parameter data.
%
% function p = parameters(settings) creates specific parameter data.
%   settings can have the following values:
%   'dummy'         - dummy motorcycle parameters are created
%   'srad'          - my srad parameters
%   'gsxr1000 k7'   - my gsx r1000 parameters
%   'FJR1300'       - FJR1300 measured by TNO
%   'FZ1'           - FZ1 measured by TNO
% note that bike parameters depend on current suspension settings and 
% addons such as navigation equipment and buddyseat content 
%
% feel free to add your own set of parameters
%
% parameter definitions:
%         % rear wheel parameters
%             % parameters relating to the shape
%                 p.a1 ; % crown radius
%                 p.b1 ; % centerline radius
% 
%             % dynamic parameters
%                 p.m1 ; % mass
%                 p.i1 ; % inertia around rotation axis
%                 P.j1 ; % inertia around the other two axes
% 
%             % parameters relating to the interaction forces
%                 p.f1 ; % friction coefficient
%                 p.e1 ; % rolling resistance coefficient
%                 p.k1 ; % normal force stiffness
%                 p.d1 ; % normal force damping
%                 p.t1 ; % tangential stiffness (for numerical stability)
%
%         % rear suspension parameters
%             % shape parameters
%                 p.l2  ; % swingarm length
% 
%             % dynamic parameters
%                 p.m2 ; % mass
%                 p.x2 ; % mass local x position
%                 p.i2 ; % inertia (average inertia to reduce parameter set)
% 
%             % parameters relating to the interaction forces
%                 p.t2 ; % top end
%                 p.b2 ; % bottom end
%                 p.p2 ; % preload damping
%                 p.d2 ; % compression damping
%                 p.e2 ; % rebound damping
%                 p.k2 ; % spring stiffness
%                 p.n2 ; % spring progressiveness
%                 p.f2 ; % friction coefficient
% 
%         % main frame parameters (sprung)
%             % shape parameters
%                 p.l3 ; % frame length (perpendicular distance from 
%                        % steering head to swingarm rotation point)
% 
%             % dynamic parameters
%                 p.m3 ; % mass
%                 p.x3 ; % mass local x position
%                 p.z3 ; % mass local z position
%                 p.i3 ; % inertia (average inertia to reduce parameter set)
%                 p.k3 ; % frame torsion stiffness (together with fork and swingarm)
%                 p.d3 ; % frame torsion damping (together with fork and swingarm)
%
%         % steering head parameters (sprung)
%             % shape parameters
%                 p.l4 ; % fork offset
% 
%             % dynamic parameters
%                 p.m4 ; % mass
%                 p.x4 ; % mass local x position
%                 p.z4 ; % mass local z position
%                 p.i4 ; % inertia (average inertia to reduce parameter set)
% 
%         % front fork/suspension parameters (unsprung)
%             % dynamic parameters
%                 p.m5 ; % mass
%                 p.x5 ; % mass local x position
%                 p.z5 ; % mass local z position
%                 p.i5 ; % inertia (average inertia to reduce parameter set)
% 
%             % parameters relating to the interaction forces
%                 p.t5 ; % top end
%                 p.b5 ; % bottom end
%                 p.p5 ; % preload damping
%                 p.d5 ; % compression damping
%                 p.e5 ; % rebound damping
%                 p.k5 ; % spring stiffness
%                 p.n5 ; % spring progressiveness
%                 p.f5 ; % friction coefficient
% 
%         % front wheel parameters
%             % parameters relating to the shape
%                 p.a6 ; % crown radius
%                 p.b6 ; % centerline radius
% 
%             % dynamic parameters
%                 p.m6 ; % mass
%                 p.i6 ; % inertia around rotation axis
%                 P.j6 ; % inertia around the other two axes
% 
%             % parameters relating to the interaction forces
%                 p.f6 ; % friction coefficient
%                 p.e6 ; % rolling resistance coefficient
%                 p.k6 ; % normal force stiffness
%                 p.d6 ; % normal force damping
%                 p.t6 ; % tangential stiffness (for numerical stability)
% 
% 
%          % 56 parameters in total       
% 
% 
%         % not included in this model
%             % - inertia orientation
%             % - brake dynamics (e.g. brake fluid pressure build up time)
%             % - engine dynamics (e.g. drivetrain gyroscopic effects, fuel usage, chain slack
%             %                         gear position, engine rpm, throttle valve, engine map)
%             % - clutch dynamics
%             % - temperature (tyres, engine oil, cylinder head, coolant)
%             % - tyre pressure effects
%             % - air drag / lift
%             % - road profile
%             % - driver
% 
%         % included in this model
%             % - sag
%             % - camber thrust
%             % - suspension dynamics
%             % - tyre dynamics (on a flat surface)
%             % - gyroscopic and coriolis effects
%
%
% for more information, contact W.Ooms; wesleyooms@gmail.com
%
% comments:
%   Motorcycle tyre is simplified by a torus.
%
%   optimization problem :
%                           - maximize(model accuracy)
%                           - minimize(number of model parameters)
%
% external forces:
%           - V contact patch normal force
%           - V contact patch tangential force (2 to include camber thrust)
%           - X lift and drag
% questionables:
%           - steering torque
%           - brake torque
%           - engine torque

if nargin < 1
    syms pa1 pb1 pm1 pi1 pj1 pf1 pe1 pk1 pd1 pt1 pm2 px2 pi2 pz2 pt2 pb2 pp2 pd2 pe2 pk2 pn2 pf2 pl2
    syms pa6 pb6 pm6 pi6 pj6 pf6 pe6 pk6 pd6 pt6 pm5 px5 pi5 pz5 pt5 pb5 pp5 pd5 pe5 pk5 pn5 pf5
    syms pl3 pm3 px3 pz3 pi3 pk3 pd3 pl4 pm4 px4 pz4 pi4 pk4 pd4
% rear wheel parameters
    % parameters relating to the shape
        p.a1 = pa1 ; % crown radius
        p.b1 = pb1 ; % centerline radius
    % dynamic parameters
        p.m1 = pm1 ; % mass
        p.i1 = pi1 ; % inertia around rotation axis
        P.j1 = pj1 ; % inertia around the other two axes
    % parameters relating to the interaction forces
        p.f1 = pf1 ; % friction coefficient
        p.e1 = pe1 ; % rolling resistance coefficient
        p.k1 = pk1 ; % normal force stiffness
        p.d1 = pd1 ; % normal force damping
        p.t1 = pt1 ; % tangential stiffness (for numerical stability)

% rear suspension parameters
    % shape parameters
        p.l2 = pl2 ; % swingarm length
    % dynamic parameters
        p.m2 = pm2 ; % mass
        p.x2 = px2 ; % mass local x position
        p.i2 = pi2 ; % inertia (average inertia to reduce parameter set)
    % parameters relating to the interaction forces
        p.t2 = pt2 ; % top end
        p.b2 = pb2 ; % bottom end
        p.p2 = pp2 ; % preload damping
        p.d2 = pd2 ; % compression damping
        p.e2 = pe2 ; % rebound damping
        p.k2 = pk2 ; % spring stiffness
        p.n2 = pn2 ; % spring progressiveness
        p.f2 = pf2 ; % friction coefficient

% main frame parameters (sprung)
    % shape parameters
        p.l3 = pl3 ; % frame length (perpendicular distance from steering head to swingarm rotation point)
    % dynamic parameters
        p.m3 = pm3 ; % mass
        p.x3 = px3 ; % mass local x position
        p.z3 = pz3 ; % mass local z position
        p.i3 = pi3 ; % inertia (average inertia to reduce parameter set)
        p.k3 = pk3 ; % frame torsion stiffness (together with fork and swingarm)
        p.d3 = pd3 ; % frame torsion damping (together with fork and swingarm)
        
% steering head parameters (sprung)
    % shape parameters
        p.l4 = pl4 ; % fork offset
    % dynamic parameters
        p.m4 = pm4 ; % mass
        p.x4 = px4 ; % mass local x position
        p.z4 = pz4 ; % mass local z position
        p.i4 = pi4 ; % inertia (average inertia to reduce parameter set)

% front fork/suspension parameters (unsprung)
    % dynamic parameters
        p.m5 = pm5 ; % mass
        p.x5 = px5 ; % mass local x position
        p.z5 = pz5 ; % mass local z position
        p.i5 = pi5 ; % inertia (average inertia to reduce parameter set)
    % parameters relating to the interaction forces
        p.t5 = pt5 ; % top end
        p.b5 = pb5 ; % bottom end
        p.p5 = pp5 ; % preload damping
        p.d5 = pd5 ; % compression damping
        p.e5 = pe5 ; % rebound damping
        p.k5 = pk5 ; % spring stiffness
        p.n5 = pn5 ; % spring progressiveness
        p.f5 = pf5 ; % friction coefficient

% front wheel parameters
    % parameters relating to the shape
        p.a6 = pa6 ; % crown radius
        p.b6 = pb6 ; % centerline radius
    % dynamic parameters
        p.m6 = pm6 ; % mass
        p.i6 = pi6 ; % inertia around rotation axis
        P.j6 = pj6 ; % inertia around the other two axes
    % parameters relating to the interaction forces
        p.f6 = pf6 ; % friction coefficient
        p.e6 = pe6 ; % rolling resistance coefficient
        p.k6 = pk6 ; % normal force stiffness
        p.d6 = pd6 ; % normal force damping
        p.t6 = pt6 ; % tangential stiffness (for numerical stability)
else
    switch settings
        case 'dummy'
        % rear wheel parameters
            % parameters relating to the shape
                p.a1 = .09 ; % crown radius
                p.b1 = .3149-.09 ; % centerline radius
            % dynamic parameters
                p.m1 = 16.85 ; % mass
                p.i1 = .8380 ; % inertia around rotation axis
                p.j1 = .4796 ; % inertia around the other two axes
            % parameters relating to the interaction forces
                p.f1 = 20 ; % friction coefficient
                p.e1 = 1 ; % rolling resistance coefficient
                p.k1 = 1e6 ; % normal force stiffness
                p.d1 = 1500 ; % normal force damping
                p.t1 = 1 ; % tangential stiffness (for numerical stability)

        % rear suspension parameters
            % shape parameters
                p.l2 = 0.5675 ; % swingarm length
            % dynamic parameters
                p.m2 = 19.31 ; % mass
                p.x2 = .2 ; % mass local x position
                p.i2 = .8 ; % inertia (average inertia to reduce parameter set)
            % parameters relating to the interaction forces
                p.t2 = 1 ; % top end
                p.b2 = 1000 ; % bottom end
                p.p2 = 1 ; % preload damping
                p.d2 = 1 ; % compression damping
                p.e2 = 1 ; % rebound damping
                p.k2 = 20000 ; % spring stiffness
                p.n2 = 1 ; % spring progressiveness
                p.f2 = 1 ; % friction coefficient

        % main frame parameters (sprung)
            % shape parameters
                p.l3 = 0.81663099159224 ; % frame length (perpendicular distance from steering head to swingarm rotation point)
            % dynamic parameters
                p.m3 = 224.2+78.13 ; % mass
                p.x3 = .31 ; % mass local x position
                p.z3 = 0.3 ; % mass local z position
                p.i3 = 30 ; % inertia (average inertia to reduce parameter set)
                p.k3 = 1e9 ; % frame torsion stiffness (together with fork and swingarm)
                p.d3 = 1 ; % frame torsion damping (together with fork and swingarm)

        % steering head parameters (sprung)
            % shape parameters
                p.l4 = 0.0198 ; % fork offset
            % dynamic parameters
                p.m4 = 9.09 ; % mass
                p.x4 = 0.036 ; % mass local x position
                p.z4 = 0.2235 + 0.09985863931372 ; % mass local z position
                p.i4 = .5 ; % inertia (average inertia to reduce parameter set)

        % front fork/suspension parameters (unsprung)
            % dynamic parameters
                p.m5 = 9.02 ; % mass
                p.x5 = -0.0114 ; % mass local x position
                p.z5 = 0.15 ; % mass local z position
                p.i5 = .3 ; % inertia (average inertia to reduce parameter set)
            % parameters relating to the interaction forces
                p.t5 = .5 ; % top end
                p.b5 = .3 ; % bottom end
                p.p5 = 0.45 ; % preload damping
                p.d5 = 6500 ; % compression damping
                p.e5 = 12000 ; % rebound damping
                p.k5 = 15000 ; % spring stiffness
                p.n5 = 1 ; % spring progressiveness
                p.f5 = 1 ; % friction coefficient

        % front wheel parameters
            % parameters relating to the shape
                p.a6 = .06 ; % crown radius
                p.b6 = .2999-.06 ; % centerline radius
     
            % dynamic parameters
                p.m6 = 13.57 ; % mass
                p.i6 = .5020 ; % inertia around rotation axis
                p.j6 = .333 ; % inertia around the other two axes
            % parameters relating to the interaction forces
                p.f6 = 20 ; % friction coefficient
                p.e6 = 1 ; % rolling resistance coefficient
                p.k6 = 1 ; % normal force stiffness
                p.d6 = 1 ; % normal force damping
                p.t6 = 2000 ; % tangential stiffness (for numerical stability)
                
                p.i1 = .8380 ; % inertia around rotation axis
                p.j1 = .4796 ; % inertia around the other two axes
                p.i2 = .8 ; % inertia (average inertia to reduce parameter set)
                p.i3 = 30 ;
                p.i4 = .5 ;
                p.i5 = .3 ;
                p.i6 = .5020 ;
                p.j6 = .333 ;
                p.m1 = 16.85 ;
                p.m2 = 19.31 ;
                p.m3 = 240 ;
                p.m4 = 9.09 ;
                p.m5 = 9.02 ;
                p.m6 = 13.57 ;
%                 p.m1 = 1e-8 ;
%                 p.m2 = 1e-8 ;
%                 p.m3 = 1e-8 ;
%                 p.m4 = 1e-8 ;
%                 p.m5 = 9.02 ;
%                 p.m6 = 1e-8 ;
p.u7 = rand ;
p.v7 = rand ;
p.w7 = rand ;
p.x7 = rand ; % x-position IMU sensor
p.y7 = rand ;
p.z7 = rand ;


    case 'srad'
        p='not available :p';
    case 'gsxr1000 k7'
        p='not available :p';
    case 'FJR1300'
        p='not sure if i am allowed to share'
    case 'FZ1'
        p='not sure if i am allowed to share'
    otherwise
        p='bad input argument';
    end
end
