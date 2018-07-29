function D = dmatrix(P)

% Distance Matrix (Eucledean distance)
% 
% A simple function to calculate the distances of all pairs of points in a 
% given group, as rows of a matrix P. The advantage of this method is that it 
% exhibits a small computational cost. 
%
% Created by Dr. Zacharias Voulgaris, 2009

N = size(P,1);
d(N,N) = 0;

for i = 1:(N-1)
    X = ones((N-i),1)*P(i,:);
    d((i+1):N,i) = sqrt( sum((X - P((i+1):N,:)).^2,2) );
end

D =d + d';
