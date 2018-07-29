% Excersize 1 - Calculate the equilibrium surface temperature of an icy
% body (e.g. a comet) at a given distance from the Sun.

% This sample program is a script that balances the equation of heat
% transfer on the surface of a ball made of ice, to find an equilibrium
% temperature. This script demonstrates how physical units can be used in
% calculations.

%% Set up the workspace with needed variables
si=setUnits;
% We begin by calling the |setUnits| function in order to get the interface
% structure that holds all predefined units.

LSun=3.8e26*si.joule/si.second;
% Total brightness of the Sun. This is the energy radiated by the Sun every
% second. (Tip: si.s is shorthand for si.second.)

dSun=2.5*1.496e11*si.meter;
% Distance from the Sun to the body whose temperature we must calculate. I
% have chosen a distance of 2.5 astronomical units (Earth-Sun distances)
% that puts our "comet" betwen Mars and Jupiter. (Tip: si.astronomical_unit
% is already defined, and si.AU is even easier. Also, si.m is shorthand for
% si.meter.)

KB=1.3806e-23*si.joule/si.K;
% Boltzmann's constant. (Tip: si.boltzmann is defined.)

stefan=5.67e-8*si.joule/si.m^2/si.s/si.K^4;
% The Stefan-Boltzmann constant. (Tip: Guess what, si.stefan_boltzmann.)

Hice=2.8345e6*si.joule/si.kg;
% Latent heat for sublimation of ice.

A=3.56e12*si.newton/si.m^2; B=6141.667*si.kelvin;
% These parameters are used in an empirical formula for the saturation
% vapor pressure. (Tip: si.N and si.K are shorter.)

avogad=6.022e23*si.mole^(-1);
% Avogadro's number. (Tip: Try si.avogadro.)

mH2O=18*si.g/si.mole;
% The molecular weight of water.

%% Now, Lion-hunt for the temperature of equilibrium
% When we write down the equation:
% radiant energy from the Sun = (radiant + sublimation)energy from the body
% we essentially get an implicit function of temperature vs. distance from
% the Sun. This function however cannot be inverted so we need to hunt for
% the temperature that will balance the equation.

tol=1e-3;
% We'll use this as the relative accuracy.

Tlo=1*si.K; Thi=400*si.K;
% The desired temperature is definitely bracketed by these values.

while (Thi-Tlo)/Thi>tol
    T=(Tlo+Thi)/2;
    fT=(stefan*T^4)+(Hice*sqrt(mH2O/(2*avogad*pi*KB*T))*A*exp(-(B/T)))-...
        (0.25*(LSun/(4*pi*dSun^2)));
    if double(fT)>0
        Thi=T;
    else
        Tlo=T;
    end
end

%% That's it. The desired temperature is
fprintf('The equilibrium temperature is\n')
T
% Try to introduce an easy-to-make-hard-to-detect error in one of the above
% statements, and run the script again. Instead of getting a wrong answer
% you will probably get an informative error message that will help you
% trace the "bug".