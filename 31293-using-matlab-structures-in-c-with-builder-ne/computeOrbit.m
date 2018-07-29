function orbit = computeOrbit(planet)
% COMPUTEORBIT Compute the orbital period of the input planets.
%
% ORBIT = COMPUTEORBIT(PLANET) uses the mass and semi-major axis of the
% planets to compute the orbital period, in days, of each planet in the
% input structure array. 
%
% The input array must be 1xN, and have the following fields:
%
%  name:   The name of the planet. A string.
%  mass:   The mass of the planet, in kilograms. A scalar double.
%  smAxis: The distance from the center of the planet to the center of
%          the sun, in meters. (Meters, not kilometers.) A scalar double.
%
% COMPUTEORBIT returns a structure array the same size as the input
% structure array, with two fields:
%
%  name: The name of the planet (copied from the input structure array).
%  period: The time, in days, required for the planet to complete one 
%          revolution around the sun.
%
% For example:
%
%    planet.name = 'Mars'
%    planet.mass = 6.4185e+024
%    planet.smAxis = 2.2792e+011
%    orbit = computeOrbit(planet)
%
%    orbit = 
%
%      name: 'Mars'
%      period: 686.8837
%
% For planetary data, see NASA's planetary fact sheet pages, i.e.,
%   http://nssdc.gsfc.nasa.gov/planetary/factsheet/marsfact.html
% NASA calculates a orbital period for Mars of 686.980 days. Their
% algorithms are cleverer than this relatively simple one, which entirely
% neglects the gravational effects of other planets and orbital 
% eccentricity.

    % G is the gravitational constant, in N(m/kg)^2
    G = 6.67259e-11;
    
    % solarMass is the (gigantic) mass of the sun, in kilograms.
    solarMass = 1.98892e30;
    
    % secondsPerDay should be pretty obvious.
    secondsPerDay = 60 * 60 * 24;
    
    % For each planet in the structure array, compute the orbital 
    % period using Kepler's laws of planetary motion. 
    %
    % An excellent introduction to orbital mechanics:
    % http://www.braeunig.us/space/orbmech.htm
    %
    % Since the core computation uses MKS units, divide the answer by
    % secondsPerDay to determine the orbital period in days.
    count = numel(planet);
    [orbit(1:count).name] = planet.name;
    
    % No need for a for-loop, use vectorized math instead.
    p = sqrt( (4 * (pi^2) * ([planet.smAxis] .^ 3)) ./ ...
            (G * ([planet.mass] + solarMass)) ) / secondsPerDay;
        
    % Convert the resulting 1xN matrix into a cell-array, then DEAL the
    % elements of the cell array into the output structure.
    np = num2cell(p);
    [orbit(1:end).period] = deal(np{:});
    
  
