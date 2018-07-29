function C = permpos(M,N)
% PERMPOS - all possible permutations of M values in N positions
%   B = PERMPOS(M,N) where M and N are non-negative integers produces a
%   logical (N!/M!(N-M)!)-by-N matrix in which each row contains a unique
%   permation of M trues and (N-M) falses. Note that each column will hence
%   contain (N-1) trues. 
%   
%   B = PERMPOS(V,N) where V is a vector of length M produces a matrix
%   where each row a contains the values of V in preserved order, but
%   uniquely permuted at the N columns. The remaining positions are zero.
%
%   Examples:
%     permpos(2,4) % ->
%      % 1     1     0     0
%      % 1     0     1     0
%      % 1     0     0     1
%      % 0     1     1     0
%      % 0     1     0     1
%      % 0     0     1     1
%
%     permpos([-4 9 3],4) % >
%      % -4     9     3     0
%      % -4     9     0     3
%      % -4     0     9     3
%      %  0    -4     9     3
%
%   See also NCHOOSEK, PERMS, RANDPERM, TRUE, FALSE
%   and COMBN, ALLCOMB, BALLATSQ, NONES (Matlab File Exchange)

% for Matlab R13
% version 2.0 (may 2006)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% 1.0 apr 2006 - creation
% 1.1 may 2006 - proper implementation of nchoosek
% 2.0 may 2006 - implementation of first argument being a matrix
% 2.1 mar 2007 - removed unneccesary check for maximum sizes of N and M
%              - 

error(nargchk(2,2,nargin)) ;

if numel(M)>1 || M < 0 || isnan(M) || isinf(M), 
    if ndims(M) > 2 || ~any(size(M)==1),
        error('First argument should be a non-negative integer or a vector') ;
    end
    A = M ;
    M = numel(A) ;
else

    if numel(M) ~= 1 || fix(M) ~= M || M < 0,
        error('First argument should be a positive integer or a vector') ;
    end
    A = [] ;
end

if numel(N) ~= 1 || fix(N) ~= N || N < 1,
    error('Second argument should be a positive integer') ;
end


if M > N,
    error('Number of entries exceeds row length') ;
elseif M == 0,
    % no true values
    B = false(1,N) ;
elseif M == N,
    % only true values
    B = true(1,N) ;    
elseif M==1,
    % one true value -> on diagonal
    B = logical(eye(N)) ;
else
    % 1 < M < N, only now some real calculations have to be done
    ind = nchoosek(1:N,M) ;  % create a list of all possible column indices
    nr = size(ind,1) ;       % equals nchoosek(N,M)
    ind = sub2ind([nr N],repmat([1:nr].',1,M),ind) ;  % create linear indices
    % fill the matrix
    B = false(nr,N) ; 
    B(ind) = true ;    
end

if ~isempty(A),   
    if numel(A)==1,
        % negative scalar
        C = zeros(size(B)) ;
        C(B) = A ;
    else
        % vector argument 
        C = cumsum(B,2) ;
        C(B) = A(C(B)) ;
        C(~B) = 0 ;
    end
else
    C = B ;
end