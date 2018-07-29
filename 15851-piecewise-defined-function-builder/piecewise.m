function funhan = piecewise(varargin)
%PIECEWISE Piecewise-defined functions.
%
%  F = PIECEWISE(COND1,DEFN1,...CONDn,DEFNn,DEFAULT) returns a callable
%  function F that applies different definitions according to supplied
%  conditions. For a given X, F(X) will test COND1 and apply DEFN1 if true,
%  etc. If all conditions fail, then DEFAULT is applied. For any particular
%  input, the first condition to match is the only one applied.
%
%  Each condition should be either a:
%    * function handle evaluating to logical values, or
%    * vector [a b] representing membership in the half-open interval [a,b).
%  Each definition should be either a:
%    * function handle, or
%    * scalar value.
%  The DEFAULT definition is optional; if omitted, it will be set to NaN.
%    
%  All function definitions can accept multiple input variables, but they
%  all must accept the same number as in the call to F. They also should
%  all be vectorized, returning results the same size and shape as their
%  inputs. Complex inputs will work if the definitions are set up
%  accordingly; in that case, intervals will be tested using only Re parts.
%
%  The special syntax F() displays all the conditions and definitions for F.
%
%  Examples:
%     f = piecewise([-1 1],@(x) 1+cos(pi*x),0);   % a "cosine bell" 
%     ezplot(f,[-2 2])
%     g = piecewise(@(x) sin(x)<0.5,@sin,@(x) 1-sin(x));
%     ezplot(g,[-2*pi 2*pi])
%     h = piecewise(@(x,y) (x<0)|(y<0),@(x,y) sin(x-y));  % defined on L
%     ezsurf(h,[-1 1])
%     chi = piecewise(@(x,y,z) x.^2+y.^2+z.^2<1,1,0); % characteristic func
%     [ triplequad(chi,-1,1,-1,1,-1,1), 4/3*pi ]
%         ans =
%                4.1888    4.1888
%
%  See also FUNCTION_HANDLE.

% Copyright (c) 2007 by Toby Driscoll.
% Version 1, 6 Aug 2007.



% If an even number of inputs was given, no default value exists.
if rem(nargin,2)==0
  default = NaN;
else 
  default = varargin{end};
end

% Number of condition/definition pairs.
numdefs = floor(nargin/2);
condn = varargin(1:2:2*numdefs);
defn = varargin(2:2:2*numdefs);

funhan = @piecewisefun;   % this is the return value

  % This is the defintion of the returned function.
  function f = piecewisefun(varargin)
  % Special syntax to display the function.
  if nargin==0
    fprintf('\nPiecewise function with conditions/definitions:\n')
    for k = 1:numdefs
      fprintf('  If %s : %s\n',funcornum2str(condn{k}),funcornum2str(defn{k}))
    end
    fprintf('  Otherwise : %s\n\n',funcornum2str(default))
    return
  end
  
  % Normal call
  f = zeros(size(varargin{1}));
  mask = false(size(f));
  for k = 1:numdefs
    % Determine the values satistfying condition k.
    if isa(condn{k},'function_handle')
      newpts = logical( condn{k}(varargin{:}) );
    else
      newpts = (varargin{1}>=condn{k}(1)) & (varargin{1}<condn{k}(2));
    end
    newpts = newpts & (~mask);
    % Evaluate definition k
    if isa(defn{k},'function_handle')
      % Tricky part: Extract subset of points from each variable.
      sref.type = '()';
      sref.subs = {newpts};
      extract = @(x) subsref(x,sref);
      x = cellfun(extract,varargin,'uniformoutput',false);
      f(newpts) = defn{k}(x{:});
    else
      f(newpts) = defn{k};  % scalar expansion
    end
    mask = mask | newpts;
  end
  
  % Default case
  if isa(default,'function_handle')
    sref.subs = {~mask};
    extract = @(x) subsref(x,sref);
    x = cellfun(extract,varargin,'uniformoutput',false);
    f(~mask) = default(x{:});
  else
    f(~mask) = default;  % scalar expansion
  end
    
  end
   
  % This subfunction converts a function or scalar to its native char form,
  % and a 2-vector into an interval notation.
  function s = funcornum2str(f)
    if isa(f,'function_handle')
      s = char(f);
    elseif numel(f)==1
      s = num2str(f);
    else
      s = [ 'in [' num2str(f(1)) ',' num2str(f(2))  ')' ];
    end
  end

end