function [ Tree ] = regressionTreeTrain( X, T, leafNum )
%REGRESSIONTREEE Summary of this function goes here
%   Detailed explanation goes here

    % leafNum: maximum number of leaf nodes

    Tree.sse = 1;
    Tree.elementIds = 1:size(X,1);
    Tree.type = 1; % 0:non-leaf, 1:leaf
        
    while length(Tree) < 2 * leafNum - 1
        
        % find the current leaf node which has the maximum SSE. splitNodeId
        % is the node which will be further split
        maxSSE=0;
        for j=1:length(Tree)
            if ( maxSSE < Tree(j).sse ) && ( Tree(j).type == 1 )
                maxSSE = Tree(j).sse;
                splitNodeId = j;
            end
        end
                
        % find the best binary splitting function and resultant outputs for
        % each leaf node as well as SSEs
        [ bestIdx, bestThr, leftOutput, rightOutput, bestLeftSSE, bestRightSSE ] = findBestSplit(  X(Tree(splitNodeId).elementIds,:), T(Tree(splitNodeId).elementIds,:), 1.0 );
        
        if bestIdx > length(X(1,:))
            Tree(splitNodeId).elementIds = [];
            Tree(splitNodeId).type = 1;
            continue;
        end
        
        % change split node to "non-leaf" node
        Tree(splitNodeId).idx = bestIdx;
        Tree(splitNodeId).thr = bestThr;
        Tree(splitNodeId).left = length(Tree)+1;
        Tree(splitNodeId).right = length(Tree)+2;
        Tree(splitNodeId).type = 0;
                
        % add left child node
        Tree(length(Tree)+1).output = leftOutput;
        Tree(end).sse = bestLeftSSE;
        Tree(end).elementIds = intersect( Tree(splitNodeId).elementIds, find( X(:,bestIdx) < bestThr ) );
        Tree(end).type = 1;
        
        % add right child node
        Tree(length(Tree)+1).output = rightOutput;
        Tree(end).sse = bestRightSSE;
        Tree(end).elementIds = intersect( Tree(splitNodeId).elementIds, find( X(:,bestIdx) >= bestThr ) );
        Tree(end).type = 1;
              
    end
   
    
end

