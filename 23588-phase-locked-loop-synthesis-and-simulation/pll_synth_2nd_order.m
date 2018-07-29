function [cap res] = pll_synth_2nd_order(ipump, vco_sensitivity, fout, fcomp, bandwidth, pm)

% Synthesizes PLL loop components for a 2nd order system using the
% topology shown below.  It is recommended that the results are verified
% using the pll_simulation.m script.
%
% Input - ipump is the charge pump current in Amperes
%       - vco_sensitivity is the VCO sensitivity in Hertz/Volt
%       - fout is the output frequency in Hertz
%       - fcomp is the comparison frequency in Hertz
%       - bandwidth is the open loop bandwidth in Hertz
%       - pm is the phase margin in degrees
% Output - cap is the capacitors of the loop in Farads [C1, C2, 0, 0]
%        - res is the resistors of the  loop in Ohms [ R2, 0, 0]   
%
% The method used here is derived from that presented in Dean Banerjee's
% Book "PLL Performance, Simulation, and Design" 4th Ed available at
% National Semiconductors site www.national.com.  Most of the work is
% derived from Chapter 21 pp.174-178.
%
% 
% Loop Topology
% 
%        +  _____                                   ______
% fcomp -->|Phase|----------------------------------| VCO |---->fout
%          |Det. |     |      |                     |     |  |
%           -----      |      |                      -----   |
%            ^ -      C1     R2                              |
%            |         |      |                              |
%            |        GND    C2                              |
%            |                |                              |
%            |               GND                             |
%            |                           _______             |
%            ----------------------------| 1/N |--------------
%                                        -------    
%   Author: Ben Gilbert 
%   Homepage: http://nicta.com.au/people/gilbertb
%   Email: ben.gilbert (wibble) nicta.com.au
%   (c) 2009 by National ICT Australia (NICTA)
%   

%% Design Parameters
% The following values will give sensible results but not necessarily
% optimal
gamma = 1.0; % optimization factor p172 and pp220-227 of Banerjee

% Conversion of parameters to more convenient units
Kpd = ipump/2/pi; % phase detector gain
Kvco = vco_sensitivity*2*pi; % vco gain
omega = 2*pi* bandwidth; % open loop bandwidth in radians/sec

%% Synthesis
%% Find T1 and T2
T1 = (sqrt( (1 + gamma)^2 * tan(pm*pi/180)^2 + 4*gamma ) - (1+gamma)*tan(pm*pi/180) )/2/omega;
T2 = gamma/omega^2/T1;

%% Solving for Loop Components
A0 = Kpd * Kvco * fcomp/fout / omega^2 * sqrt((1+omega^2*T2^2)/(1+omega^2*T1^2));

C1 = A0*T1/T2;
C2 = A0-C1;
R2 = T2/C2;

cap = [C1 C2 0 0];
res = [R2 0 0];