close all
clear all
%-------------------------------------------------------------------------%
% Isothermal flash calculation using Soave equation of state 
% Author: Arnulfo Rosales-Quintero
% Email: arnol122@gmail.com 
% Main program calls function Flash_iso01

%It can be used for multicomponent mixture, you only need the critical
%properties, acentric factor and binary interaction parameters (if you don´t 
%have it Kij(i,j)=0 is good aproximation)
%-------------------------------------------------------------------------%
    global nc xy01 beta01
    global Pc Tc w
    global R PT PT01
    global EDO delta1 delta2
    global Kij
%-------------------------------------------------------------------------%
%Ideal gas universal constant
    R = 82.0600;		%(atm cc/mol K)
%*************************************************************************%
    %Ethane-Heptane-Carbon dioxide mixture
    %Critical Pressure, critical temperature and acentric factor
    Tc = [305.4   540.2 304.20];   %Kelvin   
    Pc = [48.2    27.0  72.800];   %Atm
    w  = [0.099   0.351 0.225];   %Undimensional
    %---------------------------------------------------------------------%
    %Operating temperature (Kelvin)
    T0 = 450;
    %Operating pressure (Atm)
    P0 =  25;
    %Feed composition
    xy01 = [0.229 0.679 0.092];
    nc   = 3;
    %---------------------------------------------------------------------%    
    %Binary interaction parameter (If there are)
    Kij(1:nc,1:nc)=0;
%*************************************************************************%
%Soave-Redlich-Kwon  equation of state
    EDO='SRK';
    delta1 = 1;           delta2 = 0.0;
%-------------------------------------------------------------------------%
%Call for Isothermal flash calculations
    [beta,x,y] = Flash_iso01(nc,xy01,P0,T0);
%-------------------------------------------------------------------------%    
%Results for split fraction, liquid composition and vapor composition
    beta
    x'
    y'
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%
close all