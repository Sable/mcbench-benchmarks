function prob = survProbGenHazFun(t,b,hazardFun)
% survProbGeneralHazardFunction: Computes survival probability using the
% hazard function 'hazardFun'

h = @(t)hazardFun(t,b);

H = zeros(size(t));
H(1) = quad(h,0,t(1));
for i=2:length(H)
   H(i) = H(i-1) + quad(h,t(i-1),t(i));
end

prob = exp(-H);
