function [adj_matr, nd_coord]=waxtop(lambda, alpha, beta, domain) 
% WAXTOP Simulate and plot a random network topology by the method
%   suggested by Waxman (1988):
%   - nodes are a Poisson process in the plane with scaled
%    Lebesgue mean measure 
%   - nodes u and v are connected with probability
%    P(u,v)=alpha*exp(-d(u, v)/(beta*L)),
%    where alpha>0, beta<=1, d(u,v) is Euclidean distance, 
%    L is the maximum distance between any two nodes
%
% [adj_matr, nd_coord] = waxtop(lambda,alpha, beta, domain) 
%
% Inputs: 
%   lambda - intensity of the Poisson process
%   alpha - maximal link probability
%   beta - parameter to control length of the edges. Increased <beta>
%     yields a larger ratio of long edges to short edges
%   domain - bounds for the region. A 4-dimensional vector in
%     the form [x_min x_max y_min y_max]. 
%
% Outputs:
%   adj_matr - adjacency matrix of the graph of the topology
%   nd_coord - coordinates of the nodes

% Authors: R.Gaigalas, I.Kaj
% Detailed documentation at
% http://www.math.uu.se/research/telecom/software
% v1.5 Created 07-Nov-01
%      Modified 23-Nov-05 changed variable names
% 

 if (nargin<4) % default parameter values
   lambda = 0.6; % intensity of the Poisson process
   alpha = 0.4; % parameter for the link probability
   beta = 0.1; % parameter for the link probability
   domain = [0 10 0 10]; % bounds for the "geografical" domain
 end

 xmin = domain(1); 
 xmax = domain(2);
 ymin = domain(3);
 ymax = domain(4);
 clear domain;
   
 % number of points is Poisson distributed 
 % with intensity proportional to the area
 area = (xmax-xmin)*(ymax-ymin); 
 npoints = poissrnd(lambda*area)
% npoints = 20;
 
 % given the number of points, nodes are uniformly distributed
 nd_coord = rand(npoints, 2);
 nd_coord(:, 1) = nd_coord(:, 1)*(xmax-xmin)+xmin;
 nd_coord(:, 2) = nd_coord(:, 2)*(ymax-ymin)+ymin;
 
 % create a matrix with all possible distances
 x_rep = repmat(nd_coord(:, 1), 1, npoints);
 y_rep = repmat(nd_coord(:, 2), 1, npoints);
 dist_matr = sparse(triu(((x_rep-x_rep').^2 + ...
                          (y_rep-y_rep').^2).^0.5, 1));
 
 % create the matrix of probabilities
 prob_matr = alpha*spfun('exp', ...
                   -dist_matr./(beta*max(max(dist_matr))));

 % generate the adjacency matrix
 runi = sprand(dist_matr);
 adj_matr = (runi>0) & (runi < prob_matr);

 % test for connectivity
% s_matr = speye(size(adj_matr));
% for i=1:npoints-1
%   s_matr = s_matr+adj_matr^i;
% end
% length(find(s_matr==0))
 
 % plot the network
 figure(1);
 clf;
 hold on;
 plot(nd_coord(:, 1), nd_coord(:, 2), '.');
 gplot(adj_matr, nd_coord);
 hold off;
