function [limit,errest] = limest(fun,z0,varargin)
% limest: limit of fun as z --> z0 with an error estimate
% usage: [limit,errest] = limest(fun,z0)
% usage: [limit,errest] = limest(fun,z0,prop1,val1,prop2,val2,...)
%
% limest computes the limit of a given function at a specified
% point. When the function is evaluable at the point in question,
% this is a simple task. But when the function cannot be evaluated
% at that location due to a singularity, you may need a tool to
% compute the limit. Limest does this, as well as produce an
% uncertainty estimate in the final result.
%
% The methods used by limest are polynomial extrapolants (related
% to Richardson extrapolation) which also yield an error estimate.
% The user can specify the method order, as well as the path into
% z0. z0 may be real or complex.
%
% Finally, While I have not written this function for the
% absolute maximum speed, speed was a major consideration
% in the algorithmic design. Maximum accuracy was my main goal.
%
%
% Arguments (input)
%  fun - function to compute the limit for. May be an inline
%        function, anonymous, or an m-file. If there are additional
%        parameters to be passed into fun, then use of an anonymous
%        function is recommended.
%
%        fun should be vectorized to allow evaluation at multiple
%        locations at once. This will provide the best possible
%        speed. IF fun is not so vectorized, then you MUST set the
%        'vectorized' property to 'no', so that limest will then
%        call your function sequentially instead.
%
%        Fun is assumed to return a result of the same shape and
%        size as its input.
%
%  z0  - scalar point at which to compute the limit. z0 may be
%        real or complex, but it MUST be finite. There is no
%        default value for z0.
%
%
% Additional inputs must be in the form of property/value pairs.
%  Properties are character strings. They may be shortened
%  to the extent that they are unambiguous. Properties are
%  not case sensitive. Valid property names are:
%
%  'MethodOrder', 'Vectorized' 'StepRatio', 'DZ'
%
%  All properties have default values, chosen as intelligently
%  as I could manage. Values that are character strings may
%  also be unambiguously shortened. The legal values for each
%  property are:
%
%  'MethodOrder' - MethodOrder defines the order of approximation
%        used to find the specified limit. Each such approximation
%        will use (MethodOrder + 2) function evaluations. Since
%        the function evaluations are carefully reused, a lower
%        MethodOrder will not result in fewer overall function
%        evaluations.
%
%        MethodOrder must be a member of [1 2 3 4 5 6 7 8]. 4 is
%        a good compromise.
%
%        DEFAULT: 4
%
%  'Vectorized' - limest will normally assume that your
%        function can be safely evaluated at multiple locations
%        in a single call. This would minimize the overhead of
%        a loop and additional function call overhead. Some
%        functions are not easily vectorizable, but you may
%        (if your matlab release is new enough) be able to use
%        arrayfun to accomplish the vectorization.
%
%        When all else fails, set the 'vectorized' property
%        to 'no'. This will cause limest to loop over the
%        successive function calls.
%
%        DEFAULT: 'yes'
%
%  'DZ' - Nominal step away from z0 taken in the estimation
%        All samples of fun will be taken at some path away
%        from zo, along the path z0 + k*dz. dz may be complex.
%
%        DZ allows the you to specify a limit from above or
%        below. That is, negative values of DZ will cause the
%        limit to be taken approaching z0 from below.
%        
%        DEFAULT: 1e8*eps(z0)
% 
%  'StepRatio' - limest uses a proportionally cascaded series
%        of function evaluations, moving away from your point
%        of evaluation along a path along the real line (or in
%        the complex plane for complex z0 or DZ.) The StepRatio
%        is the ratio used between sequential steps.
%
%        A smaller StepRatio means that limest will take more
%        function evaluations to evauate the limit, but the
%        result will potentially be less accurate. StepRatio
%        MUST be a scalar larger than 1. I would recommend
%        staying in the range [2,100]. 4 seems a good compromise.
%
%        DEFAULT: 4
%
%
% Arguments: (output)
%  limit - estimated limit at z0.
%
%  errest - 95% uncertainty estimate around the limit, such
%        that
%
%        abs(limit - fun(z0)*(z-z0)) < erest(j)
%
%
% Example:
%  Compute the limit of sin(x)./x, at x == 0. The limit is 1.
%
%  [lim,err] = limest(@(x) sin(x)./x,0)
%
%  lim =
%                       1
%  err =
%    1.77249444610966e-15
%
% Example:
%  Compute the derivative of cos(x) at x == pi/2. It should
%  be -1. The limit will be taken as a function of the
%  differential parameter, dx.
%
%  x0 = pi/2;
%  [lim,err] = limest(@(dx) (cos(x0+dx) - cos(x0))./dx,0)
%
%  lim =
%                      -1
%  err =
%    2.83371792311754e-15
% 
% Example:
%  Compute the residue at a first order pole at z = 0
%  The function 1./(1-exp(2*z)) has a pole at z == 0.
%  The residue is given by the limit of z*fun(z) as z --> 0.
%  Here, that residue should be -0.5.
%
%  [lim,err] = limest(@(z) z./(1-exp(2*z)),0)
%
%  lim =
%                    -0.5
%  err =
%    1.88001426368945e-15
%
% Example:
%  A more difficult limit is one where there is significant
%  subtractive cancellation at the limit point. In the following
%  example, the cancellation is second order. The true limit
%  should be 0.5.
%  
%  [lim,err] = limest(@(x) (x.*exp(x)-exp(x)+1)./x.^2,0)
%
%  lim =
%          0.500000000094929
%  err =
%       1.56957823156003e-09
%
%
% See also: derivest
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 5/23/2008

% Parameter defaults
par.MethodOrder = 4;
par.StepRatio = 4;
par.Vectorized = 'yes';
par.DZ = [];
% TrimFactor is an undocumented parameter, used when I was
% developing the code. It should probably be left alone.
par.TrimFactor = 10;

na = length(varargin);
if (rem(na,2)==1)
  error 'Property/value pairs must come as PAIRS of arguments.'
elseif na>0
  par = parse_pv_pairs(par,varargin);
end
par = check_params(par);

% Was fun a string, or an inline/anonymous function?
if (nargin<1)
  help limest
  return
elseif isempty(fun)
  error('fun was not supplied.')
elseif ischar(fun)
  % a character function name
  fun = str2func(fun);
end

% no default for z0
if (nargin<2) || isempty(z0)
  error('z0 was not supplied')
elseif numel(z0) > 1
  error('z0 must be scalar')
end

% supply a default step?
if isempty(par.DZ)
  if z0 == 0
    % special case for zero
    par.DZ = 1e8*eps(1);
  else
    par.DZ = 1e8*eps(z0);
  end
elseif numel(par.DZ)>1
  error('DZ must be scalar if supplied')
end

% Default MethodOrder is 2.
if isempty(par.MethodOrder)
  par.MethodOrder = 2;
end

% Define the samples to use along a linear path
nsteps = round(log(2e7)/log(par.StepRatio));
k = (-nsteps:nsteps)';
delta = par.DZ*(par.StepRatio.^k);
ndel = length(delta);
Z = z0 + delta;

% sample the function at these sample points
if strcmpi(par.Vectorized,'yes')
  % fun is supposed to be vectorized.
  fz = fun(Z);
  fz = fz(:);
  if numel(fz) ~= ndel
    error('LIMEST:Vectorized','fun did not return a result of the proper size. Perhaps not properly vectorized?')
  end
else
  % evaluate in a loop
  fz = zeros(size(Z));
  for i = 1:ndel
    fz(i) = fun(Z(i));
  end
end

% replicate the elements of fz into a sliding window
m = par.MethodOrder;
fz = fz(repmat((1:(ndel-m)),m+1,1) + repmat((0:m)',1,ndel-m));

% generate the general extrapolation rule
d = par.StepRatio.^((0:m)'-m/2);
A = repmat(d,1,m).^repmat(0:m-1,m+1,1);
[qA,rA] = qr(A,0);

% compute the various estimates of the prediction polynomials.
% Note that these polynomial extrapolants are closely related
% to a Richardson extrapolation, but these are not truly
% interpolants, since we use approximate n+1 data points using
% an (n-1)'th order polynomial approximation. The use of n terms
% to fit n+1 points allows us to produce the useful error estimate.
polycoef = rA\(qA'*fz);

% predictions for each model
pred = A*polycoef;
% and residual standard errors
ser = sqrt(sum((pred - fz).^2,1));

% the actual extrapolated estimates are just the first row of polycoef
limit_estimates = polycoef(1,:);

% uncertainty estimate of the limit
rAinv = rA\eye(m);
cov1 = sum(rAinv.^2,2);

% 1 spare dof, so we use a student's t with 1 dof
errest = 12.7062047361747*sqrt(cov1(1))*ser;

% drop any estimates that were inf or nan.
k = isnan(limit_estimates) | isinf(limit_estimates);
errest(k) = [];
limit_estimates(k) = [];
% delta(k) = [];

% if nothing remains, then there was a problem. Possibly a bad dz.
nres = numel(limit_estimates);
if nres < 1
  error('No limit was found. Perhaps try a different DZ.')
end

% sort the remaining estimates
[limit_estimates,tags] = sort(limit_estimates);
errest = errest(tags);
% delta = delta(tags);

% Most of these estimates should be fairly consistent with
% each other, so find the median estimate.
limit_median = median(limit_estimates);

% and discard any estimate that differs wildly from the
% median of all estimates. A factor of 10 to 1 in either
% direction is probably wild enough here. The actual
% trimming factor is defined as a parameter.
k = (abs(limit_median)*par.TrimFactor)<abs(limit_estimates) | ...
    (abs(limit_median)/par.TrimFactor)>abs(limit_estimates);
if any(k)
  limit_estimates(k) = [];
  errest(k) = [];
  % delta([1,end]) = [];
end

% and take the one that remains with the lowest error estimate
[errest,k] = min(errest);
limit = limit_estimates(k);
% delta = delta(k);

end % mainline end

% ============================================
% subfunction - check_params
% ============================================
function par = check_params(par)
% check the parameters for acceptability
%
% Defaults:
%
% par.MethodOrder = 4
% par.StepRatio = 4;
% par.Vectorized = 'yes'
% par.DZ = [];

% MethodOrder == 4 by default
if isempty(par.MethodOrder)
  par.MethodOrder = 4;
else
  if (length(par.MethodOrder)>1) || ~ismember(par.MethodOrder,1:8)
    error('LIMEST:MethodOrder','MethodOrder must be one of [1 2 3 4 5 6].')
  end
end

% StepRatio == 4 by default
if isempty(par.StepRatio)
  par.StepRatio = 4;
else
  if (length(par.StepRatio)>1) || (par.StepRatio<=1)
    error('LIMEST:StepRatio','Must have StepRatio>1 and scalar.')
  end
end

% vectorized is char
valid = {'yes', 'no'};
if isempty(par.Vectorized)
  par.Vectorized = 'yes';
elseif ~ischar(par.Vectorized)
  error('LIMEST:Vectorized','Invalid Vectorized: Must be character')
end
ind = find(strncmpi(par.Vectorized,valid,length(par.Vectorized)));
if (length(ind)==1)
  par.Vectorized = valid{ind};
else
  error('LIMEST:Vectorized',['Invalid Vectorized: ',par.Vectorized])
end

% DZ == [] by default
if (length(par.DZ)>1)
  error('LIMEST:Vectorized','DZ must be empty or a scalar.')
end

end % check_params


% ============================================
% Included subfunction - parse_pv_pairs
% ============================================
function params=parse_pv_pairs(params,pv_pairs)
% parse_pv_pairs: parses sets of property value pairs, allows defaults
% usage: params=parse_pv_pairs(default_params,pv_pairs)
%
% arguments: (input)
%  default_params - structure, with one field for every potential
%             property/value pair. Each field will contain the default
%             value for that property. If no default is supplied for a
%             given property, then that field must be empty.
%
%  pv_array - cell array of property/value pairs.
%             Case is ignored when comparing properties to the list
%             of field names. Also, any unambiguous shortening of a
%             field/property name is allowed.
%
% arguments: (output)
%  params   - parameter struct that reflects any updated property/value
%             pairs in the pv_array.
%
% Example usage:
% First, set default values for the parameters. Assume we
% have four parameters that we wish to use optionally in
% the function examplefun.
%
%  - 'viscosity', which will have a default value of 1
%  - 'volume', which will default to 1
%  - 'pie' - which will have default value 3.141592653589793
%  - 'description' - a text field, left empty by default
%
% The first argument to examplefun is one which will always be
% supplied.
%
%   function examplefun(dummyarg1,varargin)
%   params.Viscosity = 1;
%   params.Volume = 1;
%   params.Pie = 3.141592653589793
%
%   params.Description = '';
%   params=parse_pv_pairs(params,varargin);
%   params
%
% Use examplefun, overriding the defaults for 'pie', 'viscosity'
% and 'description'. The 'volume' parameter is left at its default.
%
%   examplefun(rand(10),'vis',10,'pie',3,'Description','Hello world')
%
% params = 
%     Viscosity: 10
%        Volume: 1
%           Pie: 3
%   Description: 'Hello world'
%
% Note that capitalization was ignored, and the property 'viscosity'
% was truncated as supplied. Also note that the order the pairs were
% supplied was arbitrary.

npv = length(pv_pairs);
n = npv/2;

if n~=floor(n)
  error 'Property/value pairs must come in PAIRS.'
end
if n<=0
  % just return the defaults
  return
end

if ~isstruct(params)
  error 'No structure for defaults was supplied'
end

% there was at least one pv pair. process any supplied
propnames = fieldnames(params);
lpropnames = lower(propnames);
for i=1:n
  p_i = lower(pv_pairs{2*i-1});
  v_i = pv_pairs{2*i};
  
  ind = strmatch(p_i,lpropnames,'exact');
  if isempty(ind)
    ind = find(strncmp(p_i,lpropnames,length(p_i)));
    if isempty(ind)
      error(['No matching property found for: ',pv_pairs{2*i-1}])
    elseif length(ind)>1
      error(['Ambiguous property name: ',pv_pairs{2*i-1}])
    end
  end
  p_i = propnames{ind};
  
  % override the corresponding default in params
  params = setfield(params,p_i,v_i); %#ok
  
end

end % parse_pv_pairs






