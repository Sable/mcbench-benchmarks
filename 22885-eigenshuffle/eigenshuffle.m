function [Vseq,Dseq] = eigenshuffle(Asequence)
% eigenshuffle: Consistent sorting for an eigenvalue/vector sequence
% [Vseq,Dseq] = eigenshuffle(Asequence)
%
% Includes munkres.m (by gracious permission from Yi Cao)
% to choose the appropriate permutation. This greatly
% enhances the speed of eigenshuffle over my previous
% release.
%
% http://www.mathworks.com/matlabcentral/fileexchange/20652
%
% Arguments: (input)
%  Asequence - an array of eigenvalue problems. If
%      Asequence is a 3-d numeric array, then each
%      plane of Asequence must contain a square
%      matrix that will be used to call eig.
%
%      Eig will be called on each of these matrices
%      to produce a series of eigenvalues/vectors,
%      one such set for each eigenvalue problem.
%
% Arguments: (Output)
%  Vseq - a 3-d array (pxpxn) of eigenvectors. Each
%      plane of the array will be sorted into a
%      consistent order with the other eigenvalue
%      problems. The ordering chosen will be one
%      that maximizes the energy of the consecutive
%      eigensystems relative to each other.
%
%  Dseq - pxn array of eigen values, sorted in order
%      to be consistent with each other and with the
%      eigenvectors in Vseq.
%
% Example:
%  Efun = @(t) [1 2*t+1 t^2 t^3;2*t+1 2-t t^2 1-t^3; ...
%               t^2 t^2 3-2*t t^2;t^3 1-t^3 t^2 4-3*t];
%
%  Aseq = zeros(4,4,21);
%  for i = 1:21
%    Aseq(:,:,i) = Efun((i-11)/10);
%  end
%  [Vseq,Dseq] = eigenshuffle(Aseq);
%  
% To see that eigenshuffle has done its work correctly,
% look at the eigenvalues in sequence, after the shuffle.
%
% t = (-1:.1:1)';
% [t,Dseq']
% ans =
%        -1     8.4535           5      2.3447     0.20181
%      -0.9     7.8121      4.7687      2.3728     0.44644
%      -0.8     7.2481        4.56      2.3413     0.65054
%      -0.7     6.7524      4.3648      2.2709      0.8118
%      -0.6     6.3156      4.1751      2.1857     0.92364
%      -0.5     5.9283      3.9855      2.1118     0.97445
%      -0.4     5.5816      3.7931      2.0727     0.95254
%      -0.3     5.2676      3.5976      2.0768       0.858
%      -0.2     4.9791      3.3995      2.1156     0.70581
%      -0.1     4.7109         3.2      2.1742     0.51494
%         0     4.4605           3      2.2391     0.30037
%       0.1     4.2302         2.8      2.2971    0.072689
%       0.2     4.0303      2.5997      2.3303    -0.16034
%       0.3     3.8817      2.4047      2.3064    -0.39272
%       0.4     3.8108      2.1464      2.2628    -0.62001
%       0.5     3.8302      1.8986      2.1111    -0.83992
%       0.6     3.9301      1.5937      1.9298     -1.0537
%       0.7     4.0927      1.2308       1.745     -1.2685
%       0.8     4.3042     0.82515      1.5729     -1.5023
%       0.9     4.5572     0.40389      1.4272     -1.7883
%         1     4.8482  -8.0012e-16     1.3273     -2.1755
%
% Here, the columns are the shuffled eigenvalues.
% See that the second eigenvalue goes to zero, but
% the third eigenvalue remains positive. We can plot
% eigenvalues and see that they have crossed, near
% t = 0.35 in Efun.
%
% plot(-1:.1:1,Dseq')
%
% For a better appreciation of what eigenshuffle did,
% compare the result of eig directly on Efun(.3) and
% Efun(.4). Thus:
%
% [V3,D3] = eig(Efun(.3))
% V3 =
%     -0.74139      0.53464     -0.23551       0.3302
%      0.64781       0.4706     -0.16256      0.57659
%    0.0086542     -0.44236     -0.89119      0.10006
%     -0.17496     -0.54498      0.35197      0.74061
%
% D3 =
%     -0.39272            0            0            0
%            0       2.3064            0            0
%            0            0       2.4047            0
%            0            0            0       3.8817
%
% [V4,D4] = eig(Efun(.4))
% V4 =
%     -0.73026      0.19752      0.49743      0.42459
%      0.66202      0.21373      0.35297      0.62567
%     0.013412     -0.95225      0.25513      0.16717
%     -0.16815    -0.092308     -0.75026      0.63271
%
% D4 =
%     -0.62001            0            0            0
%            0       2.1464            0            0
%            0            0       2.2628            0
%            0            0            0       3.8108
%
% With no sort or shuffle applied, look at V3(:,3). See
% that it is really closest to V4(:,2), but with a sign
% flip. Since the signs on the eigenvectors are arbitrary,
% the sign is changed, and the most consistent sequence
% will be chosen. By way of comparison, see how the
% eigenvectors in Vseq have been shuffled, the signs
% swapped appropriately.
%
% Vseq(:,:,14)
% ans =
%       0.3302      0.23551     -0.53464      0.74139
%      0.57659      0.16256      -0.4706     -0.64781
%      0.10006      0.89119      0.44236   -0.0086542
%      0.74061     -0.35197      0.54498      0.17496
%
% Vseq(:,:,15)
% ans =
%      0.42459     -0.19752     -0.49743      0.73026
%      0.62567     -0.21373     -0.35297     -0.66202
%      0.16717      0.95225     -0.25513    -0.013412
%      0.63271     0.092308      0.75026      0.16815
%
% See also: eig
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 3.0
% Release date: 2/18/09

% Is Asequence a 3-d array?
Asize = size(Asequence);
if (Asize(1)~=Asize(2))
  error('Asequence must be a (pxpxn) array of eigen-problems, each of size pxp')
end
p = Asize(1);
if length(Asize)<3
  n = 1;
else
  n = Asize(3);
end

% the initial eigenvalues/vectors in nominal order
Vseq = zeros(p,p,n);
Dseq = zeros(p,n);
for i = 1:n
  [V,D] = eig(Asequence(:,:,i));
  D = diag(D);
  % initial ordering is purely in decreasing order.
  % If any are complex, the sort is in terms of the
  % real part.
  [junk,tags] = sort(real(D),1,'descend');
  
  Dseq(:,i) = D(tags);
  Vseq(:,:,i) = V(:,tags);
end

% was there only one eigenvalue problem?
if n < 2
  % we can quit now, having sorted the eigenvalues
  % as best as we could.
  return
end

% now, treat each eigenproblem in sequence (after
% the first one.)
for i = 2:n
  % compute distance between systems
  V1 = Vseq(:,:,i-1);
  V2 = Vseq(:,:,i);
  D1 = Dseq(:,i-1);
  D2 = Dseq(:,i);
  dist = (1-abs(V1'*V2)).*sqrt( ...
    distancematrix(real(D1),real(D2)).^2+ ...
    distancematrix(imag(D1),imag(D2)).^2);
  
  % Is there a best permutation? use munkres.
  % much faster than my own mintrace, munkres
  % is used by gracious permission from Yi Cao.
  reorder = munkres(dist);
  
  Vseq(:,:,i) = Vseq(:,reorder,i);
  Dseq(:,i) = Dseq(reorder,i);
  
  % also ensure the signs of each eigenvector pair
  % were consistent if possible
  S = squeeze(real(sum(Vseq(:,:,i-1).*Vseq(:,:,i),1))) < 0;
  Vseq(:,S,i) = -Vseq(:,S,i);
end

% =================
% end mainline
% =================
% begin subfunctions
% =================

function d = distancematrix(vec1,vec2)
% simple interpoint distance matrix
[vec1,vec2] = ndgrid(vec1,vec2);
d = abs(vec1 - vec2);

function [assignment,cost] = munkres(costMat)
% MUNKRES   Munkres (Hungarian) Algorithm for Linear Assignment Problem. 
%
% [ASSIGN,COST] = munkres(COSTMAT) returns the optimal column indices,
% ASSIGN assigned to each row and the minimum COST based on the assignment
% problem represented by the COSTMAT, where the (i,j)th element represents the cost to assign the jth
% job to the ith worker.
%

% This is vectorized implementation of the algorithm. It is the fastest
% among all Matlab implementations of the algorithm.

% Examples
% Example 1: a 5 x 5 example
%{
[assignment,cost] = munkres(magic(5));
disp(assignment); % 3 2 1 5 4
disp(cost); %15
%}
% Example 2: 400 x 400 random data
%{
n=400;
A=rand(n);
tic
[a,b]=munkres(A);
toc                 % about 2 seconds 
%}
% Example 3: rectangular assignment with inf costs
%{
A=rand(10,7);
A(A>0.7)=Inf;
[a,b]=munkres(A);
%}
% Reference:
% "Munkres' Assignment Algorithm, Modified for Rectangular Matrices", 
% http://csclab.murraystate.edu/bob.pilgrim/445/munkres.html

% version 2.0 by Yi Cao at Cranfield University on 10th July 2008

assignment = zeros(1,size(costMat,1));
cost = 0;

costMat(costMat~=costMat)=Inf;
validMat = costMat<Inf;
validCol = any(validMat,1);
validRow = any(validMat,2);

nRows = sum(validRow);
nCols = sum(validCol);
n = max(nRows,nCols);
if ~n
    return
end

maxv=10*max(costMat(validMat));

dMat = zeros(n) + maxv;
dMat(1:nRows,1:nCols) = costMat(validRow,validCol);

%*************************************************
% Munkres' Assignment Algorithm starts here
%*************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   STEP 1: Subtract the row minimum from each row.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
minR = min(dMat,[],2);
minC = min(bsxfun(@minus, dMat, minR));

%**************************************************************************  
%   STEP 2: Find a zero of dMat. If there are no starred zeros in its
%           column or row start the zero. Repeat for each zero
%**************************************************************************
zP = dMat == bsxfun(@plus, minC, minR);

starZ = zeros(n,1);
while any(zP(:))
    [r,c]=find(zP,1);
    starZ(r)=c;
    zP(r,:)=false;
    zP(:,c)=false;
end

while 1
%**************************************************************************
%   STEP 3: Cover each column with a starred zero. If all the columns are
%           covered then the matching is maximum
%**************************************************************************
    if all(starZ>0)
        break
    end
    coverColumn = false(1,n);
    coverColumn(starZ(starZ>0))=true;
    coverRow = false(n,1);
    primeZ = zeros(n,1);
    [rIdx, cIdx] = find(dMat(~coverRow,~coverColumn)==bsxfun(@plus,minR(~coverRow),minC(~coverColumn)));
    while 1
        %**************************************************************************
        %   STEP 4: Find a noncovered zero and prime it.  If there is no starred
        %           zero in the row containing this primed zero, Go to Step 5.  
        %           Otherwise, cover this row and uncover the column containing 
        %           the starred zero. Continue in this manner until there are no 
        %           uncovered zeros left. Save the smallest uncovered value and 
        %           Go to Step 6.
        %**************************************************************************
        cR = find(~coverRow);
        cC = find(~coverColumn);
        rIdx = cR(rIdx);
        cIdx = cC(cIdx);
        Step = 6;
        while ~isempty(cIdx)
            uZr = rIdx(1);
            uZc = cIdx(1);
            primeZ(uZr) = uZc;
            stz = starZ(uZr);
            if ~stz
                Step = 5;
                break;
            end
            coverRow(uZr) = true;
            coverColumn(stz) = false;
            z = rIdx==uZr;
            rIdx(z) = [];
            cIdx(z) = [];
            cR = find(~coverRow);
            z = dMat(~coverRow,stz) == minR(~coverRow) + minC(stz);
            rIdx = [rIdx(:);cR(z)];
            cIdx = [cIdx(:);stz(ones(sum(z),1))];
        end
        if Step == 6
            % *************************************************************************
            % STEP 6: Add the minimum uncovered value to every element of each covered
            %         row, and subtract it from every element of each uncovered column.
            %         Return to Step 4 without altering any stars, primes, or covered lines.
            %**************************************************************************
            [minval,rIdx,cIdx]=outerplus(dMat(~coverRow,~coverColumn),minR(~coverRow),minC(~coverColumn));            
            minC(~coverColumn) = minC(~coverColumn) + minval;
            minR(coverRow) = minR(coverRow) - minval;
        else
            break
        end
    end
    %**************************************************************************
    % STEP 5:
    %  Construct a series of alternating primed and starred zeros as
    %  follows:
    %  Let Z0 represent the uncovered primed zero found in Step 4.
    %  Let Z1 denote the starred zero in the column of Z0 (if any).
    %  Let Z2 denote the primed zero in the row of Z1 (there will always
    %  be one).  Continue until the series terminates at a primed zero
    %  that has no starred zero in its column.  Unstar each starred
    %  zero of the series, star each primed zero of the series, erase
    %  all primes and uncover every line in the matrix.  Return to Step 3.
    %**************************************************************************
    rowZ1 = find(starZ==uZc);
    starZ(uZr)=uZc;
    while rowZ1>0
        starZ(rowZ1)=0;
        uZc = primeZ(rowZ1);
        uZr = rowZ1;
        rowZ1 = find(starZ==uZc);
        starZ(uZr)=uZc;
    end
end

% Cost of assignment
rowIdx = find(validRow);
colIdx = find(validCol);
starZ = starZ(1:nRows);
vIdx = starZ <= nCols;
assignment(rowIdx(vIdx)) = colIdx(starZ(vIdx));
cost = trace(costMat(assignment>0,assignment(assignment>0)));

function [minval,rIdx,cIdx]=outerplus(M,x,y)
[nx,ny]=size(M);
minval=inf;
for r=1:nx
    x1=x(r);
    for c=1:ny
        M(r,c)=M(r,c)-(x1+y(c));
        if minval>M(r,c)
            minval=M(r,c);
        end
    end
end
[rIdx,cIdx]=find(M==minval);


