function const = get_meteo_const()
    % AMS Glossary, <http://amsglossary.allenpress.com/>
    const.R = 8.316963e3;  % J / (kmol * K),  universal gas constant
    const.M_dry = 28.9644;  % kg / kmol,  molar mass of dry air
    const.M_wet = 18.0152;  % kg / kmol,  molar mass of water vapor
    % "Gas constant" in AMS Glossary:
    const.R_dry = const.R / const.M_dry;  % specific gas constant of dry air
    const.R_wet = const.R / const.M_wet;  % specific gas constant of water vapor

    const.g_c = 9.80665;  % m/s^2, nominal constant gravity value employed 
                          % in the definition of relative geopotential heights.
    % Value used in NWP (in general) to scale the gepotential 
    % in units of length (i.e., to convert from m^2/s^2 to m). 
    % It's given in the following paper:
    %   Vedel H. (2000) Conversion of WGS84 geometric heights to NWP 
    % model HIRLAM geopotential Heights, DMI scientific rapport 00-04, 
    % Danish Meteorological Institute. <http://www.dmi.dk/dmi/sr00-04.pdf>    
    %   p. 3: "g_0 = 9.80665 m/s^2 is a value decided upon by the WMO
    % [World Metereological Organization] and used by all met. offices."
    %   I assume that what Vedel says about the Danish HIRLAM NWP model 
    % is valid for the Canadian GEM NWP model.
    %   Indeed, I found the following:
    %       GRAV       0.9806160000000E+01  ACC. DE GRAVITE       M S-2
    % That I found in file modeles/modeles_dfiles/constantes of the 
    % "GEM NWP model v 3.2.0 - Test Release" source code, available at
    %   <http://collaboration.cmc.ec.gc.ca/science/rpn.comm/tarfiles/modeles-gem3.2-phy4.2.tgz>
    % through the "RPN.COMM: COmmunity for Mesoscale NWP Modeling":
    %   <http://collaboration.cmc.ec.gc.ca/science/rpn.comm/>

    const.zero_celcius_in_kelvin = +273.15;

    % STP defined by the IUPAC (International Union of Pure and Applied Chemistry) is an absolute pressure of 100 kPa (1 bar) and a temperature of 273.15 K (0 °C).
    % <http://en.wikipedia.org/wiki/Standard_conditions_for_temperature_and_pressure>
    const.std_temperature = const.zero_celcius_in_kelvin;
    const.std_pressure = 100e3;  % in Pa;
end

%!test
%! const = get_meteo_const();
%! myassert(all(isfield(const, ...
%!     {'R', 'M_dry', 'M_wet', 'R_dry', 'R_wet', 'g_c', ...
%!      'std_temperature', 'std_pressure', 'zero_celcius_in_kelvin'})));

