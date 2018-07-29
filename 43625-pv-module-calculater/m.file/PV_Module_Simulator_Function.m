function [P_MPP,U_MPP,I_MPP,U_OC_New,I_SC_New,U_PV,I_PV,P_PV] = PV_Module_Simulator_Function(G,T_amb)
%------ Solar Module simulation according to DIN EN 50530:2010 ------------
% This function can be used to simulate an solar cell to a PV-field by
% entering the number of modules (cells) in parallel and the number of
% module in serise. 
% The equations used in this function are taken from the DIN EN 50530:2010
% norm.
% This function need two inputs:
% 1- G: The new solar irradiation at which the new working points
% (U_MPP,P_MPP,...) will be calculated.
% 2- T_amb: The new ambiant temperature at which the new working points
% (U_MPP,P_MPP,...) will be calculated.
% This function outputs are:
% 1- P_MPP,U_MPP,I_MPP: are the power, voltage, current at the maximum
% power point at the new conditions respectivily
% 2- U_OC_New,I_SC_New: are the open circuit voltage and the short circuit
% current respectivily calculated for the new weather(input) conditions.
% 3- U_PV,I_PV,P_PV: are the new characteristic curves values for the
% studied input condition.
% This function will also ask the user for addtional informations which
% need to be given in order to be able to simulate the characteristics of
% the selected PV-mdouel.
% Those information cal be obtained from the datasheet of the selected PV
% modules. if not given use the default values already given.
%Author: Aubai Alkhatib, date: 25.09.2013

prompt1 = {'Please Enter The STC Temperatur in C','Please Enter The STC Open Voltage in V','Please Enter The STC Short circut Current in A','Please Enter The Voltage temperatur coefficient Beta in %/C','Please Enter The Curent temperatur coefficient Alpha in %/C ','Please Enter The STC Irradiantion in W/m2','Please Eneter The Voltage of the MPP in V','Please Eneter The Current of the MPP in A','Please Eneter The Technology correction factor CG in W/m2','Please Eneter The Technology correction factor CU in pu','Please Eneter The Technology correction factor CR in m2/W','Please Eneter The number of PV-Modules in Parallel P','Please Eneter The number of PV-Modules in Seris R','Please Enter The Open circut Voltage of the LS'};
name = 'Initial Input data';
numlines = 1;
%defaultanswer1 = {'25','36.7','8.18','-0.32','0.04','1000','29.9','7.53','2.514','8.593','1.088','22','384','1200','Oldenburg,Germany','20130701','X:\Loc_4631\2013\07'};
defaultanswer1 = {'25','36.7','8.18','-0.32','0.04','1000','29.9','7.53','2.514','8.593','1.088','22','450','1600'};
%defaultanswer1 = {'4','1700','105','20','400','50','1'};
answer1 = inputdlg(prompt1,name,numlines,defaultanswer1);
T_STC = str2num(answer1{1})+273;
Uoc_STC =  str2num(answer1{2});
Isc_STC =  str2num(answer1{3});
V_T_C = str2num(answer1{4})/100;
I_T_C = str2num(answer1{5})/100;
E0 = str2num(answer1{6});
Umpp_STC = str2num(answer1{7});
Impp_STC = str2num(answer1{8});
CG = str2num(answer1{9})/1000;
CU = str2num(answer1{10})/100;
CR = str2num(answer1{11})/10000;
R = str2num(answer1{12});
P = str2num(answer1{13});
Ts = str2num(answer1{14});%#ok<*ST2NM>
G_STC = E0;
Uoc_STC = Uoc_STC * R;
Isc_STC = Isc_STC * P;
Umpp_STC = Umpp_STC * R;
Impp_STC = Impp_STC * P;
if 0 == 1
    T_0 = -3;
    k = 0.03;%km^2/w
    Tau = 5;% in min
    T_PV = T_amb + T_0 + ((k*1000000)/(1+(Tau*60)))*G;
else
    T_NOCT = 45;
    T_PV = T_amb + ((T_NOCT-20) * (G/800));
end
Alpha = I_T_C;
Isc_New = (Isc_STC*(G/G_STC)) * (1 + (Alpha * (T_PV - T_STC)));
Beta = V_T_C;
Uoc_New = Uoc_STC*(1+Beta*(T_PV-T_STC))*(log((G/CG)+1)*CU-CR*G);
FF_U = Umpp_STC/Uoc_STC;
FF_I = Impp_STC/Isc_STC;
I_0 = (Isc_STC*(1-FF_I)^(1/(1-FF_U)))*(G/G_STC);
CAQ = (FF_U-1)/(log(1-FF_I));
U_PV = 0:1:Ts;
I_PV = Isc_New - I_0*(exp(U_PV/(Uoc_New*CAQ))-1);
P_PV = U_PV.*I_PV;
P_MPP = max(P_PV);
U_MPP = U_PV(P_PV == P_MPP);
I_MPP = I_PV(U_MPP);
indx = find(I_PV < 0);
U_OC_New = U_PV(indx(1));
I_SC_New = I_PV(1);
figure(1);
subplot(2,1,1);
plot(U_PV,I_PV);xlabel('DC-Voltage in V');ylabel('DC-Current in A');title('PV-Module Charactaristic curves');grid on;ylim([0,I_MPP+((20/100)*I_MPP)]);xlim([0,U_OC_New+10]);
subplot (2,1,2);
plot(U_PV,P_PV);xlabel('DC-Voltage in V');ylabel('DC-Power in W');grid on;ylim([0,P_MPP+((5/100)*P_MPP)]);xlim([0,U_OC_New+10]);
end




