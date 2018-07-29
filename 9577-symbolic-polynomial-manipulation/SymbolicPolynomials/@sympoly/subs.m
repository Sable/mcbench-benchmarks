function sp=subs(sp,varargin)
% sympoly/subs: substitute into a sympoly, forming p(q(x))
% usage: sp=subs(sp,var1,val1,var2,val2,...);
% usage: sp=subs(sp,val);
% 
% arguments: (input)
%   sp - sympoly object or array
%
%  var - (character string) variable to substitute for
%
%  val - value to substitute. val may be a numeric constant,
%        or a scalar sympoly itself.
%
%        If p is a function of only one variable, then
%        you can use the usage mode: p=subs(p,val);
%
% arguments: (output)
%  sp - sympoly object resulting from the substitution
% 
% Example usage:
%
%  The following code snippet will define a sympoly as 'x',
%  add one to the poly, then substitute 2*x for x. The result
%  will be 2*x+1.
%
%    sympoly x
%    r = subs(x+1,'x',2*x);

if ~isa(sp,'sympoly')
  error 'sp must be class ''sympoly'''
end

% if p is an array, then substitute into each
% element, p(i,j), of the array
n = numel(sp);
if n>1
  for i=1:n
    sp(i)=subs(sp(i),varargin{:});
  end
  return
end

% only 1 extra argument, can we do the substitution?
nv=length(varargin);
if (nv==1)
  v = setdiff(sp.Var,{''});
  if length(v)>1
    error 'sp is a multinomial sympoly. Cannot use subs this way.'
  end
  
  sp=subs(sp,v{1},varargin{1});
  return
end

if (rem(nv,2)~=0)|(nv==0)
  error 'subs should be called with variable name & value pairs'
end

% how many substitutions to make
nsubs=nv/2;
if nsubs > 1
  % convert the serial substitutions into calls to subs
  % of a single variable at a time.
  for i=1:nsubs
    v_i=varargin{2*i-1};
    p_i=varargin{2*i};
    sp = subs(sp,v_i,p_i);
  end
  return
else
  % its a single variable to substitute for
  v_i=varargin{1};
  p_i=varargin{2};
  
  % is sp a function of this variable?
  indx=strmatch(v_i,sp.Var,'exact');
  if ~isempty(indx)
    % is p_i a sympoly itself or numeric?
    if isnumeric(p_i)
      % Its a number. The subs is easy.
      k = sp.Exponent(:,indx);
      sp.Coefficient = sp.Coefficient(:).*(p_i.^k);
      sp.Exponent(:,indx) = 0;

      % clean it all up
      sp = clean_sympoly(sp);

    else
      % Its a sympoly. I need to do this one the hard way.
      spsubs = sympoly(0);
      nc = length(sp.Coefficient);
      for i = 1:nc
        spi=sp;
        spi.Coefficient = spi.Coefficient(i);
        spi.Exponent=spi.Exponent(i,:);
        k = spi.Exponent(1,indx);
        spi.Exponent(1,indx) = 0;
        spi = spi.*(p_i.^k);
        spsubs = spsubs + spi;
      end
      sp=spsubs;

      % the good news is, any garbage collection
      % necessary was already done in the final "plus"
      % operation, so no clean_sympoly needed here.
    end
  end
  
end


