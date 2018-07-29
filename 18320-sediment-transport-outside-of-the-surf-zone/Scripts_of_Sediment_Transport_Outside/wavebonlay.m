function [kindflow,omega,fw,max_shear_velocity,max_bottom_shear_stress,phi,Abm] = wavebonlay(max_orbital_velocity,T,diam,rho,viscocine,rhom)
% _______________________________________________________________
% This routine gets the wave friction factor, the maximum shear velocity, the maximum bottom shear
% stress and the bottom shear stress phase angle for a pure wave motion over a flat bed.
%
% 0. Syntax:
% [kindflow,omega,fc,max_shear_velocity,max_bottom_shear_stress,phi,Abm] = wavebonlay(max_orbital_velocity,T,diam,rho,viscocine,rhom)
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
% kindflow = kind of flow, this, can be Fully rough or Fully smooth turbulent.
% omega = wave angle (1/s).
% fw = wave frictional factor    (dimensionless).
% max_shear_velocity = maximum wave shear velocity     (m/s)
% max_bottom_shear_stress = max_bottom shear stress   (N/m2).
% phi = phase lead of near bottom wave orbital velocity (deg).
% Abm = bottom excursion amplitude (m).
% 
% 3. Example:
% [a,b,c,d,e,g,f] = wavebonlay(0.35,8,0.1E-3,1025,1E-6,2650)
% a = 
% Fully smooth turbulent flow
% b =
%       0.7854
% c = 
%       0.007378
% d = 
%       0.021258
% e = 
%       0.4632
%  f =
%       0.44563
%  g =
%       13.6410
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

if nargin == 6          
    von_Karman = 0.4;
    omega = ( 2 * pi ) / T;    % 1/ s
    Abm = max_orbital_velocity / omega;   % m
    kn = diam;
        term1 = ( log10 ( Abm / kn ) ) - 0.17;
            xlast = 0.4;
                xnew = ( 1 / ( term1 - ( log10 ( 1 / xlast ) ) + ( 0.24 * xlast ) ) ) ;
                    errorabs = abs( xnew - xlast );
                tol = 0.0000001;
            itera = 1;
        while errorabs >= tol                        
            xlast = xnew;
                xnew = ( 1 / ( term1 - ( log10 ( 1 / xlast ) ) + ( 0.24 * xlast ) ) ) ;
                errorabs = abs( xnew - xlast );
            itera = itera + 1;
        end                                                    
        fw = ( xnew / 4 ) ^ 2;     % dimensionless
        max_shear_velocity = sqrt( fw / 2 ) * max_orbital_velocity;    % m/s
        max_bottom_shear_stress = max_shear_velocity ^ 2 * rho;    % N/m2
        z0 = kn / 30 ;
            tanphi = ( pi / 2 ) / ( log( ( von_Karman * max_shear_velocity ) / ( z0 * omega ) ) - 1.15 );
                phi = atan(tanphi) * ( 180 / pi );     % (degrees)
        flow = ( kn * max_shear_velocity ) / viscocine;

        if flow >= 3.3          
                    kindflow = 'Fully rough turbulent flow';
                    labelflow = 1 ;
        else
                    kindflow = 'Fully smooth turbulent flow';
                    labelflow = 2; 
        end 
        if labelflow  == 2                    
                Re = ( max_orbital_velocity * Abm ) / viscocine;
                    term1 = ( log10 (sqrt( Re / 50 ) ) ) - 0.17;
                        xlast = 0;
                            xnew =  1 / ( term1 ) ;
                        errorabs = abs( xnew - xlast );
                    tol = 0.0000001;
                itera = 1;
                while errorabs >= tol                
                        xlast = xnew;
                            xnew = ( 1 / ( term1 - ( log10 ( 1 / xlast ) ) + ( 0.06 * xlast ) ) ) ;
                                errorabs = abs( xnew - xlast );
                            itera = itera + 1;
                end
                fw = ( xnew / 8 ) ^ 2;
                    max_shear_velocity = sqrt( fw / 2 ) * max_orbital_velocity;
                        max_bottom_shear_stress = max_shear_velocity ^ 2 * rho;
                    z0 = viscocine / ( 9 * max_shear_velocity ) ;
                tanphi = ( pi / 2 ) / ( log( ( von_Karman * max_shear_velocity ) / ( z0 * omega ) ) - 1.15 );
                    phi = atan(tanphi) * ( 180 / pi );
        end                                        
else
        msgbox('Check if you gave all the inputs!!!' , 'error' , 'error'); 
        disp('Check if you gave all the inputs and run again the function!!!');
end     

