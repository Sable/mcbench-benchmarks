function [xfinal,ffinal,exitflag,xstart] = rmsearch(fun,optname,x0,LB,UB,varargin)
% RMSEARCH: Randomly multistarted overlay to several optimizers
% usage: [xfinal,ffinal,exitflag,xstart] = RMSEARCH(fun,optname,x0,LB,UB)
% usage: [xfinal,ffinal,exitflag,xstart] = RMSEARCH(fun,optname,x0,LB,UB,prop1,val1,prop2,val2,...)
% 
% This tool is useful when little information is available
% for good starting values for an optimization, or when many
% local solutions exist. It is also useful to map out the various
% basins of attaction of each local solution.
%
% RMSEARCH is normally used for bounded optimization problems,
% but with care can be used when some variables are unbounded.
% Whenever possible I'd still recommend the use of both lower
% and upper bounds if you can possibly do so. Restriction of
% the solution space is an important way to improve the
% performance of any optimization.
%
%
% arguments: (Input)
%  fun - name of a function, inline function, or a function handle
%
%  optname - character string - the name of the
%        optimizer to be used. Valid options are
%
%        'fminsearchbnd', 'fminsearchcon', 'fmincon'
%        'fminbnd', 'fzero', 'lsqnonlin', 'fminsearch'
%        
%        No default is allowed, but the function name may
%        be shortened as long as the shortening is unambiguous.
%        Thus 'fminb' or 'fz' are acceptable, but 'fm' is not.
%
%        Note that fzero and fminbnd, since they work in 1-d
%        will search EVERY bracketed interval they find that
%        contains either a root or a minimizer (as appropriate.)
%
%        Remember to set the options structure properly for
%        fmincon, turning off the largescale optimizer as
%        appropriate. Otherwise you will see many warning
%        messages generated, one for each call to the optimizer.
%
%  x0 -  starting value. Used to determine the dimension and
%        shape of the parameter vector. Also used to determine
%        the distribution of the random starts when the bounds
%        are incompletely specified.
% 
%        No default is allowed. 
%
%        If both lower and upper bounds are supplied for a
%        parameter, then the distribution for the multi-starts
%        is chosen to be uniform between those bounds. If no
%        upper bound or no lower bound, then the distribution
%        follows a two parameter exponential distribution, with
%        mean at x0(i). If both upper and lower bounds are
%        missing (i.e., they are +/- inf), then that parameter 
%        will be normally distribued with mean at x0(i).
%
%  LB -  Lower bounds for the parameters, as used by fmincon,
%        fminsearchbnd, lsqnonlin, etc.
%
%        LB must be the same size as x0, and LB(i)<=UB(i)
%
%        When no lower bound exists for a variable, use -inf
%
%  UB -  Upper bounds for the parameters, as used by fmincon,
%        fminsearchbnd, lsqnonlin, etc.
%
%        UB must be the same size as x0, and LB(i)<=UB(i)
%
%        When no upper bound exists for a variable, use +inf
%
%
% Additional inputs must be in the form of property/value pairs.
%   Properties are character strings. They may be shortened
%   to the extent that they are unambiguous. Properties are
%   not case sensitive. Valid property names are:
% 
%    'Plot', 'Nonlcon', 'FractionUsed', 'InitialSample',
%    'OverSample', 'A', 'B' 'Options'
%   
%   All properties have default values, chosen as intelligently
%   as I could manage. Values that are character strings may
%   also be unambiguously shortened. The legal values for each
%   property are:
%   
%   'Plot' - specifies if a plot is generated {'on', 'off'}
%         A plot can only be generated for 1 or 2 dimensional
%         problems. A warning is generated for more than 2
%         variables if plot is turned on.
%
%         DEFAULT: 'off'
% 
%   'Nonlcon' - Nonlinear constraint function or function handle
%         Only used for 'fmincon' or 'fminsearchcon'. Other
%         optimizers will cause an error if this is provided.
%
%         DEFAULT: ''
%
%   'FractionUsed' - Fractional amount of the total sample that
%         are used as multiple starts for the optimizer. It must
%         lie in the half open interval (0,1].
%
%         DEFAULT: 1  (100% of the samples are used as starting
%         points.
%
%         Note: FractionUsed is ignored for fminbnd and fzero.
%
%   'InitialSample' - Size of the total initial random sample
%         generated.
%
%         DEFAULT: 100  (100 points are generated)
%
%   'OverSample' - Over-sampling ratio. If linear inequality or
%         or nonlinear inequality constraints are involved, a
%         simple sampling strategy within the bounds may fail
%         to produce as many feasible points as are requested.
%
%         Thus if 100 points are requested in the initial sample,
%         a 20 to 1 oversampling ratio will generate a total of
%         2000 initial samples that are all within the simple bound
%         constraints. All of these points are compared to the
%         inequality constraints, rejecting all of those that fail.
%         The first InitialSample set of points are retained, only
%         these points are considered as starting points for an
%         optimization.
%
%         DEFAULT: 20  (a 20 to 1 over-sampling ratio)
%
%   'A', 'B' - Linear Inequality constraint matrix (A) and right
%         hand side vector (B), used only for 'fmincon' or
%         'fminsearchcon'. Other optimizers will cause an error
%         if these are provided.
%
%   'Options' - options structure for the specified optimizer.
%
%        default: optimset('optname')
%
%        For fminsearchbnd or fminsearchcon, the default is
%        optimset('fminsearch') 
%
% arguments: (Output)
%  xfinal - final solutions found for each xstart point. Each
%         row of xfinal is one solution.
%
%  ffinal - objective function at xfinal.
%
%         For lsqnonlin or lsqcurvefit, ffinal is the sum
%         of squares.
%  
%  exitflag - exitflags for each "solution" found
%
%  xstart - starting value used for each point in xfinal
%
%
% Example usage:
%  Find all zeros of besselj(2,x) betweeen x=0 and x=50. Note
%  that x0 is actually ignored in this case. Generate a plot of
%  the sample points and the solutions found.
%
%  fun = @(x) besselj(2,x);
%  [xfinal,ffinal,exitflag,xstart] = rmsearch(fun,'fzero',...
%       10,0,50,'initialsample',500,'plot','on')
%
% Example usage:
%  Find local minimizers of besselj(2,x) betweeen x=0 and x=200
%  Generate a plot of the sample points and the solutions found.
%
%  fun = @(x) besselj(2,x);
%  [xfinal,ffinal,exitflag,xstart] = rmsearch(fun,'fminbnd',...
%       10,0,200,'initialsample',500,'plot','on')
%
% Example usage:
%  Find local minimizers of the peaks function. Generate
%  a plot of the sample points and the solutions found. Use
%  fminsearchbnd as the optimizer.
%
%  fun = inline('peaks(x(1),x(2))','x');
%  [xfinal,ffinal,exitflag,xstart] = rmsearch(fun,'fminsearchbnd',...
%      [0 0],[-5 -5],[5 5],'initialsample',100,'plot','on')
%
% Example usage:
%  Find the local minimizers of the peaks function within a circle
%  of radius 2 around the origin. Generate a plot of the sample points
%  and the solutions found. Use fmincon as the optimizer, setting the
%  appropriate options for its use. Note the trick with deal for nonlcon
%  inside an anonymous function.
%
%  fun = inline('peaks(x(1),x(2))','x');
%  opts = optimset('fmincon');
%  opts.LargeScale = 'off';
%  opts.Display = 'none';
%  nonlcon = @(x) deal(norm(x) - 2,[]);
%  [xfinal,ffinal,exitflag,xstart] = rmsearch(fun, ...
%     'fmincon',[0 0],[-2 -2],[2 2],'initialsample',100, ...
%     'plot','on','options',opts,'nonlcon',nonlcon)
%
%
% See also: fminsearchbnd, fmincon, fminsearchcon, fzero, fminbnd, lsqnonlin
%
%
% Author: John D'Errico
% E-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 1/1/07

% set defaults
par.Plot = 'off';
par.Nonlcon = '';
par.FractionUsed = 1;
par.InitialSample = 100;
par.OverSample = 20;
par.A = [];
par.B = [];
par.OptName = optname;
par.Options = [];

na = length(varargin);
if (rem(na,2)==1)
  error 'Property/value pairs must come as PAIRS of arguments.'
elseif na>0
  par = parse_pv_pairs(par,varargin);
end

% shape of x0, dimension of the problem
if (nargin<3) || isempty(x0)
  error 'x0 must be provided.'
else
  par.Nx0 = size(x0);
  x0 = x0(:);
  par.Dim = prod(par.Nx0);
end

% checks for validity of parameters, any problems
par = check_params(par);

% Was fun a string, or an inline/anonymous function?
if (nargin<1)
  help rmsearch
  return
elseif isempty(fun)
  error 'fun was not supplied.'
elseif ischar(fun)
  % a character function name
  fun = str2func(fun);
end

% Check the bounds
if (nargin<4) || isempty(LB)
  LB = repmat(-inf,par.Dim,1);
else
  LB = LB(:);
end
if (nargin<5) || isempty(UB)
  UB = repmat(inf,par.Dim,1);
else
  UB = UB(:);
end
% are they the same size as X0?
if length(LB)~=par.Dim
  error 'Lower bound array was inconsistent in size with x0'
end
if length(UB)~=par.Dim
  error 'Upper bound array was inconsistent in size with x0'
end

% Were there any unusable inequalities provided?
if ~ismember(par.OptName,{'fmincon','fminsearchcon'})
  if par.UseLC
    error(['Linear inequalities provided are not usable by ',par,OptName])
  elseif par.UseNLC
    error(['Nonlinear inequalities provided are not usable by ',par,OptName])
  end
end

% are any of the bounds inconsistent?
if any(LB>UB)
  error 'It is required that: LB <= UB'
end

% Choose the distributions used to sample
% from for each variable.
LBinf=isinf(LB);
UBinf=isinf(UB);
for i = 1:par.Dim
  if LBinf(i) && UBinf(i)
    % both are unbounded, use a normal
    vardist(i).dist = 'normal';
    vardist(i).mean = x0(i);
    vardist(i).sd = 1;
  elseif ~LBinf(i) && UBinf(i)
    % only lower bound, use an exponential
    vardist(i).dist = 'lower';
    vardist(i).lambda = x0(i) - LB(i);
    if vardist(i).lambda<=0
      vardist(i).lambda = 0.5;
    else
      vardist(i).lambda = 0.5 ./(vardist(i).lambda);
    end
    vardist(i).shift = LB(i);
  elseif LBinf(i) && ~UBinf(i)
    % only upper bound, use an exponential
    vardist(i).dist = 'upper';
    vardist(i).lambda = UB(i) - x0(i);
    if vardist(i).lambda <= 0
      vardist(i).lambda = 0.5;
    else
      vardist(i).lambda = 0.5 ./(vardist(i).lambda);
    end
    vardist(i).shift = UB(i);
  else
    % dual bounds, use a uniform
    vardist(i).dist = 'uniform';
    vardist(i).a = LB(i);
    vardist(i).b = UB(i);
  end
end

% Generate the intial random samples. Choose enough
% of them in case there are constraints to worry about.
if par.UseLC || par.UseNLC
  % oversampling for rejection
  xinitial = rand(par.OverSample*par.InitialSample,par.Dim);
else
  % No need to oversample
  xinitial = rand(par.InitialSample,par.Dim);
end

% generate a sample with the specified distributions
for i = 1:par.Dim
  switch vardist(i).dist
    case 'uniform'
      % uniform between two bounds
      xinitial(:,i) = vardist(i).a + ...
        (vardist(i).b - vardist(i).a)*xinitial(:,i);
    case 'normal'
      % unbounded - use a normal
      xinitial(:,i) = vardist(i).mean + ...
        vardist(i).sd*randn(par.InitialSample,1);
    case 'lower'
      % lower bound, use an exponential
      xinitial(:,i) = vardist(i).shift - ...
        log(xinitial(:,i))/vardist(i).lambda;
    case 'upper'
      % upper bound, use an exponential
      xinitial(:,i) = vardist(i).shift + ...
        log(xinitial(:,i))/vardist(i).lambda;
  end
end

% if 1-d problem, fminbnd and fzero will both do best
% if any bounds are included in the sample
if (par.Dim == 1)
  if ~isinf(LB) && ~isinf(UB)
    xinitial = [LB;UB;xinitial];
  elseif  (~isinf(LB) && isinf(UB))
    xinitial = [LB;xinitial];
  elseif (isinf(LB) && ~isinf(UB))
    xinitial = [UB;xinitial];
  end
end

% Do we need to reject any samples?
if par.UseLC
  k = ((repmat(par.B,1,size(xinitial,1)) - par.A*xinitial') < 0);
  k = any(k,1);
  xinitial(k,:) = [];
end
if size(xinitial,1)<1
  error 'Linear inequalities too strict. No feasible points were identified.'
end
if par.UseNLC
  % test any nonlinear constraints
  nx = size(xinitial,1);
  k = true(nx,1);
  for i = 1:nx
    [cineq,ceq] = par.Nonlcon(xinitial(i,:)); %#ok
    k(i) = all(cineq>0);
  end
  % reject those that failed
  xinitial(k,:) = [];
end
if size(xinitial,1)<1
  error 'Nonlinear constraints too strict. No feasible points were identified.'
end

% Some points got through, but not as many as requested
xsize = size(xinitial,1);
if xsize < par.InitialSample
  warning('RMSEARCH:FeasiblePoints',['Only ',num2str(xsize),' feasible points were found, ', ...
    num2str(par.InitialSample),' were requested. Insufficiently Oversampled.'])
end
% keep as many samples as we need if oversampled
xinitial = xinitial(1:min(xsize,par.InitialSample),:);
xsize = size(xinitial,1);

% Evaluate each sample through our objective function.
finitial = zeros(xsize,1);
for i = 1:xsize
  if ~strcmp(par.OptName,'lsqnonlin')
    % A simple optimizer:
    % 'fminbnd', 'fzero', 'fmincon', 'fminsearchbnd', 
    % 'fminsearchcon','fminsearch'
    finitial(i) = fun(reshape(xinitial(i,:),par.Nx0));
  else
    % lsqnonlin, so we need to form the sum of squares
    f = fun(reshape(xinitial(i,:),par.Nx0));
    finitial(i) = sum(f.^2);
  end
end

% At which of these sample points will we
% start the indicated optimizer? Was it a 1-d
% problem? If so, then both fzero and fminbnd
% use a bracketed interval.
xfinal = zeros(size(xinitial));
ffinal = zeros(size(finitial));
if (par.Dim==1) && ismember(par.OptName,{'fzero', 'fminbnd'})
  switch par.OptName
    case 'fzero'
      % fzero - sort on x first
      [xinitial,tags] = sort(xinitial);
      finitial = finitial(tags);

      % find zero crossings in f
      ind = 1:(xsize-1);
      k = find((sign(finitial(ind)) .* sign(finitial(ind+1))) <= 0);

      % any crossings found?
      if isempty(k)
        error 'No zero crossings found in this sample for fzero'
      end

      xfinal = zeros(length(k),1);
      ffinal = xfinal;
      exitflag = xfinal;
      xstart = xfinal;
      fstart = xfinal;
      % loop over the candidate intervals
      for i = 1:length(k)
        [xfinal(i),ffinal(i),exitflag(i)] = fzero(fun, ...
          [xinitial(k(i)),xinitial(k(i)+1)],par.Options);

        % store the better of the two points in each bracket
        if abs(finitial(k(i))) <= abs(finitial(k(i)+1))
          xstart(i) = xinitial(k(i));
          fstart(i) = finitial(k(i));
        else
          xstart(i) = xinitial(k(i)+1);
          fstart(i) = finitial(k(i)+1);
        end
      end

    case 'fminbnd'
      % fminbnd - sort on x first
      [xinitial,tags] = sort(xinitial);
      finitial = finitial(tags);

      % find local minima in f
      ind = 2:(xsize-1);
      k = 1 + find((finitial(ind) <= finitial(ind-1)) & ...
        (finitial(ind) <= finitial(ind+1)));

      % do we look in the first interval?
      if finitial(1) < finitial(2)
        k = union(2,k);
      end
      % or the last one?
      if finitial(end) < finitial(end-1)
        k = union(xsize-1,k);
      end

      % any local minima found?
      xfinal = zeros(length(k),1);
      ffinal = xfinal;
      exitflag = xfinal;
      xstart = xfinal;
      fstart = xfinal;
      % loop over the candidate intervals
      for i = 1:length(k)
        [xfinal(i),ffinal(i),exitflag(i)] = fminbnd(fun, ...
          xinitial(k(i)-1),xinitial(k(i)+1),par.Options);

        % store in xstart
        xstart(i) = xinitial(k(i));
        fstart(i) = finitial(k(i));
      end
  end
else
  % it must be a multivariable minimization, or only one
  % variable, but not with a bracketed optimizer.
  
  % sort on f first in increasing order
  [finitial,tags] = sort(finitial);
  xinitial = xinitial(tags,:);
  
  if isempty(par.FractionUsed) || (par.FractionUsed==1)
    % use all the points as starting values
    nk = xsize;
  else
    nk = min(xsize,ceil(xsize*par.FractionUsed));
  end
  
  % any local minima found?
  xfinal = zeros(nk,par.Dim);
  ffinal = zeros(nk,1);
  exitflag = ffinal;
  xstart = xfinal;
  fstart = ffinal;
  % loop over the candidates chosen
  for i = 1:nk
    % store the start points in xstart and
    % fstart for plotting later
    xstart(i,:) = xinitial(i,:);
    fstart(i) = finitial(i);
    
    % but which optimizer?
    switch par.OptName
      case 'lsqnonlin'
        [xfinal(i,:),ffinal(i),residual,exitflag(i)] = ...
          lsqnonlin(fun,xinitial(i,:),LB,UB,par.Options); %#ok
      case 'fminsearchbnd'
        [xfinal(i,:),ffinal(i),exitflag(i)] = ...
          fminsearchbnd(fun,xinitial(i,:),LB,UB,par.Options);
      case 'fminsearchcon'
        [xfinal(i,:),ffinal(i),exitflag(i)] = ...
          fminsearchcon(fun,xinitial(i,:),LB,UB, ...
          par.A,par.B,par.Nonlcon,par.Options);
      case 'fminsearch'
        [xfinal(i,:),ffinal(i),exitflag(i)] = ...
          fminsearch(fun,xinitial(i,:),par.Options);
      case 'fmincon'
        [xfinal(i,:),ffinal(i),exitflag(i)] = ...
          fmincon(fun,xinitial(i,:),par.A,par.B, ...
          [],[],LB,UB,par.Nonlcon,par.Options);
    end
  end
end

% do we plot the results?
if strcmp(par.Plot,'on') && par.Dim <= 2
  switch par.Dim
    case 1
      % its a 1-d problem
      figure
      plot([xstart';xfinal'],[fstart';ffinal'],'g-')
      hold on
      plot(xfinal,ffinal,'ro')
      plot(xinitial,finitial,'b+')
      plot([xinitial(1),xinitial(end)],[0 0],'k:')
      hold off
      xlabel 'x'
      ylabel 'fun(x)'
      title(['Random multi-started search: ',par.OptName])
      
    case 2
      % a 2-d problem
      figure
      C = finitial-min(finitial);
      C = C/max(C);
      colormap hsv
      scatter3(xinitial(:,1),xinitial(:,2),finitial,50,C,'+')
      hold on
      plot3([xstart(:,1)';xfinal(:,1)'], ...
        [xstart(:,2)';xfinal(:,2)'],[fstart';ffinal'],'g-')
      plot3(xfinal(:,1),xfinal(:,2),ffinal,'ro')
      hold off
      xlabel 'x'
      ylabel 'y'
      zlabel 'fun([x,y])'
      title(['Random multi-started search: ',par.OptName])
      
  end
end

% ============================================
%     end of mainline rmsearch
% ============================================

% ============================================
% subfunction - check_params
% ============================================
function par = check_params(par)
% check the parameters for acceptability
%
% Defaults
% par.Plot = 'off'
% par.Nonlcon = '';
% par.FractionUsed = 1;
% par.InitialSample = 100;
% par.OptName = optname;

% Nonlcon == '' by default
if ~isempty(par.Nonlcon)
  if ischar(par.Nonlcon)
    par.Nonlcon = str2func(par.Nonlcon);
  end
  par.UseNLC = true;
else
  par.UseNLC = false;
end

% FractionUsed == 1 by default
if isempty(par.FractionUsed)
  par.FractionUsed = 1;
elseif (length(par.FractionUsed)>1) || (par.FractionUsed<=0) || (par.FractionUsed>1)
  error 'FractionUsed must be scalar, in the interval (0,1]'
end

% InitialSample == 100 by default
if isempty(par.InitialSample)
  par.InitialSample = 100;
elseif (length(par.InitialSample)>1) || (par.InitialSample<=0)
  error 'InitialSample must be positive and scalar'
else
  par.InitialSample = ceil(par.InitialSample);
end

% OverSample == 20 by default
if isempty(par.OverSample)
  par.OverSample = 20;
elseif (length(par.OverSample)>1) || (par.OverSample<1)
  error 'OverSample must be positive and scalar, >= 1'
end

% OptName is char
valid = {'fmincon', 'fminsearchcon', 'fminsearchbnd', ...
  'fminbnd', 'fzero', 'lsqnonlin', 'fminsearch'};
if isempty(par.OptName) || ~ischar(par.OptName)
  error 'Invalid OptName: Must be non-empty character'
end
ind = strmatch(par.OptName,valid,'exact');
if (length(ind)==1)
  par.OptName = valid{ind};
else
  ind = strmatch(par.OptName,valid);
  if isempty(ind) || (length(ind)>1)
    error(['Invalid OptName: ',par.OptName])
  else
    par.OptName = valid{ind};
  end
end
% 2+ dimensions for a 1-d optimizer?
if (par.Dim>1) && ismember(par.OptName,{'fminbnd', 'fzero'})
  error '1-d optimizer specified, but more than 1 variable to optimize'
end

% Options is a struct
if isempty(par.Options)
  switch par.OptName
    case 'fmincon'
      par.options = optimset('fmincon');
    case 'fzero'
      par.options = optimset('fzero');
    case 'fminbnd'
      par.options = optimset('fminbnd');
    case 'lsqnonlin'
      par.options = optimset('lsqnonlin');
    case {'fminsearch', 'fminsearchbnd', 'fminsearchcon'}
      par.options = optimset('fminbnd');
  end
elseif ~isstruct(par.Options)
  error 'If provided, Options must be a struct generated by optimset'
end

% Plot is char
valid = {'on', 'off'};
if isempty(par.Plot)
  error 'Invalid Plot: Must be character or empty'
end
ind = find(strncmpi(par.Plot,valid,length(par.Plot)));
if (length(ind)==1)
  par.Plot = valid{ind};
else
  error(['Invalid Plot: ',par.Plot])
end
if strcmp(par.Plot,'on') && (par.Dim>3)
  % No plots available for 4 or more variables
  Warning 'Sorry, plots are not generated for 4 or more variables.'
  par.Plot = 'off';
end

% A & B are both empty by default
if ~isempty(par.A) && (size(par.A,2)~=par.Dim)
  error 'A must have the same number of columns as the # of variables'
end
if ~isempty(par.B) && (size(par.A,1)~=size(par.B,1))
  error 'B must have the same number of rows as A'
end
if isempty(par.A)
  par.UseLC = false;
else
  par.UseLC = true;
end




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

% end % parse_pv_pairs








