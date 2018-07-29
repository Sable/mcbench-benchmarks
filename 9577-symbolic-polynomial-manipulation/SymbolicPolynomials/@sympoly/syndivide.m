function [q,r,rflag] = syntheticdivision(snumer,sdenom)
% syntheticdivision: quotient and remainder of a synthetic polynomial division
% usage: [q,r] = syntheticdivision(snumer,sdenom)
%
% arguments: (input)
%  snumer - scalar sympoly object - Numerator polynomial
%
%  sdenom - scalar sympoly object - Denomenator polynomial
%
% arguments: (output)
%  q - quotient sympoly
%
%  r - remainder sympoly
%
%  rflag - scalar boolean flag - denotes if the remainder term
%      was judged to be zero.
%
%      rflag == 0 --> the remainder was zero to within a tolerance
%      rflag == 1 --> the remainder was greater than the tolerance

% are they both sympolys?
if ~isa(snumer,'sympoly')
  snumer = sympoly(snumer);
end
if ~isa(sdenom,'sympoly')
  sdenom = sympoly(sdenom);
end

% monomial sympoly == 0 (right now)
monomial = sympoly(1);

% make all variable sets the same
[snumer,sdenom,monomial] = equalize_vars(snumer,sdenom,monomial);

% shift the sympolys to have all positive exponents
% The shift will be zero for variables which have all
% positive exponents already.
sh = min(0,min(snumer.Exponent,[],1));
numershift = monomial;
numershift.Exponent = sh;
nt = size(snumer.Exponent,1);
snumer.Exponent = snumer.Exponent - repmat(sh,nt,1);

sh = min(0,min(sdenom.Exponent,[],1));
denomshift = monomial;
denomshift.Exponent = sh;
nt = size(sdenom.Exponent,1);
sdenom.Exponent = sdenom.Exponent - repmat(sh,nt,1);

% initialize the quotient and remainder sympolys
q = sympoly(0);
r = snumer;

% highest order term in the denomenator sympoly
order = sum(sdenom.Exponent,2);
[order,ind] = max(order);
denorder = sdenom.Exponent(ind,:);
denomcoef = sdenom.Coefficient(ind);

% set up a while loop to do the synthetic division
divflag = 1;
tol = 1e-12*max(abs(snumer.Coefficient))/max(abs(sdenom.Coefficient));
rflag = logical(0);
while divflag
  % find the highest order term in the remainder sympoly
  order = sum(r.Exponent,2);
  [order,ind] = max(order);
  if order>=sum(denorder)
    % "divide"
    remorder = r.Exponent(ind,:);
    remCoef = r.Coefficient(ind);
    
    % another piece to add in to q
    monomial.Exponent = remorder - denorder;
    monomial.Coefficient = remCoef/denomcoef;
    q = q + monomial;

    % and decrement the remainder
    r = r - monomial*sdenom;
    r = equalize_vars(r,monomial);

    % Is there anything left in the remainder that has a
    % positive exponent? If so, then continue the while loop.
    if all(r.Exponent(:)<0)
      divflag = 0;
      rflag = logical(1);
    elseif all(r.Exponent(:)<=0) && all(abs(r.Coefficient)<=tol)
      divflag = 0;
    end
  else
    % there is a non-zero remainder
    divflag = 0;
    if any(abs(r.Coefficient)>=tol)
      rflag = logical(1);
    end
  end
end

% when all is done, unshift the sympolys
shift = numershift./denomshift;
q = q*shift;
r = r*shift;

