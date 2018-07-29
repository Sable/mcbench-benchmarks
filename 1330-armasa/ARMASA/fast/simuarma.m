function x = simuARMA(a,b,nobs)
% x = simuARMA(a,b,nobs)
% simulation of nobs observations of an ARMA process with parameters
% a,b en standard deviation 1.
%
% No transients in finite signal
% Paper:
%
%   Broersen, P.M.T. and S. de Waele
% 	Generating Data with Prescribed Power Spectral Density.
%	IEEE Trans. on Instrumentation and Measurement, vol. 52, no. 4, p 1061-1067, 2003.
%
%
% uses randn( , )
%

aro = length(a)-1;
mao = length(b)-1;
[cor,g]=arma2cor(a,b);
[cor2,gar]=arma2cor(a,1);

if ~aro,
   v = randn(nobs+mao,1)/sqrt(g);   
else
   z = randn(aro,1);
   vs = zeros(aro,1);
   [at rc] = ar2arset(a);
   f = 1;
   vs(1) = f*z(1);
   al = [];
   for i = 2:aro,
   	f = sqrt(1-rc(i)^2)*f;
      al = [al 0] + rc(i)*[fliplr(al) 1];
      vs(i) = f*z(i)-al*vs(i-1:-1:1);
   end %for i = 2:aro,
   vs = vs*sqrt(gar/g);
   v = armafilter(randn(nobs+mao,1)/sqrt(g),a,1,vs,z);
end %if ~aro,
x = armafilter(v,1,b);
x = x(mao+1:mao+nobs);