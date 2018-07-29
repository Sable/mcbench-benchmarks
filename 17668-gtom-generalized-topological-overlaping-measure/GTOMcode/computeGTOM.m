%COMPUTEGTOM computes the generalized overlaping measure algorithm (GTOM) [1]
%   Joaquin Goñi <jgoni@unav.es> & Iñigo Martincorena
%   <imartincore@alumni.unav.es>
%   University of Navarra - Dpt. of Physics and Applied Mathematics &
%   Centre for Applied Medical Research. Pamplona (Spain).
%   
%   November 22nd, 2007
%
%   [GTOM] = computeGTOM(adj,numSteps) for MxM adjacency matrix adj, it
%   computes the MxM GTOM matrix for the given number of steps numSteps. 
%   In particular, when numSteps equals to 1, GTOM matches with TOM [2]
%   (topological overlaping measure).
%   
%   Adjacency matrix adj must be symmetric with zeros along the diagonal
%
%   Example:
%
%       [GTOM0] = computeGTOM(adj,0) returns de input adjacency matrix adj
%       [GTOM1] = computeGTOM(adj,1) returns the topological overlaping measure (TOM), which matches with 1-step GTOM (GTOM1).
%       [GTOM2] = computeGTOM(adj,2) returns 2-steps GTOM (GTOM2)
%
%   References
%   GTOM [1] Yip A, Horvath S (2007) Gene network interconnectedness and the generalized topological overlap measure BMC Bioinformatics 2007, 8:22
%   TOM  [2] Ravasz E. et al. (2002) Hierarchical Organization of Modularity in Metabolic Networks Science 297 (5586), 1551.

function [GTOM,bm]=computeGTOM(adj,numSteps)

bm=adj; %initial state for bm matrix;
bmAux=bm;
numNodes = size(adj,1);

if (numSteps > numNodes)
    disp('warning, reached maximum value for numSteps. numSteps reduced to adj-size')
    numSteps = numNodes;
end

if (numSteps == 0)
    GTOM = adj; %GTOM0

else

    for steps = 2:numSteps    %step1 is just TOM (known as GTOM1)
        for i = 1:numNodes                   
            [neighRow,neighColumn] = find(bm(i,:)==1);    %neighbours of node i          
            [neighNeighRow,neighNeighColumn] = find(bm(neighColumn,:)==1); %neighbours of neighbours of node i
            newNeigh = setdiff(unique(neighNeighColumn),i);
            bmAux(i,newNeigh) = 1;  %neighbours of neighbours of node i become considered node i neighbours
            bmAux(newNeigh,i) = 1;  %keep symmetry of matrix
        end
        bm = bmAux; %bm is updated with new step all at once
    end

    numeratorMatrix = bm*bm + adj + eye(size(adj)); %numerators of GTOM formula
    denominatorMatrix = zeros(numNodes);

    bmSum=sum(bm);  %vector containing degree of each node
    for i=1:numNodes
        denominatorMatrix(i,:) = min(bmSum(i),bmSum) + 1 - adj(i,:);    %denominators of GTOM formula
    end
    GTOM = numeratorMatrix ./ denominatorMatrix;
end












