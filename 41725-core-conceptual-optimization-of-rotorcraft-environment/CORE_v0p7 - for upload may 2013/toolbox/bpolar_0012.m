function [cl,cd] = bpolar(BladeState,AC)
% To make your own bpolar:
% BladeState is the state of the blade element with matrix components:
% BladeState =
%            M: Mach number
%        alpha: angle of attack (radians)
%            r: radius location (nondimensional)
%          psi: azimuth location (radians)
%     alphadot: rate of change of angle of attack (rad/s)
%           Re: Reynolds number
% all components on BladeState inputs are m x n, where n is the number of
% blade elements, and m is the uniformly distributed number of azimuth
% elements.
%
% NB: this function should run VERY fast, so avoid loops and extensive
% interpolation.
% see also lininterp1f
%
% AC is a structure with AC data (see documentation)
%
% cl and cd are the m x n arrays containing each blade element's lift and
% drag coefficients.
% note that output coefficients will be non-dimensionalized by a constant
% blade chord, typically the average blade chord.
%
% The blade polar function is responsible for capturing all important rotor
% phenomena, including reverse flow, retreating blade stall, and advancing
% tip critical mach number.
%
% to capture reverse flow effects, the drag polar should be able to handle
% alphas +/- 360 deg
%
% critical mach drag rise and stall should also be modeled.

% This file is an example of using wind tunnel data (NACA 0012), very fast
% interpolation, and a critical mach drag rise approximation.


% Drag Coefficient data
%from http://www.cyberiad.net
% -------------------------------- REYNOLDS NUMBER -----------------------

% RE = [5000000] ;

DragData = [    0.0064
    0.0064
    0.0066
    0.0068
    0.0072
    0.0076
    0.0081
    0.0086
    0.0092
    0.0098
    0.0106
    0.0118
    0.0130
    0.0143
    0.0159
    0.0177
    0.0198
    0.0229
    0.1480
    0.2740
    0.2970
    0.3200
    0.3440
    0.3690
    0.3940
    0.4200
    0.4460
    0.4730
    0.5700
    0.7450
    0.9200
    1.0750
    1.2150
    1.3450
    1.4700
    1.5750
    1.6650
    1.7350
    1.7800
    1.8000
    1.8000
    1.7800
    1.7500
    1.7000
    1.6350
    1.5550
    1.4650
    1.3500
    1.2250
    1.0850
    0.9250
    0.7550
    0.5750
    0.4200
    0.3200
    0.2300
    0.1400
    0.0550
    0.0250
    0.0550
    0.1400
    0.2300
    0.3200
    0.4200
    0.5750
    0.7550
    0.9250
    1.0850
    1.2250
    1.3500
    1.4650
    1.5550
    1.6350
    1.7000
    1.7500
    1.7800
    1.8000
    1.8000
    1.7800
    1.7350
    1.6650
    1.5750
    1.4700
    1.3450
    1.2150
    1.0750
    0.9200
    0.7450
    0.5700
    0.4730
    0.4460
    0.4200
    0.3940
    0.3690
    0.3440
    0.3200
    0.2970
    0.2740
    0.1480
    0.0229
    0.0198
    0.0177
    0.0159
    0.0143
    0.0130
    0.0118
    0.0106
    0.0098
    0.0092
    0.0086
    0.0081
    0.0076
    0.0072
    0.0068
    0.0066
    0.0064
    0.0064];
LiftData =[          0
    0.1100
    0.2200
    0.3300
    0.4400
    0.5500
    0.6600
    0.7700
    0.8800
    0.9900
    1.1000
    1.1842
    1.2673
    1.3242
    1.3423
    1.3093
    1.2195
    1.0365
    0.9054
    0.8412
    0.8233
    0.8327
    0.8563
    0.8903
    0.9295
    0.9718
    1.0193
    1.0680
    0.9150
    1.0200
    1.0750
    1.0850
    1.0400
    0.9650
    0.8750
    0.7650
    0.6500
    0.5150
    0.3700
    0.2200
    0.0700
    -0.0700
    -0.2200
    -0.3700
    -0.5100
    -0.6250
    -0.7350
    -0.8400
    -0.9100
    -0.9450
    -0.9450
    -0.9100
    -0.8500
    -0.7400
    -0.6600
    -0.6750
    -0.8500
    -0.6900
    0
    0.6900
    0.8500
    0.6750
    0.6600
    0.7400
    0.8500
    0.9100
    0.9450
    0.9450
    0.9100
    0.8400
    0.7350
    0.6250
    0.5100
    0.3700
    0.2200
    0.0700
    -0.0700
    -0.2200
    -0.3700
    -0.5150
    -0.6500
    -0.7650
    -0.8750
    -0.9650
    -1.0400
    -1.0850
    -1.0750
    -1.0200
    -0.9150
    -1.0680
    -1.0193
    -0.9718
    -0.9295
    -0.8903
    -0.8563
    -0.8327
    -0.8233
    -0.8412
    -0.9054
    -1.0365
    -1.2195
    -1.3093
    -1.3423
    -1.3242
    -1.2673
    -1.1842
    -1.1000
    -0.9900
    -0.8800
    -0.7700
    -0.6600
    -0.5500
    -0.4400
    -0.3300
    -0.2200
    -0.1100
    0];
Alpha =[0
    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    30
    35
    40
    45
    50
    55
    60
    65
    70
    75
    80
    85
    90
    95
    100
    105
    110
    115
    120
    125
    130
    135
    140
    145
    150
    155
    160
    165
    170
    175
    180
    185
    190
    195
    200
    205
    210
    215
    220
    225
    230
    235
    240
    245
    250
    255
    260
    265
    270
    275
    280
    285
    290
    295
    300
    305
    310
    315
    320
    325
    330
    333
    334
    335
    336
    337
    338
    339
    340
    341
    342
    343
    344
    345
    346
    347
    348
    349
    350
    351
    352
    353
    354
    355
    356
    357
    358
    359
    360]*pi/180;
modinpcount = 0;
while any(BladeState.alpha(:)<0)
    ind = BladeState.alpha<0;
    BladeState.alpha(ind) = BladeState.alpha(ind)+2*pi;
    modinpcount=modinpcount+1;
end
if modinpcount>2
    disp('crazy stuff going on in bpolar - very very negative alphas')
end
modinpcount = 0;
while any(BladeState.alpha(:)>2*pi)
    ind = BladeState.alpha>2*pi;
    BladeState.alpha(ind) = BladeState.alpha(ind)-2*pi;
    modinpcount=modinpcount+1;
end
if modinpcount>1
    disp('crazy stuff going on in bpolar - very very positive alphas')
end
cd = mylerp1(Alpha,DragData,BladeState.alpha);%,'linear');
cl = mylerp1(Alpha,LiftData,BladeState.alpha);%,'linear');
if any(isnan([cd(:);cl(:)]));
    disp('    check this out')
end
% Data from http://adg.stanford.edu/aa241/drag/dragrise.html
% at Cl of .3
% M-Mcrit:
Mdiff0 =[ -1
    -0.15
    -0.125
    -0.1
    -0.075
    -0.05
    -0.025
    0
    0.025
    0.05
    0.075
    0.1
    0.125
    0.15
    0.175
    0.2
    0.225
    10000.225];

Cdinvisc =[0
    0
    0
    0.000025
    0.00005
    0.00015
    0.0005
    0.002
    0.0052
    0.0103
    0.0173
    0.026
    0.037
    0.048
    0.068
    0.1
    0.148
    20000];

Mcrit = max(.55,-.02002*abs(BladeState.alpha)+.765);
% from ESDU AERO W.00.03.01
% Critical Mach number for high speed aerofoil sections.

cd = cd + mylerp1(Mdiff0,Cdinvisc,abs(BladeState.M)-Mcrit);

%tip loss
ind = BladeState.r>.97;
cl(ind)=cl(ind).*(1-(BladeState.r(ind)-.97)/.03);

%% root cutout
cl(BladeState.r<.15) = 0;
cd(BladeState.r<.15) = .1;

if any([isnan(cl(:)) isnan(cd(:))])
    disp('NaN in bpolar function')
    cd(isnan(cd)) = 1;
    cl(isnan(cl)) = 1;
end

end

function yi = mylerp1(x,y,xi)
% Y = interp1(x,y,X,'linear');

toreshape = size(xi);
xi = xi(:);
yi = lininterp1f(x,y,xi,NaN); %mex .dll function
yi = reshape(yi,toreshape);

end