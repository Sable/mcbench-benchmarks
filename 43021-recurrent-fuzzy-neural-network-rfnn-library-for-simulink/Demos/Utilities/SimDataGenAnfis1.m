% Load and Format Mackey-Glass chaotic system data. 

load MG_Train.dat
load MG_Check.dat

NumOfSamples = 500;
NumOfInputVars = 4;

Train_Time = [1:NumOfSamples]';
Train_Time_End = max(Train_Time);
Check_Time = [1:NumOfSamples]'+Train_Time_End;

MG_Train4Sim    = [Train_Time MG_Train(1:NumOfSamples,1:NumOfInputVars)];
MG_Train_Target = [Train_Time MG_Train(1:NumOfSamples,7)];

MG_Check4Sim = [MG_Train4Sim; Check_Time MG_Check(Train_Time_End+1:end,1:NumOfInputVars);];


MG_Check_Target = [MG_Train_Target;
                   Check_Time MG_Check(Train_Time_End+1:end,7)];