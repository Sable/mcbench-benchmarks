function qt
% _______________________________________________________________
% This routine gets the total sediment transport
%
% 0. Syntax:
% Only run the function. 
%
% 1. Inputs (inside the InputsM_G_S.txt):
% max_orbital_velocity = maximum near bottom wave orbital velocity (m/s).
% T = significant wave period (s).
% diam = sediment size (m).
% rhom = mass density fo sediment grains (kg/m3).
% rho = seawater density (kg/m3).
% viscocine = kinematic viscosity (m2/s).
% current_velocity = current velocity in zr (m/s).
% zr = reference level (m).
% angwc = current direction relative to the direction of wave propagation (degrees).
% angubm = maximum near bottom orbital velocity angle of incidence (degrees).
% beta = bottom slope (degrees)
% hk = water deep (m)
% angm = moving friction angle of sediment (degrees).
%
% 2. Outputs:
% qst = magnitude of total sediments transport.
% 
% 
% 3. Example:
% >>run(qt)
% The magnitude of total sediment transport vector is = 1.93e-002 (cm3/cm-s)
% directed at an angle of 39.77º to the wave direction. 
% >>
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

%clear all; clc;

fid = fopen('InputsM_G_S.txt','r');
datos = fscanf(fid, '%g %g %g %g %g %g %g %g %g %g %g %g %g\n',  [13 inf]) ;
fclose(fid);

max_orbital_velocity = datos(1,1) ; 
T = datos(2,1); 
diam = datos(3,1); 
rhom = datos(4,1);
rho = datos(5,1) ; 
viscocine = datos(6,1); 
current_velocity_zr= datos(7,1); 
zr = datos(8,1);
angwc = datos(9,1); 
angubm = datos(10,1); 
beta = datos(11,1); 
hk = datos(12,1); 
angm = datos(13,1);

clear fid datos

[ripplesh,ripplesl,kn] = ripplesbonlay(max_orbital_velocity,T,diam,rhom,rho,viscocine);
[omega,current_shear_velocity,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom,waveblthickness,phi] = combinedwcbonlay2(max_orbital_velocity,T,diam,rhom,rho,viscocine,current_velocity_zr,zr,angwc,kn);
uc = current_shear_velocity ;
um = max_shear_velocity ;
uwm = w_max_shear_velocity;
dcw = waveblthickness;
flowm = ( kn * max_shear_velocity ) / viscocine;     
if flowm >= 3.3
       z0 = kn / 30;
else
       z0 = viscocine / ( 9 * max_shear_velocity );
end
z0o = z0;
currentvelo = ( ( uc / 0.4 ) * ( uc / um ) * log( dcw / z0o ) );
z0a = ( dcw / exp ( currentvelo / ( uc / 0.4 ) ) );
absswc =( ( pi / 2 ) / ( log( ( 0.4 * uwm ) / ( z0o * omega ) ) - 1.15 ) );
angbsswc = atan(absswc) * ( 180 / pi );
current_velocity_zr = currentvelo;
zr = dcw;
clear omega current_shear_velocity taoc w_max_shear_velocity taowm max_shear_velocity ...
           taom waveblthickness phi absswc flown currentvelo
[omega,current_shear_velocity,taoc,w_max_shear_velocity,taowm,max_shear_velocity,taom,waveblthickness] = combinedwcbonlay(max_orbital_velocity,T,current_velocity_zr,zr,angwc,diam,rho,viscocine,rhom);
current_shear_velocity_prime = current_shear_velocity;
w_max_shear_velocity_prime = w_max_shear_velocity;
max_shear_velocity_prime = max_shear_velocity;
z0 = diam / 30 ;
tanphip = ( pi / 2 ) / ( log( ( 0.4 * max_shear_velocity_prime ) / ( z0 * omega ) ) - 1.15 );
phi_prime = atan(tanphip) * ( 180 / pi );    
Shieldc_prime = current_shear_velocity ^ 2 / ( ( ( rhom / rho ) -1 ) * 9.81 * diam );
Shieldwm_prime = w_max_shear_velocity ^ 2 / ( ( ( rhom / rho ) - 1 )* 9.81 * diam );
termi1 = 6.11 * Shieldc_prime ^ ( 3 / 2 ) * ( w_max_shear_velocity / current_shear_velocity);
termi2 = sqrt( ( ( rhom / rho ) - 1 ) * 9.81 * diam ) * diam;
qsbwc1 = termi2 * termi1 * ( ( 3 / 2 ) * cos(angwc * ( pi / 180 ) ) );
qsbwc2 = termi2 * termi1 * sin(angwc * ( pi / 180 ) );
tanbeta = tan(beta * ( pi / 180 ))* cos(angubm * ( pi / 180 ) );
mub = tanbeta / tan( ( angm * ( pi /180 ) ) );
termi3 = 4.5 * ( Shieldwm_prime ) ^( 3 / 2 );
qsbbta1 = termi2 * termi3 * -mub;
qsbbta2 = termi2 * termi3 * 0;
xbed_load = qsbwc1 + qsbbta1;
ybed_load = qsbwc2 + qsbbta2;
wf = settlingvelocity(rhom,diam,rho,viscocine);
[critical_shear_velocity,taocr,S] = shieldsmodbonlay(rhom,diam,rho,viscocine);
Cb = 0.65;
if (ripplesh == 0 ) && ( ripplesl == 0 )
    gamma = 2E-4;
else
    gamma = 2E-3;
end
cr = gamma * Cb * ( ( ( 2 / pi ) * ( w_max_shear_velocity_prime / critical_shear_velocity ) ^2 ) - 1 );
crwm = gamma * Cb * ( ( ( 4 / pi ) * ( current_shear_velocity_prime / critical_shear_velocity ) ^2 ) * ...
                cos(angwc*(pi/180)) - ( ( w_max_shear_velocity_prime / critical_shear_velocity ) ^2 ) * mub );
zrcon = 7 * diam;
tanphis = ( pi / 2 ) / ( log( ( 0.4 * um ) / ( zrcon * omega ) ) - 1.15 );
phi_s = atan(tanphis) * ( 180 / pi );   
ang1 = angbsswc * (pi /180);
ang2 = phi_prime * (pi /180);
ang3 = phi_s * (pi /180);
ab1 = ( ( 0.4 * uc ) / ( ( 0.4* um ) - wf ) ) ;
ab2 = log( dcw / z0o );
ab3 =  ( ( 0.4 * um ) / ( ( 0.4* um ) - wf ) ) ;
ab4 = zrcon / dcw;
ab5 = ( ( ( 0.4* um ) - wf ) / ( 0.4 * um ) );
ab6 = log( zrcon / z0o );
ab7 = log(dcw / zrcon);
ab8 = ( ( 0.4 * uc ) / ( ( 0.4*uc ) - wf ) ) ;
ab9 = hk / dcw;
ab10 = ( ( ( 0.4* uc ) - wf ) / ( 0.4 * uc ) );
ab11 = log( hk / z0a );
ab12 = log( dcw / z0a );
ab13 = log( dcw / ( pi * z0o ) );
ab14 = ( pi * zrcon ) / dcw;
ab15 = log( dcw / ( pi * zrcon ) );
ab17 = ( uc / 0.4 ) * cr * ( ( dcw / zrcon ) ^ ( - wf / ( 0.4 * um ) ) ) * dcw; 
I1 = ab1 * ( ab2 - ab3 - ( ( ab4 ^ ab5 ) * ( ab6 - ab3) ) );
I2 = ab8 * ( ( (ab9 ^ ab10 ) * ( ab11 - ab8 ) ) - ( ab12 - ab8 ) );
I3 = ( ab2 / ab7 ) * ab1 * ( ab7 - ( ab3 * ( 1 - ab4 ^ ab5) ) );
I4 = ab13 - 1 - ( ab14 * ( ab6 - 1 ) );
I5 = ( ab6 * ( ab15 -1 + ab14 ) ) + ( ab15 ) ^ 2 - ( 2 * ab15 ) + ( 2 * ( 1 - ab14) );
I6 = ab15 - 1 + ab14;
I7 = ( ab15 ) ^ 2 - ( 2 * ab15) + ( 2 * ( 1 - ab14 ) );
if ( zr < z0o )
          qsss = ab17 * ( I1 + I2 );
else
          qsss = ab17 * ( I3 + I2 );
end
qssx = qsss * cos( angwc * ( pi / 180 ) );
qssy = qsss * sin( angwc * ( pi / 180 ) );
if ( 7 * diam ) > ( dcw / pi )
       qsswx = 0;
       qsswy = 0;
else
        if ( 7 * diam ) > z0o
                ba1 = ( 1 / ( pi ^2 ) ) * sin(ang1) * max_orbital_velocity * crwm * dcw;
                ba2 = (I4*cos( (ang1-ang2) ) )-( I5*( (2*sin(ang3)*cos( (ang1-ang2-ang3) ) ) / pi ) ); 
                qsswx = ba1 * ba2;
                qsswy = 0;               
        else    
                ba1 = ( 1 / ( pi ^2 ) ) * sin(ang1) * max_orbital_velocity * crwm * dcw * ( ab13 / ab15 );
                ba2 = (I6*cos( (ang1-ang2) ) )-( I7*( (2*sin(ang3)*cos( (ang1-ang2-ang3) ) ) / pi ) );
                qsswx = ba1 * ba2;
                qsswy = 0;
        end
end
qstx = xbed_load + qssx + qsswx;
qsty = ybed_load + qssy + qsswy;
qst = sqrt( (qstx ^2 + qsty ^2 ) );
angtransport = atan( qsty / qstx ) *( 180 / pi );
qstcm = qst *10000;
fprintf('The magnitude of total sediment transport vector is = %8.2e (cm3/cm-s)\n' , qstcm);
fprintf('directed at an angle of %5.2fº to the wave direction. \n', angtransport);

fid = fopen('OutputsM_G_S.txt','w+');
fprintf(fid, '%g\n %g\n %g\n %g\n %g\n %g\n %g\n %g\n %g\n %g\n %g\n %g\n %g\n',  ...
            uc,um,uwm,dcw,kn,z0o,z0a,wf,angbsswc,phi_prime,phi_s,qst,angtransport) ;
fclose(fid);


