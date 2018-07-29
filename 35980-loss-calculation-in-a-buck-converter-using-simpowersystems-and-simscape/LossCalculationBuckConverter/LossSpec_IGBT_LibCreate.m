% This M file creates the "LossSpec_IGBT_Library.mat " file 
% containing loss and thermal IGBT models provided in the
% "LossModelib.mdl' libray.
% IGBT specifications are saved in the "LossSpec_IGBT" structure. 
%
% Data provided below for three different commercial 
% IGBT/Diode half-bridge packs are extracted from manufacturer data sheets 
% (see pdf files provided in the same directory).
%
% How to to add your own IGBT specifications
% ------------------------------------------
%   1)  Open the "LossModelib.mdl' library
%   2)  Duplicate a cell containing specifications of one existing IGBT 
%       and insert it at the end of this file 
%       (see "Add your own specifications here" cell)
%   3)  Modify this new set of data according to your specifications
%   4)  Run this script file in order to update the "LossSpec_IGBT_Library.mat " file
%   5)  In the "LossModelib.mdl' library
%            - select the IGBT or half-bridge model to update
%            - open the Mask Editor 
%            - select "IGBT_Type" parameter
%            - In the "Popups" window, enter a new description 
%              after existing IGBT descriptions 
%   6) Save the "LossModelib.mdl' library.
% Note: Future release of SPS will provide an easy-to-use GUI to add or
% edit device characteristics.

% Pierre Giroux, Hydro-Quebec (IREQ), March 2012

% Ic=  Collector current
% Vce= Collector-emitter voltage
% Eon= Turn-on switching energy (mJ)
% Eoff= Turn-off switching energy (mJ)
% Tj= Junction temperature (degrees Celsius)
% Vcc= Supply voltage (V)
% Note1: IGBT switching energies are function of Vcc, Ic and Tj
% Note2: IGBT on-state losses = Vce (function of Ic and Tj) * Ic
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear all

%% Fuji Electric IGBT Module, 2 in one-package, 600V, 150A
Type='IGBT';
Manufacturer= 'Fuji Electric';
PartNo= '2MBI150U2A 060';
Description= 'IGBT Module, 2 in one-package, 600V, 150A';
%
% Typical turn-on (Eon)switching energies vs Ic
Vcc_Eon= 300;
Tj_Eon=  [  25 125 ]; 
Ic_Eon=  [  0  25    50    75    100   125   150   175   200   225  ]; 
Eon=     [  0  0.85  1.62  2.40  3.18  4.02  4.87  5.83  6.81  7.84
            0  1.12  2.15  3.20  4.27  5.49  6.67  8.18  9.85  11.6 ]; 
% Typical turn-off (Eoff)switching energies vs Ic
Vcc_Eoff= 300;
Tj_Eoff=  [ 25 125 ]; 
Ic_Eoff=  [ 0  25    50    75    100   125   150   175   200   225  ]; 
Eoff=     [ 0  0.66  1.33  2.13  3.18  4.37  5.46  6.90  8.34  9.92 
            0  0.87  1.97  2.99  4.27  5.49  6.90  8.43  10.1  11.8 ];        
% Typical on-state characteristics
Tj_OnState=  [ 25 125 ];      
Ic_OnState = [ 0   1      5     10    15    33    50    75    100   150   200   300 ]; 
Vce_OnState= [ 0   0.64   0.74  0.80  0.87  1.08  1.19  1.37  1.51  1.77  2.03  2.48
               0   0.48   0.66  0.75  0.87  1.08  1.26  1.50  1.68  2.02  2.35  3.01 ];
%-------------------------------------------------------------------------
%
% Thermal Impedance:
%
Rth_jc=0.25;    % Junction-to-Case thermal resistance(K/W)
% Based on transient thermal impedance vs. time curve
Cth_j=0.27;   % Junction thermal capacitance (Joule/Kelvin)
%
%-------------------------------------------------------------------------
LossSpec_IGBT(1)= struct('Type',Type, 'Manufacturer',Manufacturer, 'PartNo',PartNo, ...
    'Description',Description, 'Vcc_Eon',Vcc_Eon, ...
    'Tj_Eon',Tj_Eon, 'Ic_Eon',Ic_Eon, 'Eon',Eon, 'Vcc_Eoff',Vcc_Eoff, ...
    'Tj_Eoff',Tj_Eoff, 'Ic_Eoff',Ic_Eoff, 'Eoff',Eoff, ...
    'Tj_OnState',Tj_OnState, 'Ic_OnState',Ic_OnState, 'Vce_OnState',Vce_OnState, ...
    'Rth_jc',Rth_jc, 'Cth_j',Cth_j);
clear Vcc_Eon Tj_Eon Ic_Eon Eon Vcc_Eoff Tj_Eoff Ic_Eoff Eoff Tj_OnState ...
      Ic_OnState Vce_OnState Manufacturer PartNo Description Type ...
      Rth_jc Cth_j 
%=========================end of specifications===========================

%% ABB IGBT Module, ABB HiPak, 1700V, 800A

Type='IGBT';
Manufacturer= 'ABB';
PartNo= '5SNE 0800M170100';
Description= 'IGBT Module, ABB HiPak, 1700V, 800A';

% For Tj=25 deg. C, manufacturer specifications provide Eon and Eoff at only one current (800 A).
% The Eon and and Eoff values @ Tj=25 and 125 deg. C, 800 A specified below
% are used to deduce the Eon(Ic) and Eoff(Ic) curves @ Tj=25 deg. C,
% from the Eon(Ic) and Eoff(Ic) curves @ Tj=125 deg. C
% assuming that Eon and Eoff stay proportionnal to their values @ Tj= 125 deg. C

Tj_800A=   [ 25   125 ];  % Junction temperature (degrees Celsius)
Eon_800A=  [ 160  250 ];  % Turn-on energy at Tj_800A (mJ) for Ic=800A
Eoff_800A= [ 220  300 ];  % Turn-off energy at Tj_800A (mJ) for Ic=800A
%
% Typical turn-on (Eon)switching energies vs Ic
Vcc_Eon= 900;  
Tj_Eon=  [ 25 125 ];    
Ic_Eon=    [ 0 198  399 501 686 800 900 999 1100 1200 1300 1440 1550 1620 ];
% Eon @ 125 C (per data sheet curves)
Eon(2,:)=  [ 0 73.4 108 136 202 250 300 350 413  480  551  652  750  810  ];
% Eon @ 25 C (calculated using data sheet spec at 25 C)
Eon(1,:)=Eon_800A(1)/Eon_800A(2) * Eon(2,:);
%
% Typical turn-off (Eoff)switching energies vs Ic
Vcc_Eoff= 900;  
Tj_Eoff=  [ 25 125 ];    
Ic_Eoff=    [ 0 198  399 501 686 800 900 999 1100 1200 1300 1440 1550 1620 ];
% Eon @ 125 C (per data sheet curves)
Eoff(2,:)=  [ 0 99.7 161 192 255 300 335 372 413  451  497  558  608  640  ]; 
% Eon @ 25 C (calculated using data sheet spec at 25 C)
Eoff(1,:)=Eoff_800A(1)/Eoff_800A(2) * Eoff(2,:);
%
% IGBT - Typical on-state characteristics
Tj_OnState=  [ 25 125 ];      % (C)
Ic_OnState = [ 0  0.01  46   102  194  299  399  498  601  700  797  999  1200 1500 ];
Vce_OnState= [ 0  0.70  0.99 1.19 1.38 1.57 1.72 1.86 2.00 2.13 2.25 2.50 2.74 3.11
               0  0.70  0.87 1.12 1.38 1.65 1.85 2.04 2.23 2.41 2.58 2.93 3.28 3.82 ]; 
%-------------------------------------------------------------------------
% Thermal properties:
%
Rth_jc=0.021;   % Junction-to-Case thermal resistance(K/W)
%
% Based on transient thermal impedance vs. time curve
Cth_j=6.5095;     % Junction thermal capacitance (Joule/Kelvin)
%
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
LossSpec_IGBT(2)= struct('Type',Type, 'Manufacturer',Manufacturer, 'PartNo',PartNo, ...
    'Description',Description, 'Vcc_Eon',Vcc_Eon, ...
    'Tj_Eon',Tj_Eon, 'Ic_Eon',Ic_Eon, 'Eon',Eon, 'Vcc_Eoff',Vcc_Eoff, ...
    'Tj_Eoff',Tj_Eoff, 'Ic_Eoff',Ic_Eoff, 'Eoff',Eoff, ...
    'Tj_OnState',Tj_OnState, 'Ic_OnState',Ic_OnState, 'Vce_OnState',Vce_OnState, ...
    'Rth_jc',Rth_jc, 'Cth_j',Cth_j);
%
clear Vcc_Eon Tj_Eon Ic_Eon Eon Vcc_Eoff Tj_Eoff Ic_Eoff Eoff Tj_OnState ...
      Ic_OnState Vce_OnState Manufacturer PartNo Description Type ...
      Rth_jc Cth_j Tj_800A Eon_800A Eoff_800A
%=========================end of specifications============================


%% ABB  Half-bridge IGBT Module, 3300V, 250A
Type='IGBT';
Manufacturer= 'ABB';
PartNo= '5SNG 0250P330300';
Description= 'Half-bridge IGBT Module, 3300V, 250A';

% For Tj=25 deg. C, manufacturer specifications provide Eon and Eoff at only one current (250 A).
% The Eon and and Eoff values @ Tj=25 and 125 deg. C, 250 A specified below
% are used to deduce the Eon(Ic) and Eoff(Ic) curves @ Tj=25 deg. C,
% from the Eon(Ic) and Eoff(Ic) curves @ Tj=125 deg. C
% assuming that Eon and Eoff stay proportionnal to their values @ Tj= 125 deg. C


Tj_250A=   [ 25    125 ];  % Junction temperature (degrees Celsius)
Eon_250A=  [ 330   425 ];  % Turn-on energy at Tj_250A (mJ) for Ic=250A
Eoff_250A= [ 330   450 ];  % Turn-off energy at Tj_250A (mJ) for Ic=250A
%
% Typical turn-on (Eon)switching energies vs Ic
Vcc_Eon= 1800;  
Tj_Eon=  [ 25 125 ];    
Ic_Eon=   [ 0 37.8  99   199  250  300  349  400  451  499  ];
% Eon @ 125 C (per data sheet curves)
Eon(2,:)= [ 0 83.6  160  318  425  522  643  775  919  1070 ];
% Eon @ 25 C (calculated using data sheet spec at 25 C)
Eon(1,:)=Eon_250A(1)/Eon_250A(2) * Eon(2,:);
%
% Typical turn-off (Eoff)switching energies vs Ic
Vcc_Eoff= 1800;  
Tj_Eoff=  [ 25 125 ];    
Ic_Eoff=    [ 0 37.8  99   199  250  300  349  400  451  499  ];
% Eon @ 125 C (per data sheet curves)
Eoff(2,:)=  [ 0 118   218  381  450  543  622  699  782  861  ]; 
% Eon @ 25 C (calculated using data sheet spec at 25 C)
Eoff(1,:)=Eoff_250A(1)/Eoff_250A(2) * Eoff(2,:);
%
% IGBT - Typical on-state characteristics
Tj_OnState=  [ 25 125 ];      % (C)
Ic_OnState=  [ 0   1      16    77    131   174   276   375   500  ];
Vce_OnState= [ 0   0.51   1.00  1.50  1.81  2.04  2.49  2.88  3.37 
               0   0.50   1.00  1.71  2.18  2.50  3.11  3.77  4.52 ]; 
%-------------------------------------------------------------------------
% Thermal properties:
%
Rth_jc=0.051;   % Junction-to-Case thermal resistance(K/W)
%
% Based on transient thermal impedance vs. time curve
Cth_j=2.6804;     % Junction thermal capacitance (Joule/Kelvin)
%
%-------------------------------------------------------------------------
LossSpec_IGBT(3)= struct('Type',Type, 'Manufacturer',Manufacturer, 'PartNo',PartNo, ...
    'Description',Description, 'Vcc_Eon',Vcc_Eon, ...
    'Tj_Eon',Tj_Eon, 'Ic_Eon',Ic_Eon, 'Eon',Eon, 'Vcc_Eoff',Vcc_Eoff, ...
    'Tj_Eoff',Tj_Eoff, 'Ic_Eoff',Ic_Eoff, 'Eoff',Eoff, ...
    'Tj_OnState',Tj_OnState, 'Ic_OnState',Ic_OnState, 'Vce_OnState',Vce_OnState, ...
    'Rth_jc',Rth_jc, 'Cth_j',Cth_j);
%
clear Vcc_Eon Tj_Eon Ic_Eon Eon Vcc_Eoff Tj_Eoff Ic_Eoff Eoff Tj_OnState ...
      Ic_OnState Vce_OnState Manufacturer PartNo Description Type ...
      Rth_jc Cth_j Tj_250A Eon_250A Eoff_250A
%=========================end of specifications===========================

%% Add your own specifications here
% Type='IGBT';
% Manufacturer= 'My Manufacturer';
% PartNo= 'XXX';
% Description= 'My IGBT Module, YYY V, ZZZ A;
% ....

%% Save IBGT thermal data structure "LossSpec_IGBT" in "LossSpec_IGBT_Library.mat" file
save LossSpec_IGBT_Library LossSpec_IGBT
%----------------------------END OF SCRIPT FILE--------------------------------;