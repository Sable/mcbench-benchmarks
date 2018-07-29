function [ result ] = murnaghan_eos(V, x)
%MURNAGHAN_EOS Evaluate the Murnaghan equation of state.
%   murnaghan_eos(V, x) gives the Murnaghan equation of state evaluated at a
%   series of volumes given by the 1xN array V. x contains the parameters:
%   x = [B0 B0' V0 E0]
%
%   See also FIT_MURNAGHAN_EOS.
       result = x(4)+x(1)*V/x(2)/(x(2)-1).*(x(2)*(1-x(3)./V)+(x(3)./V).^x(2)-1);
end