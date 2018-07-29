function [kindflow,fc,shear_velocity,bottom_shear_stress] = currentboylay(current_velocity_zr,zr,diam,rho,viscocine)
% _______________________________________________________________
% This routine gets the current friction factor, the shear velocity and the bottom shear
% stress for a current over a flat bed.
%
% 0. Syntax:
% [kindflow,fc,shear_velocity,bottom_shear_stress] = currentboylay(current_velocity_zr,zr,diam,rho,viscocine)
%
% 1. Inputs:
% current_velocity_zr = current velocity in zr (m/s).
% zr = reference level (m).
% diam = sediment size (m).
% rho = seawater density (kg/m3).
% viscocine = kinematic viscosity (m2/s).
%
% 2. Outputs:
% kindflow = kind of flow, this, can be Fully rough or Fully smooth turbulent.
% fc = current frictional factor    (dimensionless).
% shear_velocity = shear velocity by current     (m/s)
% bottom_shear_stress = bottom shear stress   (N/m2).
% 
% 3. Example:
% [a,b,c,d] = currentbonlay(0.35,1,0.2E-3,1025,1E-6)
% a = 
% Fully smooth turbulent flow
% b =
%      0.0025
% c = 
%      0.0123
% d = 
%      0.1550
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

if nargin == 5          
    format('short' , 'g');
    kn = diam;
    z0 = kn / 30;                                                % m
    fc = ( 1 / ( ( log10( zr / z0 ) ) * 4 )  ) ^ 2;     % dimensionless
    shear_velocity = sqrt( fc / 2 ) * current_velocity_zr;    % m/s
    bottom_shear_stress = shear_velocity ^ 2 * rho;    % N/m2
    flow = ( kn * shear_velocity ) / viscocine;
    if flow >= 3.3         
             kindflow = 'Fully rough turbulent flow';
             labelflow = 1 ;
    else
             kindflow = 'Fully smooth turbulent flow';
             labelflow = 2; 
    end
    if labelflow == 2
            z0 = viscocine / ( 9 * shear_velocity );
                fc = ( 1 / ( ( log10( zr / z0 ) ) * 4 )  ) ^ 2;
                    shear_velocity = sqrt( fc / 2 ) * current_velocity_zr;
                bottom_shear_stress = shear_velocity ^ 2 * rho;
    end
else
        msgbox('Check if you gave all the inputs!!!' , 'error' , 'error'); 
        disp('Check if you gave all the inputs and run again the function!!!');
end     
