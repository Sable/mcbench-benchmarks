function z = piecewise_eval(x,breakpoints,funs)
% PIECEWISE_EVAL: evaluates a piecewise function of x
% usage: y = PIECEWISE_EVAL(x,breakpoints,funs)
%
% arguments (input)
%  x    - vector or array of points to evaluate though the function
%  
%  breakpoints - list of n breakpoints, -inf and +inf are implicitly
%         the first and last breakpoints. A function with only two
%         pieces has only one explicit breakpoint. In the event that
%         you want to define a function with breakpoints [a,b,c],
%         and only two functions, but you do not care what happens
%         for x < a or x > b, then you should specify only the
%         breakpoint b. Alternatively, one could specify all 3
%         breaks, and force the function to return NaN above and
%         below those limits.
%
%         x(i) will be identified as falling in interval (j) if
%         break(j) <= x(i) < break(j+1)
%  
%  funs - cell array containing n+1 functions as scalar constants,
%         strings, anonymous functions, inline functions, or any
%         simple matlab function name.
%
%         Note: use .*, ./, .^ where appropriate in the function
%
%         These functions need not be differentiable or even
%         continuous across the breaks.
%
% arguments (output)
%  z    - evaluated function, result is same shape as x
%
% Example usage:
%  For       x < -5, y = 2
%  For -5 <= x < 0,  y = sin(x)
%  For  0 <= x < 2,  y = x.^2
%  For  2 <= x < 3,  y = 6
%  For  3 <= x,      y = inf
%
%  y = piecewise_eval(-10:10,[-5 0 2 3],{2,'sin(x)','x.^2',6,inf})

n=length(breakpoints);
% there must be n+1 funs for n breaks
if length(funs)~=(n+1)
  error 'funs and breakpoints are incompatible in size'
end

if any(diff(breakpoints)<=0)
  error 'Breakpoints must be both distinct and increasing'
end

% ensure the functions are feval-able
for i=1:(n+1)
  if ischar(funs{i})
    % A string. Make it a function
    f=inline(funs{i});
    funs{i} = f;
  elseif isa(funs{i},'function_handle') || isa(funs{i},'inline')
    % a function handle or an inline. do nothing.
  elseif isnumeric(funs{i}) | isnan(funs{i}) | isinf(funs{i})
    % A scalar value was supplied, may be NaN or inf.
    % Make it a function.
    funs{i}=@(x) funs{i};
  else
    % It must be something that feval can handle
    % directly, so leave funs{i} alone.
  end
end

% initialize as nans
z=nan(size(x));

% below the first break
k=(x<breakpoints(1));
z(k)=feval(funs{1},x(k));

left = k;
for i=2:n
  k=(~left) & (x<breakpoints(i));
  if any(k)
    z(k)=feval(funs{i},x(k));
    left = k | left;
  end
end

% over the top
k=(x>=breakpoints(end));
z(k)=feval(funs{end},x(k));


