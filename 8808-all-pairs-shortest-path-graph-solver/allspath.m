% ALLSPATH - solve the All Pairs Shortest Path problem
% 
% Rapidly returns the shortest node-to-node distance along the edges of a
% graph, for all nodes in the graph.
% 
% USAGE: B = allspath(A)
% 
% A = input distance matrix between nodes
% B = shortest path distance matrix between all nodes
% 
% Notes: (1) For a graph with n nodes, A is an n-by-n distance matrix
%            giving the distances between adjacent nodes. Since the
%            distance from point i to point j is the same as the distance
%            from point j to point i, A must be a symmetric matrix
%        (2) The distance from a node to itself can either be entered as
%            zero or infinity. (Either will produce a correct result.) This
%            means that the diagonal elements of the matrix A must all be
%            either zero or infinity.
%        (3) The distance between nodes that are not adjacent to each
%            other must be entered as either zero or infinity. (Either will
%            produce a correct result.) This means that the (i,j) and (j,i)
%            elements of A, where i and j are non-adjacent nodes, must
%            all be either zero or infinity.
%        (4) If the input graph is not "connected," meaning that some
%            nodes cannot be reached from other nodes no matter how
%            many edges are traversed, then the distances between nodes
%            that cannot be connected will be returned as infinite.
%        (5) Distances between a node and itself are returned as zero.
%        (6) This function codifies an original algorithm created by
%            the author.
%        (7) No warranties; use at your own risk.
%        (8) Written by Michael Kleder, October 2005.
%        (9) Modified to remove "pdist" from example, May 2007.
% 
% EXAMPLE:
%
% % nodes:
% xy = [.73 .13;.41 .21;.74 .61;.27 .63;.44 .37;...
%     .93 .58;.68 .45;.21 .04;.8 .65;.5 .2];
% % adjacency matrix:
% A=[ 0 0 0 1 0 1 1 1 0 0
%     0 0 0 1 0 0 0 0 0 0
%     0 0 0 0 0 0 0 0 1 0
%     1 1 0 0 0 0 1 0 0 0
%     0 0 0 0 0 0 0 0 0 1
%     1 0 0 0 0 0 0 0 0 0
%     1 0 0 1 0 0 0 0 1 0
%     1 0 0 0 0 0 0 0 0 0
%     0 0 1 0 0 0 1 0 0 0
%     0 0 0 0 1 0 0 0 0 0];
% % distance matrix:
% [a,b]=ndgrid(1:10);
% x=xy(:,1);y=xy(:,2);A=A.*sqrt((x(a)-x(b)).^2+(y(a)-y(b)).^2);
% clc
% disp('Pairwise Distance Matrix (Nonzero for Adjacent Nodes):')
% disp(num2str(A,3))
% % plot the graph:
% figure;gplot(A,xy);hold on
% % plot node numbers:
% h=[];
% for n=1:10;h(n)=text(xy(n,1),xy(n,2),num2str(n));end
% set(h,'fontsize',16)
% % shortest path distance matrix
% disp(' ')
% disp('All Pairs Shortest Path Matrix for All Nodes:')
% disp(num2str(allspath(A),3))

function B = allspath(A)
B=full(A);
B(B==0)=Inf;
C=ones(size(B));
iter=0;
while any(C(:))
    C=B;
    B=min(B,squeeze(min(repmat(B,[1 1 length(B)])+...
        repmat(permute(B,[1 3 2]),[1 length(B) 1]),[],1)));
    C=B-C;
end
B(logical(eye(length(B))))=0;
return