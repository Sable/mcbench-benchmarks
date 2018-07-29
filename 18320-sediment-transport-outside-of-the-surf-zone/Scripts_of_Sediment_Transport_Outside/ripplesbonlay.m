function [ripplesh,ripplesl,kn] = ripplesbonlay(max_orbital_velocity,T,diam,rhom,rho,viscocine)
% _______________________________________________________________
% This routine gets the height, length and movable bed roughness of wave ripples in 
% the field.
%
% 0. Syntax:
% [ripplesh,ripplesl,kn] = ripplesbonlay(max_orbital_velocity,T,diam,rhom,rho,viscocine)
%
% 1. Inputs:
% max_orbital_velocity = maximum near bottom wave orbital velocity (m/s).
% T = significant wave period (s).
% rhom = mass density fo sediment grains (kg/m3)
% diam = sediment grain diameter (m).
% rho = mass density of seawater (kg/m3).
% viscocine = kinematic viscosity (m2/s).
%
% 2. Outputs:
% ripplesh = critical shear velocity     (m/s)
% ripplesl = the maximum bottom shear stress    (Pa)
% kn = movable bed roughness (m).
% 
% 3. Example: 
%  [ripplesh,ripplesl,kn] = ripplesbonlay(0.35,8,0.2E-3,2650,1025,1E-6,2650)
% 
% ripplesh = 
%   0.010873
% ripplesl =
%   0.15854
% kn = 
%   0.043491
%
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
%           Salles, Paulo A. (2005). Notes of Coastal Morphology. UNAM. México.
%
% Programming : Gabriel Ruiz Mtz.
% UNAM.
% 2006
%_____________________________________________________________________


[kindflow,omega,fw,max_shear_velocity,max_bottom_shear_stress,phi,Abm] = wavebonlay(max_orbital_velocity,T,diam,rho,viscocine,rhom);
max_shear_velocityprime = max_shear_velocity;
sm = rhom / rho ; 
shieldprime = max_shear_velocityprime ^ 2 / ( ( sm - 1 ) * 9.81 *diam );
[critical_shear_velocity,taocr,S] = shieldsmodbonlay(rhom,diam,rho,viscocine);
format('short' , 'g');
if shieldprime <= ( 0.5 * critical_shear_velocity )
                             ripplesh = 0;     
                             ripplesl = 0;
                             kn = diam;
elseif shieldprime >= 0.35
                             ripplesh = 0;   
                             ripplesl = 0;
                             kn = 15 * shieldprime *diam;         
elseif shieldprime < 0.35 && shieldprime > ( 0.5 * critical_shear_velocity )    
                             Z = shieldprime / S;
                             if Z >= 0.0016 && Z <= 0.012
                                          rela = 0.018 * ( Z ^ - 0.5 );
                                          relb = 0.15 * ( Z ^ - 0.009 );
                                          ripplesh = rela * Abm ;
                                          ripplesl = ripplesh / relb;
                                          kn =4* ripplesh;
                             elseif Z >= 0.012 && Z <= 0.18
                                          rela = 0.0007 * ( Z ^ - 1.23 );
                                          relb = 0.0105 * ( Z ^ - 0.65 );
                                          ripplesh = rela * Abm ;
                                          ripplesl = ripplesh / relb;
                                          kn =4* ripplesh;
                             elseif Z < 0.0016 && diam > 0.0006
                                          rela = 0.018 * ( Z ^ - 0.5 );
                                          relb = 0.15 * ( Z ^ - 0.009 );
                                          ripplesh = rela * Abm ;
                                          ripplesl = ripplesh / relb;
                                          kn =4* ripplesh;
                             elseif Z > 0.18 && diam > 0.00008
                                          kn = 15 * shieldprime *diam;
                                          ripplesh = 0;
                                          ripplesl = 0;
                             else
                                 msgbox('Anything wrong with the Z!!!' , 'error' , 'error'); 
                             end                              
end
