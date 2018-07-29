function [current_shear_velocity1,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom]=uxc(waveblthickness,current_shear_velocity1,max_shear_velocity,angwc,Abm,kn,max_orbital_velocity,rho,omega,zr,z0,current_velocity_zr,von_Karman)
%_________________________________________________________________
% This routine gets the current_shear_velocity,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom
%
% 1. Inputs:
% max_orbital_velocity = maximum near bottom wave orbital velocity (m/s).
% T = significant wave period (s).
% diam = sediment grain diameter (m).
% rho = mass density of seawater (kg/m3).
% viscocine = kinematic viscosity (m2/s).
% rhom = mass density fo sediment grains (kg/m3).
%
% 2. Outputs:
% omega = wave angle (1/s).
% fw = wave frictional factor    (dimensionless).
% max_shear_velocity = maximum wave shear velocity     (m/s)
% max_bottom_shear_stress = max_bottom shear stress   (N/m2).
% phi = phase lead of near bottom wave orbital velocity (deg).
% Abm = bottom excursion amplitude (m).
% z0 =
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
%           Salles, Paulo A. (2005). Notes of Coastal Morphologic. UNAM. México.
%
% Programming : Gabriel Ruiz Mtz.
% UNAM.
% 2006
%_____________________________________________________________________         

 mu = ( current_shear_velocity1 / max_shear_velocity ) ^ 2;
 Cu = sqrt( 1 + ( ( 2 * mu ) * cos ( (angwc * ( pi / 180 ) ) ) ) + mu ^ 2 );
 term2 = ( log10 ( ( Cu * Abm ) / kn ) ) - 0.17;
     xlast = 0.4;
         xnew = ( 1 / ( term2 - ( log10 ( 1 / xlast ) ) + ( 0.24 * xlast ) ) ) ;
             errorabs = abs( xnew - xlast );
          tol = 0.0000001;
      itera = 1;
while errorabs >= tol                        
            xlast = xnew;
                xnew = ( 1 / ( term2 - ( log10 ( 1 / xlast ) ) + ( 0.24 * xlast ) ) ) ;
                errorabs = abs( xnew - xlast );
            itera = itera + 1;
end                                                 
fw = ( xnew / 4 ) ^ 2 * Cu;     % dimensionless
   w_max_shear_velocity = sqrt( fw / 2 ) * max_orbital_velocity;    % m/s
       taowm = rho * w_max_shear_velocity ^ 2;   % N/m2
           max_shear_velocity = sqrt(Cu) * w_max_shear_velocity;       % m/s
       taom =  rho * max_shear_velocity ^ 2;   % N/m2
   waveblthickness = ( 0.4 * max_shear_velocity ) / omega;
current_shear_velocity1 = max_shear_velocity * ( ( log ( zr / waveblthickness ) ) /  ( log ( waveblthickness / z0 ) ) ) * ...
                                                 ( -0.5 + sqrt ( 0.25 + ( von_Karman * ( current_velocity_zr / max_shear_velocity ) * ( ( log ( waveblthickness / z0 ) ) /  ( log ( zr /waveblthickness ) ) ^ 2 ) ) ) );
taoc = rho * current_shear_velocity1 ^ 2;
