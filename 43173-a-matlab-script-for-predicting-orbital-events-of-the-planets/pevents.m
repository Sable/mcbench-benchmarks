% pevents.m         August 21, 2013

% predict orbital events of the planets

%  aphelion and perihelion of a planet
%  nodal crossings of a planet
%  closest approach distance between two planets
%  minimum angular separation between two planets

% JPL ephemeris with root- and minima-finding

% Note: DE424.bin valid from 12/24/1999 to 2/1/2200

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global smu jdtdbi au rtd iplanet1 iplanet2

global iap_flg tisaved pnames

global ephname iephem km eq2000 ioftype

% astrodynamic and utility constants

rtd = 180.0 / pi;

dtr = pi / 180.0;

% J2000 equatorial-to-ecliptic transformation matrix

eq2000 = [[1.000000000000000 0  0]; ...
    [0   0.917482062069182   0.397777155931914]; ...
    [0  -0.397777155931914   0.917482062069182]];

% de424 value for astronomical unit (kilometers)

au = 149597870.6996262;

% sun gravitational constant (kilometers^3/second^2)

smu = 132712440040.9446d0;

% initialize DE424 algorithm

ephname = 'de424.bin';

iephem = 1;

km = 1;

% initialize orbital condition flag to start with minima

iap_flg = 1;

% read leap seconds data file

readleap;

% create planet names array

pnames = ['Mercury'; 'Venus  '; 'Earth  '; 'Mars   '; ...
    'Jupiter'; 'Saturn '; 'Uranus '; 'Neptune'];

% begin simulation

iplanet1 = 0;

iplanet2 = 0;

clc; home;

fprintf('\nprogram pevents\n');

fprintf('\n< orbital events of the planets >\n');

% request initial calendar date

[month, day, year] = getdate;

% compute tdb julian date at initial time

jdtdbi = julian(month, day, year);

while (1)
    
    fprintf('\nplease input the search duration (years)\n');
    
    nyears = input('? ');
    
    if (nyears > 0.0)
        
        break;
        
    end
    
end

% request type of planetary event to predict

while (1)
    
    fprintf('\n\nplease select the planetary event to predict\n');
    
    fprintf('\n   <1> aphelion and perihelion of a planet');
    
    fprintf('\n\n   <2> nodal crossings of a planet');
    
    fprintf('\n\n   <3> closest approach distance between two planets');
    
    fprintf('\n\n   <4> minimum angular separation between two planets\n\n');
    
    ioftype = input('? ');
    
    if (ioftype >= 1 && ioftype <= 4)
        
        break;
        
    end
    
end

if (ioftype == 1 || ioftype == 2)
    
    % aphelion/perihelion and nodal crossings
    
    while(1)
        
        fprintf('\nplanet menu\n');
        
        fprintf('\n  <1> Mercury\n');
        fprintf('\n  <2> Venus\n');
        fprintf('\n  <3> Earth\n');
        fprintf('\n  <4> Mars\n');
        fprintf('\n  <5> Jupiter\n');
        fprintf('\n  <6> Saturn\n');
        fprintf('\n  <7> Uranus\n');
        fprintf('\n  <8> Neptune\n');
        
        fprintf('\nplease select the planet\n');
        
        iplanet1 = input('? ');
        
        if (iplanet1 >= 1 && iplanet1 <= 8)
            
            break;
            
        end
        
    end
    
end

if (ioftype == 3 || ioftype == 4)
    
    % closest approach distance and minimum separation angle
    
    while(1)
        
        fprintf('\nplease select the first planet\n');
        
        fprintf('\n  <1> Mercury\n');
        fprintf('\n  <2> Venus\n');
        fprintf('\n  <3> Earth\n');
        fprintf('\n  <4> Mars\n');
        fprintf('\n  <5> Jupiter\n');
        fprintf('\n  <6> Saturn\n');
        fprintf('\n  <7> Uranus\n');
        fprintf('\n  <8> Neptune\n');
        
        fprintf('\nplease select the planet\n');
        
        iplanet1 = input('? ');
        
        if (iplanet1 >= 1 && iplanet1 <= 8)
            
            break;
            
        end
        
    end
 
    while(1)
        
        fprintf('\nplease select the second planet\n');
        
        fprintf('\n  <1> Mercury\n');
        fprintf('\n  <2> Venus\n');
        fprintf('\n  <3> Earth\n');
        fprintf('\n  <4> Mars\n');
        fprintf('\n  <5> Jupiter\n');
        fprintf('\n  <6> Saturn\n');
        fprintf('\n  <7> Uranus\n');
        fprintf('\n  <8> Neptune\n');
        
        fprintf('\nplease select the planet\n');
        
        iplanet2 = input('? ');
        
        if (iplanet2 >= 1 && iplanet2 <= 8)
            
            break;
            
        end
        
    end
    
end

% number of days to search

ndays = 365.25 * nyears;

% initialize search parameters

ti = 0.0;

tf = ndays;

tisaved = ti;

% search step size in days
    
dt = 3.0;

dtsml = 0.1;

if (ioftype == 1)
    
    % find aphelion and perihelion events
    
    minmax_event('applanet_func', 'applanet_prt', ti, tf, dt, dtsml);
    
end

if (ioftype == 2)
    
    % predict nodal crossings
    
    root_event('rz_func', 'nodal_prt', tf);
    
end

if (ioftype == 3)
    
    % find close approach conditions
    
    minmax_event('capproach_func', 'capproach_prt', ti, tf, dt, dtsml);
    
end

if (ioftype == 4)
    
    % find minimum separation angle conditions
    
    minmax_event('sepangle_func', 'sepangle_prt', ti, tf, dt, dtsml);
    
end

% close all files

fclose('all');



