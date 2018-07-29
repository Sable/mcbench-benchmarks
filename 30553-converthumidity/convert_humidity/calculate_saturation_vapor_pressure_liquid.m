% T in K
% es in Pa
function es = calculate_saturation_vapor_pressure_liquid (T, method)
    if (nargin < 2) || isempty(method),  method = 'Murphy&Koop2005';  end
    switch method
    case {'Bolton1980', 'approx'}
        t = T - 273.15;
        es2 = 0.6112 .* exp(17.67 .* t ./ (t + 243.5));
        es = es2 * 1000;
        % The AMS Glossary gives [1] the simplified formula above, 
        % accordingly to Bolton (1980, eq. 10).
        % 
        % AMS Glossary. <http://amsglossary.allenpress.com/glossary/search?id=clausius-clapeyron-equation1>
        % Bolton, D., 1980: The computation of equivalent potential temperature. Mon. Wea. Rev., 108, 1046-1053. <http://dx.doi.org/10.1175/1520-0493(1980)108<1046:TCOEPT>2.0.CO;2>
    case 'Murphy&Koop2005'
        if ~all(123 < T & T < 332)
            warning('calculate_saturation_vapor_pressure_liquid:outRange', ...
                'Temperature out of range [123-332] K.');
        end
        temp = 54.842763 - 6763.22 ./ T - 4.210 .* log(T) + 0.000367 .* T ...
          + tanh( 0.0415 * (T - 218.8) ) ...
          .* (53.878 - 1331.22 ./ T - 9.44523 .* log(T) + 0.014025 .* T);
        es = exp(temp);
        % D. M. MURPHY and T. KOOP
        % Review of the vapour pressures of ice and supercooled water for
        % atmospheric applications
        % Q. J. R. Meteorol. Soc. (2005), 131, pp. 1539-1565 
        % doi: 10.1256/qj.04.94
        % <http://dx.doi.org/10.1256/qj.04.94>
        % 
        % "Widely used expressions for water vapour (Goff and Gratch 1946; Hyland and Wexler 1983) are being applied outside the ranges of data used by the original authors for their fits. This work may be the first time that data on the molar heat capacity of supercooled water [i.e., at temperatures below its freezing temperature] have been used to constrain its vapour pressure.
    otherwise
        error('calculate_saturation_vapor_pressure_liquid:methodUnknown', ...
            'Method "%s" unknown.', method);        
    end
end

%!test
%! % Table C1. VALUES RECOMMENDED FOR CHECKING COMPUTER CODES
%! temp = [...
%! % Temperature (K), Liquid vapor pressure (Pa)
%! 150     1.562e-5    0.001e-5
%! 180     0.011239    0.000001    
%! 210     1.2335      0.0001
%! 240     37.667      00.001
%! 273.15  611.213     000.001
%! 273.16  611.657     000.001
%! 300     3536.8      0000.1
%! ];
%! T = temp(:,1);
%! es = temp(:,2);
%! tol = temp(:,3)/10*5;  % rounding error.
%! es2 = calculate_saturation_vapor_pressure_liquid (T);
%! %[es, es2, es2-es]  % DEBUG
%! myassert(es2, es, -tol);

%!test
%! T = (123:10:332)';
%! es  = calculate_saturation_vapor_pressure_liquid (T, 'Murphy&Koop2005');
%! es2 = calculate_saturation_vapor_pressure_liquid (T, 'Bolton1980');
%! %[T-273.15, es, es2, es2-es, 100*(es2-es)./es]  % DEBUG
%! % worse agreement (in percentage) for supercooled temperatures, as expected.
%! temp = 100*(es2-es)./es;
%! myassert(abs(temp(1)) > abs(temp(end)))

