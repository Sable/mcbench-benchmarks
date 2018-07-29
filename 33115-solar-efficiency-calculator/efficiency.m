function [FF, eta, Voc, Isc, Imp, Vmp] = efficiency(Volts,Curr,measInt,cellArea)
%% 	efficiency.m   extract cell parameters from an illuminated IV curve
%    Created by Jacob Mohin on 2011-01-13 
%    Last updated:  2011-10-3
%
%   OUTPUT VARIABLES
%   FF (Fill factor) - ratio of max power to theoretcial power
%   eta   - principle cell efficiency 
%   Voc   - cell Open-Circuit Voltage
%   Isc   - cell Short-Circuit Current
%   Imp   - Current at the max power point
%   Vmp   - Voltage at the max power point
%
%   INPUT VARIABLES
%   Volts - array of voltages used to sweep the cell
%   Curr  - array of measured current at each voltage, in mA

%******PLEASE NOTE VOLTS AND CURR ARRAYS SHOULD BE THE SAME LENGTH*********


%   measInt -  the intensity of light used to illuminate the cell, in
%              mW/cm^2
%   cellArea - the cell area in M^2 (for now, until I change it to cm^2)
%   
%
% 	See comments in code for explanations/justifications
%   Data should be taken in from the kv200IVSweep.m file when possible
% 	
%

%%%%%Find size of fills - real and theoretical
%
% Find the two points immediately above and below zero
%   %%%%%% tested to be more accurate AND faster than interpolation to 
    %%%%%% find the zero-crossing for systems with >250 data points %%%%%
    zPhi=find(Curr>0,1,'first');
    zPlo=find(Curr<0,1,'last');
%
% Get the slope between these points
  slope=(Curr(zPhi)-Curr(zPlo))/(Volts(zPhi)-Volts(zPlo));
% 
% Find zero crossing, by solving with slope - This is V open-circuit
  Voc = -Curr(zPlo)/slope + Volts(zPlo);

% short circuit is current at V=0 (converted to A)
  zind=find(Volts>0,1)-1;
  Isc = Curr(zind);
% 
% make array of power from I*V, pick out the max 
%  %%% memory intensive but fast; don't give it >1000-point long vars tho %%%%
   fills = -(Curr).*Volts;
   [pmax,pind]=max(fills);
%
% theoretical power from the max we found
  Vmp = Volts(pind);
  Imp = Curr(pind);
  maxPow=abs(Imp*10^-3*Vmp);
% 
% Must convert current to Amps
  theorPow=abs((Isc*10^-3)*Voc);
%
% Find the fill factor and principle cell efficiency 
 measIntCm = measInt*10;
 FF = maxPow/theorPow;
 eta = 100*maxPow / (measIntCm * cellArea);


