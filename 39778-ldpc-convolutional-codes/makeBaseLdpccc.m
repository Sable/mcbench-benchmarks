function H = makeBaseLdpccc(N, numOfOne)
% Create LDPC-CC base parity check matrix
%
%  N        : Matrix dimension (N X N)
%  numOfOne : Number of ones per column or row
%
%  H        : Base LDPC-CC matrix                   
%
% Bagawan S. Nugroho 2007

% Number of ones per column or row
onePerCol = numOfOne;
onePerRow = numOfOne;
   
% Evenboth: For each column and row, place 1s uniformly at random

% Distribute 1s uniformly at random within column
for i = 1:N
   onesInCol(:, i) = randperm(N)';
end
        
% Create non zero elements (1s) index
r = reshape(onesInCol(1:onePerCol, :), N*onePerCol, 1);
tmp = repmat([1:N], onePerCol, 1);
c = reshape(tmp, N*onePerCol, 1);
     
% Make the number of 1s between rows as uniform as possible     
      
% Order row index
[r, ix] = sort(r);
      
% Order column index based on row index
for i = 1:N*onePerCol
   cSort(i, :) = c(ix(i));
end
      
% Create new row index with uniform weight
tmp = repmat([1:N], onePerRow, 1);
r = reshape(tmp, N*onePerCol, 1);
      
% Create sparse matrix H
% Remove any duplicate non zero elements index using logical AND
S = and(sparse(r, cSort, 1, N, N), ones(N, N));
H = full(S);     
      
% Check rows that have no 1 or only have one 1
for i = 1:N
   
   n = randperm(N);
   % Add two 1s if row has no 1
   if length(find(r == i)) == 0
      H(i, n(1)) = 1;
      H(i, n(2)) = 1;
   % Add one 1 if row has only one 1   
   elseif length(find(r == i)) == 1
      H(i, n(1)) = 1;
   end

end % for i

% Add 0/1 bits (see text)
H = [ones(N, 1) H zeros(N, 1)];

fprintf('LDPC-CC base matrix is created.\n');
