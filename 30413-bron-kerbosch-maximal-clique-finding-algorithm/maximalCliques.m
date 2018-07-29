function [ MC ] = maximalCliques( A, v_str )
%MAXIMALCLIQUES Find maximal cliques using the Bron-Kerbosch algorithm
%   Given a graph's boolean adjacency matrix, A, find all maximal cliques 
%   on A using the Bron-Kerbosch algorithm in a recursive manner.  The 
%   graph is required to be undirected and must contain no self-edges.
%
%   V_STR is an optional input string with the version of the Bron-Kerbosch 
%   algorithm to be used (either 'v1' or 'v2').  Version 2 is faster (and 
%   default), and version 1 is included for posterity.
%
%   MC is the output matrix that contains the maximal cliques in its 
%   columns.
%
%   Note: This function can be used to compute the maximal independent sets
%   of a graph A by providing the complement of A as the input graph.  
%
%   Note: This function can be used to compute the maximal matchings of a 
%   graph A by providing the complement of the line graph of A as the input
%   graph.
%
%   Ref: Bron, Coen and Kerbosch, Joep, "Algorithm 457: finding all cliques
%   of an undirected graph", Communications of the ACM, vol. 16, no. 9, 
%   pp: 575–577, September 1973.
%
%   Ref: Cazals, F. and Karande, C., "A note on the problem of reporting 
%   maximal cliques", Theoretical Computer Science (Elsevier), vol. 407,
%   no. 1-3, pp: 564-568, November 2008.
%
%   Jeffrey Wildman (c) 2011
%   jeffrey.wildman@gmail.com
%   
%   Updated: 10/27/2011 - updated documentation & removal of ~ punctuation 
%   to ignore function output arguments for better compatibility with older
%   MATLAB versions prior to 2009b (Thanks to Akli Benali).


% first, some input checking

if size(A,1) ~= size(A,2)
    error('MATLAB:maximalCliques', 'Adjacency matrix is not square.');
elseif ~all(all((A==1) | (A==0)))
    error('MATLAB:maximalCliques', 'Adjacency matrix is not boolean (zero-one valued).')
elseif ~all(all(A==A.'))
    error('MATLAB:maximalCliques', 'Adjacency matrix is not undirected (symmetric).')
elseif trace(abs(A)) ~= 0
    error('MATLAB:maximalCliques', 'Adjacency matrix contains self-edges (check your diagonal).');
end
    
if ~exist('v_str','var')
    v_str = 'v2';
end

if ~strcmp(v_str,'v1') && ~strcmp(v_str,'v2')
    warning('MATLAB:maximalCliques', 'Version not recognized, defaulting to v2.');
    v_str = 'v2';
end


% second, set up some variables

n = size(A,2);      % number of vertices
MC = [];            % storage for maximal cliques
R = [];             % currently growing clique
P = 1:n;            % prospective nodes connected to all nodes in R
X = [];             % nodes already processed


% third, run the algorithm!

if strcmp(v_str,'v1')
    BKv1(R,P,X);
else
    BKv2(R,P,X);
end
    

    % version 1 of the Bron-Kerbosch algo 
    function [] = BKv1 ( R, P, X )
        
        if isempty(P) && isempty(X)
            % report R as a maximal clique
            newMC = zeros(1,n);
            newMC(R) = 1;                   % newMC contains ones at indices equal to the values in R   
            MC = [MC newMC.'];
        else
            for u = P
                P = setxor(P,u);
                Rnew = [R u];
                Nu = find(A(u,:));
                Pnew = intersect(P,Nu);
                Xnew = intersect(X,Nu);
                BKv1(Rnew, Pnew, Xnew);
                X = [X u];
            end
        end
        
    end % BKv1


	% version 2 of the Bron-Kerbosch algo
    function [] = BKv2 ( R, P, X )

        ignore = [];                        % less elegant ignore function output variable, but works with older versions of MATLAB: <2009b
        if (isempty(P) && isempty(X))
            % report R as a maximal clique
            newMC = zeros(1,n);
            newMC(R) = 1;                   % newMC contains ones at indices equal to the values in R   
            MC = [MC newMC.'];
        else
            % choose pivot
            ppivots = union(P,X);           % potential pivots
            binP = zeros(1,n);
            binP(P) = 1;                    % binP contains ones at indices equal to the values in P          
            % rows of A(ppivots,:) contain ones at the neighbors of ppivots
            pcounts = A(ppivots,:)*binP.';  % cardinalities of the sets of neighbors of each ppivots intersected with P
            [ignore,ind] = max(pcounts);
            u_p = ppivots(ind);             % select one of the ppivots with the largest count
            
            for u = intersect(find(~A(u_p,:)),P)   % all prospective nodes who are not neighbors of the pivot
                P = setxor(P,u);
                Rnew = [R u];
                Nu = find(A(u,:));
                Pnew = intersect(P,Nu);
                Xnew = intersect(X,Nu);
                BKv2(Rnew, Pnew, Xnew);
                X = [X u];
            end
        end
        
    end % BKv2
       

end % maximalCliques

