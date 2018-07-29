% FastFloyd - quickly compute the all pairs shortest path matrix
% 
% Uses a vectorized version of the Flyod-Warshall algorithm
% see: http://en.wikipedia.org/wiki/Floyd_Warshall
% 
% USAGE:
%
% D = FastFloyd(A)
% 
% D - the distance (geodesics, all pairs shortest path, etc.) matrix.
% A - the adjacency matrix, where A(i,j) is the cost for moving from vertex i to
%     vertex j.  If vertex i and vertex j are not connected then A(i,j) should
%     be >= the diameter of the network (Inf works fine).
%      
% EXAMPLE:
% 
% Here I create a random binary matrix and convert it to an integer format. Then
% I take the reciprocal of the matrix so that all non-adjacent pairs get a value
% of Inf.  The result is stored in D.
%
% A = int32(rand(100,100) < 0.05);
% D = FastFloyd(1./A)
%

function D = FastFloyd(D)

	n = size(D, 1);	

	for k=1:n
	
		i2k = repmat(D(:,k), 1, n);
		k2j = repmat(D(k,:), n, 1);
		
		D = min(D, i2k+k2j);
	
	end

end