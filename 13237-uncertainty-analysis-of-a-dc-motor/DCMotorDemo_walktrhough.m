%% Uncertainty Analysis of a DC Motor System Model
% This is a _walkthrough_ of the Demo shown in the 30 November 2006 Webinar
% titled "Using Statistics for Uncertainty Analysis in System Models".  The
% demo covers two basic topics:
%
% * Quantifying the DC Motor system model accuracy.
% * Understanding how uncertainty in model parameters affect the motor output.
%
% _NOTE: The demo is set up to run if MATLAB and Statistics Toolbox are
% installed. You will need additional toolboxes if you want to run the
% Simulink Model. |verifyInstalled| will tell you which products you need._
%
% Link to recorded Webinar: <http://www.mathworks.com/wbnr13340> 
%% Preliminaries
% Check to see which licenses the user has available.  This demo will run
% if MATLAB and Statistics Toolbox are available.  Optional products enable
% the user to use the Simulink Model.

[doRTVCalc, doSimulink] = verifyInstalled

%% 1. Quantifying Model Accuracy
% The steps performed for quantifying model accuracy are:
%
%  1. Design an Experiment
%  2. Test the real world motor
%  3. Run the Simulink Motor model at the same conditions
%  4. Evaluate the model accuracy
%
% As a quick check, let's open the motor model, and evaluate it against
% manufacturer specifications.  For 24V input, and no load, the rise time
% should be 0.013 seconds (at ~6100 rpm) and the steady-state velocity
% should be 6790 rpm.
%
% _NOTE: We will only open the motor model if Simulink and Simulink products
% are installed._
%
% Define operating conditions and motor parameters:

% Motor inputs:
V = 32;             % input voltage         (V)
Jd = 0;             % inertial load         (kg.m^2)
% Motor parameters:
J = 65.2;           % shaft inertia         (g-cm^2)
Kemf = 211.5945;    % back emf constant     (rpm/v)
Kt = 44.5;          % torque constant       (mNm/A)
Ra = 1.71;          % armature resistance   (ohm)
La = 0.30;          % armature inductance   (mH)
b = 7.1213e-7;      % viscous damping       (mNm/rpm)

%%
% Run the Model.
if doSimulink
    open('MaxonDCMotor.mdl')            % open simulink model
    sim('MaxonDCMotor.mdl',[0 0.1]);    % run simulink model
else
    load MotorSpecCheck
end

%%
% Look at Results in MATLAB Figure Window
plot(tout,vel)
axis([0 0.1 0 7000])
xlabel('Time (s)')
ylabel('Angular Velocity (rpm)')

% Add rise time/angular velocity annotation
annotation('textarrow',[0.7503 0.7503],[0.7845 0.8959],...
    'HorizontalAlignment','Left',...
    'String',{'Steady-State Velocity',...
    'actual: 6767', ...
    'spec:   6790'});
annotation(gcf,'textarrow',[0.2706 0.2235],[0.7288 0.8184],...
    'HorizontalAlignment','Left',...
    'String',{'Rise Time',...
    'actual: 0.012', ...
    'spec:   0.013'});
%%
% The DC motor model is close to the manufacturing specifications.
%% 1.1 Design of Experiments
% Generate the experimental design - use a face-centered central composite
% design so we can fit a quadratic model to the error

factorNames = {'Voltage','Inertial Load'};
design      = ccdesign(2,'type','faced');

plotMotorSim(design)
showDOETable(design, factorNames)

%%
% Randomize the order and display test matrix in real-world units.
% Randomization is performed to reduce the effect noise factors may have on
% the analysis of our results.

noRuns     = length(design);
bounds     = [  12.0   36.0 ;              % Min/Max for Voltage
               0.001  0.005 ];             % Min/Max for Intertia
testMatrix = coded2real(design,bounds);
testMatrix = sortrows([randperm(noRuns)' testMatrix]);

close all % previous figures
plotMotorSim(testMatrix)
showDOETable(testMatrix,{'Run Number',factorNames{1:end}})

%% 1.2 Perform the Test and View Results
% We performed the test in the order specified in the test matrix.  We'll
% now look at the results color coded to Voltage and Inertia.

close all % previous figures

load DCMotorTest            % load in the test data

plotByColorMap(measTime,measVelocity,measV)
title('Color Mapped to Voltage')

figure, plotByColorMap(measTime,measVelocity,measJ)
title('Color Mapped to Inertial Load')

%% 
% The steady-state velocity achieved has a direct relationship to the input
% voltage level, but the effect of inertial load is not clear.  Rise time
% appears to be directly related to inertial load, but the relationship to
% voltage is unclear.
%
% Extract the rise time and steady-state angular velocity from the data.
% Use generated m-function from |cftool| (Curve Fitting Toolbox) to return
% the model coefficients (rise time and steady state velocity).  The
% m-function fits curves to the time series data and extract the
% steady-state velocity and rise time as coefficients from the curve fits.

measSSVelocity = zeros(noRuns,1);
measRiseTime = measSSVelocity;

if doRTVCalc % If toolboxes are installed, calculate
    for i = 1:noRuns
        [tau, measSSVelocity(i)] = myDCMotorFit(measTime{i},measVelocity{i});
        measRiseTime(i) = 2.1792*tau;
    end
else
    load RTVdata % load data if not toolbox installed
end

showDOETable([testMatrix measRiseTime measSSVelocity],{'Run Number',...
    factorNames{1:end},'Rise Time','SS Velocity'})

%% 1.3 Run Simulation at Test Conditions and Evaluate Results
% Run the Simulink model at tested conditions given in testMatrix.

Voltage = testMatrix(:,2);      % Input for simulation
Inertia = testMatrix(:,3);      % Input for simulation

close_system % Close Simulink model to speed up simulation

if doSimulink
    runDCMotorSim               % Run the simulation if products available
else
    load DCMotorSim             % Load a saved copy
end

%%
% Calculate the percent error and show in a table format.

simSSVelocity = zeros(noRuns,1);
simRiseTime   = simSSVelocity;

if doRTVCalc
    for i = 1:noRuns
        [tau, simSSVelocity(i)] = myDCMotorFit(time{i},velocity{i});
        simRiseTime(i) = 2.1792*tau;
    end
else
    load SimRTVCalc % Load if curve fitting is not available
end

pErrorRiseTime   = (simRiseTime - measRiseTime)./measRiseTime*100;
pErrorSSVelocity = (simSSVelocity - measSSVelocity)./measSSVelocity*100;

showDOETable([testMatrix measRiseTime simRiseTime pErrorRiseTime ...
               measSSVelocity simSSVelocity pErrorSSVelocity ],...
              {'Run Number',factorNames{1:end},...
              'Meas. Rise Time','Sim. Rise Time','RT Error',...
              'Meas. SS Velocity','Sim. SS Velocity','SS Vel. Error'})

%%
% Create quadratic response surface plots of the error.

close all % previous figures
t = regstats(pErrorRiseTime, [Voltage, Inertia], 'quadratic');
s = regstats(pErrorSSVelocity, [Voltage, Inertia], 'quadratic');

ezsurf(@(x,y)x2fx([x,y],'quadratic')*t.beta,[bounds(1,:),bounds(2,:)])
colorbar
title('Average error in Rise Time') 
ylabel('Load (kg m^2)') 
xlabel('Input Voltage (V)')

figure
ezsurf(@(x,y)x2fx([x,y],'quadratic')*s.beta,[bounds(1,:),bounds(2,:)])
colorbar
title('Average error in Angular Velocity') 
ylabel('Load (kg m^2)') 
xlabel('Input Voltage (V)')

%%
% The maximum rise time error is ~-4% and the maximum angular velocity
% error is ~1.2%.  The response surface plots show the average error, so
% let's look into the error in a little more detail.
%
% Use |rstool| to interactively plot the response surface plot and show the
% 95% confidence interval.  We'll do this for rise time only since the
% error for velocity is low.

rstool([Voltage, Inertia],pErrorRiseTime, 'quadratic',0.05,...
    {'Voltage','Inertial Load'},'Rise Time Percent Error')
%%
% In |rstool|, we can move the blue lines around to see how the error
% changes for different input values.  In general, it appears that the
% error in rise time ranges from around 5% to -9%.

%% 2. Evaluating Parametric Uncertainty
% The steps performed for evaluating parametric uncertainty in the model 
% are:
%
%  1. Define Parameter Distributions
%  2. Perform Monte Carlo Simulation
%  3. Evaluate the Results

%% 2.1 Define Parameter Distributions
% Define input factor distributions for Monte Carlo Simulation.  We'll
% model the nominal voltage (24V) and inertial load (0.003 kg*m^2) case
% only.  This analysis could be repeated for other input combinations if
% desired.

clear all, close all

% Set input conditions to the motor:
V = 24;
Jd = 0.003;

% Define the simulation parameters:
mcSamples = 1000;
mcRa25 = normrnd(1.71,0.17/3,[mcSamples 1]);          % Armature Resistance
mcLa   = normrnd(0.3,.03/3,[mcSamples 1]);            % Armature Inductance
mcKt   = normrnd(44.5,1.33/3,[mcSamples 1]);          % Shaft Inertia
mcKemf = 30000/pi./mcKt;                              % Back EMF

% Parameters we are not changing:
J = 65.2;           % shaft inertia         (g-cm^2)
b = 7.1213e-7;      % viscous damping       (mNm/rpm)

%%
% Evaluate the historical temperature use data to select an appropriate
% distribution for simulation.  The Webinar showed how to use |dfittool|.
% Here we will use the generated m-file from the tool.

load Temperature
% dfittool(Temperature) %--> Uncomment this line to use the gui

% fit the generalized extreme value distribution to the temperature data.
[k,sigma,mu] = myDistFit(Temperature)

%%
% The Simulink model does not explicitly use temperature, but we know
% temperature effect is primarily captured in the value of resistance of
% the armature.

mcT  = gevrnd(k,sigma,mu,[mcSamples 1]);       % Temperature dist.

mcRa = mcRa25 .* (1 + 0.00392 .* (mcT - 25));  % adjust armature resistance

%% 2.2 Perform the Simulation
% Run the Monte Carlo Simulation.  In the interest of time, we'll load the
% data and not run the simulation.

% Uncomment this next line to run the simulation (>1 hour run time,
% depending on your machine) and add a comment out the following load
% statement.
% runDCMotorMCSim

load mcresults
who

%% 2.3 Show Results in Matrix Plot
% Visualize the results in a matrix plot to summarize all the factors and
% their effect on the responses.

[h,ax,bax] = plotmatrix([mcRa mcLa mcKt riseTime ssVelocity]);
varNames = {'Ra (ohm)','La (mH)','Kt (mNm/A)', ...
            'rTime (s)','Ang. Velocity (rpm)'};
for i = 1:length(varNames)
    xlabel(ax(end,i),varNames{i});
    ylabel(ax(i,1),varNames{i});
end

%%
% The diagonal shows the distribution of the various parameters.  Resistance
% is not normal, and looks similar to the temperature distribution shown
% previously. Inductance and the torque constant appear to be normal.  Rise
% time and steady-state velocity are not normal.  Looking at the plots, it
% appears the armature resistance has the largest effect on the motor
% output.  Rise time has a nonlinear increasing trend with resistance.
% Steady-state velocity has the opposite trend with resistance.
% 
% One of the requirements for the motor is that it has a rise time of 8
% seconds or lower for the 24 V, 0.003 kg m^2 input.  We can see that some
% of the simulation data has a rise time of greater than 8 seconds. How
% much of the time are we not in compliance with the requirement and can
% we live with it? 
%
% Fit a distribution using |dfittool|, and use the cumulative probability
% plot to estimate the population that has less than 8 second rise time.
% In the Webinar we showed the tool, here we will use the generated m-code
% to produce the plot.

% dfittool(riseTime) %--> Uncomment this line to use the gui.
myProbFit(riseTime)
%%
% From the plot, it appears that 94% of the time a rise time of <8 seconds
% is achieved.  So 6% of the time we would not meet the requirement.  If
% this value was closer to 1%, we could accept it.  Since it is not, we
% need to look into changing our motor parameter tolerances or operating
% temperature limits to keep below a 1%.
%% Summary
% We found that our model accuracy is within -4% for rise time and 1.2% for
% angular velocity on average.  At the 95% confidence level, the rise time
% accuracy ranges from 5% to -9%.  From the Monte Carlo simulation, it was
% found that 6% of the time the motor will be used in a region that has a
% rise time greater than 8 seconds, which is unacceptable for our use.  We
% need to reevaluate the motor parameter tolerances and operating
% temperature range to keep rise time below 8 seconds >99% of the time (<1%
% failure).
