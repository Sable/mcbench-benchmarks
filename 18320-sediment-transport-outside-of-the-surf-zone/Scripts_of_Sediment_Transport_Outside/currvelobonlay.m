function [currentvelo,aproughness,angbsswc] = currvelobonlay(max_orbital_velocity,T,current_velocity_zr,zr,angwc,diam,rho,viscocine,rhom)
% _______________________________________________________________
% This routine gets the wave friction factor, the maximum shear velocity and the maximum bottom shear
% stress and the bottom shear stress phase angle for a pure wave motion over a flat bed.
%
% 0. Syntax:
% [currentvelo, aproughness] = currvelobonlay(max_orbital_velocity,T,current_velocity_zr,zr,angwc,diam,rho,viscocine,rhom)
%
% 1. Inputs:
% max_orbital_velocity = maximum near bottom wave orbital velocity (m/s).
% T = significant wave period (s).
% current_velocity_zr = current magnitud (m/s).
% zr = reference level (m).
% angwc = current direction (degrees).
% diam = sediment grain diameter (m).
% rho = mass density of seawater (kg/m3).
% viscocine = kinematic viscosity (m2/s).
% rhom = mass density fo sediment grains (kg/m3).
%
% 2. Outputs:
% currentvelo = current velocity at z, when z is equal to wave boundary layer thickness  (m/s).
% aproughness = arbitrary constant of integration (m/s).
% angbsswc =  phase angle of the wave associated bottom shear stress for a 
%                          combined wave current bottom boundary layer flow (º).
% 
% 3. Example: 
% currentvelo = 
%   0.054
% aproughness =
%   0.25768     
% angbsswc = 
%   0.023859     
%

% Referents:
%          Fredsoe,  Jorgen and Deigaard Rolf. (1992). Mechanics of Coastal Sediment.
%                Sediment Transport. Advanced Series on Ocean Engineering - Vol. 3.
%                 World Scientific. Singapure.
%          Madsen, Ole S., Wood, William. (2002).  Sediment Transport Outside the 
%                 Surf Zone. In: Vincent, L., and Demirbilek, Z. (editors), 
%                 Coastal Engineering Manual, Part III, Combined wave and current 
%                 bottom boundary layer flow, Chapter III-6, 
%                 Engineer Manual 1110-2-1100, U.S. Army Corps of Engineers,
%                 Washington, DC.
%           Nielsen, Peter. (1992). Coastal Bottom Boundary Layers and
%                 Sediment Transport. Advanced Series on Ocean Engineering - Vol. 4.
%                 World Scientific. Singapure.
%           Salles, Paulo A. (2005). Notes of Coastal Morphologic. UNAM. México.
%
% Programming : Gabriel Ruiz Mtz.
% UNAM.
% 2006
%_____________________________________________________________________

[omega,current_shear_velocity,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom,waveblthickness] = combinedwcbonlay(max_orbital_velocity,T,current_velocity_zr,zr,angwc,diam,rho,viscocine,rhom);
[ripplesh,ripplesl,kn] = ripplesbonlay(max_orbital_velocity,T,diam,rhom,rho,viscocine);
flowm = ( kn * max_shear_velocity ) / viscocine;   
if flowm >= 3.3
       z0 = kn / 30;
else
       z0 = viscocine / ( 9 * max_shear_velocity );
end
currentvelo = ( ( current_shear_velocity / 0.4 ) * ( current_shear_velocity / max_shear_velocity ) * ...
                          log( waveblthickness / z0 ) );
aproughness = ( waveblthickness / exp ( currentvelo / ( current_shear_velocity / 0.4 ) ) );
absswc =( ( pi / 2 ) / ( log( ( 0.4 * w_max_shear_velocity ) / ( z0 * omega ) ) - 1.15 ) );
angbsswc = atan(absswc) * ( 180 / pi );
