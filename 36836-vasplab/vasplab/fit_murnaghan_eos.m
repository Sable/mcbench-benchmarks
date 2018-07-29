function [ x,fval,exitflag ] = fit_murnaghan_eos( V, E )
%FIT_MURNAGHAN_EOS Fit to the Murnaghan equation of state.
%   [ x,fval,exitflag ] = fit_murnaghan_eos( V, E ) attempts to fit the 
%   and energies given by the 1xN arrays V and E to the Murnaghan equation 
%   of state. x contains the fitted parameters:
%   x = [B0 B0' V0 E0]      
%
%   See also MURNAGHAN_EOS.

    x0 = [1 1 mean(V) min(E)]; % initial guess
    banana = @(x)sum((murnaghan_eose(V,x)-E).^2);
    [x,fval,exitflag] = fminsearch(banana,x0,optimset('TolX',1e-12,'MaxFunEvals',3000)); 
end