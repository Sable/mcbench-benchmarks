function Th = theta(type,v,m,tol)
%THETA evaluates theta functions of four types.
%   Th = THETA(TYPE,V,M) returns values of theta functions
%   evaluated for corresponding values of argument V and parameter M.  
%   TYPE is a type of the theta function, there are four numbered types.
%   The arrays V and M must be the same size (or either can be scalar).  
%   As currently implemented, M is limited to 0 <= M <= 1. 
%
%   Th = THETA(TYPE,V,M,TOL) computes the theta and eta 
%   elliptic functions to the accuracy TOL instead of the default TOL = EPS.  
%
%   The parameter M is related to the nome Q as Q = exp(-pi*K(1-M)/K(M)).
%   Some definitions of the Jacobi elliptic functions use the modulus
%   k instead of the parameter m.  They are related by m = k^2.
%
%   Example:
%       [phi,alpha] = meshgrid(0:5:90, 0:2:90);                  
%       Th1 = theta(1, pi/180*phi, sin(pi/180*alpha).^2);  
%       Th2 = theta(2, pi/180*phi, sin(pi/180*alpha).^2);  
%       Th3 = theta(3, pi/180*phi, sin(pi/180*alpha).^2);  
%       Th4 = theta(4, pi/180*phi, sin(pi/180*alpha).^2);  
%
%   See also 
%       Standard: ELLIPKE, ELLIPJ, 
%       Moiseev's package: ELLIPTIC12, ELLIPTIC12I, JACOBITHETAETA.
%
%   References:
%   [1] M. Abramowitz and I.A. Stegun, "Handbook of Mathematical
%       Functions" Dover Publications", 1965, Ch. 16-17.6.

% Moiseev Igor
% 34106, SISSA, via Beirut n. 2-4,  Trieste, Italy
% For support, please reply to 
%     moiseev.igor[at]gmail.com, moiseev[at]sissa.it
%     Moiseev Igor, 
%     34106, SISSA, via Beirut n. 2-4,  Trieste, Italy

if nargin<4, tol = eps; end
if nargin<3, error('Not enough input arguments.'); end

if ~isreal(v) | ~isreal(m)
    error('Input arguments must be real.')
end

Th = zeros(size(v));
H = Th;

if length(m)==1, m = m(ones(size(v))); end
if length(v)==1, v = v(ones(size(m))); end
if ~isequal(size(m),size(v)), error('V and M must be the same size.'); end

% m = m(:).';    % make a row vector
% v = v(:).';

if any(m < 0) | any(m > 1), 
  error('M must be in the range 0 <= M <= 1.');
end

K = ellipke(m);
u = 2*K.*v/pi;

switch type
    case { '1', 1 }
        [th, H] = jacobiThetaEta(u,m,tol);
        Th(:) = H;
        return;
    case { '2', 2 }
        [th, H] = jacobiThetaEta(u+K,m,tol);
        Th(:) = H;
        return;
    case { '3', 3 }
        Th(:) = jacobiThetaEta(u+K,m,tol);
        return;
    case { '4', 4 }
        Th(:) = jacobiThetaEta(u,m,tol);
        return;
end

% END FUNCTION theta()
