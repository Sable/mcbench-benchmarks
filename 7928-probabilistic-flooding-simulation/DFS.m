function [] = DFS(r)
global connMatrix;
global visited;
global xLocation;
global yLocation;
global floodProb;
global savedTransmission;

wait_time = 20000000;

% Get the number of reachable neighbors
neighborNodes = find(connMatrix(r, :) == 1);
% Get the unreached neighbors
neigbborNodes = intersect(neighborNodes, find(visited(:) == 0));
for k = 1:length(neighborNodes),
    line([xLocation(r) xLocation(neighborNodes(k))], [yLocation(r) yLocation(neighborNodes(k))]);
end;
drawnow;
for k = 1:length(neighborNodes),
    if (visited(neighborNodes(k)) == 0), 
        visited(neighborNodes(k)) = 1;
        for i=1:wait_time j=i; end
        floodProb = 9 / length(neighborNodes);
        p = rand;
        if p <= floodProb,
            % broadcast again;
            DFS(neighborNodes(k));
        else
            savedTransmission = savedTransmission + 1;
        end;
    end;
end;
