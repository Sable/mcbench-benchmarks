% This M file creates the "LossSpec_Diode_Library.mat " file 
% containing loss and thermal diode models provided in the
% "LossModelib.mdl' libray.
% Diode specifications are saved in the "LossSpec_Diode" structure. 
%
% Data provided below for three different commercial 
% IGBT/Diode half-bridge packs are extracted from manufacturer data sheets 
% (see pdf files provided in the same directory).

% Pierre Giroux, Hydro-Quebec (IREQ), March 2012


%% How to to add your own diode specifications
% -------------------------------------------
%   1)  Open the "LossModelib.mdl' library
%   2)  Duplicate a cell containing specifications of one existing IGBT 
%       and insert it at the end of this file 
%       (see "Add your own specifications here" cell)
%   3)  Modify this new set of data according to your specifications
%   4)  Run this script file in order to update the "LossSpec_Diode_Library.mat " file
%   5)  In the "LossModelib.mdl' library
%            - select the IGBT or half-bridge model to update
%            - open the Mask Editor 
%            - select "Diode_Type" parameter
%            - In the "Popups" window, enter a new description 
%              after existing diode descriptions 
%   6) Save the "LossModelib.mdl' library.
% Note: Future release of SPS will provide an easy-to-use GUI to add or
% edit device characteristics.

% Pierre Giroux, Hydro-Quebec (IREQ), March 2012

% If=  Forward current (A)
% Vf= Forward voltage (V)
% Erec= Reverse recovery energy (mJ)
% Tj= Junction temperature (degrees Celsius)
% Vcc= Supply voltage (V)
% Note1: Reverse recovery energy (Erec)is function of Vcc, If and Tj
% Note2: Diode on-state losses = Vf (function of If and Tj) * If
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear all

%% Fuji Electric - Diode, IGBT Module, 2 in one-package, 600V, 150A

Type         = 'Diode';
Manufacturer = 'Fuji Electric';
PartNo       = '2MBI150U2A 060';
Description  = 'Diode, IGBT Module, 2 in one-package, 600V, 150A';

% Typical reverse recovery energy (Erec) vs If
Vcc_Erec = 300; 
Tj_Erec  = [ 25 125 ];
If_Erec  = [ 0  25    50    75    100   125   150   175   200    225  ]; 
Erec     = [ 0  0.27  0.48  0.62  0.69  0.73  0.75  0.77  0.795  0.81  
             0  0.48  0.82  1.07  1.23  1.37  1.47  1.58  1.67   1.79 ];
%
% Diode - Typical on-state characteristics
Tj_OnState=  [ 25 125 ]; 
If_OnState = [ 0  0.1  3     10    30    70    111   167   240   300  ];
Vf_OnState = [ 0  0.43 0.78  0.92  1.11  1.31  1.47  1.66  1.89  2.07
               0  0.42 0.55  0.70  0.96  1.23  1.47  1.72  2.02  2.25 ];   
%-------------------------------------------------------------------------
%
% Thermal Impedance:
%
Rth_jc=0.46; % Junction-to-Case thermal resistance(K/W)
% Based on transient thermal impedance vs. time curve
Cth_j=0.13;    % Junction thermal capacitance (Joule/Kelvin)
%
%-------------------------------------------------------------------------
LossSpec_Diode(1)= struct('Type',Type, 'Manufacturer',Manufacturer, 'PartNo',PartNo, ...
    'Description',Description, 'Vcc_Erec',Vcc_Erec, ...
    'Tj_Erec',Tj_Erec, 'If_Erec',If_Erec, 'Erec',Erec, ...
    'Tj_OnState',Tj_OnState, 'If_OnState',If_OnState, 'Vf_OnState',Vf_OnState, ...
    'Rth_jc',Rth_jc, 'Cth_j',Cth_j);
%
clear Vcc_Erec Tj_Erec If_Erec Erec Tj_OnState ...
      If_OnState Vf_OnState Manufacturer PartNo Description Type ...
      Rth_jc Cth_j 
%=========================end of specifications===========================


%% ABB - Diode, IGBT Module, ABB HiPak, 1700V, 800A
Type='Diode';
Manufacturer= 'ABB';
PartNo= '5SNE 0800M170100';
Description= 'Diode, IGBT Module, ABB HiPak, 1700V, 800A';

% For Tj=25 deg. C, manufacturer specifications provide Erec at only one current (800 A).
% The Erec values for Tj=25 deg. C and Tj=125 deg. C, 800 A specified below
% are used to deduce the Erec(Ic) curve @ Tj=25 deg. C from the Erec(Ic) curve @ Tj=125 deg. C 
% assuming that Erec stays proportionnal to its value  @ Tj= 125 deg. C

Tj_800A=   [ 25   125 ]; % Junction temperature (C) 
Erec_800A= [ 150  270];  % Reverse recovery energy  at Tj_800A (mJ) for Ic=800A
%
% Typical reverse recovery energy (Erec) vs If
Vcc_Erec= 900;  
Tj_Erec=  [ 25 125 ];    
If_Erec=   [ 0 101  196  301  500  703  800 902  1100 1300 1500 1600 ]; 
% Erec @ 125 C (per data sheet curves)
Erec(2,:)= [ 0 82.0 115  145  201  245  270 282  309  330  340  342  ];
% Eon @ 25 C (calculated using data sheet spec at 25 C)
Erec(1,:)=Erec_800A(1)/Erec_800A(2) * Erec(2,:);
%
% Diode - Typical on-state characteristics
Tj_OnState=  [ 25 125 ]; 
If_OnState = [ 0  0.01  96.4 142  195  259  365  500  669  900  1100 1400 1500];
Vf_OnState = [ 0  0.80  1.09 1.17 1.23 1.29 1.38 1.48 1.58 1.71 1.83 2.00 2.06
               0  0.50  0.86 0.97 1.06 1.15 1.28 1.43 1.58 1.78 1.94 2.18 2.26 ];   
%-------------------------------------------------------------------------
%
% Thermal Impedance:
%
Rth_jc=0.036; % Junction-to-Case thermal resistance(K/W)
% Based on transient thermal impedance vs. time curve
Cth_j=3.729;    % Junction thermal capacitance (Joule/Kelvin)
%
%-------------------------------------------------------------------------
LossSpec_Diode(2)= struct('Type',Type, 'Manufacturer',Manufacturer, 'PartNo',PartNo, ...
    'Description',Description, 'Vcc_Erec',Vcc_Erec, ...
    'Tj_Erec',Tj_Erec, 'If_Erec',If_Erec, 'Erec',Erec, ...
    'Tj_OnState',Tj_OnState, 'If_OnState',If_OnState, 'Vf_OnState',Vf_OnState, ...
    'Rth_jc',Rth_jc, 'Cth_j',Cth_j);
%
clear Vcc_Erec Tj_Erec If_Erec Erec Tj_OnState ...
      If_OnState Vf_OnState Manufacturer PartNo Description Type ...
      Rth_jc Cth_j Tj_800A Erec_800A
%=========================end of specifications===========================


%% ABB - Diode, Half-bridge IGBT Module, 3300V, 250A;
Type='Diode';
Manufacturer= 'ABB';
PartNo= '5SNG 0250P330300';
Description= 'Half-bridge IGBT Module, 3300V, 250A';

% For Tj=25 deg. C, manufacturer specifications provide Erec at only one current (250 A).
% The Erec values for Tj=25 deg. C and Tj=125 deg. C, 250 A specified below
% are used to deduce the Erec(Ic) curve @ Tj=25 deg. C from the Erec(Ic) curve @ Tj=125 deg. C 
% assuming that Erec stays proportionnal to its value  @ Tj= 125 deg. C

Tj_250A=   [ 25   125 ];  % Junction temperature (C) 
Erec_250A= [ 165  280 ];  % Reverse recovery energy at Tj_250A (mJ) for If=250A
%
% Typical reverse recovery energy (Erec) vs If
Vcc_Erec= 1800;  
Tj_Erec=  [ 25 125 ];    
If_Erec=   [ 0  26.2  48.9  99   150  199  250  299  350  400  450  ]; 
% Erec @ 125 C (per data sheet curves)
Erec(2,:)= [ 0  85.9  113   165  211  248  280  306  325  336  340  ];
% Eon @ 25 C (calculated using data sheet spec at 25 C)
Erec(1,:)=Erec_250A(1)/Erec_250A(2) * Erec(2,:);
%
% Diode - Typical on-state characteristics
Tj_OnState=  [ 25 125 ]; 
If_OnState = [ 0  0.01  14.0  43    66.5  101  162   250   401   500  ];
Vf_OnState = [ 0  0.75  1.13  1.40  1.53  1.65 1.81  2.00  2.25  2.39 
               0  0.50  0.90  1.20  1.37  1.55 1.81  2.11  2.50  2.71 ];   
%-------------------------------------------------------------------------
%
% Thermal Impedance:
%
Rth_jc=0.102; % Junction-to-Case thermal resistance(K/W)
% Based on transient thermal impedance vs. time curve
Cth_j=1.3235;    % Junction thermal capacitance (Joule/Kelvin)
%
%-------------------------------------------------------------------------
LossSpec_Diode(3)= struct('Type',Type, 'Manufacturer',Manufacturer, 'PartNo',PartNo, ...
    'Description',Description, 'Vcc_Erec',Vcc_Erec, ...
    'Tj_Erec',Tj_Erec, 'If_Erec',If_Erec, 'Erec',Erec, ...
    'Tj_OnState',Tj_OnState, 'If_OnState',If_OnState, 'Vf_OnState',Vf_OnState, ...
    'Rth_jc',Rth_jc, 'Cth_j',Cth_j);
%
clear Vcc_Erec Tj_Erec If_Erec Erec Tj_OnState ...
      If_OnState Vf_OnState Manufacturer PartNo Description Type ...
      Rth_jc Cth_j Tj_250A Erec_250A
%=========================end of specifications===========================

%% Add your own specifications here
% Type='Diode';
% Manufacturer= 'My Manufacturer';
% PartNo= 'XXX';
% Description= 'My Module, YYY V, ZZZ A;
% ....


%% Save diode thermal data structure "LossSpec_Diode" in "LossSpec_Diode_Library.mat" file
save LossSpec_Diode_Library LossSpec_Diode
%