
function f = grep(rgx, varargin)
% FUNC = GREP(REGEXP, OPTIONS)
%   Return a function that returns whether its argument matches a regular
%   expression.  This is basically a flipped curried matches, but with the
%   following options available.
%     OPTIONS
%       i, ignore-case, no-case
%         Perform a case insensitive match.
%
%       v, reverse, invert
%         Negate the match.
%
%       s, safe, type-safe
%         Check to make sure the options to FUNC are strings, otherwise
%         just hafe FUNC return false.
%         
  icase = false;
  rev   = false;
  safe  = false;

  for i = 1:numel(varargin)
    arg = varargin{i};
    if ~ischar(arg)
      error('grep:Arguments', 'Grep requires strings for all options.');
    end
    arg = lower(arg);
    if matches(arg, '^i|(ignore|no)[ -]?case$')
      icase = true;
      continue;
    end
    if matches(arg, '^v|reverse|invert$')
      rev = true;
      continue;
    end
    if matches(arg, '^s|(type[ -]?)?safe$')
      safe = true;
      continue;
    end
    error('grep:Arguments', 'Could not understand argument %s.', arg);
  end

  match = @matches;
  if icase, match = @matchesi; end
  
  comp = @(str) match(str, rgx);
  if rev, comp = @(str) ~match(str, rgx); end

  function b = safeComp(str)
    b = false;
    if ischar(str)
      b = comp(str);
    end
  end

  f = comp;
  if safe, f = @safeComp; end
end
