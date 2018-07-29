function [Ua1rms,Ub1rms,Uc1rms,Ia1rms,Ib1rms,Ic1rms,P1pos,Q1pos,U1pos,Iact1pos,Ireac1pos,cosphi1pos,time] = IEC_Analysis_Function_Matlab_2007(U1,U2,U3,I1,I2,I3,U1_time,f_grid)
% This function will calculate the positive sequence values of an electrical
% system (from its voltages and current measurements) like the active and
% reactive power using the IEC 61400-21 Norm. 
% for simplisity the function assume that the measured three phase signals
% have the same sampling rate and the same length (that is why it accepts
% only one time signal as an input).
% The function inputs are:
% 1- the mesured three phase voltage and currents signals of an power
% system (Only the amplitude /Y-Values only/)
% 2- one of the time values of the measured signals like U1_time which
% indicate the x- Values where the sampling rate and offset values can be
% extracted.
% 3- f_grid: the nominal frequency of the power system under study (normaly
% 50 Hz)
% The function outputs are:
% 1- The three phase RMS values of the measured voltages calculated
% according to the norm 
% 2- The three phase RMS vlaues of the measured currents calculated
% according to the norm
% 3- P1pos & Q1pos are the positive sequence Active- and Reactive power
% values calculated according to the IEC norm.
% 4- U1pos: is the positive sequence voltage calculated according to the
% IEC norm.
% 5- Iact1pos,Ireac1pos: is the positive sequence Active- and Reactive currents
% calcualted according to the IEC norm
% 6- cosphi1pos: is the possitive sequence power factor calculated
% according to the IEC norm.
% 7- the final output (time): is the time axie of the different output
% resutls.
% this function will also need the movstat.m file which will be used to
% calcutlate the "mvint" of the sin and cos signals in this function.
% for more information please refer to the IEC 61400-21 Norm.
N = length(U1);
delta_t = (U1_time(2)-U1_time(1));
offset = U1_time(1);

duration = N*delta_t;
ramp_t = offset:delta_t:(duration)-delta_t;
sinwt = sin(2*pi*f_grid*ramp_t);
coswt = cos(2*pi*f_grid*ramp_t);

[r,c] = size(U1);
if r > 1
    Ua_sin = U1'.*sinwt;
    Ua_cos = U1'.*coswt;
    Ub_sin = U2'.*sinwt;
    Ub_cos = U2'.*coswt;
    Uc_sin = U3'.*sinwt;
    Uc_cos = U3'.*coswt;
    Ia_sin = I1'.*sinwt;
    Ia_cos = I1'.*coswt;
    Ib_sin = I2'.*sinwt;
    Ib_cos = I2'.*coswt;
    Ic_sin = I3'.*sinwt;
    Ic_cos = I3'.*coswt;
elseif c > 1
    Ua_sin = U1.*sinwt;
    Ua_cos = U1.*coswt;
    Ub_sin = U2.*sinwt;
    Ub_cos = U2.*coswt;
    Uc_sin = U3.*sinwt;
    Uc_cos = U3.*coswt;
    Ia_sin = I1.*sinwt;
    Ia_cos = I1.*coswt;
    Ib_sin = I2.*sinwt;
    Ib_cos = I2.*coswt;
    Ic_sin = I3.*sinwt;
    Ic_cos = I3.*coswt;
end
    

fn = @int;
[Ua_sin] = mvstat_Matlab_2007(Ua_sin,U1_time,(1/f_grid),delta_t,fn); Ua_sin = Ua_sin*2*f_grid;
[Ub_sin] = mvstat_Matlab_2007(Ub_sin,U1_time,(1/f_grid),delta_t,fn); Ub_sin = Ub_sin*2*f_grid;
[Uc_sin] = mvstat_Matlab_2007(Uc_sin,U1_time,(1/f_grid),delta_t,fn); Uc_sin = Uc_sin*2*f_grid;
[Ua_cos] = mvstat_Matlab_2007(Ua_cos,U1_time,(1/f_grid),delta_t,fn); Ua_cos = Ua_cos*2*f_grid;
[Ub_cos] = mvstat_Matlab_2007(Ub_cos,U1_time,(1/f_grid),delta_t,fn); Ub_cos = Ub_cos*2*f_grid;
[Uc_cos] = mvstat_Matlab_2007(Uc_cos,U1_time,(1/f_grid),delta_t,fn); Uc_cos = Uc_cos*2*f_grid;
[Ia_sin] = mvstat_Matlab_2007(Ia_sin,U1_time,(1/f_grid),delta_t,fn); Ia_sin = Ia_sin*2*f_grid;
[Ib_sin] = mvstat_Matlab_2007(Ib_sin,U1_time,(1/f_grid),delta_t,fn); Ib_sin = Ib_sin*2*f_grid;
[Ic_sin] = mvstat_Matlab_2007(Ic_sin,U1_time,(1/f_grid),delta_t,fn); Ic_sin = Ic_sin*2*f_grid;
[Ia_cos] = mvstat_Matlab_2007(Ia_cos,U1_time,(1/f_grid),delta_t,fn); Ia_cos = Ia_cos*2*f_grid;
[Ib_cos] = mvstat_Matlab_2007(Ib_cos,U1_time,(1/f_grid),delta_t,fn); Ib_cos = Ib_cos*2*f_grid;
[Ic_cos,time] = mvstat_Matlab_2007(Ic_cos,U1_time,(1/f_grid),delta_t,fn); Ic_cos = Ic_cos*2*f_grid;
%Cl. 7
Ua1rms = sqrt((Ua_sin.*Ua_sin+Ua_cos.*Ua_cos)/2);
Ub1rms = sqrt((Ub_sin.*Ub_sin+Ub_cos.*Ub_cos)/2);
Uc1rms = sqrt((Uc_sin.*Uc_sin+Uc_cos.*Uc_cos)/2);
Ia1rms = sqrt((Ia_sin.*Ia_sin+Ia_cos.*Ia_cos)/2);
Ib1rms = sqrt((Ib_sin.*Ib_sin+Ib_cos.*Ib_cos)/2);
Ic1rms = sqrt((Ic_sin.*Ic_sin+Ic_cos.*Ic_cos)/2);
%Cl. 8-11
U1pos_cos = (2*Ua_cos-Ub_cos-Uc_cos-sqrt(3)*(Uc_sin-Ub_sin))/6;
U1pos_sin = (2*Ua_sin-Ub_sin-Uc_sin-sqrt(3)*(Ub_cos-Uc_cos))/6;
I1pos_cos = (2*Ia_cos-Ib_cos-Ic_cos-sqrt(3)*(Ic_sin-Ib_sin))/6;
I1pos_sin = (2*Ia_sin-Ib_sin-Ic_sin-sqrt(3)*(Ib_cos-Ic_cos))/6;
%Cl. 12-17
P1pos = 1.5*(U1pos_cos.*I1pos_cos+U1pos_sin.*I1pos_sin);
Q1pos = 1.5*(U1pos_cos.*I1pos_sin-U1pos_sin.*I1pos_cos);
%Voltage, current and phase angle acc. C.14 to C.17
U1pos = sqrt(1.5*(power(U1pos_sin,2)+power(U1pos_cos,2)));
Iact1pos = P1pos/(sqrt(3)*U1pos);
Ireac1pos = Q1pos/(sqrt(3)*U1pos);
cosphi1pos = P1pos/sqrt(power(P1pos,2)+power(Q1pos,2));
%--------------------------------------------------------------------------
%----------------------------- End :)--------------------------------------
%--------------------------------------------------------------------------
end