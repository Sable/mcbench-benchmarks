% pressure in Pa (not hPa nor mbar)
% temperature in K (not in degree Celsius)
% humidity:
% - partial pressure of water vapor in Pa (not hPa nor mbar)
% - specific humidity in kg/kg (not g/kg)
% - mixing ratio in kg/kg (not g/kg)
% - relative humidity in percent
% - dew point temperature in K (not degree Celsius)
% - virtual temperature in K (not degree Celsius)
function out = convert_humidity (P, T, in, type_in, type_out, method_es, tol_T)
    if (nargin < 6),  method_es = [];  end
    if (nargin < 7),  tol_T = [];  end
    temp = get_meteo_const();  c = temp.M_wet / temp.M_dry;

    % Partial pressure of water vapor is the intermediary type,  
    % -- all input types are converted to it, and all output 
    % types are converted from it.

    if strcmp(type_in, 'specific humidity') ...
    && strcmp(type_out, 'virtual temperature')
        % direct conversion does NOT depend on pressure:
        clear P
        P = ones(size(T));
    end

    switch type_in
    case {'partial pressure', 'partial pressure of water vapor'}
        e = in;
    case 'specific humidity'
        q = in;
        e = (q .* P)./(c + (1 - c).*q);
    case 'mixing ratio'
        r = in;
        e = (r .* P)./(r + c);
    case 'relative humidity'
        RH = in;
        es = calculate_saturation_vapor_pressure_liquid(T, method_es);
        e = RH./100 .* es;
    case {'dew point', 'dew point temperature'}
        Td = in;
        e = calculate_saturation_vapor_pressure_liquid(Td, method_es);
    case 'virtual temperature'
        Tv = in;
    	e = P .* (1 - T ./ Tv) ./ (1 - c);
    otherwise
        error('convert_humidity:typeUnknown', ...
            'Type "%s" unknown.', type);
    end    

    switch type_out
    case {'partial pressure', 'partial pressure of water vapor'}
        out = e;
    case 'specific humidity'
        Pd = P - e;
        q = (e.*c)./(e.*c+Pd);
        out = q;
    case 'mixing ratio'
        Pd = P - e;
        r = (e./Pd) .* c;
        out = r;
    case 'relative humidity'
        es = calculate_saturation_vapor_pressure_liquid(T, method_es);
        RH = 100 .* e./es;
        out = RH;
    case {'dew point', 'dew point temperature'}
        Td = calculate_saturation_vapor_pressure_liquid_inv(e, method_es, ...
            tol_T);
        out = Td;
    case 'virtual temperature'
        Tv = T ./ ( 1 - (e./P).*(1-c) );
        out = Tv;
    otherwise
        error('convert_humidity:typeUnknown', ...
            'Output type "%s" unknown.', type_out);
    end    
end

%!shared
%! types = {...
%!     'partial pressure of water vapor'
%!     'specific humidity'
%!     'mixing ratio'
%!     'relative humidity'
%!     'dew point temperature'
%!     'virtual temperature'
%! };
%! 
%! const = get_meteo_const();
%! P = const.std_pressure;
%! T = const.std_temperature;

%!test
%! % direct conversion between 'specific humidity' and 'virtual temperature'
%! % does NOT depend on pressure:
%! q = 3.99e-2/1e3;
%! Tv = convert_humidity ([], T, q, 'specific humidity', 'virtual temperature');
%! 
%! P2 = P;
%! e  = convert_humidity (P2, T, q, 'specific humidity', 'partial pressure');
%! Tv2= convert_humidity (P2, T, e, 'partial pressure', 'virtual temperature');
%! 
%! P3 = P + 100 + 100*rand;
%! e  = convert_humidity (P3, T, q, 'specific humidity', 'partial pressure');
%! Tv3= convert_humidity (P3, T, e, 'partial pressure', 'virtual temperature');
%! 
%! %[Tv, Tv2, Tv3]  % DEBUG
%! %[Tv, Tv2, Tv3] - Tv  % DEBUG
%! myassert(Tv2, Tv, -eps)
%! myassert(Tv3, Tv, -eps)
%! %pause  % DEBUG

%!test
%! % consistency check:
%! % conversion followed by inverse conversion should give original input.
%! 
%! % generate sample input:
%! in = 0.1 * P;  % partial pressure.
%! out = NaN(size(types));
%! for i=1:length(types)
%!     out(i) = convert_humidity (P, T, in, 'partial pressure', types{i});
%! end
%! 
%! % now input previous output:
%! in = out;
%! % and this output should be equal to previous input:
%! out = repmat(in(:)', length(types), 1);
%! 
%! out2 = NaN(length(types), length(types));
%! for i=1:length(types),  for j=1:length(types)
%!     %fprintf('type_in: %s\ntype_out: %s\n\n', types{i}, types{j})  % DEBUG
%!     out2(i,j) = convert_humidity (P, T, in(i), types{i}, types{j});
%!     %out2, pause  % DEBUG
%! end,  end
%! 
%! % compare results:
%! %out2, out2-out  % DEBUG
%! myassert(out2, out, -sqrt(eps))

%!test
%! % Package called Cactus2000, written by Helge Krüger, available at 
%! % <http://www.cactus2000.de/uk/unit/masshum.shtml>
%! out = [...
%!     3.0539 * 100 % partial pressure
%!     1.9017/1e3  % specific humidity
%!     1.9053/1e3  % mixing ration
%!     50  % relative humidity
%!     -8.16+273.15  % dew point temperature
%! ];
%! 
%! in = 50;  % relative humidity;
%! out2 = NaN(length(types)-1,1);
%! for i=1:length(types)-1
%!     out2(i) = convert_humidity (P, T, in, 'relative humidity', types{i});
%! end
%! 
%! %[out, out2, out2-out, (out2-out)./out] % DEBUG
%! myassert(out2, out, 0.005)

%!test
%! % Package called Cactus2000, written by Helge Krüger, available at 
%! % <http://www.cactus2000.de/uk/unit/masshum.shtml>
%! T = -50+273.15;
%! out = [...
%!     6.4149e-2 * 100 % partial pressure
%!     3.99e-2/1e3  % specific humidity
%!     3.9902e-2/1e3  % mixing ration
%!     50  % relative humidity
%!     -45.97+273.15  % dew point temperature
%! ];
%! 
%! in = 50;  % relative humidity;
%! out2 = NaN(length(types)-1,1);
%! for i=1:length(types)-1
%!     out2(i) = convert_humidity (P, T, in, 'relative humidity', types{i});
%! end
%! 
%! %[out, out2, out2-out, (out2-out)./out] % DEBUG
%! myassert(out2, out, 0.6)

%!test
%! temp = [...
%! %# ---------------------------------------------------------
%! %# Reference data-set for IAG WG. 4.3.3
%! %# site name: ALB
%! %# date: 920101
%! %# UT: 0000
%! %# geodetic latitude [deg]: 42.8
%! %# ---------------------------------------------------------
%! %# format description
%! %# col 1-12 : geopotential height [m]
%! %# col 13-21: pressure [hPa]
%! %# col 22-30: temperature [degree Celsius]
%! %# col 31-39: relative humidity [percent]
%! %# col 40-48: water vapor pressure [hPa]
%! %# col 49-57: dew point temperature [degree Celsius]
%! %# ---------------------------------------------------------
%! %# number of pressure levels: 28
%! %# ---------------------------------------------------------
%! %# DATA BEGIN
%!        86.00  1028.00    -7.10    67.30     2.40   -12.10
%!       108.90  1025.00    -4.50    41.70     1.80   -15.50
%!       132.00  1022.00    -3.90    32.50     1.50   -17.90
%!       303.60  1000.00    -3.90    45.40     2.10   -13.90
%!       487.80   977.00    -1.60     7.90      .40   -31.60
%!      1073.00   908.00     1.10     8.40      .60   -28.90
%!      1601.90   850.00      .00     8.20      .50   -30.00
%!      1938.00   815.00     -.30     8.10      .50   -30.30
%!      3141.80   700.00    -5.30     7.30      .30   -35.30
%!      5683.60   500.00   -24.90    23.30      .20   -39.90
%!      6237.00   463.00   -29.60    45.60      .20   -37.60
%!      7263.80   400.00   -37.10    30.90      .10   -48.10
%!      7670.40   377.00   -40.10    33.50      .10   -50.10
%! ];
%! P = temp(:,2)*100;
%! T = temp(:,3) + 273.15;
%! RH = temp(:,4);
%! e = temp(:,5)*100;
%! Td = temp(:,6) + 273.15;
%! 
%! method_es = 'Bolton1980';
%! method_es = 'Murphy&Koop2005';
%! 
%! RH_RH = convert_humidity (P, T, RH, 'relative humidity', ...
%!     'relative humidity', method_es);
%!  e_RH = convert_humidity (P, T, RH, 'relative humidity', ...
%!     'partial pressure', method_es);
%! Td_RH = convert_humidity (P, T, RH, 'relative humidity', ...
%!     'dew point', method_es);
%! 
%! RH_e  = convert_humidity (P, T,  e, 'partial pressure', ...
%!     'relative humidity', method_es);
%!  e_e  = convert_humidity (P, T,  e, 'partial pressure', ...
%!     'partial pressure', method_es);
%! Td_e  = convert_humidity (P, T,  e, 'partial pressure', ...
%!     'dew point', method_es);
%! 
%! RH_Td = convert_humidity (P, T, Td, 'dew point', ...
%!     'relative humidity', method_es);
%!  e_Td = convert_humidity (P, T, Td, 'dew point', ...
%!     'partial pressure', method_es);
%! Td_Td = convert_humidity (P, T, Td, 'dew point', ...
%!     'dew point', method_es);
%! 
%! [RH_RH - RH,  e_RH -  e, Td_RH - Td]
%! [RH_e  - RH,  e_e  -  e, Td_e  - Td]
%! [RH_Td - RH,  e_Td -  e, Td_Td - Td]
%! % there are large discrepancies (up to 20% in RH).
%! % method_es doesn't seem to account for that.
%! % I'll check with the data provider, the IAG WG. 4.3.3.
%! %keyboard  % DEBUG
%! 
