function freq = lp_lgfrq(min_freq,max_freq,nop)
%
%  Delivers a vector of "frequency sampling points" which are 
%  logarithmically distributed in the interval [min_freq,max_freq].
%
%  Calling sequence:
%
%    freq = lp_lgfrg(min_freq,max_freq,nop)
%
%  Input:
%
%    min_freq   lower bound of frequency range (0 < min_freq);
%    max_freq   upper bound of frequency range (min_freq < max_freq);
%    nop        number of frequency sampling points (length of vector 
%               freq), default: nop = 100.
%
%  Output:
%
%    freq       frequency points (in ascending order).
%
%
%  LYAPACK 1.0 (Thilo Penzl, May 1999)

% Input data not completely checked!

na = nargin;
if na<2 & na>3, error('Wrong number of input arguments.'); end
if min_freq<=0, error('min_freq must be positive.'); end
if max_freq<=min_freq, error('max_freq must be larger than min_freq.'); end

if na==2, nop = 100; end

df = (max_freq/min_freq)^(1/(nop-1));
freq = zeros(nop,1);
f = min_freq;
for i = 1:nop-1
  freq(i) = f;
  f = f*df;
end
freq(nop) = max_freq;

