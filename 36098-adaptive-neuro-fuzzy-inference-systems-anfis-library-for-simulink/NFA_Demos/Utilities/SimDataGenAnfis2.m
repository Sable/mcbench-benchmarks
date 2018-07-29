% Mackey-Glass chaotic time series I/O data setup. 
% This script prepares the input - output training (LE=1) data pairs 
% and checking (LE=0) data pairs.
% Four past time-series values are used as inputs to ANFIS in order to
% predict the next value of the series.

load MG_Train_2000.dat
load MG_Check_2000.dat

NumOfSamples = 1000;
NumOfInputVars = 4;

Train_Time          = [1:NumOfSamples]';
Train_Time_End = max(Train_Time);
Check_Time        = [1:NumOfSamples]' + Train_Time_End;

% Training mode I/O data pairs.
MG_Train4Sim     = [Train_Time MG_Train_2000(1:NumOfSamples,1:NumOfInputVars)];
MG_Train_Target = [Train_Time MG_Train_2000(1:NumOfSamples,7)];

% Checking mode I/O data pairs.
MG_Check4Sim     = [ MG_Train4Sim; 
                                       Check_Time    MG_Check_2000(1:NumOfSamples,1:NumOfInputVars);];
MG_Check_Target = [MG_Train_Target;
                                       Check_Time MG_Check_2000(1:NumOfSamples,7)];