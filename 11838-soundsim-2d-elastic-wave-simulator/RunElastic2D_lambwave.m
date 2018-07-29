function [ CatchAline ] = RunElastic2D_lambwave( input_args )
% SoundSim - 2D Elastic Simulation - For Academic Use Only
% -------------------------------------------------------------------------------------
% Limited Feature Beta Release of a SoundSim (www.SoundSim.com)
% Please Send all Questions, Suggestions, and Comments to kevinrudd@SoundSim.com
% -------------------------------------------------------------------------------------
% Lamb Wave Example (Guided Elastic Wave)-
% An 5 cycle 0.68 MHz excitation on a 3.2mm thick Aluminum Plate.
% As the guided waves propagate down the plate, The first symmetric (So)
% and anti-symmetric Modes (Ao) separate and are easily distinguishable.
%
%
%                                                                                         Aprox. Material Values From
%                                                                                Stress Waves in Solids (H. Kolsky) Dover 1963
% Material Properties                                                                   Aluminum  Steel  Copper  Glass
p.cl = 6320;                         % Longitudinal Wave Speed (m/s)                     6320      5940   4560    5800
p.cs = 3100;                         % Sheer Wave Speed (m/s)                            3100      3220   2250    3350
p.den = 2700;                        % Material density (kg/m^3)                         2700      7800   8900    2500 
p.platethickness = 0.0032;           % plate thickness (meters)  (in x2-direction)
p.platelength    = 0.30;             % plate length (meters)     (in x1-direction)

% Driving Transducer Properties
% -- These parameters adust the transducer position, size, frequency, and drive function length
% -- of the driving transducer.  The transducer is on the top of the plate.  
p.tpos = 0.025;                      % transducer position  (meters) - from left side of the plate
p.tthickness = 0.001;                % transducer diameter  (meters) - this is 2D
p.tfreq = 680000;                    % frequency of transducer (Hertz) 
p.tpulselength = (5)*(1/(p.tfreq));  % transducer pulse length (seconds)

% Catch Transducer Properties
% -- These parameters adjust the catch transducer location and size.  Again, this transducer is 
% -- can only be placed on the top of the plate
p.catchtpos = 0.25;                  % catch transducer position  (meters) - from left side of the plate
p.catchtthickness = 0.001;           % catch transducer diameter  (meters) - this is 2D

% Other Params
p.abc = 40;                          % thickness of absorbing boundary layer (in simulation units ds) Only on left and right
p.plotevery = 3;                     % update the plot every <plotevery> timesteps
p.SimulationTime =.00012;            % siulation runtime (seconds)

p.plotmode = 'x2_velocity';          % plot mode ('abs_velocity' = absolute velocity);
                                     %           ('x1_velocity'  = velocity in the x1 position (left and right))
                                     %           ('x2_velocity'  = velocity in the x2 position (up and down))
                             
CatchAline=SoundSim_ElasticEngine2D( p );