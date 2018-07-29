function [critical_shear_velocity,taocr,S] = shieldsmodbonlay(rhom,diam,rho,viscocine)
% _______________________________________________________________
% This routine gets the critical shear velocity and critical bottom shear stress for initiation of motion.
%
% 0. Syntax:
% [critical_shear_velocity,taocr] = shieldsmodbonlay(rhom,diam,rho,viscocine)
%
% 1. Inputs:
% rhom = mass density fo sediment grains (kg/m3)
% diam = sediment grain diameter (m).
% rho = mass density of seawater (kg/m3).
% viscocine = kinematic viscosity (m2/s).
%
% 2. Outputs:
% critical_shear_velocity = critical shear velocity     (m/s)
% taocr = the maximum bottom shear stress    (Pa)
% S = Sediment fluid parameter (dimensionless)
% 
% 3. Example: 
%  [critical_shear_velocity,taocr,S] = shieldsmodbonlay(2650,0.2E-3,1025,1E-6)
% 
% critical_shear_velocity = 
%   0.012649
% taocr =
%   0.16399 
% S =
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


if nargin == 4          

        
        S =  ( ( diam / ( 4 * viscocine) ) * sqrt( ( ( rhom / rho ) - 1 ) * 9.81 * diam ) );     % (dimensionless)
        
         if S < 0.8          
                   psicr = 0.1* ( S ^ ( -2 / 7 ) ) ;
         elseif S >= 300
                    psicr = 0.06;
         elseif ( S >= 0.8 ) && ( S < 300 )
                   x = log10(S);
                   polpsi = ( ( 0.002235 * x ^ 5 ) - ( 0.06043 * x ^ 4 ) + ( 0.20307 * x ^ 3 ) + ...
                                   ( 0.054252 * x ^ 2 ) - ( 0.636397 * x ) - 1.03167 );
                   psicr = 10 ^ polpsi;
         end
        critical_shear_velocity = sqrt( ( ( rhom / rho ) - 1) * 9.81 * diam * psicr );      % m/s
        taocr = rho * critical_shear_velocity ^ 2;   % Pa      
else
        msgbox('Check if you gave all the inputs!!!' , 'error' , 'error'); 
        disp('Check if you gave all the inputs and run again the function!!!');
end        

