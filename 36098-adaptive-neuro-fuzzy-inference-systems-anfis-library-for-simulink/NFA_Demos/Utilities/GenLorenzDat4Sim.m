% Lorenz 3D chaotic system I/O data setup. 
% This script prepares the input - output training (LE=1) data pairs 
% and checking (LE=0) data pairs.
% Two previous 3-D solution points (which makes 6 input signals in total) 
% are used as inputs to ANFIS in order to predict the next 3-D solution point of the system.

load lorenz_data.mat
Process  = lorenz_dat;

NumOfSamples = 2000;
NumOfInputVars = 6;

Process0 = Process(:,1:NumOfSamples);
Process1 = Process(:,2:NumOfSamples+1);
Process2 = Process(:,3:NumOfSamples+2);

Process0ch = Process(:,NumOfSamples+1:2*NumOfSamples);
Process1ch = Process(:,NumOfSamples+2:2*NumOfSamples+1);
Process2ch = Process(:,NumOfSamples+3:2*NumOfSamples+2);

Train_Time = [1:NumOfSamples]';
Train_Time_End = max(Train_Time);
Check_Time = [1:NumOfSamples]'+Train_Time_End;

% Training I/O data pairs.
Lorenz_Train_Inps     = [ Train_Time Process1' Process0'];  % Training Inputs
Lorenz_Train_Target = [ Train_Time Process2'];                  % Training desired (target) output.

% Checking I/O data pairs.
Lorenz_Check_Inps = [ Lorenz_Train_Inps; 
                                        Check_Time Process1ch' Process0ch']; % Checking mode Inputs. 

Lorenz_Check_Target = [ Lorenz_Train_Target; 
                                             Check_Time Process2ch'];  % Checking mode desired (target) output. 