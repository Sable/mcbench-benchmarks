% fkn_dbl_exp_fit - makes a double-exponential curve fit of F(k,t)/F(k,0)
%   [dy,y_fit]=fkn_dbl_exp_fit(p,t,Fr,k) where:
%
%   dy = the error in the fit
%   y_fit = the fitted values of F(k,t)/F(k,0)
%
%   p(1) = gamma2 (the fraction of component 2)
%   p(2) = D1 (the diffusion coefficient of component 1)
%   p(3) = D2 (the diffusion coefficient of component 2)
%   p(4) = gamma0 (the fraction of immobile molecules)
%   p(5:end) = amplitudes for each value of k (correcting for errors in
%       F(k,0))
%   t = the times for each frame
%   Fr = F(k,t)/F(k,0) (where F(k,t) is the Hankel transform of the
%       experimental data)
%   k = spatial frequencies

function [dy,y_fit]=fkn_dbl_exp_fit(p,t,Fr,k)

gamma2=p(1);
D1=p(2);
D2=p(3);    
gamma0=p(4);
y_fit=zeros(size(Fr));
dy=zeros(size(Fr));

% Computes dy(k) from the curve fits to Fr for each value of k with gamma2,
% D1, D2 and gamma0 common for all k
for i=1:length(k)
     y_fit(i,:)=p(4+i)*((1-gamma2-gamma0)*exp(-4*pi^2*k(i)^2*D1*t)+...
         gamma2*exp(-4*pi^2*k(i)^2*D2*t)+gamma0);
     dy(i,:)=y_fit(i,:)-Fr(i,:);
end
dy=dy(:);   % Places all errors in a vector
