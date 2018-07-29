function [ar_d2,ma_d2,pe_n] = durbin2(ar_long,ar_ini,ma_order,ASAcontrol)

%function [ar_d2,ma_d2,pe_n] = durbin2(ar_long,ar_ini,ma_order,ASAcontrol)
%The Durbin-2 part of sig2arma.
%If the 3rd output argument is added, the prediction error of ar_d2,ma_d2
%with respect to the ar_long model is calculated.
%
%See also: SIG2ARMA.

if nargin < 4,
    ASAcontrol.is_version = [2000 12 30 20 0 0];
end

ar_order = length(ar_ini)-1;
ar_long_order = length(ar_long)-1;
ar_d2 = ar_ini;

%Determine an intermediate AR model by
%polynomial devision of the (long) sliding AR
%model and the initial AR parameters
ar_interm = deconvol...
    (ar_long,ar_ini,ASAcontrol);

%Determine the MA parameters with Durbin's MA
%estimator, using the intermediate AR model
ar_corr = convolrev...
    (ar_interm,ma_order,ASAcontrol);
ma_d2 = cov2arset(ar_corr,ASAcontrol);

%Update the initial AR parameters by
%computing AR parameters that provide the
%best description of the model obtained by
%the polynomial product of the sliding AR
%model and the determined MA parameters
ar_d2 = convol(ar_long,ma_d2,ASAcontrol);
[ar_d2 rc] = ar2arset(ar_d2,ar_order:ar_long_order+ma_order,ASAcontrol);
pe_n = 1/prod(1-rc(2:end).^2);
ar_d2 = ar_d2{1};
