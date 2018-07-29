function xPerm = partperm(x,idx,varargin)
%PARTPERM Partial random permutation of a vector.
%
%   X = PARTPERM(A,IDX) randomly permutes the elements of vector A which are 
%   specified by vector IDX.  That is, the elements A(IDX) are randomly
%   interchanged with one another and the resulting (partially permuted) vector 
%   is returned.  No permutation occurs when length(IDX) < 2.
%   
%   By default, the permutation is a "derangement"; that is, no element
%   specified by IDX will appear in its original position.  (The derangement
%   of the specified elements is ensured by repeatedly generating and testing
%   candidate permutation vectors within a WHILE loop.  I have not really
%   thought about the tractability of this approach, but as I understand
%   the MathWorld article <http://mathworld.wolfram.com/Derangement.html>,
%   the probability of a successful derangement under random permutation
%   asymptotes at 1/e ~ .37, so about 1 out of 3 attempted permutations should
%   produce a valid derangement.  Hopefully the WHILE loop is therefor not
%   such a terrible approach.)
% 
%   To disable this "derangement" constraint and thereby allow permuted elements
%   to reappear in their original positions, use the following syntax:
% 
%   X = PARTPERM(A,IDX,'allow') randomly permutes the elements of vector A which
%   are specified by vector IDX, but allows indexed elements to remain unchanged 
%   if that is the natural result of the random permutation (i.e., if after 
%   permutation an element's new location happens to be the same as its original
%   location).
%
%   See also RANDPERM.
%

if isempty(idx) | length(idx)==1,
    xPerm = x;
    %warning('No permutation requested.') 
    return
end
if ~isequal(prod(size(x)),length(x)),
    error('Input X must be a vector.')
end
if ~isequal(prod(size(idx)),length(idx)),
    error('Input IDX must be a vector.')
end

sizeXorig = size(x);
x = x(:);     % Columnize
idx = idx(:);

numPerm = length(idx);
candidatePerm = 1:numPerm;

if isempty(varargin),
    % Find an appropriate permutation of the selected indices...
    % none the same as the original.
    whileCnt = 0;
    while any(candidatePerm == 1:numPerm),
        whileCnt = whileCnt + 1;
        if rem(whileCnt,50) == 0,
            disp(['Tested ' num2str(whileCnt) ' candidates. Searching for identity-free permutation...'])
        end
        candidatePerm = randperm(numPerm);
    end
elseif strcmp(varargin{1},'allow'),
    candidatePerm = randperm(numPerm);
else 
    error('Use flag ''allow'' to permit identities.')
end

idxPerm = idx(candidatePerm);
xPerm = x;
xPerm(idxPerm) = x(idx);
xPerm = reshape(xPerm,sizeXorig);