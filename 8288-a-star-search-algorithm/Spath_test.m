clear;
noOfNodes  = 100;
%rand('state', 0);
plot_flag = 1;
if plot_flag==1
    figure(1);
    clf;
    hold on;
end
L = 1000; % size of the whole area
R = 300; % maximum range;

s = 1; % source id
d = 10; % destination id

netXloc = double(rand(1,noOfNodes)*L);
netYloc = double(rand(1,noOfNodes)*L);
%netXloc = [0 1 0 1];
%netYloc = [0 0 1 1];
Astar_connect = zeros(noOfNodes, noOfNodes);
Astar_coord = zeros(noOfNodes, 2);
for i = 1:noOfNodes
    if plot_flag==1
        plot(netXloc(i), netYloc(i), '.');
    end
    Astar_coord(i,1) = netXloc(i);
    Astar_coord(i,2) = netYloc(i);
    if plot_flag == 1
        %text(netXloc(i), netYloc(i), num2str(i));
    end
    for j = 1:noOfNodes
        distance = sqrt((netXloc(i) - netXloc(j))^2 + (netYloc(i) - netYloc(j))^2);
        if distance <= R
            matrix(i, j) = distance;   % if set to '1', Dijkstra computes Spath in terms of hops; if set to 'distance', it is the real shortest path
            if i~=j % must be satisfied
                Astar_connect(i, j) = 1;
            else
                Astar_connect(i, j) = 0;
            end
            if plot_flag==1
                %line([netXloc(i) netXloc(j)], [netYloc(i) netYloc(j)], 'LineStyle', ':');
            end
        else
            matrix(i, j) = inf;
            Astar_connect(i, j) = 0;
        end;
    end;
end;


activeNodes = [];
for i = 1:noOfNodes,
    % initialize the farthest node to be itself;
    farthestPreviousHop(i) = i;     % used to compute the RTS/CTS range;
    farthestNextHop(i) = i;
end;

Astar_coord;
Astar_connect;

[path, totalCost, farthestPreviousHop, farthestNextHop] = dijkstra(noOfNodes, matrix, s, d, farthestPreviousHop, farthestNextHop);
combo = [noOfNodes s-1 d-1 R/2];
[Astar_path, Astar_search] = Astar(Astar_coord', Astar_connect, combo); % notice, we must put Astar_coord' rather than Astar_coord
path
totalCost
Astar_path
Astar_search
if length(path) ~= 0
    for i = 1:(length(path)-1)
        if plot_flag==1
            line([netXloc(path(i)) netXloc(path(i+1))], [netYloc(path(i)) netYloc(path(i+1))], 'Color','g','LineWidth', 2.50, 'LineStyle', '-.');
            text(netXloc(i), netYloc(i), num2str(i));
        end    
    end;
end;

if length(Astar_path) ~= 0
    for i = 1:(length(Astar_path)-1)
        if plot_flag==1
            line([netXloc(Astar_path(i)) netXloc(Astar_path(i+1))], [netYloc(Astar_path(i)) netYloc(Astar_path(i+1))], 'Color','r','LineWidth', 2.50, 'LineStyle', '-.');
            text(netXloc(i), netYloc(i), num2str(i));
        end    
    end;
end;
if plot_flag == 1
    hold off;
end
return;
    