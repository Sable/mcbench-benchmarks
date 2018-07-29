function SPresult = terms(SP,pattern,opmode,exactmatch)
% sympoly/terms: extract or delete specific terms of a sympoly
% usage: SPresult = terms(SP,pattern)
% usage: SPresult = terms(SP,pattern,opmode)
% usage: SPresult = terms(SP,pattern,opmode,exactmatch)
%
% arguments: (input)
%  SP - any sympoly object
%  
%  pattern - either a scalar monomial sympoly
%       or a scalar integer, or a vector of integers
%
%       If pattern is an integer, then it designates
%       the i'th subterm to operate on in SP. If a
%       vector of integers, then it deginates the
%       list of numbered terms to operate on.
%
%       If pattern is a sympoly itself, then it
%       designates the explicit terms to search for.
%       (See the examples.)
% 
%  opmode - (OPTIONAL) character string flag, that
%       designates the operation to be performed.
%       opmode must be one of:
% 
%       {'extract', 'delete', ''}
%
%       Case is ignored.
%
%       opmode == 'delete' --> drop the indicated
%          terms from the sympoly, returning those
%          that remain.
%
%       opmode == 'extract' --> extract only the
%          indicated terms from the sympoly, dropping
%          all other terms.
%
%       DEFAULT: opmode = 'extract'
%
%  exactmatch - (OPTIONAL) boolean flag. 
%       designates whether an exact match on the
%       term is required, or if other factors may
%       be included. If pattern is supplied as a
%       number, indicating a specific term, then
%       exactmatch is ignored.
%
%       exactmatch == 0 --> terms included may have
%          other factors.
%
%       exactmatch == 1 --> only the specific term
%          that exactly matches pattern is processed.
% 
%       DEFAULT: true
%
% Example:
%  

if (nargin<1) || (nargin>4)
  error('terms requires exactly 2, 3, or 4 arguments')
end

% default for exactmatch
if (nargin < 4) || isempty(exactmatch)
  exactmatch = 1;
elseif ~ismember(exactmatch,[0 1])
  error('exactmatch must be 0 or 1 if supplied')
end

% default for opmode
if (nargin <3) || isempty(opmode)
  opmode = 'extract';
elseif ~ischar(opmode)
  error('opmode must be character if supplied, either ''extract'' or ''delete''')
else
  valid = {'extract', 'delete'};
  ind = strmatch(lower(opmode),valid);
  if isempty(ind)
    error('opmode must be character if supplied, either ''extract'' or ''delete''')
  end
  opmode = valid{ind};
end

% is SP a sympoly?
if ~isa(SP,'sympoly')
  error('SP must be a sympoly')
end

% is patterns a sympoly or a numeric (positive integer) vector/scalar?
if isa(pattern,'sympoly') && (numel(pattern) > 1)
  % pattern must be a scalar monomial pattern
  error('pattern must be a scalar monomial if it is a sympoly')
elseif isnumeric(pattern) && ~(all(pattern(:)>0) && all(pattern(:)==round(pattern(:))))
  error('pattern must be positive integer if numeric')
elseif ~isnumeric(pattern) && ~isa(pattern,'sympoly')
  error('pattern must be a sympoly monomial or a positive integer if numeric')
else
  pattern = pattern(:);
end

% is this an array or vector sympoly?
if numel(SP) > 1
  % it is an array
  SPresult = SP;
  for i = 1:numel(SP)
    SPresult(i) = terms(SP(i),pattern,opmode);
  end
  % we can quit now
  return
end
% if we drop through, then SP is a scalar sympoly

% was pattern a sympoly or a numbered set of terms?
if isnumeric(pattern)
  % a numbered set of terms, and SP is a scalar sympoly
  
  % how many terms are in SP?
  nsp = length(SP.Coefficient);
  
  if any(pattern> nsp)
    warning('SYMPOLY:TERMS:patternmismatch','SP does not have as many terms as indicated by pattern')
  end
  % drop the extranseous terms in pattern
  % so we do not search for them
  pattern(pattern>nsp) = [];
  
  if isempty(pattern)
    % nothing there in the pattern
    switch opmode
      case 'extract'
        SPresult = sympoly(0);
      case 'delete'
        SPresult = SP;
    end
  else
    % which terms? Which opmode?
    switch opmode
      case 'extract'
        SPresult = SP;
        SPresult.Exponent = SPresult.Exponent(pattern(:),:);
        SPresult.Coefficient = SPresult.Coefficient(pattern(:));
      case 'delete'
        SPresult = SP;
        SPresult.Exponent(pattern,:) = [];
        SPresult.Coefficient(pattern,:) = [];
    end
    
    % clean up
    SPresult = clean_sympoly(SPresult);
  end
  
else
  % pattern is a scalar sympoly, as is SP.
  
  % make sure that pattern had only one term in it
  if length(pattern.Coefficient) > 1
    error('A sympoly pattern may only have a single polynomial term')
  end
  
  % ensure that SP and patterns have a
  % consistent set of variables
  [SP,pattern] = equalize_vars(SP,pattern);
  
  % look for a match between exponents in the terms
  nt = length(SP.Coefficient);
  if exactmatch
    % match the indicated exponents exactly between
    % SP and pattern
    k = all(SP.Exponent == repmat(pattern.Exponent,nt,1),2);
  else
    % other factors may be present between SP and pattern
    m = find(pattern.Exponent);
    k = all(SP.Exponent(:,m) == repmat(pattern.Exponent(m),nt,1),2);
  end
  if any(k)
    switch opmode
      case 'extract'
        SPresult = SP;
        SPresult.Exponent = SPresult.Exponent(k,:);
        SPresult.Coefficient = SPresult.Coefficient(k);
      case 'delete'
        SPresult = SP;
        SPresult.Exponent(k,:) = [];
        SPresult.Coefficient(k,:) = [];
    end
  else
    switch opmode
      case 'extract'
        % nothing extracted - so a zero sympoly
        SPresult = sympoly(0);
      case 'delete'
        % no deletions, so the original sympoly
        SPresult = SP;
    end
  end

  % clean up
  SPresult = clean_sympoly(SPresult);
end



  



