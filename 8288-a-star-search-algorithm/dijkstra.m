function [path, totalCost, farthestPreviousHop, farthestNextHop] = dijkstra(n, netCostMatrix, s, d, farthestPreviousHop, farthestNextHop)
% path: the list of nodes in the path from source to destination;
% totalCost: the total cost of the path;
% farthestNode: the farthest node to reach for each node after performing
% the routing;
% n: the number of nodes in the network;
% s: source node index;
% d: destination node index;


% clear;
% noOfNodes  = 50;
% rand('state', 0);
% figure(1);
% clf;
% hold on;
% L = 1000;
% R = 200; % maximum range;
% netXloc = rand(1,noOfNodes)*L;
% netYloc = rand(1,noOfNodes)*L;
% for i = 1:noOfNodes
%     plot(netXloc(i), netYloc(i), '.');
%     text(netXloc(i), netYloc(i), num2str(i));
%     for j = 1:noOfNodes
%         distance = sqrt((netXloc(i) - netXloc(j))^2 + (netYloc(i) - netYloc(j))^2);
%         if distance <= R
%             matrix(i, j) = 1;   % there is a link;
%             line([netXloc(i) netXloc(j)], [netYloc(i) netYloc(j)], 'LineStyle', ':');
%         else
%             matrix(i, j) = inf;
%         end;
%     end;
% end;
% 
% 
% activeNodes = [];
% for i = 1:noOfNodes,
%     % initialize the farthest node to be itself;
%     farthestPreviousHop(i) = i;     % used to compute the RTS/CTS range;
%     farthestNextHop(i) = i;
% end;
% 
% [path, totalCost, farthestPreviousHop, farthestNextHop] = dijkstra(noOfNodes, matrix, 1, 15, farthestPreviousHop, farthestNextHop);
% path
% totalCost
% if length(path) ~= 0
%     for i = 1:(length(path)-1)
%         line([netXloc(path(i)) netXloc(path(i+1))], [netYloc(path(i)) netYloc(path(i+1))], 'Color','r','LineWidth', 0.50, 'LineStyle', '-.');
%     end;
% end;
% hold off;
% return;
    

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all the nodes are un-visited;
visited(1:n) = 0;

distance(1:n) = inf;    % it stores the shortest distance between each node and the source node;
parent(1:n) = 0;

distance(s) = 0;
Dijkstra_search = 0;
for i = 1:(n-1),
    Dijkstra_search = Dijkstra_search + 1;
    temp = [];
    for h = 1:n,
         if visited(h) == 0   % in the tree;
             temp=[temp distance(h)];
         else
             temp=[temp inf];
         end
     end;
     [t, u] = min(temp);    % it starts from node with the shortest distance to the source;
     visited(u) = 1;       % mark it as visited;
     if u == d
         break;
     end
     for v = 1:n,           % for each neighbors of node u;
         if ( ( netCostMatrix(u, v) + distance(u)) < distance(v) )
             distance(v) = distance(u) + netCostMatrix(u, v);   % update the shortest distance when a shorter path is found;
             parent(v) = u;                                     % update its parent;
         end;             
     end;
end;

path = [];
if parent(d) ~= 0   % if there is a path!
    t = d;
    path = [d];
    while t ~= s
        p = parent(t);
        path = [p path];
        
        if netCostMatrix(t, farthestPreviousHop(t)) < netCostMatrix(t, p)
            farthestPreviousHop(t) = p;
        end;
        if netCostMatrix(p, farthestNextHop(p)) < netCostMatrix(p, t)
            farthestNextHop(p) = t;
        end;

        t = p;      
    end;
end;

totalCost = distance(d);
Dijkstra_search

return;