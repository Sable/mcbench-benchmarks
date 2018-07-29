function sysdfod=dfod2(n,T,r)
% sysdfod=dfod2(n,T,r): digital fractional order differentiator
%                       and integrator    
%
% Output: =>
% Discrete system in the form of the FIR filter of the order n
% obtained by power series expansion of the backward difference.
%
% Inputs: <=
% n: order of truncation (min n=100 is recommended)
% T: sampling period in [sec]
% r: approximated fractional order (s^r), r is generally real number
%
% Author: Ivo Petras (ivo.petras@tuke.sk)
%
% Note: differentiator  -> nonrecusrive approximation 
%       integrator      -> recursive approximation
%
% Copyright (c), 2003-2011.
%

if r>0
   bc=cumprod([1,1-((r+1)./[1:n])]);   
   sysdfod=filt(bc,[T^r],T);
end
if r<0
   bc=cumprod([1,1-((-r+1)./[1:n])]);
   sysdfod=filt([T^-r],bc,T);
end
%