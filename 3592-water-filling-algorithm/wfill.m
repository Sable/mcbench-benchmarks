function wline=wfill(vec, pcon, tol)
%   WFILL: The Water Filling algorithm.
%   WLINE = WFILL(VEC, PCON, TOL) performs the water filling algorithm 
%   with the given total power constrain to approach Shannon capacity 
%   of the channel. 
%   The water filling algorithm is based on an interative procedure, so the tolerance
%   must be assigned to determine the end-of-loop.
%   
%   VEC is a noise absolute or relative level in LINEAR units at different frequencies, 
%   space or whatever bins. PCON is a total power constrain given in the same units as the VEC.
%   TOL is an acceptable tolerance in the units of VEC.
%   WLINE indicates the WATERLINE level in units of VEC so that: 
%
%                       abs(PCON-SUM(MAX(WLINE-VEC, 0)))<=TOL
%   
%   The algorithm is built such a way that PCON>=SUM(MAX(WLINE-VEC, 0)) and never 
%   PCON<SUM(MAX(WLINE-VEC, 0)).
%
%   VEC must be a row vector representing a noise level. PCON and TOL must be scalars in 
%   the same units as VEC.

%   Example:
%   
%   Input: VEC=[1 3 5 4]
%          PCON=7
%          TOL=1e-5
%
%   Output: WLINE=5
%
%   The function doesn't check the formats of VEC, PCON and TOL, as well as a number of the
%   input and output parameters.
%
% Author: G. Levin, May, 2003
%
% References:
%   T. M. Cover and J. A. Thomas, "Elements of Information Theory", John Wiley & Sons,
%   Inc, 1991.

N=length(vec);

%first step of water filling
wline=min(vec)+pcon/N; %initial waterline
ptot=sum(max(wline-vec,0)); %total power for current waterline
 
%gradual water filling
while abs(pcon-ptot)>tol
    wline=wline+(pcon-ptot)/N;
    ptot=sum(max(wline-vec,0));
end

