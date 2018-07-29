function sysdfod=dfod3(n,T,r)
%
% sysdfod=dfod3(n,T,r): digital fractional - order differentiator (r > 0)
%                       and integrator (r < 0) in form of the IIR filter;     
%                       Recommended restriction for order r: (-1 < r < 1)
% Output: =>
% Discrete system in the form of the IIR filter of the given order 'n'
% obtained by power series expansion of the trapezoidal (Tustin) rule.
%
% Inputs: <=
% n: order of truncation (min. n = 20 is recommended) --> filter order
% T: sampling period in [sec]
% r: approximated fractional order (s^r), r is an arbitrary real number
%
% Copyright (c), 2011, Ivo Petras (ivo.petras@tuke.sk)
%
% Note: It requires a Matlab Control System Toolbox (->FILT function<-)
% 
% Example: fractional half order integrator for T=0.1 sec and n = 20 :
% >> FHOI=dfod3(20, 0.1, -0.5); bode(FHOI); figure; step(FHOI);

bcN(1)=1.0; bcD(1)=1.0;
for i=1:n
  bcN(i+1)=((-1)^i)*(gamma(abs(r)+1)./(gamma(i+1).*gamma(abs(r)-i+1)));    
  bcD(i+1)=gamma(abs(r)+1)./(gamma(i+1).*gamma(abs(r)-i+1));
end
if r>=0
  sysdfod=((2/T)^r)*(filt(bcN,bcD,T));
end
if r<0
  sysdfod=((2/T)^r)*(filt(bcD,bcN,T));
end
%