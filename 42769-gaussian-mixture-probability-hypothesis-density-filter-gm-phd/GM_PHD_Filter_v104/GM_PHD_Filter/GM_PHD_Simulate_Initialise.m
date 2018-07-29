%GM_PHD_Simulate_Initialise
%Last modified 27th August 2013
%Matlab code by Bryan Clarke b.clarke@acfr.usyd.edu.au 

%This file initialises the simulation described in example 1 of Vo&Ma 2006.
%The velocity and starting position values are rough estimates obtained by visual
%inspection of the simulation. 
%They can probably be changed without things breaking.

%If you want to use this GM-PHD filter for your own problem, you will need
%to replace this script with your own.

%%Control parameters
noiseScaler = 1.0;       %Adjust the strength of the noise on the measurements by adjusting this. Useful for debugging.
nClutter = 50; %Assume 50 clutter measurements.

%I haven't included descriptions of every variable because their names are
%fairly self-explanatory

endTime = 100;%Duration of main loop
simTarget1Start = birth_mean1;
simTarget2Start = birth_mean2;
simTarget1End = [500, -900]';
simTarget2End = [900, -500]';
simTarget3End = [-200, -750]';
simTarget1Vel = (simTarget1End - simTarget1Start(1:2)) / endTime;
simTarget2Vel = (simTarget2End - simTarget2Start(1:2)) / endTime;
simTarget3Vel = [-10; -2];
simTarget1Start(3:4) = simTarget1Vel;
simTarget2Start(3:4) = simTarget2Vel;
simTarget3Start(3:4) = simTarget3Vel;

%History arrays are mostly used for plotting.
simTarget1History = simTarget1Start;
simTarget2History = simTarget2Start;
simTarget3History = [];

simMeasurementHistory = {};%We use a cell array so that we can have rows of varying length.

simTarget1State = simTarget1Start;
simTarget2State = simTarget2Start;
simTarget3State = [];

simTarget3SpawnTime = 66;%Target 3 is spawned from target 1 at t = 66s.

%Set up for plot
%Measurements and targets plot
figure(1);
clf;
hold on;
axis([-1000 1000 -1000 1000]);
xlim([-1000 1000]);
ylim([-1000 1000]);


%X and Y measurements plot
xlabel('X position');
ylabel('Y position');
title('Simulated targets and measurements');
axis square;

figure(2);
subplot(2,1,1);
hold on;
axis([0 100 -1000 1000]);
xlabel('Simulation step');
ylabel('X position of measurement (m)');
title('Measurement X coordinates');
subplot(2,1,2);
hold on;
axis([0 100 -1000 1000]);
xlabel('Simulation step');
ylabel('Y position of measurement (m)');
title('Measurement Y coordinates');

%A few more plots if needed.
%If you want to use them, enable them in GM_PHD_Simulate_Plot as well. 
if 0
figure(4);
clf;
hold on;
figure(5);
clf;
hold on;

%Speed
figure(6);
clf;
hold on;

%Covariance
figure(7);
clf;
hold on;

end