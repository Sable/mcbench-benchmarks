function P = nextprime(N,direction)
% nextprime: finds the next larger prime number directly above (or below) N
% usage: P = nextprime(N)
% usage: P = nextprime(N,direction)
%
% arguments: (input)
%  N - a positive scalar numeric variable or vpi number)
%      or an array of numbers.
%
%  direction - (OPTIONAL) character string (or empty)
%      Either 'above' or 'below', or any simple shortening
%      that matches the first few characters in those words.
%
%      'above' --> Finds the first prime P > N
%      'below' --> Finds the first prime P < N
%
%      An attempt to find the next prime BELOW 2 will
%      result in a NaN, and a warning message.
%
%      DEFAULT: 'above'
%
%
% Example:
%  nextprime(100:10:200)
% ans =
%   101   113   127   131   149   151   163   173   181   191   211
% 
%  nextprime(100:10:200,'below')
% ans =
%    97   109   113   127   139   149   157   167   179   181   199
% 
%  nextprime(vpi('10000000000000'))
% ans =
%   10000000000037
%
%
%  See also: isprime, factor
%
%
%  Author: John D'Errico
%  e-mail: woodchips@rochester.rr.com
%  Release: 2.0
%  Release date: 4/9/09

if nargin<2 || isempty(direction)
  incsign = 1;
elseif ~ischar(direction)
  error('NEXTPRIME:direction',...
    'direction must be either ''above'' or ''below''')
else
  valid = {'above','below'};
  ind = strmatch(direction,valid);
  if ~isempty(ind)
    if ind == 1
      incsign = 1;
    else
      incsign = -1;
    end
  else
    error('NEXTPRIME:direction',...
      'direction must be either ''above'' or ''below''')
  end
end

if any(N(:) <= 0)
  error('NEXTPRIME:PositiveN',...
    'N must be a positive number, or an array of positive numbers')
end

% If the inputs are a numeric variable, support only inputs
% as large as 2^46 in terms of doubles.
if isnumeric(N) && (any(N(:) > 2^46))
  % I could convert (on the fly) any numeric variable to
  % vpi above some limit. I'd be limited to 2^53 there
  % anyway, since doubles are not represented exactly as
  % integers beyond 2^53.
  %
  % For 2^46 <= N <= 2^53, I could switch to a vpi form
  % on the fly. This seems rude to me, since the user might
  % not have vpi installed, but changing class here to a
  % vpi seems a rude surprise. If N is already a vpi number
  % and of any size, then nextprime will work with ease.
  %
  % So I've chosen to replace the call to isprime with a
  % hacked version of isprime, called isbigprime. This will
  % allow nextprime to work up to 2^46. isprime actually
  % works slightly beyond 2^46, but I need to leave some
  % headroom there to find larger primes.
  error('NEXTPRIME:InputOutOfRange',...
    'The maximum value of N (for numeric input) allowed is 2^46.');
end

% set a flag to indicate the vpi version of isprime
% this gets around a bug in MATLAB, because if I named
% isbigprime as isprime, then the wrong version gets
% called when N is a vpi number.
Nisvpi = isa(N,'vpi');

% just in case N was not an integer
switch incsign
  case 1
    % take the floor of N. If it was
    % an integer already, then no harm
    N = floor(N);
  case -1
    N = ceil(N);
end

% pre-allocate the result
P = N;

% possession of a few small primes will help us
% to avoid actually testing every number for
% explicit primality.
smallprimes = primes(5*max(1,max(ceil(log2(N)))));
oddprimes = smallprimes(2:end);

for i = 1:numel(N)
  Ni = N(i);
  if (Ni + incsign) <= smallprimes(end)
    % N is really small
    switch incsign
      case 1
        k = find(Ni < smallprimes,1,'first');
        P(i) = smallprimes(k);
      case -1
        if Ni > 2
          k = find(Ni > smallprimes,1,'last');
          P(i) = smallprimes(k);
        else
          if Nisvpi
            error('NEXTPRIME:SmallPrimes', ...
              'There is no prime below 2. An error since vpi numbers cannot be NaN')
          else
            warning('NEXTPRIME:SmallPrimes', ...
              'There is no prime below 2. NaN returned')
            P(i) = NaN;
          end
        end
    end
  else
    % N is large enough
    flag = true;
    if rem(Ni,2) == 0
      % Ni is even, so shift it to an odd number
      % since we know the next prime must be odd.
      % we don't need to worry about 2, since the
      % small primes were already weeded out.
      Ni = Ni - incsign;
    end
    moduli = double(mod(Ni,oddprimes));
    offset = 0;
    while flag
      offset = offset + 2*incsign;
      
      if any((Ni + offset) == smallprimes) || ...
          (all(0 ~= mod(offset + moduli,oddprimes)) && ...
          (Nisvpi && isprime(Ni+offset)) || (~Nisvpi && isbigprime(Ni + offset)))
        P(i) = Ni + offset;
        flag = false;
      end
    end
  end
end

% ================================
% end mainline, begin subfunctions
% =================================

function isp = isbigprime(X)
%isbigprime True for prime numbers. This version works up to 1.5*2^46.
%   isbigprime(X) is 1 for the elements of X that are prime, 0 otherwise.
%
%   Class support for input X:
%      float: double, single
%
%   See also FACTOR, PRIMES.

% Modified from the built-in R2007b version to work for larger inputs.
%  Copyright 1984-2006 The MathWorks, Inc. 

if isempty(X), isp = false(size(X)); return, end
if ~isreal(X) || any(X(:) < 0) || any(floor(X(:)) ~= X(:))
  error('MATLAB:isbigprime:InputNotPosInt',...
        'All entries of X must be positive integers.'); 
end

isp = false(size(X));
n = max(X(:));
if n > (1.5*2^46)
    error('NEXTPRIME:isbigprime:InputOutOfRange',...
          'The maximum value of X allowed is 2^46.');
end

p = primes(ceil(sqrt(n)));
for k = 1:numel(isp)
   isp(k) = all(rem(X(k), p(p<X(k))));
end

% p(p<1) would give an empty matrix and all([]) returns true.
% we need to correct isp for this case.
isp(X==1 | X==0)=0;



