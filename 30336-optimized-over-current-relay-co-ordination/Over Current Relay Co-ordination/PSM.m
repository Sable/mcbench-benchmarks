function [PSM_Max, PSM_Min] = PSM (CT, OLF_Max, OLF_Min, LC, MaxPSM, MinPSM, StepPSM)

LC_Max=LC*OLF_Max;
LC_Min=LC*OLF_Min;
PSM_Max_Desired=LC_Max/CT;
PSM_Min_Desired=LC_Min/CT;

PSM_Max=floor(PSM_Max_Desired/StepPSM)*StepPSM;
PSM_Min=ceil(PSM_Min_Desired/StepPSM)*StepPSM;
if (PSM_Max>=MaxPSM)
    PSM_Max=MaxPSM;
elseif(PSM_Min<=MinPSM)
    PSM_Min=MinPSM;
elseif(PSM_Max<PSM_Min)
    Temp=PSM_Max;
    PSM_Max=PSM_Min;
    PSM_Min=Temp;
end