function [Set_PSM, Set_TDS, OperatingTime] = ORCD (CT, OLF_Min, OLF_Max, LC, FC, C1, C2, TOP_Desired, IDMT_Saturation, Tolerance_Dn, Discrimination_Time, MinPSM, MaxPSM, StepPSM, MinTDS, MaxTDS, StepTDS)

[PSM_Max, PSM_Min] = PSM(CT, OLF_Max, OLF_Min, LC, MaxPSM, MinPSM, StepPSM);

TOP_Desired_For_Present_Relay=TOP_Desired+Discrimination_Time;
n=round((PSM_Max-PSM_Min)/StepPSM);
PSM_Temp=PSM_Min;
D=zeros(1,4);
    for i=1:n+1
        M=(FC/(PSM_Temp*CT));
        if (M>=IDMT_Saturation)
            M=IDMT_Saturation;
        end

        K=C1/((M^C2)-1);

        TDS_Desired=TOP_Desired_For_Present_Relay/K;
    
        TDS_Rounded_Up=ceil(TDS_Desired/StepTDS)*StepTDS;
        Difference_Up=abs(TDS_Rounded_Up-TDS_Desired);
    
        TDS_Rounded_Dn=floor(TDS_Desired/StepTDS)*StepTDS;
        Difference_Dn=abs(TDS_Rounded_Dn-TDS_Desired);
    
        Difference=min(Difference_Up,Difference_Dn);
        
        D(i,1)=PSM_Temp;
        D(i,2)=K;
        D(i,3)=TDS_Desired;
        D(i,4)=Difference;
    
        PSM_Temp=PSM_Temp+StepPSM;
        if (i~=n+1)
            D=[D;zeros(1,4)];
        end
    end
    D;
    [~,I]=min(D(:,4));
    Set_PSM=D(I,1);
    Set_TDS_Up=ceil(D(I,3)/StepTDS)*StepTDS;
    Set_TDS_Dn=floor(D(I,3)/StepTDS)*StepTDS;
    OperatingTime_Up=D(I,2)*Set_TDS_Up;
    OperatingTime_Dn=D(I,2)*Set_TDS_Dn;
    TOP_Error_Up=abs(TOP_Desired_For_Present_Relay-OperatingTime_Up);
    TOP_Error_Dn=abs(TOP_Desired_For_Present_Relay-OperatingTime_Dn);
    TOP_Error=min(TOP_Error_Up,TOP_Error_Dn);
    if (TOP_Error==TOP_Error_Dn && TOP_Error<=Tolerance_Dn)
        OperatingTime=OperatingTime_Dn;
        Set_TDS=Set_TDS_Dn;
    else
        OperatingTime=OperatingTime_Up;
        Set_TDS=Set_TDS_Up;
    end