function brtModel = brtTrain( X, T, leafNum, treeNum, nu )
%BRT Summary of this function goes here
%   Detailed explanation goes here
    
    brtModel = cell(treeNum+1,1);
    
    brtModel{1} = mean(T);
    brtModel{end} = nu;
    estT = zeros( size(T) ); % estimated T from current tree
    previousT = repmat( brtModel{1}, size(T,1), 1 ); % estimated T from current brt
    residualT = zeros( size(T) );
    
    for i=2:treeNum
        fprintf( 'tree num = %d\n', i );
        residualT = T - previousT;
        brtModel{i} = regressionTreeTrain( X, residualT, leafNum );
        
        for j=1:size(T,1)
            estT(j,:) = regressionTreeTest( X(j,:), brtModel{i} );
        end
        previousT = previousT + nu * estT;
    end
end

