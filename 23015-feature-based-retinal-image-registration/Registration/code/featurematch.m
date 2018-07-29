function [P1, P2, P2idx] = featurematch(featuremat1, featuremat2, NumMin, NeighborNum)

% This function matches the best point in the feature matrix

if (nargin == 3)
   NeighborNum = 3; 
end

M1 = size(featuremat1, 1);
M2 = size(featuremat2, 1);
 
errmat = zeros(M1, M2);
idxmat = zeros(M1, M2);
for i=1:M1
    vec1 = featuremat1(i,:);
    for j=1:M2
        vec2 = featuremat2(j,:);
        for k=1:NeighborNum
            vec2 = circshift(vec2, [0, (k-1)*(NeighborNum+2)]);
            tmperr(k)= mean(abs(vec2-vec1));
        end
        [errmat(i,j), idxmat(i,j)]= min(tmperr);
    end
end

% errmat(i,j) (M1 X M2) <==>(j-1)*M1 + i

[errmat, idx]= sort(errmat(:));
seeds = idx(1:NumMin);

P1 = mod(seeds, M1);
P1(find(P1==0))= M1; 
P2 = 1+(seeds-P1)/M1;

idxmat = idxmat(:);
P2idx = idxmat(idx(1:NumMin));