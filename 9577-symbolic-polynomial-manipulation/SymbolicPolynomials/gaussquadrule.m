function [nodes,weights]=gaussquadrule(n,class,alpha,beta)
% gaussquadrule: generate a gauss quadrature rule using associated orthogonal polynomials
% usage: [nodes,weights]=gaussquadrule(n,class,alpha,beta)
%
% arguments:
%        n - number of nodes in the guassian quadrature
%          
%    class - (optional) - class of gaussian quadrature rule
%            any one of { 'Legendre' 'Laguerre' 'Hermite',
%            'Jacobi', '1Cheby', '2Cheby' }. '1cheby' refers
%            of course to a first kind Gauss-Chebychev rule.
%            
%            Capitalization is ignored and class names
%            may be shortened as long as they are left
%            unambiguous. These are all minimally valid:
%            {'le', 'la', 'h' 'j' '1' '2'}
%            
%            DEFAULT == 'Legendre'
%
%            The nominal integration intervals are:
%            
%              'Legendre' --> [  -1,  1]
%              'Laguerre' --> [   0,inf]
%              'Hermite'  --> [-inf,inf]
%              'Jacobi'   --> [  -1,  1]
%              '1Cheby'   --> [  -1,  1]
%              '2Cheby'   --> [  -1,  1]
%            
%            See Abramowitz & Stegun for in-depth information
%            
% alpha, beta - (optional) parameters for the rules
%            DEFAULT == 0 for both
%
%            alpha and beta are ignored for the 'legendre',
%            'hermite', 'cheby1' and 'cheby2' rules. Only
%            alpha is used for the Laguerre quadrature rules.
%           
% arguments (output)
%    nodes - x values for integration
%  weights - integration weights

% default parameters
if (nargin<2) || isempty(class)
  class='legendre';
end

class=lower(class);
valc={'legendre' 'laguerre' 'hermite' 'jacobi' 'cheby1' ...
      'cheby2' '1chebychev' '2chebychev'};
ind=strmatch(class,valc);
if isempty(ind)
  error 'Invalid quadrature class'
elseif length(ind)>1
  error 'Ambiguous quadrature class'
else
  class=valc{ind};
end

if (nargin<4) || isempty(beta)
  beta=0;
end
if (nargin<3) || isempty(alpha);
  alpha=0;
end

% generate the appropriate orthogonal sympolys.
% use the sympoly objects for this. orthpoly
% creates them.
pn = orthpoly(n,class,alpha,beta);
pnp1 = orthpoly(n+1,class,alpha,beta);

nodes=roots(pn);
nodes=sort(nodes');

pnprime=diff(pn);
weights=zeros(1,n);
for i=1:n
  weights(i)=-(pnp1.Coefficient(end))/(pn.Coefficient(end))./ ...
    double(subs(pnp1,'x',nodes(i)))./ ...
    double(subs(pnprime,'x',nodes(i)));
end

% norm
switch class
  case 'legendre'
    weights=weights*(2/(2*n+1));
  case 'hermite'
    weights=sqrt(pi)*(2^n)*(gamma(n+1))*weights;
  case 'laguerre'
    weights=weights*gamma(n+alpha+1)/gamma(n+1);
  case 'jacobi'
    weights=weights*(2/sum(weights));
    nodes=(nodes+1)/2;
  case {'cheby1' '1chebychev'}
    weights=weights*(2/sum(weights));
  case {'cheby2' '2chebychev'}
    weights=weights*(2/sum(weights));
end

