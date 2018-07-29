function [x,y, nblist, tp] = getxy(board, eps)
%#ok<*AGROW>

%% NEW POLYGON
i = 1;
x = zeros(100,1);
y = zeros(100,1);
poly = patch;
while true
    [x(i),y(i)] = ginput(1);
    d = sqrt((x(i) - x(1)).^2 + (y(i) - y(1)).^2);
    if i > 1 && d <= eps
        x(i:end) = [];
        y(i:end) = [];
        break;
    end
    delete(poly);
    poly = patch(x(1:i),y(1:i),[0,0,0]);
    set(poly, 'EdgeColor', [1 0 0], 'Marker', '.', 'MarkerEdgeColor', [0 0 1]);
    i = i+1;
end

tp = ginput(1);

%% GATHER ALL VERTICES
alldata = [];
for i = 1:numel(board)
    alldata = [alldata ; [board(i).xy, i * ones(size(board(i).xy,1),1)]]; 
end

%% WELD CLOSE ONES TOGETHER AND FIND NEIGHBORS
nblist = [];
for i = 1:numel(x)
    for j = 1:size(alldata, 1)
        d = sqrt((x(i) - alldata(j,1)).^2 + (y(i) - alldata(j,2)).^2);
        if d < eps
            x(i) = alldata(j,1);
            y(i) = alldata(j,2);
            nblist = unique([nblist, alldata(j,3)]);
            break;
        end
    end
end

delete(poly);