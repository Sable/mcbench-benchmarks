function sp=mpower(sp,k)
% sympoly/mpower: raise a scalar or matrix sympoly to a scalar power
% usage: sp=sp^k;
% 
% arguments:
%  sp - sympoly object or sympoly array
%
%   k - numeric scalar - exponent of the sympoly. k may be 
%       fractional if sp has only one additive term.

if ~isa(sp,'sympoly')
  error 'sp must be a sympoly'
end

% is k a numeric scalar?
if ~isnumeric(k) || (numel(k)>1)
  error 'k must be a numeric scalar'
end

% check to see if sp is a sympoly array first
np = numel(sp);
if np==1
  % just use mtimes
  sp = sp.^k;
else
  % sp is an array. it must be square, and k must
  % be a non-negative integer.
  s = size(sp);
  if (length(s)>2) || (diff(s)~=0)
    error 'sp must be a square 2-d sympoly array.'
  elseif (k<0) || (k~=floor(k))
    error 'k must be a non-negative integer'
  end
  
  if k == 0
    sp = sympoly(eye(s));
    
  elseif k==1
    % unit power. a no-op
    
  else
    % integer power > 1
    sp1 = sp;
    
    L = 1;
    while L < k
      if (2*L)<=k
        % repeated squaring until close enough
        sp = sp*sp;
        L = 2*L;
      else
        sp = sp*sp1;
        L = L+1;
      end
    end
    
  end
end


