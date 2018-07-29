%% The aliquot parts of a number
%
% This demo file teaches about the aliquot parts of a number,
% and how to use the functions I've provided.
%
% Author: John D'Errico
%
% e-mail: woodchips@rochester.rr.com
%
% Release: 1.0
%
% Release date: 9/21/08

%% The aliquot parts of a number are its proper divisors
% For example, the number 12 has the list of prime factors
factor(12)

%%
% but its proper divisors are given by
aliquotparts(12)

%%
% See that N will not be listed as a proper divisor of itself, not
% for any value of N. In fact, the number 1 has no proper divisors.
aliquotparts(1)

%%
% Of course, prime numbers can have only 1 as a proper divisor.
aliquotparts(17)

%% The sum of the aliquot parts, or sum of proper divisors
aliquotsum([2 4 5 6 8 12 27 135 40320])

%% aliquotsum is efficient and vectorized
% In this test, the sum of the divisors for EVERY number from 1 to 100000
% is computed in short order.
N = (1:100000)';
tic,pdsum = aliquotsum(N);toc
%%
% Show the numbers up to 100000 with the largest relative sums of their proper divisors.
[pdsum,tags] = sort(pdsum./N,'descend');
disp('         N,      sigma(N)./N')
disp([N(tags(1:10)),pdsum(1:10)])

%% You can also count the number of divisors
% This is just the sum of the zero'th powers of the divisors. Logically,
% we expect all the prime numbers to have only one divisor.
N = (1:20)';
[N,aliquotsum(N,0)]

%%
% What number no larger than 100000 has the most proper divisors?
N = (1:100000)';
d = aliquotsum(N,0);
[maxdivisors,Nmax] = max(d)
%%
% As you might expect, that number has multiple small factors
factor(Nmax)

%% Or you can form the sum of the p'th powers
% Here we will compute the sum of the squares of the aliquot parts.
N = (1:20)';
[N,aliquotsum(N,2)]

%% Perfect numbers
% Perfect numbers have their aliquot sums equal to the
% number itself.
aliquotsum([6 28 496 8128])

%% Abundant numbers
% Just under 25% of all numbers are abundant
N = 100000;
100*sum(aliquotsum(1:N)>(1:N))/N

%% Hyper-abundant numbers
% Few (roughly 2%) of numbers are hyper-abundant.
% I've defined hyper-abundancy as an aliquot sum of the number N
% that is at least twice as large as N.
N = (1:100000)';
%%
% As a percentage...
100*sum(aliquotsum(N)>(2*N))./100000

%%
% Show the numbers up to 100000 with the largest relative sums of their proper divisors.
pdsum = aliquotsum(N);
[pdsum,tags] = sort(pdsum./N,'descend');
disp('         N,      sigma(N)./N')
disp([N(tags(1:10)),pdsum(1:10)])

%% Collosally-abundant numbers?
% How hyper-abundant can they get? Is there a maximum?
N = 1000000;
pdsum = aliquotsum(1:N);
[maxsum,whichN] = max(pdsum)
%%
% It does not appear that there is any maximum value
% to this ratio. Certainly it exceeds 3. Mathworld suggests
% <http://mathworld.wolfram.com/ColossallyAbundantNumber.html |(Collossally abundant)|>
% that the ratio can get fairly large. Add 1 to get the ratio they list.
maxsum/whichN

%% Odd abundant numbers are less common than the abundant numbers in general
% The smallest odd abundant number is 945. 
N = (1:2:10000)';
pdsum = aliquotsum(N);
ind = find(pdsum>N);
N(ind)'

%% The odd abundant numbers are also "less" abundant
% The third column here is the extent of the overabundancy.
% Since 1.0 there would indicate a perfect number, these odd abundants
% are all clearly just barely so. I wonder, is there a limit to the
% extent of abundancy for the odd numbers? Are any hyper-abundant,
% as I've defined it above?
N = (1:2:1000000)';
pdsum = aliquotsum(N);
maxOddAbundancy = max(pdsum./N)

%% Why are the odd abundants so rare?
% We can get some idea as to the reason why odd abundant numers 
% are so rare, by looking at the factors of a highly abundant even
% number.
%
% Try 840 for example. Clearly it has multiple powers of 2 in its
% factorization.
factor(840)
%%
% 840 is also quite abundant.
aliquotsum(840)
%% 
% If we look at the factors of the most highly abundant numbers,
% you will generally find many spare powers of 2. But how about
% the odd abunbdants? There are no powers of 2 allowed in an odd number,
% so pick some of the odd abundant numbers and look at their factors.
% As expected, we find some extra powers of 3, along with some other
% moderately small odd primes.
factor(945)
factor(9765)
%%
% Pick a rather large odd number that will have very many factors.
% Unfortunately, this is close to as far as aliquotsum will go, due to
% the limits of MATLAB's operating precision. I'll admit the ratio
% is starting to approach 2.
N = 3*3*3*5*5*7*7*11*13*17*19
aliquotsum(N)/N

%% Deficient numbers
% All primes are deficient, as are all pure powers of prime numbers.
% As well, all the divisors of any perfect number are known to be deficient.
aliquotsum(primes(50))

%% Maximally deficient numbers
% Naturally, the prime numbers represent the most deficient numbers
% possible, since each prime has only one divisor less than itself,
% and that is the number 1. If we ignore the prime numbers, which
% numbers are the next most deficient? Do you see a pattern?
N = setdiff(1:50,primes(50))';
[N,aliquotsum(N)]

%% Amicable numbers
% A pair of numbers is amicable if their aliquot sums are
% equal to the other member of the pair.
aliquotsum([220 284])

%% Sociable numbers form cliques, or amicable cycles
% Perfect numbers are self-amicable, with a cycle length of 1.
% Amicable pairs have a cycle length of 2.
% This cycle has length 5 before it returns to the start.
aliquotsum([12496 14288 15472 14536 14264])

%% Amicable cycles
% Perfect numbers are self-amicable. The amicablecycles function:
%
%  cycles = amicablecycles(N,L)
% 
% will find all cycles that start with a number
% as large as N. The length of the cycle is L.
amicablecycles(20000,1)
%%
% Amicable pairs have a cycle length of 2.
amicablecycles(20000,2)

%%
% There are no known sociable cliques of length 3 or 4
amicablecycles(20000,3)
amicablecycles(20000,4)

%%
% The smallest cycle of length 5 starts at 12496
amicablecycles(20000,5)

%% Odd amicables
% You can force amicablecycles to look only at certain starting points.
% For example, to find the odd amicable cycles only
amicablecycles(1:2:200000,2)

%% Some interesting things to try
% What fun things can you find to do with these numbers?
% Can you find any odd perfect numbers? Perhaps a quasi-perfect
% number?
%
% Some simple problems for the student, and a few that may not be so
% simple.
%
% 1. Which numbers have many distinct divisors?
%
% 2. What is the smallest number to have exactly 31 divisors?
%
% 3. Does the product of the first k primes necessarily have the largest number of distinct divisors?
%
% 4. Can you construct a number less than 2*3*5*7*11 that has more divisors than this number?
%
% 5. For which values of non-prime numbers N is the lower bound sqrt(N)+1 realized for the aliquot sum?
%
% 6. Can you prove that sqrt(N)+1 forms a lower bound for the aliquot sum for the non-prime numbers N?
%
% 7. Is there a simple relationship for the upper bound of the aliquot sum
% as a function of N? Consider N*log(N) as a start.
%
% 8. There are many abundant numbers. As was shown above, roughly 25% of
% all numbers are abundant. Can you generate the list of all abundant
% numbers up to some value? (Start with the aliquotsum function.) What is the
% smallest abundant number?
%
% 9. The odd abundant numbers were shown to be somewhat rare, and always
% seemed to have multiple powers of 3 in their representations. Are there
% any abundants that do not have either 2 or 3 as a factor? Can this
% happen? Note that such an investigation might involve numbers that are
% too large for the tools I've provided to work with properly.
N = vpi(5)*5*5*5*5*5*7*7*7*11*13
aliquotsum(N)
%%
% 10. Can you represent numbers as the sum of two abundant numbers? Which
% numbers are not so representable? Is there a smallest number such that
% all those above it are the sum of two abundant numbers?
%
% 11. An interesting generalization of a perfect number is what I'll call the p-perfect
% number. Thus, if a perfect number is an integer such that the sum of its
% proper divisors adds up to the number itself, a p-perfect number N might
% have the sum of the p'th powers of the divisors adding up to N^p. Do any
% such numbers exist? Can you show this cannot happen? Or are there any
% numbers with the squares of the divisors that adds up to the original
% number?
%
% 12. How about p-amicability? Can you think of a way to generalize this
% concept?
