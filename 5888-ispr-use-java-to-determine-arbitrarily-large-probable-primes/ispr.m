% ISPR - Rapidly determine whether an arbitrarily large positive integer
%        is a probable prime.
% 
% USAGE: q = ispr(n)
%        q = ispn(n,1)
% 
% n = positive integer, either as a numeric or string datatype
% q = 1 if n is prime, 0 if n is composite
% 1 = any second input will cause the function to output
%     a message describing the result in plain language,
%     including (if n is probably prime) a statement about
%     the certainty with which n is claimed to be prime.
% 
%  Notes: Probable primes are also known as "industrial strength"
%         primes because of the exceedingly high probability -- but
%         not certainty -- of primality. This function utilizes the
%         Java class "BigInteger" with its method "isProbablePrime."
%         For small integers, you can use numeric inputs; however,
%         for abitrarily large integers, you must input the number
%         as a string in order to avoid an overflow. Note the overflow
%         error in the second to last example below.
% 
% Examples:
% 
% >>ispr(314159,1)
% I believe that 314159 is prime, but there is a
% 1 in 590295810358705650000 chance that I am mistaken.
% 
% >>ispr('338327950288419716939',1) % correct with quotes
% I believe that 338327950288419716939 is prime, but there
% is a 1 in 664613997892457940000000000000000000 chance
% that I am mistaken.
% 
% >>ispr(338327950288419716939,1) % no quotes, therefore overflow
% 338327950288419680000 is definitely not prime.
% 
% >> for i=1:1000;if ispr(i);fprintf('%i ',i);end;end;fprintf('\n')
%
% Michael Kleder, 2004

function q=ispr(varargin)
n = varargin{1};
if isnumeric(n)
    n = num2str(n);
end
if n(end)==46 % strip trailing decimal point
    n=n(1:end-1);
end
% check for positive integers:
if strcmp(n,'0') | any(n==45) | any(n==46)
    error('Input must be a positive integer.')
end
x=java.math.BigInteger(n);
% create "industrial-strength" certainty:
certfactor = ceil(3.33*length(n))+50;
q=x.isProbablePrime(certfactor);
if nargin > 1
    % code to display the result, if you want it:
    if q
        wrong = 2 ^ certfactor;
        disp(['I believe that ' n ' is prime, but there is a 1 in ' ...
            num2str(wrong) ' chance that I am mistaken.']);
    else
        disp([n ' is definitely not prime.']);
    end
end
return
