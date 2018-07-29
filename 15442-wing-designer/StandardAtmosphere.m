function [dens, a, visc] = StandardAtmosphere(alt)
%Read in altitude and output viscosity, density, and speed of sound
%Units:
%altitude as a string in ft
%density in kg/m^3
%speed of sound, a, in m/s

%Convert altitude to number in meters
alt = str2num(alt)*0.3048;

g = 9.80665;
R = 287.1;
gamma = 1.4;
if alt < 11000
    T1 = 288.16;  %From Anderson, Introduction to Flight, 5 ed, pg 109
    laps = -6.5e-3;
    T = T1 + laps*(alt);
    dens1 = 1.2250;
    dens = (T/T1)^-(g/(laps*R)+1)*dens1;
elseif alt >= 11000 & alt < 25000
    T1 = 216.66;
    T = T1;
    dens1 = 0.3640;
    dens = exp(-g/(R*T)*(alt-11000))*dens1;
else
    T1 = 216.66;
    laps = 3e-3;
    T = T1 + laps*(alt);
    dens1 = 0.11;
    dens = (T/T1)^-(g/(laps*R)+1)*dens1;
end
a = sqrt(gamma*R*T);
visc = 1.458e-6*T^1.5/(T+110.1); %Bertin, Aerodynamics for Engineers, 4 ed, pg 5