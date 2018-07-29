function [p_min, f_min, iter]=pso(func, numInd, range, n_var, tolerance, numIter, pesoStoc)
% It finds the absolut minimum of a n variables function with the Particle 
% Swarm Optimization Algorithm.
% The input parameters are:
% -func: it's the objective function's handle to minimize
% -numInd: it's the number of the swarm's elements
% -range: it's the range in which the elements must be created
% -n_var: it's the number of function's variables
% -tolerance: it's the tolerance for the stop criterion on the swarm's
% radius
% -numIter: it's the max iterations' number
% -pesoStoc: it's the swarm's movability
%
% The output parameters are:
% -p_min: the minimum point find
% -f_min: the minimum value of the function
% -iter: the number of iterations processed

range_min=range(1); % Range for initial swarm's elements
range_max=range(2);
numVar=n_var; % Number of variables
fOb=func; % Objective function
iter=1; % Number of iteration
ind = range_min + (range_max-range_min).*rand(numInd,n_var); % Initial swarm
k=pesoStoc; % weight of stocastic element

v=zeros(numInd,numVar); % Vector of swarm's velocity

radius=1000; % Initial radius for stop criterion

while iter<numIter && radius>tolerance
    for l=1:numInd
        valF(l,1)=fOb(ind(l,:)); % Fitness function for the swarm
    end
    [valF_ord,index]=sort(valF); % Sort the objective function's values for the swarm and identify the leader
    leader=ind(index(1),:);
    for l=1:size(ind,1) % Calculates the new velocity and positions for all swarm's elements
        fi=rand();
        v(l,:)=(1-(sqrt(k*fi))/2)*v(l,:)+k*fi*(leader-ind(l,:)); % Velocity
        ind(l,:)=ind(l,:)+(1-(sqrt(k*fi))/2)*v(l,:)+(1-k*fi)*(leader-ind(l,:)); % Position
    end
    radius=norm(leader-ind(index(end),:)); % Calculates the new radius
    iter=iter+1; % Increases the number of iteration
end

p_min=ind(1:20,:); % Output variables
f_min=valF_ord(1:20,:);
