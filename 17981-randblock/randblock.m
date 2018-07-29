function [M,indi,indj] = randblock(M,S) 
% RANDBLOCK - randomize blocks of a matrix
%    R = RANDBLOCK(M,S) randomizes the matrix M by dividing M into
%    non-overlapping blocks of the size specified by S, and shuffling these
%    blocks. M can be a N-D matrix. 
%    The number of elements in S should match the number of dimensions of
%    M, or S can be a scalar specifying a S-by-S-by-S-by ... block size.
%    S should contain positive integers. TThe size of M in any dimension
%    should be an integer number of times the specified size of the block in
%    that dimension (e.g., if size(M,1) equals 6, S(dim) can be 1,2,3, or 6).
%
%    [R,I,J] = RANDBLOCK(...) also returns indices I and J, so that R equals A(I)
%    and R(J) equals A.
%
%    M can be a numerical or cell array. 
%
%    Examples:
%      % Shuffle blocks of 3 elements of a 15-element vector 
%        M = 1:15 ;
%        randblock(M,3)
%
%      % Scramble a 2D matrix
%        M = reshape(1:24,6,[]) ; 
%        randblock(M,[3 2])   % randomize the position of the four 3-by-2 blocks 
%        randblock(M,2)       % randomize the position of the six 2-by-2 blocks
% 
%      % Scramble a 3D volume
%        M = reshape(1:64,[4 8 2]) ; 
%        randblock(M,[2 4 2]) % randomize the position of the four
%                             % 2-by-4-by-2 sub-volumes
%
%      % Scramble a cell matrix
%        M = {'1','a','bb','1c' ; '2a',[3 4 5],'2c','2dd'} ;
%        randblock(M,[2 2])   % randomize the position of the four 2-by-2 blocks
%
%      % Scramble a RGB image Z, and retrieve the original using the
%      % indices
%        Z = peaks(200) ; Z = cat(3,Z,flipud(Z), -(circshift(Z.',[100,100]))) ; 
%        Z = (Z - min(Z(:))) ; Z = Z./ max(Z(:)) ; 
%        [Z2,I,J] = randblock(Z,[25,25,size(Z,3)]) ; % Scramble 25-by-25 blocks
%        subplot(2,2,1) ; image(Z) ; title('Original image') ;        
%        subplot(2,2,2) ; image(Z2) ; title('25x25 scrambled image') ;
%        subplot(2,2,3) ; image(Z2(J)) ; title('Z2(J) = original image') ;
%        subplot(2,2,4) ; image(Z(I)) ; title('Z(I) = scrambled image') ;
%        set (gcf,'Name','[Z2,I,J] = randblock(Z,[25,25,size(Z,3)])') ;
%
%  See also RAND, RANDPERM, MAT2CELL
%       and RANDSWAP, SHAKE on the File Exchange

% for Matlab R13 and up (works on R2010b)
% version 2.3 (mar 2011)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% Created: nov 2007
% 2.0 (dec 2007) implemented cell matrix capabilities
% 2.1 (dec 2007) added several examples for the File Exchange
% 2.2 (dec 2007) modified image example, remove minor m-lint messages
% 2.3 (mar 2011) fixed a small error in the examples; tested in 2010b 

% check if the size of the blocks is specified for each dimension of M
NdimM = ndims(M) ;
sizM = size(M) ;  % size of the matrix
nS = numel(S) ;

if nS==1,
    S = repmat(S,1,NdimM) ; % scalar expansion
elseif nS ~= NdimM,
    error('Number of elements of S should equal the number of dimensions of M.') ;
end

% S should contain positive integers only
if ~isnumeric(S) || any(S ~= fix(S)) || any(S<1),
    error('S should be a numeric array with positive integer values.') ;
end

% vectors are 2D and S can be a scalar in this case:
% the singleton dimension of M should be taken care of.
if NdimM==2 && any(sizM==1) && nS==1 && all(S~=1),
    S(sizM==1) = 1 ;    
end

if all(S==1),
    % Each element of M is a single block. We can just randomize the linear
    % indices. 
    indj = randperm(numel(M)) ;
else        

    nb = sizM ./ S ;  % how many blocks in each dimension, this should be an integer  
    B = cell(NdimM,1) ;
    % for each dimension of M: 
    for i=1:NdimM,
        % check if the number of blocks is an integer
        if nb(i) ~= fix(nb(i)), 
            error(['Size mismatch: the size of the matrix M (= %d) in dimension %d\n' ...
                    'is not an integer number of times the specified blocksize (= %d).'],...
                sizM(i),i,S(i)) ;
        else
            % expand the size in that dimension. B is used for mat2cell
            B{i} = repmat(S(i),1,nb(i)) ;
        end
    end
       
    % M can be a numerical or cell array. By randomizing the (linear)
    % indices, we do not have to worry about the actual contents of M.    
    indj = reshape(1:numel(M),sizM) ; 
    % convert to a cell array. Each cell contains a block.
    C = mat2cell(indj,B{:}) ;         
    % randomize the order of the cells
    C(randperm(numel(C))) = C ;      
    % convert back from cell array
    indj = cell2mat(C) ;              
end

% use these randomized block indices to shuffle M
M(indj) = M ;                         

if nargout>1,    
    indi(indj) = 1:numel(indj) ; 
    indi = reshape(indi,sizM) ;
    indj = reshape(indj,sizM) ;
end



