% Function for converting an adjacency matrix to an incidence matrix
% mInc = adj2inc(mAdj) - conversion from adjacency matrix mAdj to
% incidence matrix mInc
%
% INPUT:    mAdj - adjacency matrix of a graph; if
%                  -- directed    - elements from {-1,0,1}
%                  -- undirected  - elements from {0,1}
% OUTPUT:   mInc - incidence matrix; rows = edges, columns = vertices
%
% example: Graph:   __(v1)<--
%                  /         \_e2/e4_
%               e1|                  |  
%                  \->(v2)-e3->(v3)<-/
%
%          mAdj = [0 1 1
%                  0 0 1
%                  1 0 0];
%                  
%                 v1  v2 v3  <- vertices 
%                  |  |  |
%          mInc = [1 -1  0   <- e1   |
%                  1  0 -1   <- e2   | edges
%                  0  1 -1   <- e3   |
%                 -1  0  1]; <- e4   |
%
% 08 Jul 2009   - created:  Ondrej Sluciak <ondrej.sluciak@nt.tuwien.ac.at>
% 08 Jul 2009   - major speed-up thanks to Wolfgang Schwanghart
% 10 Jul 2009   - self-loops check added + example
% 23 Mar 2011   - warning identifier added + minor comments
% 24 Mar 2011   - faster check for matrix symmetry (minor speed-up)
% 26 Mar 2011   - function renamed to adj2inc() + speed-up
% 06 Jul 2011   - new optional parameter: adj2inc(A,0)= directed, graph,adj2inc(A,1) = undirected graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mInc = adj2inc(mAdj,varargin)

if (~(issparse(mAdj)&& islogical(mAdj)))
    warning('adj2inc:sparseExpected','Adjacency matrix should be sparse and contain only {0,1}');
    mAdj = sparse(logical(mAdj));  
end

vM = size(mAdj);

iN_nodes  = vM(1);

if (iN_nodes < 2)
    error('adj2inc:notEnoughNodes','Graph must contain at least 2 nodes (and one edge)!');
end

if (iN_nodes ~= vM(2))
    error('adj2inc:wrongInput','Input matrix must be square!');
end

if (nnz(diag(mAdj)))
    error('adj2inc:selfLoops','No self-loops are allowed!');
end

if (nargin>2)
    error('adj2inc:wrongInput','Too many input parameters!');
end

if isempty(varargin)                
    bDir = isequal(mAdj,mAdj.');    %if the matrix is symmetric, graph is undirected
else
    bDir = logical(varargin{1});    %don't check the symmetricity,but decide according to the input parameter
end

if (bDir)         % undirected graph
    
    [vNodes1,vNodes2] = find(triu(mAdj));     
    iN_edges = length(vNodes1);

    vEdgesidx = 1:iN_edges;
           
    mInc = sparse([vEdgesidx, vEdgesidx]',... 
               [vNodes1; vNodes2],... 
               true,...                 %logical matrix
               iN_edges,iN_nodes);      
        
else              % directed graph       
    
    [vNodes1,vNodes2] = find(mAdj');     
    iN_edges = length(vNodes1);

    vOnes = ones(iN_edges,1); 
    vEdgesidx = 1:iN_edges;
    
    mInc = sparse([vEdgesidx, vEdgesidx]',... 
               [vNodes1; vNodes2],... 
               [-vOnes; vOnes],... 
               iN_edges,iN_nodes); 
  
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%