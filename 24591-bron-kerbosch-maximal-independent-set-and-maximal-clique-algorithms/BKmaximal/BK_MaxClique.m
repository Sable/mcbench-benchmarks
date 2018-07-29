function [ M ] = BK_MaxClique( int_matrix )
%BK_MAXCLIQUE Find maximal cliques using Bron-Kerbosch algorithm
%   Given a graph's interference matrix int_matrix, calculates the 
%   maximal cliques using the Bron-Kerbosch algorithm in a recursive
%   manner.
%   Every column of the returned matrix M corresponds to an maximal 
%   clique. If row i of column j is 1, then vertex i participates in the
%   clique indexed by column j.
%  
%   NOTE: This function is NOT self-contained, and needs BK_MaxIS (in the
%    same package on MatlabCentral) to work.
%
%   Berk Birand (c) 2012
%   http://www.berkbirand.com

no_nodes = size(int_matrix,1);


% Find the complement of the graph
int_new = abs(int_matrix - 1);
int_new(logical(eye(no_nodes))) = zeros(1, no_nodes);

M = BK_MaxIS(int_new);

end

