%% Analyzing Motor Noise Data Using MATLAB Products
% This case study analyzes the noise levels of 4 electric motors that are
% each slight variations of an original design.  We want to see if the new
% designs have the same noise levels as the original motor.
% Copyright 2006-2009 The MathWorks, Inc.

%% Modeling the Benchmark Motor
% We model the benchmark motor in the Curve Fitting Tool GUI using a custom
% exponential model.  The results are plotted here with a 95% confidence
% range. 
lowerbound = analysisresults1.lower;
upperbound = analysisresults1.upper;
expmodel = analysisresults1.yfit;
plotmodel;

%% Comparing Motors 1 & 2 to the Benchmark Model
% I'll now compare motors 1 & 2 with the my benchmark model to see if they
% land within the 95% confidence region.  I'll start with motor 1. 
figure('windowstyle', 'docked')
plot(rpm,[lowerbound upperbound],':r','LineWidth',1.5); hold on
plot(rpm,motor1,'.-');title('Motor 1')
xlabel('Motor speed (rpm)');ylabel('Noise (dBA)');ylim([67 72]);
% Plot motor 2 test results with original motor fit:
figure('windowstyle', 'docked')
plot(rpm,[lowerbound upperbound],':r','LineWidth',1.5); hold on
plot(rpm,motor2,'.-');title('Motor 2')
xlabel('Motor speed (rpm)');ylabel('Noise');ylim([67 72]);

%% Evaluating Test Variation
% I’ll use analysis of variance functions from the Statistics Toolbox to
% determine whether test to test differences in motor1 are significant.  
motor1flat = motor1(15:end,:);
[pval,table,stats] = anova1(motor1flat); dockfigures;
% Based on the P-value, test-to-test differences are significant.  We have
% to check the reliability of our test setup.

%% Creating an Excel(R) add-in to Compare Motors to Benchmark
% I'd like Excel users at my organization to have a simple way of checking
% whether new motors fall within the 95% confidence range of my benchmark
% model and whether tests are repeatable.  I created a MATLABA function
% that does this and deployed it as an Excel add-in.
