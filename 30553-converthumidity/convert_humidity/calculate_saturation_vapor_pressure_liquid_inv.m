% T in K
% es in Pa
function [T, T_approx] = calculate_saturation_vapor_pressure_liquid_inv (...
es, method, tol_T)
    if (nargin < 2) || isempty(method),  method = '';  end % [] ~= ''
    if (nargin < 3) || isempty(tol_T),  tol_T = eps;  end

    switch method
    case {'Bolton1980', 'approx'}
        % this also serves as a good starting point for more elaborate methods.
        es2 = es ./ 1e3;
        temp = log(es2 ./ 0.6112) ./ 17.67;
        t = 243.5 .* temp ./ (1 - temp);
        T = t + 273.15;
        if (nargout > 1),  T_approx = T;  end
    otherwise
        T_approx = calculate_saturation_vapor_pressure_liquid_inv (es,'approx');
        f = @(T_) calculate_saturation_vapor_pressure_liquid (T_, method);
        temp = warning('off', ...
            'calculate_saturation_vapor_pressure_liquid:outRange');
        T = inv_func2 (f, es, T_approx, tol_T);
        warning(temp);
        % we disable the warning because fzero may rightesously probe 
        % outside the valid range, in the search for the root.
    end
end

%!test
%! method = 'Bolton1980';
%! T = (123:10:332)';
%! es = calculate_saturation_vapor_pressure_liquid (T, method);
%! [T2, T3] = calculate_saturation_vapor_pressure_liquid_inv (es, method);
%! %[T, T2, T3, T2-T, T3-T]  % DEBUG
%! %max(abs(T2-T))  % DEBUG
%! tol = eps;
%! myassert(T2, T, -tol)

%!test
%! method = 'Murphy&Koop2005';
%! T = (123:10:332)';
%! es = calculate_saturation_vapor_pressure_liquid (T, method);
%! [T2, T3] = calculate_saturation_vapor_pressure_liquid_inv (es, method);
%! %[T, T2, T3, T2-T, T3-T]  % DEBUG
%! %max(abs(T2-T))  % DEBUG
%! tol = nthroot(eps, 3);
%! myassert(T2, T, -tol)

%!test
%! % empty method should work.
%! method = [];
%! T = (123:10:332)';
%! es = calculate_saturation_vapor_pressure_liquid (T, method);
%! [T2, T3] = calculate_saturation_vapor_pressure_liquid_inv (es, method);

