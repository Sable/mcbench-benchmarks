% fkn_dbl_exp_fit_k - makes a double-exponential curve fit of F(k,t)/F(k,0)
%   [dy,y_fit]=fkn_dbl_exp_fit_k(p,t,Fr,k) where:
%
%   dy = the error in the fit
%   y_fit = the fitted values of F(k,t)/F(k,0)
%
%   p(1) = gamma0 (the fraction of immobile molecules)
%   p(2) = D2 (the diffusion coefficient of component 2)
%   p(3) = gamma2 (the fraction of component 2)
%   p(4:2:end) = D1(k) (the diffusion coefficient for component 1
%       determined at each value of k separately)
%   p(5:2:end) = amplitudes for each value of k (correcting for errors in
%       F(k,0))
%   t = the times for each frame
%   Fr = F(k,t)/F(k,0) (where F(k,t) is the Hankel transform of the
%       experimental data)
%   k = spatial frequencies

function [dy,y_fit]=fkn_dbl_exp_fit_k(p,t,Fr,k)

gamma0=p(1);
D2=p(2);
gamma2=p(3);
D1=p(4:2:end);
f0=p(5:2:end);
y_fit=zeros(size(Fr));
dy=zeros(size(Fr));

% Computes dy(k) from the curve fits to Fr for each value of k with gamma2,
% D2 and gamma0 common for all k, but with D1 allowed to vary
for i=1:length(k)
     y_fit(i,:)=f0(i)*((1-gamma2-gamma0)*exp(-4*pi^2*k(i)^2*D1(i)*t)+...
         gamma2*exp(-4*pi^2*k(i)^2*D2*t)+gamma0);
     dy(i,:)=y_fit(i,:)-Fr(i,:);
end
dy=dy(:);   % Places all errors in a vector
