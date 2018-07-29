function sp=power(sp,n)
% sympoly/power: raise a sympoly (elementwise) to a scalar power
% usage: sp=sp.^n;
% 
% arguments:
%  sp - sympoly object
%  n  - scalar - exponent of the sympoly, need not be an integer

if ~isa(sp,'sympoly')
  error 'sp must be a sympoly'
end

if ~isnumeric(n) || (length(n) > 1)
  error 'n must be a scalar numeric variable'
end

% for an array, raise the individual elements
% to the n'th power
k=numel(sp);
if k>1
  % its an array. Raise each element to the nth power
  for i=1:k
    sp(i)=sp(i).^n;
  end
else
  % a scalar sympoly. 
  
  % If n is a scalar, non-negative integer, then
  % we will compute the power by repeated multiplies.
  % If it is fractional, then we can only do this
  % for single term sympolys.
  
  if n == 0
    % The zero'th power is 1
    sp = sympoly(1);
    
  elseif n==1
    % n == 1 is a no-op.
    
  elseif (rem(n,1)==0) && (n>0)
    % A positive integer exponent. Use multiplication
    
    % loop on k
    sp1=sp;
    k=1;
    while (2*k)<=n
      % square until near k
      sp=sp.*sp;
      k=2*k;
    end
    
    if k<n
      for i=(k+1):n
        sp=sp.*sp1;
      end
    end
    
  else
    % it must be a fractional or negative exponent
    if length(sp.Coefficient)>1
      error 'Cannot raise a multinomial sympoly to a fractional or negative power.'
    end
    
    % raise a single term to the nth power
    sp.Coefficient=sp.Coefficient.^n;
    sp.Exponent = sp.Exponent*n;
    
  end
end



