function sp=orthpoly(n,opfamily,alpha,beta)
% orthpoly: generate an n'th order (symbolic) orthogonal polynomial
% usage: sp=orthpoly(n,opfamily,alpha,beta);
% 
% arguments: (input)
%  n        - order of polynomial requested
%
%  opfamily - (OPTIONAL) character string - specifies the
%             type of orthogonal polynomial to be generated.
%             Legal polytypes are: {'legendre', 'hermite',
%             '1cheby', '2cheby', 'laguerre', 'jacoby'}
%
%             Default == 'legendre'
%             
%             Note: 1cheby refers to first kind
%             chebychev polynomials (Tn(x)),
%             and 2cheby refers to second kind
%             chebychev polynomials (Un(x))
%             
%             The domain of support is [-1,1] for the polynomial
%             families 'legendre', '1cheby', '2cheby', 'jacoby'.
%             It is [0,inf] for 'laguerre', and [-inf,inf] for
%             the 'hermite' family.
%
%             See Abramowitz & Stegun for in-depth information
%             on all of these polynomial families.
%
%  alpha,beta - scalar - orthogonal family parameters - 
%             See Abramowitz & Stegun for more information.
%
%             These parameters are ignored for 'legendre',
%             'hermite', '1cheby' and '2cheby' polys.
%
% arguments: (output)
%  p        - sympoly object containing the polynomial

% defaults
if (nargin<2)|isempty(opfamily)
  % default is legendre
  opfamily = 'legendre';
else
  if ~ischar(opfamily)
    error 'Opfamily must be a character string'
  end
  valtypes = {'legendre', 'hermite', 'cheby1', '1chebychev' ...
            'cheby2', '2chebychev', 'laguerre', 'jacobi'};
  
  ptind = strmatch(opfamily,valtypes);
  if isempty(ptind)
    % no match
    error 'Invalid opfamily'
  elseif length(ptind)>1
    % match more than one
    error 'Ambiguous opfamily'
  else
    % there was exactly one match
    opfamily = valtypes{ptind};
  end
end

if nargin<1
  error 'Polynomial order must be supplied. No default for n.'
end

if (nargin<3) || isempty(alpha)
  % default is 0
  alpha = 0;
end

if (nargin<4) || isempty(beta)
  % default is 0
  beta = 0;
end

% initialize (-1)'th and zero'th order sympolys
% for the three term recurrence relation.
pnm1=sympoly(0);
pn=sympoly(1);
x=sympoly('x');

if n==0
  % p0 is easy to get
  sp=pn;
  return
elseif n<0
  error 'Polynomial order must not be negative'
end

% iterate to get polynomial
for i=0:(n-1)
  switch opfamily
    case 'legendre'
      pnp1=((2*i+1)*x*pn - i*pnm1)./(i+1);
      % normalize so that Tn(1)=1
      pnp1=pnp1./double(subs(pnp1,'x',1));
      
    case 'hermite'
      % neither alpha nor beta is meaningful
      pnp1=2*pn*x - 2*i*pnm1;
      
    case 'laguerre'
      % only alpha is meaningful here
      pnp1=((2*i+alpha+1)*pn - pn*x - (i+alpha)*pnm1)./(i+1);
      
    case {'cheby1' '1chebychev'}
      % first kind chebychev
      % neither alpha nor beta is meaningful
      pnp1=(2*pn*x - pnm1);
      % normalize so that Tn(1)=1
      pnp1=pnp1/double(subs(pnp1,'x',1));
      
    case {'cheby2' '2chebychev'}
      % second kind chebychev
      % neither alpha nor beta is meaningful
      pnp1=(2*pn*x - pnm1);
      
    case 'jacobi'
      % both alpha and beta are needed
      if (alpha~=0) | (beta~=0)
        a1n=2*(i+1)*(i+alpha+beta+1)*(2*i+alpha+beta);
        a2n=(2*i+alpha+beta+1)*(alpha^2-beta^2);
        if (2*i+alpha+beta)<=150
          a3n=gamma(2*i+alpha+beta+3)./gamma(2*i+alpha+beta);
        else
          a3n=exp(gammaln(2*i+alpha+beta+3)-gammaln(2*i+alpha+beta));
        end
        a4n=2*(i+alpha)*(i+beta)*(2*i+alpha+beta+2);
        pnp1=(a2n*pn + a3n*pn*x - a4n*pnm1)/a1n;
      else
        pnp1=((2*i+1)*pn*x - i*pnm1)/(i+1);
      end
  end
  pnm1=pn;
  pn=pnp1;

end

% return the generated sympoly
sp=pnp1;



