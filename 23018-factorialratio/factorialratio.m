function FR = factorialratio(A,B) 
% FACTORIALRATIO - ratio of factorial numbers
%
%   FR = FACTORIALRATIO (A,B) calculates the ratio between products of
%   factorials specified by A and B.  A and B are lists of positive
%   integers, with N and M elements, respectively. The number of values in
%   each list may differ. The factorial ratio is based on the following formula:
%
%              (A1! * A2! * ... * AN!)
%      FR  =  -------------------------
%              (B1! * B2! * ... * BM!)
%
%    However, an approach is taken that increases the accuracy when A or B
%    contain larger values, as mentioned in the help of FACTORIAL. 
%
%    Examples:      
%
%      f1 = factorialratio([10 8 6],[9 6 5]) ;
%      f2 = 10 * 8 * 7 * 6 ; % by hand
%      f3 = (factorial(10) * factorial(8) * factorial(6)) ./ ...
%            (factorial(9) * factorial(6) * factorial(5)) ;
%      disp('f1, f2, f3 = ') ; disp([f1 f2 f3])
%
%
%      % Also for larger values FACTORIALRATIO works correctly
%      f1 = factorialratio(150,143) ;
%      f2 = prod(144:150) ; % by hand
%      % where FACTORIAL lacks precision
%      f3 = factorial(150) ./ factorial(143) ;
%      disp('f1, f2, f3 = ') ; disp([f1 f2 f3])
%      disp('   Differences with f2 = ') ; disp([f1-f2 f2-f2 f3-f2])
%
%      % and even for extreme numbers things turn out well
%      f1 = factorialratio(30000,29998) ; 
%      f2 = (30000 * 29999) ; % by hand
%      % whereas calls to FACTORIAL fail miserably ...
%      f3 = factorial(30000) ./ factorial(29998) ;
%      disp('f1, f2, f3 = ') ; disp([f1 f2 f3])
%
%    Note that, for instance, factorialratio(200,1) also fails, of course.
%    For such occasions other engines have to be used.
%     
%    See also PROD, FACTORIAL, GAMMALN

% for Matlab R13 and up
% version 2.0 (oct 2012)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0 (feb 2009) - created for (later) use in a statistical test
% 1.1 (feb 2009) - fixed minor bug in error checking
% 2.0 (oct 2012) - fixed bug "maxE > 1" which should be "maxE > 0". Thanks
%                  to 'Charles' for pointing this out.

% check the input arguments
error(nargchk(2,2,nargin)) ;
if isempty(A) || isempty(B) || ...
    ~isnumeric(A) || ~isnumeric(B) || ...
    any(A(:)<0) || any(fix(A(:)) ~= A(:)) || ...
    any(B(:)<0) || any(fix(B(:)) ~= B(:))
    error('Inputs should be numerical arrays with positive integers.')
end

% Example for terminology used in comments:
%   FR = factorialratio([6 4],[3 2 1])      call
%      = (6! * 4!) / (3! * 2!)              numerators / denominators  (ignoring ones)
%      = 6*5*4*3*2*4*3*2 / 3*2*2            expanded factorial (showing all factors > 1)
%         [6 5 4 3 2] .^ [1 1 1 2 2] 
%      = ----------------------------       as powers (factors and exponents)
%         [6 5 4 3 2] .^ [0 0 0 1 2]
%
%      = [6 5 4 3 2] .^ [1 1 1 1 0]         rewritten

% only values larger than 2 have an effect as both 1! and 0! equal 1
% we can subtract 1 if we do not forget to add 1 later
A = A(A>1) - 1 ;
B = B(B>1) - 1 ;

% what is the largest element?
maxE = max([A(:) ; B(:) ; 0]) ;

if maxE > 0 && ~isequal(A,B),
    % Create a 2 by m array holding the elements of A and B:
    % - the first column refers to the numerators of the ratio (A)
    % - the second column refers to the denominators of the ratio (B)
    R = sparse(A,1,1,maxE,2) + sparse(B,2,1,maxE,2) ;
    
    % By flipping, cumsumming (over columns) and flipping again ...
    R = flipud(cumsum(flipud(R))) ;    
    % ... we get numbers that indicate how many times a factor is present in
    % the expanded ratio. R(X,1) indicates the number of times (X+1) is present in
    % the numerator in the expanded ratio, and R(X,2) the number of times
    % (X+1) is present in the denominator. The difference will give us the
    % exponent for taking the power of the value (X+1).
    R = (R(:,1) - R(:,2)).' ;    % exponents
    X = 2:(maxE+1) ;             % base numbers (we now do need to add the 1)
    
    % We only used the nonzero entries, since X^0 = 1, and this may affect
    % the time used for ...
    q = find(R) ;     
    % ... getting the total product
    FR = prod(X(q).^R(q)) ; % 
else    
    % All elements were less than 2, or A equals B
    FR = 1 ;
end




