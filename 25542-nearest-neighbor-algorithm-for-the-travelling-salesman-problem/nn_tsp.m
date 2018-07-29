%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2009, Aleksandar Jevtic
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the 
%       distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Nearest Neighbor algorithm for the Travelling Salesman Problem



function [shortestPathLength,shortestPath] = nn_tsp(cities)

% cities - two column matrix of type double - contains cities' coordinates
% shortestPath - column vector - optimal soultion city list (ends with the
%                starting city)
% shortestPathLength - scalar - optimal path length


% Oliver 30 TSP
% cities = [
%     54	67
%     54	62
%     37	84
%     41	94
%     2     99
%     7     64
%     25	62
%     22	60
%     18	54
%     4     50
%     13	40
%     18	40
%     24	42
%     25	38
%     44	35
%     41	26
%     45	21
%     58	35
%     62	32
%     82	7
%     91	38
%     83	46
%     71	44
%     64	60
%     68	58
%     83	69
%     87	76
%     74	78
%     71	71
%     58	69];


cities = 100*rand(10,2);

N_cities = size(cities,1);

distances = pdist(cities);
distances = squareform(distances);
distances(distances==0) = realmax;

shortestPathLength = realmax;

for i = 1:N_cities
    
    startCity = i;

    path = startCity;
    
    distanceTraveled = 0;
    distancesNew = distances;
    
    currentCity = startCity; 
    
    for j = 1:N_cities-1
        
        [minDist,nextCity] = min(distancesNew(:,currentCity));
        if (length(nextCity) > 1)
            nextCity = nextCity(1);
        end
        
        path(end+1,1) = nextCity;
        distanceTraveled = distanceTraveled +...
                    distances(currentCity,nextCity);
        
        distancesNew(currentCity,:) = realmax;
        
        currentCity = nextCity;
        
    end
    
    path(end+1,1) = startCity;
    distanceTraveled = distanceTraveled +...
        distances(currentCity,startCity);
    
    if (distanceTraveled < shortestPathLength)
        shortestPathLength = distanceTraveled;
        shortestPath = path; 
    end 
    
end


figure
x_min = min(cities(:,1)) - 3;
x_max = max(cities(:,1)) + 3;
y_min = min(cities(:,2)) - 3;
y_max = max(cities(:,2)) + 3;
plot(cities(:,1),cities(:,2),'bo');
axis([x_min x_max y_min y_max]);
axis equal;
grid on;
hold on;

% plot the shortest path
xd=[];yd=[];
for i = 1:(N_cities+1)
    xd(i)=cities(shortestPath(i),1);
    yd(i)=cities(shortestPath(i),2);
end
line(xd,yd);
title(['Path length = ',num2str(shortestPathLength)]);
hold off;














