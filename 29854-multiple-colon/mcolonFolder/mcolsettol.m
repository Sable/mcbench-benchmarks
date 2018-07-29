function prevtol = mcolsettol(tol)
% set/get multi-colon tolerance 
%
% defaultol(TOL) set the relative tolerance to TOL
%
% INQUIRING: prevtol = mcolsettol(...) return the current tolerance before
%                                      the new tolerance is set.
%
% See also: mcolon, mcolonops
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% Last update: 31/December/2010

persistent MCOLON_TOL

if isempty(MCOLON_TOL)
    % Default tolerance
    MCOLON_TOL = 1e-12;
end
if nargout>=1 || nargin<1
    prevtol = MCOLON_TOL; % Return the previous tolerance
end

if nargin>=1
    MCOLON_TOL = tol;
end

% Prevent the persistent variable to be cleared
mlock;

end