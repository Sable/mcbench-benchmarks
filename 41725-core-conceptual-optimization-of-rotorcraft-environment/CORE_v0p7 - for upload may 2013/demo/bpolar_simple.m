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

% This file is a simple but reasonable drag polar
%alphadot is not used for this simple polar, but can be used for more
%complex historesis stall behavior, etc.

RootCutout = .15;
Clmax = 1.35;

%%
alpha = BladeState.alpha;
r = BladeState.r;
M = BladeState.M;

tau = 2*pi;

astallmax = Clmax/tau;

% put all values between 0 and 360
ind = alpha<0;
while any(ind(:))
    alpha(ind) = alpha(ind)+tau;
    ind = alpha<0;
end
ind = alpha>tau;
while any(ind(:))
    alpha(ind) = alpha(ind)-tau;
    ind = alpha>tau;
end

% flat plate:
% fpClmax = 1.05;
% fpCl = @(a) fpClmax*sin(2*a);
% fpCd = @(x) -.9*cos(2*x) +.92;  
cl = 1.05*sin(2*alpha);
cd= -.9*cos(2*alpha)+.92;

ind = alpha<=astallmax;
cl(ind) = tau*alpha(ind);
cd(ind)=.006+.1737*alpha(ind).^2;

ind = alpha>=tau-astallmax;
cl(ind) = tau*(alpha(ind)-tau);
cd(ind)=.006+.1737*(alpha(ind)-tau).^2;


% Critical Mach
absalpha = abs(alpha);
absalpha(alpha>pi/2) = abs(alpha(alpha>pi/2)-pi);
absalpha(alpha>3*pi/2) = abs(alpha(alpha>3*pi/2)-tau);
Mcrit = max(.55,-.02*absalpha+.765);
% from ESDU AERO W.00.03.01

dM = abs(M)-Mcrit;
drise = 801.6*exp(-((dM-1.441)/.4146).^2);
drise(dM>.3147) = .5;
cd = cd + drise;

%tip loss
ind = r>.97;
cl(ind)=cl(ind).*(1-(r(ind)-.97)/.03);

%% root cutout
cl(r<RootCutout) = 0;
cd(r<RootCutout) = .1;
