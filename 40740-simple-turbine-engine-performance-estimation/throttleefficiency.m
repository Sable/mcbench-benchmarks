function eThrottle = throttleefficiency(h,M,throttle,assumptions)
% Change in gas turbine efficiency as a function of throttle setting. Note
% that for this function throttle is shaft Preq/Pavail, NOT Treq/Tavail.
% 
%   relativeEfficiency = throttleefficiency(h,M,throttle,assumptions)
% 
%   See also CALCULATEPSFC.

%% Interpolation method
%{
tau = [0
0.185
0.35
0.5
0.65
0.8
1];

e = [0.56
0.746
0.86
0.947
0.988
1
0.988];

eThrottle = interp1(tau,e,throttle,'linear');
%}

%% Quadratic curve fit from interpolation data
eThrottle =-0.6713*throttle.^2 + 1.0928*throttle + 0.5626;

%% Raymer method
%{
TSFCoverTSFCfullthrottle = .1./throttle+.24./throttle.^.8+...
    .66*throttle.^.8 + .1*M.*(1./throttle+throttle); 
eThrottle = max(2-TSFCoverTSFCfullthrottle,0);
%}

end