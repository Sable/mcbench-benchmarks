function A = blktridiag(Amd,Asub,Asup,n)
% BLKTRIDIAG: computes a sparse (block) tridiagonal matrix with n blocks
% usage: A = BLKTRIDIAG(Amd,Asub,Asup,n)  % identical blocks
% usage: A = BLKTRIDIAG(Amd,Asub,Asup)    % a list of distinct blocks
%
% BLKTRIDIAG runs in two distinct modes. The first mode
% supplies three blocks, one for the main diagonal, and
% the super and subdiagonal blocks. These blocks will be
% replicated n times down the main diagonals of the matrix,
% and n-1 times down the sub and super diagonals.
% 
% The second mode is to supply a list of distinct blocks
% for each diagonal, as planes of 3d arrays. No replication
% factor is needed in this mode.
%
% arguments: (input mode 1)
%  Amd  - pxq array, forming the main diagonal blocks
%
%  Asub - pxq array, sub diagonal block
%         Asub must be the same size and shape as Amd
%
%  Asup - pxq array, super diagonal block
%         Asup must be the same size and shape as Amd
%
%  n    - scalar integer, defines the number of blocks
%         When n == 1, only a single block will be formed, A == Amd
%
% arguments: (input mode 2)
%  Amd  - pxqxn array, a list of n distinct pxq arrays
%         Each plane of Amd corresponds to a single block
%         on the main diagonal.
%
%  Asub - pxqx(n-1) array, a list of n-1 distinct pxq arrays,
%         Each plane of Asub corresponds to a single block
%         on the sub-diagonal.
%
%  Asup - pxqx(n-1) array, a list of n-1 distinct pxq arrays,
%         Each plane of Asup corresponds to a single block
%         on the super-diagonal.
%
% Note: the sizes of Amd, Asub, and Asup must be consistent
% with each other, or an error will be generated.
% 
% arguments: (output)
%  A    - (n*p by n*q) SPARSE block tridiagonal array
%         If you prefer that A be full, use A=full(A) afterwards.
%
%
% Example 1:
%  Compute the simple 10x10 tridiagonal matrix, with 2 on the
%  diagonal, -1 on the off diagonal.
%
%  A = blktridiag(2,-1,-1,10);
%
%
% Example 2:
%  Compute the 5x5 lower bi-diagonal matrix, with blocks of
%  [1 1;1 1] on the main diagonal, [2 2;2 2] on the sub-diagonal,
%  and blocks of zeros above.
%
%  A = blktridiag(ones(2),2*ones(2),zeros(2),5);
%
% Example 3:
%  Compute the 3x6 tridiagonal matrix, with non-square blocks
%  that vary along the main diagonal, [2 2] on the sub-diagonal,
%  and [1 1] on the super-diagonal. Note that all blocks must have
%  the same shape.
%
%  A = blktridiag(rand(1,2,3),2*ones(1,2,2),ones(1,2,2));
%
%
% See also: blkdiag, spdiags, diag
%
% Author: John D'Errico
% e-mail address: woodchips@rochester.rr.com
% Release: 4.0
% Original release date: 4/01/06
% Current release date: 12/14/07

% Which mode of operation are we in?
if nargin==4
  % replicated block mode
  
  % verify the inputs in this mode are 2-d arrays.
  if (length(size(Amd))~=2) || ...
     (length(size(Asub))~=2) || ...
     (length(size(Asup))~=2) 
    error 'Inputs must be 2d arrays if a replication factor is provided'
  end
  
  % get block sizes, check for consistency
  [p,q] = size(Amd);
  if isempty(Amd)
    error 'Blocks must be non-empty arrays or scalars'
  end
  if any(size(Amd)~=size(Asub)) || any(size(Amd)~=size(Asup))
    error 'Amd, Asub, Asup are not identical in size'
  end

  if isempty(n) || (length(n)>1) || (n<1) || (n~=floor(n))
    error 'n must be a positive scalar integer'
  end
  
  % scalar inputs?
  % since p and q are integers...
  if (p*q)==1
    if n==1
      A = Amd;
    else
      % faster as Jos points out
      A = spdiags(repmat([Asub Amd Asup],n,1),-1:1,n,n);
    end
    % no need to go any farther
    return
  end
  
  % use sparse. the main diagonal elements of each array are...
  v = repmat(Amd(:),n,1);
  % then the sub and super diagonal blocks.
  if n>1
    % sub-diagonal
    v=[v;repmat(Asub(:),n-1,1)];
    
    % super-diagonal
    v=[v;repmat(Asup(:),n-1,1)];
  end
  
elseif nargin==3
  % non-replicated blocks, supplied as planes of a 3-d array
  
  % get block sizes, check for consistency
  [p,q,n] = size(Amd);
  if isempty(Amd)
    error 'Blocks must be (non-empty) arrays or scalars'
  end
  
  if (p~=size(Asub,1)) || (q~=size(Asub,2)) || (p~=size(Asup,1)) || (q~=size(Asup,2))
    error 'Amd, Asub, Asup do not have the same size blocks'
  end

  if (n>1) && (((n-1) ~= size(Asub,3)) || ((n-1) ~= size(Asup,3)))
    error 'Asub and Asup must each have one less block than Amd'
  end
  
  % scalar inputs?
  if (p*q)==1
    if n==1
      A = Amd(1);
    else
      % best to just use spdiags
      A = spdiags([[Asub(:);0], Amd(:), [0;Asup(:)]],-1:1,n,n);
    end
    % no need to go any farther
    return
  end
  
  % The main diagonal elements
  v = Amd(:);
  % then the sub and super diagonal blocks.
  if n>1
    % sub-diagonal
    v=[v;Asub(:)];

    % super-diagonal
    v=[v;Asup(:)];
  end
else
  % must have 3 or 4 arguments
  error 'Must have either 3 or 4 arguments to BLKTRIDIAG'
end

% now generate the index arrays. first the main diagonal
[ind1,ind2,ind3]=ndgrid(0:p-1,0:q-1,0:n-1);
rind = 1+ind1(:)+p*ind3(:);
cind = 1+ind2(:)+q*ind3(:);
% then the sub and super diagonal blocks.
if n>1
  % sub-diagonal
  [ind1,ind2,ind3]=ndgrid(0:p-1,0:q-1,0:n-2);
  rind = [rind;1+p+ind1(:)+p*ind3(:)];
  cind = [cind;1+ind2(:)+q*ind3(:)];

  % super-diagonal
  rind = [rind;1+ind1(:)+p*ind3(:)];
  cind = [cind;1+q+ind2(:)+q*ind3(:)];
end

% build the final array all in one call to sparse
A = sparse(rind,cind,v,n*p,n*q);

% ====================================
% end mainline
% ====================================

