function [sp, spcost] = dijkstraties(matriz_costo, s, d)
%
% This function is built on the dijkstra.m function written by Jorge
% Ignacia Barrera Alviar (April 2008), available at
% http://www.mathworks.com/matlabcentral/fileexchange under file ID 5550.
% Modification records all ties for shortest path.
%
% The inputs are the same is with the original code. Because the original
% documentation is not clear with respect to the array matriz_costo, 
% matriz_costo is an n x n adjacency matrix where the (i,j) element
% represents the cost of traveling along the edge linking node i to node j. 
% One should not set any elements to 0 (unless your intention is that there 
% is no cost to travel along the corresponding edge). Typically I choose 
% some arbitrarily large number for all elements representing non-edges.
%
% I have also been trying, unsuccessfully, so modify the code so that
% instead of adding the costs of each edge to compute total path costs,
% the cost of traveling along edges e1 and 2 is equal to 1 - (1-coste1)(1-coste2).
% This formulation is useful if the costs represent hazard rates, and the
% goal is find the path that minimizes the probability of loss from node s
% to node d (or maximizes the probability of survival).
%
% My attempt to modify the code in the latter manner is commented out.
% Code to be removed is commented "Switch # (add)" and code to substituted
% in its place is labeled "Switch # (mult)". If one were to output the the 
% prev array, one would see that it isn't
% generated properly which the code switch is performed. However the dist
% vector does appear to be generated correctly.
%
% Any help in getting the code to work properly while computing costs
% as 1 minus the product of survival probabilities  would be greatly 
% appreciated.
%
% -David Blum
%  dmblum@gmail.com
%
%
%
%%%%%%%%%% Original documentation %%%%%%%%%%%%%%%%%%
%
% This is an implementation of the dijkstra´s algorithm, wich finds the 
% minimal cost path between two nodes. It´s supoussed to solve the problem on 
% possitive weighted instances.

% the inputs of the algorithm are:
%farthestNode: the farthest node to reach for each node after performing
% the routing;
% n: the number of nodes in the network;
% s: source node index;
% d: destination node index;

%For information about this algorithm visit:
%http://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

%This implementatios is inspired by the Xiaodong Wang's implememtation of
%the dijkstra's algorithm, available at
%http://www.mathworks.com/matlabcentral/fileexchange
%file ID 5550

%Author: Jorge Ignacio Barrera Alviar. April/2007


n=size(matriz_costo,1);
S(1:n) = 0;     %s, vector, set of visited vectors
dist(1:n) = inf;   % it stores the shortest distance between the source node and any other node;
prev = cell(1,n);
% prev(1:n) = n+1;    % Previous node, informs about the best previous node known to reach each  network node 
prev(1:n) = {n+1};
dist(s) = 0;
counter(1:n) = 1;


while sum(S)~=n
    candidate=[];
    for i=1:n
        if S(i)==0
            candidate=[candidate dist(i)];
        else
            candidate=[candidate inf];
        end
    end
    [u_index u]=min(candidate);
    S(u)=1;
    for i=1:n
       if(dist(u)+matriz_costo(u,i))<dist(i) % SEE DOCUMENTATION Switch 1 (add)
       %if (1 - (1 - dist(u)) * (1 - matriz_costo(u,i))) < dist(i) % SEE DOCUMENTATION Switch 1 (mult)
          % dist(i) = (1 - (1 - dist(u)) * (1 - matriz_costo(u,i))); % SEE DOCUMENTATION Switch 2 (mult)
            dist(i)=dist(u)+matriz_costo(u,i); % SEE DOCUMENTATION switch 2 (add)
            prev(1,i) = {u};
            if counter > 1
                for j=2:counter
                    prev(counter,i) = {NaN};
                end
            end
            counter(i) = 1;
        elseif(dist(u)+matriz_costo(u,i)) == dist(i) % SEE DOCUMENTATION Switch 3 (add)
    %   elseif (1 - (1 - dist(u)) * (1 - matriz_costo(u,i))) == dist(i) % SEE DOCUMENTATION Switch 3 (mult) 
            prev(counter(i)+1,i) = {u};
            counter(i) = counter(i)+1;            
        end
    end
end

% Define a vector to represent how many ties are contained in the prev cell
% array corresponding to each node 

prevcolindex = ones(1,n); 
for i = 1:n
    for j = 2:size(prev,1)
        if isempty(prev{j,i}) == 1
            break;
        else
            prevcolindex(i) = j;
        end
    end
end

% Trace the branches of the path backwards beginning at d using the prev cell array. Record 
% the history of all steps each branch of the shortest path in backpaths cell array. 
% (Each step backwards along any branch in the path trace occupies a new cell in backpaths.)

backpaths = cell(1,1);
backpaths(1,1) = {d};
counters = 1;
counterf = 1;
test = 0;
while all(test == s) == 0 % The stopping criteria is that all remaining active branches (ie step histories that have not yet arrived at s) arrive at s simultaneuously
    test = s;
    for j = counters:counterf
        if backpaths{j}(1) == s 
            continue; % If a step history his already arrived at s, it is skipped
        end
        counterm = length(backpaths);
        for i = 1:prevcolindex(backpaths{j}) % Step backwards along each branch of the shortest path, and record the resulting history in a new cell in backpaths
            backpaths{counterm+i} = cat(2,prev{i,backpaths{j}(1)},backpaths{j});
        end
        test = cat(1,test,prev{i,backpaths{j}(1)});
    end
    counters = 1+counterf;
    counterf = length(backpaths);
end

% Extract the step histories that end (ie begin) at node s, and save them
% to sp (the shortest path array)

sp = cell(1,1);
for i = 1:counterf
    if backpaths{i}(1) == s && isempty(sp{1}) == 1
        sp = backpaths(i);
    elseif backpaths{i}(1) == s && isempty(sp{1}) == 0
        sp = cat(1,sp,backpaths(i));
    end
end

spcost = dist(d);
end