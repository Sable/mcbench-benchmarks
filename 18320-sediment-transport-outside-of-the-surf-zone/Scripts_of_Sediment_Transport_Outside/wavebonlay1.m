function  [von_Karman,omega,Abm,kn,kindflow,fw,max_shear_velocity,max_bottom_shear_stress,z0,tanphi,phi] = wavebonlay1(max_orbital_velocity,T,diam,rho,viscocine)  
%_________________________________________________________________
% This routine gets the wave friction factor, the maximum shear velocity, the maximum bottom shear
% stress and the bottom shear stress phase angle for a pure wave motion over a flat bed.
%
% 0. Syntax:
% [von_Karman,omega,fc,max_shear_velocity,max_bottom_shear_stress,phi,Abm] = wavebonlay1(max_orbital_velocity,T,diam,rho,viscocine,rhom)
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
                   
                    format('short' , 'g');
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
                    else
                            kindflow = 'Fully smooth turbulent flow';
                            [von_Karman,omega,Abm,kn,fw,max_shear_velocity,max_bottom_shear_stress,z0,tanphi,phi] =ts(max_orbital_velocity,T,Abm,rho,viscocine,omega,von_Karman,kn);
                    end                         
