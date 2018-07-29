%GM_PHD_Simulate_Measurements
%Last modified 27th August 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file generates simulated measurement data for  the simulation
%described in Vo&Ma.
%There will be gaussian noise on the measurement and Poisson-distributed clutter
%in the environment. 
%Note: It is possible to get no measurements if the target is not detected
%and there is no clutter

%If you want to use this PHD filter implementation for another problem, you
%will need to replace this function with another one that populates Z,
%zTrue, and simMeasurementHistory (Z is used in a lot of the update code,
%zTrue and simMeasurementHistory are used in GM_PHD_Simulate_Plot)

s = sprintf('Step Sim: Simulating measurements.');
disp(s);

%Simulate target movement
simTarget1State = F * simTarget1State;
simTarget2State = F * simTarget2State;
if(~isempty(simTarget3State))
    simTarget3State = F * simTarget3State;
end
%Spawn target 3 when k = 66
if(k == simTarget3SpawnTime)
    simTarget3State = simTarget1State;
    simTarget3State(3:4) = simTarget3Vel;
end
if(k > simTarget3SpawnTime)
    simTarget3State = F * simTarget3State;
end

%Save target movement for plotting
simTarget1History = [simTarget1History, simTarget1State];
simTarget2History = [simTarget2History, simTarget2State];
simTarget3History = [simTarget3History, simTarget3State];

%First, we generate some clutter in the environment.
clutter = zeros(2,nClutter);%The observations are of the form [x; y]
for i = 1:nClutter
    clutterX = rand * (xrange(2) - xrange(1)) + xrange(1); %Random number between xrange(1) and xrange(2), uniformly distributed.
    clutterY = rand * (yrange(2) - yrange(1)) + yrange(1); %Random number between yrange(1) and yrange(2), uniformly distributed.
    
    clutter(1,i) = clutterX;
    clutter(2,i) = clutterY;
end

%We are not guaranteed to detect the target - there is only a probability
detect1 = rand;
detect2 = rand;
detect3 = rand;
if(detect1 > prob_detection)
    measX1 = [];
    measY1 = [];
else
    measX1 = simTarget1State(1) + sigma_r * randn * noiseScaler;
    measY1 = simTarget1State(2) + sigma_r * randn * noiseScaler;
end
if(detect2 > prob_detection)
    measX2 = [];
    measY2 = [];
else
    measX2 = simTarget2State(1) + sigma_r * randn * noiseScaler;
    measY2 = simTarget2State(2) + sigma_r * randn * noiseScaler;
end

if(k >= simTarget3SpawnTime) && (detect3 <= prob_detection)
    measX3 = simTarget3State(1) + sigma_r * randn * noiseScaler;
    measY3 = simTarget3State(2) + sigma_r * randn * noiseScaler;
else
    measX3 = [];
    measY3 = [];
end

%Generate true measurement
Z = [ [measX1 measX2 measX3]; [measY1 measY2 measY3] ];
zTrue = Z;%Store for plotting

%Append clutter
Z = [Z, clutter];

%Store history
simMeasurementHistory{k} =  Z;





