function tol = cputime_tol
    % cputime_res applies to either t1 or t2 individually; 
    % tol applies to t2-t1;
    tol = 2*cputime_res + sqrt(eps);
end

%!test
%! tol = cputime_tol;

