function p=recperms(n,p)

% RECPERMS(n) or RECPERMS(n,[]) where n is a positive integer, returns a 
% random permutation of the integers from 1 to n (using Matlab's RANDPERM).
% RECPERMS(n,p), where n is a positive integer, and p is a valid permutation
% of the integers from 1 to n, returns a vector with n elements containing 
% the next permutation of the integers from 1 to n. 
% If RECPERMS(n,p) is called n!-1 times recursively (i.e feeding the output
% vector into the function for the next step) starting with p = 1:n, then 
% the successive outputs span the same output from perms(1:n). The order of
% the permutations is, however, different from that of perms(1:n), which 
% uses a different algorithm.
% If the input p is 1:n, the used algorithm results in the last permutation 
% being n:-1:1. Starting with p=1:n is, however, optional. The function is 
% designed to wrap to the first permutation (1:n) when the last permutation 
% (n:-1:1) is reached. This way, if any (valid) starting permutation p is 
% used, then recursively calling the function n!-1 times spans all possible
% permutations as expected.
% 
% Examples:
% 
% 1)    recperms(5) or recperms(5,[])   
%           returns a random permutation of the integers 1, 2, 3, 4, 5.
%
% 2)    recperms(5,1:5)                 
%           returns [1 2 3 5 4]
%
% 3)    recperms(5,[5 4 3 2 1])         
%           returns [1 2 3 4 5]
%
% 4)    recperms(5,[1 5 4 3 2])         
%            returns [2 1 3 4 5]
%   
% 5)    n=5; 
%       p=1:n;
%       for i=1:factorial(n)-1
%            p=recperms(n,p);
%            %other code utilizing the generated permutation      
%       end;   
%       
%           cycles through all possible permutations starting with 
%           [1 2 3 4 5] and ending with [5 4 3 2 1].
%
% 6)    n=5; 
%       p=[2 1 3 4 5];
%       for i=1:factorial(n)-1
%            p=recperms(n,p);
%            %other code utilizing the generated permutation      
%       end;   
%       
%           cycles through all possible permutations starting with 
%           [2 1 3 4 5] and ending with [1 5 4 3 2], which is the 
%           permuation just before the starting one (see example 4).
%
% 7)    n=5; 
%       p=[];
%       for i=1:factorial(n)
%            p=recperms(n,p);
%            %other code utilizing the generated permutation      
%       end;   
%       
%           cycles through all possible permutations starting with some 
%           random permutation.

% The algorithm is based on simulating the permutations as the states of 
% n nested loops each with a counter from 1 to n. The counter in each of the 
% inner loops skips the states of all outer loops to generate a valid 
% permutation. Given a certain valid permutation, the algorithm figures out
% how the counters are incremented to produce the next valid permutation.

%K. H. Hamed, 
%Sultan Qaboos University, Muscat, Oman
%khhamed@squ.edu.om
%23 November 2006

if nargin <1
    error('RECPERMS:minrhs','At least One Input Argument is required.')
end;

if fix(n) ~= n ||n < 1 || ~isa(n,'double') || ~isreal(n)
    error('RECPERMS:posint','Input Parameter n Must be a positive Integer.');
end

if nargin<2 || isempty(p);                     %user gives n only, or an empty permutation vector
    p=randperm(n);                             %return a random permutation
    return;
end;

if min(size(p))>1 || length(p)~=n || any(~(sort(p(:))==(1:n)')) || ~isreal(p) 
    error('RECPERMS:noperm','Input Parameter p Must be a vector containing a Valid Permutation of the integers from 1 to n.');
end;

idx=n-1;                                    %start one level above the innermost level 
while idx>0                                 %repeat while there are levels to be incremented  
    
    x=p(idx:end);                           %consider the states from the current level down to the innermost level (available states)
    y=x(x>p(idx));                          %find available states which are larger than the state of the current level
    
    if isempty(y)                           %none is larger
        idx=idx-1;                          %move up one level    
    
    else                                    %found at least one state that is larger than that of the current level
        p(idx)=min(y);                      %set the state of the current level to the next available state
        p(idx+1:end)=sort(x(x~=p(idx)));    %reset the remaining inner loops using the remaining available states
        break;                              %finished for this permutation
    end;
end;
if idx<1;                                   %reached beyond the uppermost level? p must be the last permutation (n:-1:1)
    p=1:n;                                  %wrap to the first permutation (1:n)
end;      