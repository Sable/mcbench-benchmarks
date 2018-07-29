function V = kthvalue(L,K)
% KTHVALUE - select the k-th smallest element in a (randomized) list
% 
%   V = KTHVALUE(L,K) returns the K-th smallest number from a list. L is
%   (unordered) list of N values, and K is a scalar between 1 and N. 
%
%   Example:
%     L  = ceil(10*rand(1,6)), K = 3 
%     V = kthvalue(L,K) 
%   
%   The result is equivalent to picking the K-th value in the sorted list
%   "sort(L)". However, KTHVALUE does not require the explicit creation of
%   a temporary array, and is often faster.  
%
%     L  = rand(10000,1000) ; K  = ceil(numel(L)/2) ;
%     tic ; V1 = kthvalue(L,K) ; toc
%        % Elapsed time is 0.73 seconds. (on average)
%     tic ; B  = sort(L(:)) ; V2 = B(K) ; toc ;
%        % Elapsed time is 1.79 seconds.
%     isequal(V1,V2)  % of course ...
%
%   Notes:
%   - Despite its nice algorithm, I would recommend the approach using SORT
%     over KTHVALUE, primarily because with one call to SORT one can
%     extract multiple elements.  
%   - To find the k-th largest element, use -KTHVALUE(-L,K)
%   - For lists L with (2*K-1) numbers, KTHVALUE(L,K) equals the median
%     value of L.
%   - KTHVALUE can be used as a (rather inefficient ;-) ) sorting algorithm:
%       A = rand(5,1) ; 
%       sortedA = zeros(size(A)) ;
%       for i=1:numel(A),
%         sortedA(i) = kthvalue(A,i) ;
%       end
%       [sort(A) sortedA]
%
%   For some more ideas on element selection see
%   http://en.wikipedia.org/wiki/Selection_algorithm
%
%   See also SORT, MIN, MAX, MEDIAN

% for Matlab R13 and up
% version 2.1 (jun 2012)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History
% 1.0 (dec 2008) - inspired by a thread on CSSM and created as a
%                  programming exercise
% 2.0 (mar 2009) - added help and comments, put on the File Exchange
% 2.1 (jun 2012) - replace for k=0:Inf with a while(1) loop to avoid
%                  warning "FOR loop index is too large."

% check K to avoid most of the possible strange error messages
if K > numel(L) || K < 1 || fix(K) ~= K || ~isnumeric(K) || numel(K) ~= 1,
    error('K should be an integer between 1 and %d',numel(L)) ;
end

% The algorithm works as follows:
% step 1) select a random value from the list (pivot)
% step 2) each element is categorized as being smaller, equal or larger than
%    this pivot value
% step 3) Now there are three possibilities, that are considered in order
%    A) if (K-1) is smaller than the number of elements smaller than the pivot
%       value (Nsmaller), the k-th element is one of these numbers.
%       Continue with step 1 using a new list containing these smaller values; 
%    B) if (K-1) is smaller than the number elements smaller than or equal to
%    the pivot value, the pivot value represents the K-th smallest number; We are done!
%    else C) the K-th smallest number is in the list consisting of the
%    numbers larger than the pivot value. Continue with step 1 with a new list
%    containing these larger values values (and decrease K by the amount of
%    numbers discarded).
%
%  In the worst case, the number of iterations is the same as the number of
%  elements in the list. 

L = L(:) ; % needs to be a vector
K = K-1 ; % use zero-based indexing

% Loop until we have found the K-th smallest element.
while (1)  
    
    % 1) select a value from the list (pivot). 
    V = L(K+1) ; % on average the K-th element is fine as a pivot
                 % other options for randomized lists are L(1), L(end), etc
    
    % 2) which elements are smaller than this pivot value 
    D = L < V ; 
    Nsmaller = sum(D) ; % and how many are there?
    
    % The three possibilities:
    if K < Nsmaller, 
        % 3A) the wanted element is one of the values smaller than the
        % pivot value
        L = L(D) ; % new list
    elseif K < (Nsmaller + sum(L==V)),
        % 3B) the wanted element is (the same as) the pivot value 
        break ;
    else
        % 3C) the wanted element is one of the values larger than the pivot
        % value, so create the new list
        L = L(L>V) ;
        % update K since (#D-#L) smaller items have been removed
        K = K + numel(L) - numel(D) ; 
    end
end


