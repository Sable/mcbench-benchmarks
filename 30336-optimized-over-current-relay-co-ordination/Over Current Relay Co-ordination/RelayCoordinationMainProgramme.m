clc
format long

Output_File=[];

Input_File=xlsread('INPUTS.xls', 'Inputs', 'A:R');
save Input_File.dat Input_File -ascii -tabs
n=length(Input_File(:,1));

for i=1:n
    CT=Input_File(i,2);
    OLF_Min=Input_File(i,3);
    OLF_Max=Input_File(i,4);
    LC=Input_File(i,5);
    FC=Input_File(i,6);
    C1=Input_File(i,7);
    C2=Input_File(i,8);
    
    if (i~=1)
        j=i-1;
        TOP_Actual=Output_File(j,3);
    else
        TOP_Desired=Input_File(i,9);
    end
    
    IDMT_Saturation=Input_File(i,10);
    Tolerance_Dn=Input_File(i,11);
    Discrimination_Time=Input_File(i,12);

    MinPSM=Input_File(i,13);
    MaxPSM=Input_File(i,14);
    StepPSM=Input_File(i,15);

    MinTDS=Input_File(i,16);
    MaxTDS=Input_File(i,17);
    StepTDS=Input_File(i,18);
    
    if (i==1)
        [Set_PSM, Set_TDS, OperatingTime] = ORCD (CT, OLF_Min, OLF_Max, LC, FC, C1, C2, TOP_Desired, IDMT_Saturation, Tolerance_Dn, Discrimination_Time, MinPSM, MaxPSM, StepPSM, MinTDS, MaxTDS, StepTDS);
        Output_File=[Output_File;Set_PSM, Set_TDS, OperatingTime, 0];
    else
        [Set_PSM, Set_TDS, OperatingTime] = ORCD (CT, OLF_Min, OLF_Max, LC, FC, C1, C2, TOP_Actual, IDMT_Saturation, Tolerance_Dn, Discrimination_Time, MinPSM, MaxPSM, StepPSM, MinTDS, MaxTDS, StepTDS);
        DTime=abs(Output_File(i-1,3)-OperatingTime);
        Output_File=[Output_File;Set_PSM, Set_TDS, OperatingTime, DTime];
    end
 end
Output_File;
[status, message]=xlswrite('OUTPUT.xls', Output_File, 'Result', 'A:D');