function so = primes
% PRIMES  Stream of prime numbers.
so = PrimesFrom(integersFrom(2));

function so = PrimesFrom(si)
% PRIMESFORM  Adding filters for the primes:
% The first number is ok:
val=head(si); so=tail(si);
% The others are filtered:
so = streamFilter(so,@(v,p)(mod(v,p)~=0),val);
% Composing:
so = {val,delayEval(@PrimesFrom,{so})};
