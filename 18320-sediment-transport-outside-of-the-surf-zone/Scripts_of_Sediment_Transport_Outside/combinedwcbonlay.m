function [omega,current_shear_velocity,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom,waveblthickness] = combinedwcbonlay(max_orbital_velocity,T,current_velocity_zr,zr,angwc,diam,rho,viscocine,rhom)
%_________________________________________________________________
% This routine gets the wave friction factor, the maximum shear velocity and the maximum bottom shear
% stress and the bottom shear stress phase angle for a pure wave motion over a flat bed.
%
% 0. Syntax:
% [omega,current_shear_velocity,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom,waveblthickness] =  combinedwcbonlay(max_orbital_velocity,T,current_velocity_zr,zr,angwc,diam,rho,viscocine,rhom)
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
% omega = wave angular (1/s).
% current_shear_velocity = current shear velocity (m/s)
% taoc =  the shear stress due to currents (Pa)
% w_max_shear_velocity = maximum wave shear velocity     (m/s)
% taowm = the maximum bottom shear stress    (Pa)
% max_shear_velocity = maximum combined shear velocity   (m/s)
% taom = the bottom shear stress (Pa)
% waveblthickness = wave boundary layer thickness (m)
% 
% 3. Example: 
 % [omega,current_shear_velocity,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom,waveblthickness] = combinedwcbonlay(0.35,8,0.35,1,45,0.2e-3,1025,1e-6,2650)
%
% omega =  
%   0.7854
% current_shear_velocity = 
%   0.016291
% taoc =
%   0.25768     
% w_max_shear_velocity = 
%   0.023859     
% taowm = 
%   0.5835    
% max_shear_velocity = 
%   0.026664
% taom =
%   0.72876
% waveblthickness = 
%   0.014613
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

if nargin == 9          

        [von_Karman,omega,Abm,kn,kindflow,fw,max_shear_velocity,max_bottom_shear_stress,z0,tanphi,phi] = wavebonlay1(max_orbital_velocity,T,diam,rho,viscocine);
        flowm = ( kn * max_shear_velocity ) / viscocine;
        if flowm >= 3.3         
                    kindflowm = 'Fully rough turbulent flow';
                    labelflow = 1;
        else
                    kindflowm = 'Fully smooth turbulent flow';
                    labelflow = 2;
                    [von_Karman,omega,Abm,kn,fw,max_shear_velocity,max_bottom_shear_stress,z0,tanphi,phi]=ts(max_orbital_velocity,T,Abm,rho,viscocine,omega,von_Karman,kn);
        end                         
        waveblthickness = ( 0.4 * max_shear_velocity ) / omega;     % m
        current_shear_velocity = max_shear_velocity * ( ( log ( zr / waveblthickness ) ) /  ( log ( waveblthickness / z0 ) ) ) * ...
                                                 ( -0.5 + sqrt ( 0.25 + ( von_Karman * ( current_velocity_zr / max_shear_velocity ) * ( ( log ( waveblthickness / z0 ) ) /  ( log ( zr /waveblthickness ) ) ^ 2 ) ) ) );                                 
         mu = ( current_shear_velocity / max_shear_velocity ) ^ 2;
         Cu = sqrt( 1 + ( 2 * mu  * cos ( (angwc * ( pi / 180 ) ) ) ) + mu ^ 2 );
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
        taowm = rho * w_max_shear_velocity ^ 2;   % Pa
        max_shear_velocity = sqrt(Cu) * w_max_shear_velocity;       % m/s
        taom =  rho * max_shear_velocity ^ 2;   % Pa
        waveblthickness = ( 0.4 * max_shear_velocity ) / omega;     % m
        current_shear_velocity1 = max_shear_velocity * ( ( log ( zr / waveblthickness ) ) /  ( log ( waveblthickness / z0 ) ) ) * ...
                                                 ( -0.5 + sqrt ( 0.25 + ( von_Karman * ( current_velocity_zr / max_shear_velocity ) * ( ( log ( waveblthickness / z0 ) ) /  ( log ( zr /waveblthickness ) ) ^ 2 ) ) ) );                                      
        taoc = rho * current_shear_velocity1 ^ 2;       %Pa
        errorcur = abs( current_shear_velocity - current_shear_velocity1 );
        tol2 = 0.00000000001; 
        iterac = 2;
        while  errorcur >= tol2                         
                  current_shear_velocity = current_shear_velocity1;
                  [current_shear_velocity1,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom]=uxc(waveblthickness,current_shear_velocity1,max_shear_velocity,angwc,Abm,kn,max_orbital_velocity,rho,omega,zr,z0,current_velocity_zr,von_Karman);
                  errorcur = abs( current_shear_velocity - current_shear_velocity1 );
                   iterac = iterac + 1;
        end                                                     
else
        msgbox('Check if you gave all the inputs!!!' , 'error' , 'error'); 
        disp('Check if you gave all the inputs and run again the function!!!');
end     
