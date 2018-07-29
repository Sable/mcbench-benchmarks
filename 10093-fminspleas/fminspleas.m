function [INLP,ILP] = fminspleas(funlist,NLPstart,xdata,ydata,INLB,INUB,weights,options)
% pleas: partitioned nonlinear least squares estimation, using fminsearch
% usage: [INLP,ILP] = FMINSPLEAS(funlist,NLPstart,xdata,ydata)
% usage: [INLP,ILP] = FMINSPLEAS(funlist,NLPstart,xdata,ydata,INLB,INUB)
% usage: [INLP,ILP] = FMINSPLEAS(funlist,NLPstart,xdata,ydata,INLB,INUB,weights)
% usage: [INLP,ILP] = FMINSPLEAS(funlist,NLPstart,xdata,ydata,INLB,INUB,weights,options)
%
% FMINSPLEAS will be far more robust (and faster) in solving nonlinear
% least squares than the basic FMINSEARCH because of its partitioned
% least squares estimation procedure. (As described in my optimization
% tips and tricks document.) In fact, FMINSPLEAS may be faster and more
% robust than some other optimizers that do not use a partitioned least
% squares scheme. Finally, FMINSPLEAS is the only nonlinear regression
% tool that explicitly allows the user to provide weights in the
% regression.
%
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=8553&objectType=FILE
%
% arguments: (input)
%  funlist - cell array of functions comprising the nonlinear parts
%            of each term in the model. Each independent function in
%            this list must transform xdata using a vector of intrinsicly
%            nonlinear parameters into an array of the same size and
%            shape as ydata. (Constants will be expanded in size.) The
%            arguments to each function will be in the order (INLP,xdata).
%
%            These functions may be
%             - scalar (double) constants (E.g., 1)
%             - anonymous functions
%             - inline functions
%             - character function names
%
%            FMINSPLEAS assumes a model of the form:
%
%            ydata = a1*f1(INLP,xdata) + a2*f2(INLP,xdata) + ...
%
%            funlist is the list of functions {f1,f2,...}. The
%            intrinsically linear parameters [a1,a2,...] are estimated
%            using an internal linear regression.
%
%            Any additional parameters to these functions should be
%            passed anonymously.
%
%  NLPstart - vector of starting values for the intrinsicly nonlinear
%            parameters only.
%
%  xdata   - array of independent variables
%            
%  ydata   - array of dependent variable data
%
%  INLB    - (OPTIONAL) array of lower bounds of the NONLINEAR
%            variables. Must be the same size as NLPstart.
%
%            If no lower bounds are supplied, then INLB should
%            be left empty. If only some variables have lower
%            bounds, then use -inf as the lower bounds for the
%            unconstrained variables.
%
%  INUB    - (OPTIONAL) array of upper bounds of the NONLINEAR
%            variables. Must be the same size as NLPstart.
%
%            If no upper bounds are supplied, then INUB should
%            be left empty. If only some variables have upper
%            bounds, then use inf as the upper bounds for the
%            unconstrained variables.
%
%  weights - (OPTIONAL) array of non-negative weights, of the same
%            size as ydata. If provided, these weights will be used
%            to scale the squared residual errors in the estimation.
%
%            To be specific, a weight of 2 is equivalent to a
%            replication of the corresponding data point so there
%            would have been 2 samples at that value.
%
%            Only the relative weights are important.
%
%            A weight of zero is equivalent to dropping that data
%            point from the estimation. Negative weights will
%            cause an error.
%
%  options - (OPTIONAL) options structure appropriate for fminsearch
%
% arguments (output)
%  INLP - optimized list of intrinsicly nonlinear parameters
%
%  ILP  - optimized list of intrinsicly linear parameters 
%
%
% Example 1:
%  Fit a simple exponential model plus a constant term to data.
%  Note that fminspleas deals with the linear parameters, the
%  user needs only worry about the nonlinear parameters.
%
%   x = rand(100,1);
%   y = 4 - 3*exp(2*x) + randn(size(x));
%
%   funlist = {1, @(coef,xdata) exp(xdata*coef)};
%   % If you have an older release of matlab, use this form:
%   % funlist = {1, inline('exp(xdata*coef)','coef','xdata')};
%
%   NLPstart = 1;
%   options = optimset('disp','iter');
%   [INLP,ILP] = fminspleas(funlist,NLPstart,x,y,[],[],[],options)
%
% Output:
%  Iteration   Func-count     min f(x)         Procedure
%      0            1           101.57         
%      1            2           98.314         initial simplex
%      2            4          92.4016         expand
%      3            6           82.945         expand
%      4            8           73.175         expand
%      5           10          72.6363         contract outside
%      6           12          72.5564         contract inside
%      7           14          72.5101         contract inside
%      ...
%  
% Optimization terminated:
%  the current x satisfies the termination criteria using OPTIONS.TolX of 1.000000e-04 
%  and F(X) satisfies the convergence criteria using OPTIONS.TolFun of 1.000000e-04 
% 
% INLP =
%        1.8884
% 
% ILP =
%        4.3268
%       -3.3207
%
% Similar accuracy with fminsearch directly operating on all three
% parameters at once took roughly 300 function evaluations.
%
% Example 2:
%  Fit a sum of several sine terms to data. Beware of terms
%  with a similar form - you must use distinct starting
%  values for the nonlinear parameters.
%
%   x = rand(500,1);
%   y = 4 - 3*sin(2*x) + 2*cos(3*x) + randn(size(x))/10;
%
%   funlist = {1, @(c,xdata) sin(c(1)*xdata), @(c,xdata) cos(c(2)*xdata)};
%   [INLP,ILP] = fminspleas(funlist,[3 4],x,y)
%
% INLP =
%          1.91830441497209          3.04626358883634
%
% ILP =
%          4.16097130716892
%         -3.21354044158414
%          1.86372562015106
%
% See also: fminsearch, fminsearchbnd, pleas, lsqcurvefit
%  Note: pleas is found as an adjunct to my optimtips document.
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 2.1
% Release date: 5/23/06

% Check the functions
if ~iscell(funlist)
  error 'funlist must be a cell array of functions, even if only one fun'
end
nfun=length(funlist);
for i = 1:nfun
  fi = funlist{i};
  
  % There are two cases where we need to turn the supplied
  % function into an executable function
  if isa(fi,'double')
    % a constant
    funlist{i} = @(coef,xdata) repmat(fi,size(ydata));
  elseif ischar(fi)
    % a character function name
    funlist{i} = str2func(fi);
  end
end

% were any options supplied?
if (nargin<8) || isempty(options)
  options = optimset('fminsearch');
end

if (nargin<7)
  weights = [];
end

nnlin = size(NLPstart);
% any bound constraints?
if (nargin<5) || isempty(INLB)
  INLB = repmat(-inf,nnlin);
elseif any(nnlin~=size(INLB))
  error 'INLB (if provided) must be the same size as NLPstart'
end
if (nargin<6) || isempty(INUB)
  INUB = repmat(inf,nnlin);
elseif any(nnlin~=size(INUB))
  error 'INUB (if provided) must be the same size as NLPstart'
end
% check for inverted bounds
if any(INLB(:) > INUB(:))
  error 'Some lower/upper bounds were inconsistent with each other'
end

% what transformations will be used for the nonlinear parameters?
INLPclass = zeros(nnlin);
%  0 --> no bounds
%  1 --> only a lower bound
%  2 --> only an upper bound
%  3 --> both lower and upperbounds
%  4 --> Fixed variable
for i = 1:numel(INLPclass);
  if ~isinf(INLB(i))
    INLPclass(i) = INLPclass(i) + 1;
  end
  if ~isinf(INUB(i))
    INLPclass(i) = INLPclass(i) + 2;
  end
  if INLB(i) == INUB(i)
    INLPclass(i) = 4;
  end
end
params.INLB = INLB;
params.INUB = INUB;
params.INLPclass = INLPclass;

% Transform starting values into the unconstrained domain
tNLPstart = xtransform(NLPstart,params,1);

% make sure that ydata is a column vector
ydata = ydata(:);
ny = length(ydata);

% check that weights is the proper size (same as ydata)
if ~isempty(weights)
  weights = weights(:);
  if length(weights)~=ny
    error 'If provided, weights must be the same size as ydata'
  end
  
  if any(weights<0)
    error 'If provided, weights must be non-negative'
  elseif all(weights==0)
    error 'If provided, at least some weights must be non-zero'
  end
  
  % sqrt so that we can scale the residuals by the weights
  % this makes the linear regression simple.
  weights = sqrt(weights);
end

% ================================================
% =========== begin nested function ==============
% ================================================
function [obj,ILP] = fminspleas_obj(tINLP)
  % nested objective function for lsqnonlin, so all
  % the data and funs from pleas are visible to pleas_obj
  
  % Untransform the parameters into the constrained range space.
  INLP = xtransform(tINLP,params,0);
  
  % loop over funlist
  A = zeros(ny,nfun);
  for ii=1:nfun
    fi = funlist{ii};
    term = fi(INLP,xdata);
    A(:,ii) = term(:);
  end
  
  % do the linear regression using \
  if isempty(weights)
    % unweighted regression
    ILP = A\ydata;
    
    % residuals
    res = A*ILP - ydata;
  else
    % use weights in the regression
    ILP = (repmat(weights,1,nfun).*A)\(ydata.*weights);
    
    % weighted residuals
    res = (A*ILP - ydata).*weights;
  end
  
  % sum of squares objective for fminsearch. Weights are
  % built in already here.
  obj = sum(res.^2);
  
end % nested function termination
% ================================================
% ============= end nested function ==============
% ================================================

% call fminsearch, using a nested function handle
tINLP = fminsearch(@fminspleas_obj,tNLPstart,options);

% call one final time to get the final linear parameters
[junk,ILP] = fminspleas_obj(tINLP);

% undo the variable transformations into the original space
INLP = xtransform(tINLP,params,0);


end % main function terminator


% ================================================
% ============== begin subfunctions ==============
% ================================================
function xtrans = xtransform(x,params,transdirection)
% transdirection == 0 --> unconstrained domain into constrained set
% transdirection == 1 --> constrained range into constrained domain

if transdirection == 0
  % transform from unconstrained problem into the user's
  % parameter space
  xtrans = zeros(size(params.INLPclass));
  k = 1;
  for i = 1:numel(xtrans)
    switch params.INLPclass(i)
      case 1
        % lower bound only
        xtrans(i) = params.INLB(i) + x(k).^2;
        k = k + 1;
      case 2
        % upper bound only
        xtrans(i) = params.INUB(i) - x(k).^2;
        k = k + 1;
      case 3
        % lower and upper bounds
        temp = (sin(x(k))+1)/2;
        xtrans(i) = temp*(params.INUB(i) - params.INLB(i)) + params.INLB(i);
        k = k + 1;
      case 4
        % fixed variable, bounds are equal, set it at either bound
        xtrans(i) = params.INLB(i);
      case 0
        % unconstrained variable.
        xtrans(i) = x(k);
        k = k + 1;
    end
    
    % ensure that floating point irregularities
    % do not exceed the bounds
    xtrans(i) = min(params.INUB(i),max(params.INLB(i),xtrans(i)));
    
  end

else
  % send values into their unconstrained surrogates.
  % Check for infeasible starting guesses.
  xtrans = zeros(1,sum(params.INLPclass(:)~=4));
  k = 1;
  for i = 1:length(params.INLPclass)
    switch params.INLPclass(i)
      case 1
        % lower bound only
        if x(k)<=params.INLB(i)
          % infeasible starting value. Use bound.
          xtrans(k) = 0;
        else
          xtrans(k) = sqrt(x(i) - params.INLB(i));
        end
        k = k + 1;
      case 2
        % upper bound only
        if x(i)>=params.INUB(i)
          % infeasible starting value. use bound.
          xtrans(k) = 0;
        else
          xtrans(k) = sqrt(params.INUB(i) - x(i));
        end
        k = k + 1;
      case 3
        % lower and upper bounds
        if x(i)<=params.INLB(i)
          % infeasible starting value
          xtrans(k) = -pi/2;
        elseif x(i)>=params.INUB(i)
          % infeasible starting value
          xtrans(k) = pi/2;
        else
          xtrans(k) = 2*(x(i) - params.INLB(i))/(params.INUB(i)-params.INLB(i)) - 1;
          xtrans(k) = asin(max(-1,min(1,xtrans(k))));
        end
        k = k + 1;
      case 4
        % Fixed. Drop this variable so the optimizer will not see it.
      case 0
        % unconstrained variable. xtrans(i) is set.
        xtrans(k) = x(i);
        k = k + 1;
    end
  end
  
end

end % subfunction terminator
% ================================================
% ================ end subfunctions ==============
% ================================================




