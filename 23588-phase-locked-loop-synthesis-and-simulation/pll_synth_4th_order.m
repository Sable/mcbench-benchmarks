function [cap res] = pll_synth_4th_order(ipump, vco_sensitivity, fout, fcomp, bandwidth, pm)

% Synthesizes PLL loop components for a 4th order system using the
% topology shown below.  
%
% Input - ipump is the charge pump current in Amperes
%       - vco_sensitivity is the VCO sensitivity in Hertz/Volt
%       - fout is the output frequency in Hertz
%       - fcomp is the comparison frequency in Hertz
%       - bandwidth is the open loop bandwidth in Hertz
%       - pm is the phase margin in degrees
% Output - cap is the capacitors of the loop in Farads [C1, C2, C3, C4]
%        - res is the resistors of the  loop in Ohms [ R2, R3, R4]   
%
% The method used here is derived from that presented in Dean Banerjee's
% Book "PLL Performance, Simulation, and Design" 4th Ed available at
% National Semiconductors site www.national.com.  Most of the work is
% derived from Chapter 23 pp.186-197.
%
% No closed form solution exists for 4th 
% order systems, therefore some simplification of the model has been made 
% to derive the results.  Due to the simplifications the results will 
% also not always be 100% accurate.  It is recommended that the 
% results are verified using the pll_simulation.m script, which does not
% use a simplified model.
% 
% Loop Topology
% 
%        +  _____                                   ______
% fcomp -->|Phase|-----------------R3------R4-------| VCO |---->fout
%          |Det. |     |      |         |     |     |     |  |
%           -----      |      |         |     |      -----   |
%            ^ -      C1     R2        C3     C4             |
%            |         |      |         |     |              |
%            |        GND    C2        GND   GND             |
%            |                |                              |
%            |               GND         _______             |
%            ----------------------------| 1/N |--------------
%                                        -------    
%
%   Author: Ben Gilbert 
%   Homepage: http://nicta.com.au/people/gilbertb
%   Email: ben.gilbert (wibble) nicta.com.au
%   (c) 2009 by National ICT Australia (NICTA)
%   

%% Design Parameters
% The following values will give sensible results but not necessarily
% optimal
T31 = 0.4; % T3/T1 ratio of time constants
T43 = 0.4; % T4/T1/T31 ratio of time constants
gamma = 1.0; % optimization factor p172 and pp220-227 of Banerjee

% Conversion of parameters to more convenient units
Kpd = ipump/2/pi; % phase detector gain
Kvco = vco_sensitivity*2*pi; % vco gain
omega = 2*pi* bandwidth; % open loop bandwidth in radians/sec

%% Synthesis
%% Find T1 using numerical methods
t1 = (sec(pm*pi/180)-tan(pm*pi/180))/(omega*(1+T31)); % approximate value for T1

% T1 is the root of this equation
num1 = @(t) atan(gamma./(omega.*t*(1+T31)))-atan(omega.*t)-atan(omega.*t*T31) -atan(omega*t*T31*T43 ) - pm*pi/180;
T1 = fzero(num1, t1); % find root numerically

%% Finding T2, T3 and T4
T3 = T1*T31;
T4 = T1*T31*T43;
T2 = gamma/omega^2/(T1+T3+T4);

%% Solving for Loop Components
A0 = Kpd * Kvco * fcomp/fout / omega^2 * sqrt((1+omega^2*T2^2)/(1+omega^2*T1^2)/(1+omega^2*T3^2)/(1+omega^2*T4^2));

a1T3 = A0*(T1+T3);
a2T3 = A0*T1*T3;
c1T3 = a2T3/T2^2 * (1 + sqrt(1+T2/a2T3*(T2*A0-a1T3)) );
c3T3 = (-T2^2*c1T3^2+T2*a1T3*c1T3-a2T3*A0)/(T2^2*c1T3-a2T3);
r3T3 = a2T3/(c1T3*c3T3*T2);

a1T4 = A0*(T1+T4);
a2T4 = A0*T1*T4;
c1T4 = a2T4/T2^2 * (1 + sqrt(1+T2/a2T4*(T2*A0-a1T4)) );
c3T4 = (-T2^2*c1T4^2+T2*a1T4*c1T4-a2T4*A0)/(T2^2*c1T4-a2T4);
r3T4 = a2T4/(c1T4*c3T4*T2);

C1 = (c1T3+c1T4)/2;
R3 = (r3T3+r3T4)/2;


A1 = A0*(T1+T3+T4);
A2 = A0*(T1*T3 + T1*T4 + T3*T4);
A3 = A0*T1*T3*T4;

k0 = A2/A3-1/T2-1/C1/R3-(A0-C1)*T2*R3*C1/A3;
k1 = A1-T2*A0-A3/T2/R3/C1-(A0-C1)*R3*C1;

a = A3/(T2*C1)^2;
b = T2 + R3*(C1-A0) + A3/T2/C1*(1/T2-k0);
c = k1 - k0*A3/T2;

C2 = (-b+sqrt(b^2-4*a*c))/2/a;
R2 = T2/C2;

C3 = T2*A3*C1/R3/(k0*T2*A3*C1-C2*(A3-R3*(T2*C1)^2));
C4 = A0 - C1 -C2 -C3;
R4 = A3/(T2*R3*C1*C3*C4);

cap = [C1 C2 C3 C4];
res = [R2 R3 R4];
