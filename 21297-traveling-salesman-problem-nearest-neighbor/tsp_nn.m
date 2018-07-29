%TSP_NN Traveling Salesman Problem (TSP) Nearest Neighbor (NN) Algorithm
%   The Nearest Neighbor algorithm produces different results depending on
%   which city is selected as the starting point. This function determines
%   the Nearest Neighbor routes for multiple starting points and returns
%   the best of those routes
%
% Summary:
%     1. A single salesman travels to each of the cities and completes the
%        route by returning to the city he started from
%     2. Each city is visited by the salesman exactly once
%
% Input:
%     XY (float) is an Nx2 matrix of city locations, where N is the number of cities
%     DMAT (float) is an NxN matrix of point to point distances/costs
%     POPSIZE (scalar integer) is the size of the population (should be <= N)
%     SHOWPROG (scalar logical) shows the GA progress if true
%     SHOWRESULT (scalar logical) shows the GA results if true
%
% Output:
%     OPTROUTE (integer array) is the best route found by the algorithm
%     MINDIST (scalar float) is the cost of the best route
%
% Example:
%     n = 50;
%     xy = 10*rand(n,2);
%     popSize = n;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tsp_nn(xy,dmat,popSize,showProg,showResult);
%
% Example:
%     n = 100;
%     phi = (sqrt(5)-1)/2;
%     theta = 2*pi*phi*(0:n-1);
%     rho = (1:n).^phi;
%     [x,y] = pol2cart(theta(:),rho(:));
%     xy = 10*([x y]-min([x;y]))/(max([x;y])-min([x;y]));
%     popSize = n;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tsp_nn(xy,dmat,popSize,showProg,showResult);
%
% Example:
%     n = 50;
%     xyz = 10*rand(n,3);
%     popSize = n;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xyz(a,:)-xyz(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tsp_nn(xyz,dmat,popSize,showProg,showResult);
%
% See also: tsp_ga, tspo_ga, tspof_ga, tspofs_ga, distmat
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 1.3
% Release Date: 11/07/11
function varargout = tsp_nn(xy,dmat,popSize,showProg,showResult)

% Process Inputs and Initialize Defaults
nargs = 5;
for k = nargin:nargs-1
    switch k
        case 0
            xy = 10*rand(100,2);
        case 1
            N = size(xy,1);
            a = meshgrid(1:N);
            dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),N,N);
        case 2
            N = size(xy,1);
            popSize = N;
        case 3
            showProg = 1;
        case 4
            showResult = 1;
        otherwise
    end
end

% Verify Inputs
[N,dims] = size(xy);
[nr,nc] = size(dmat);
if N ~= nr || N ~= nc
    error('Invalid XY or DMAT inputs!')
end
n = N;

% Sanity Checks
popSize = max(1,min(n,round(real(popSize(1)))));
showProg = logical(showProg(1));
showResult = logical(showResult(1));

% Initialize the Population
pop = zeros(popSize,n);

% Run the NN
distHistory = zeros(1,popSize);
if showProg
    pfig = figure('Name','TSP_NN | Current Solution','Numbertitle','off');
end
for p = 1:popSize
    d = 0;
    thisRte = zeros(1,n);
    visited = zeros(1,n);
    I = p;
    visited(I) = 1;
    thisRte(1) = I;
    for k = 2:n
        dists = dmat(I,:);
        dists(logical(visited)) = NaN;
        dMin = min(dists(~visited));
        J = find(dists == dMin,1);
        visited(J) = 1;
        thisRte(k) = J;
        d = d + dmat(I,J);
        I = J;
    end
    d = d + dmat(I,p);
    pop(p,:) = thisRte;
    distHistory(p) = d;

    if showProg
        % Plot the Current Route
        figure(pfig);
        rte = thisRte([1:n 1]);
        if dims > 2, plot3(xy(rte,1),xy(rte,2),xy(rte,3),'r.-');
        else plot(xy(rte,1),xy(rte,2),'r.-'); end
        title(sprintf('Total Distance = %1.4f',distHistory(p)));
    end
end

% Find the Minimum Distance Route
[minDist,index] = min(distHistory);
optRoute = pop(index,:);

if showResult
    % Plot the Best Route
    figure(pfig);
    rte = optRoute([1:n 1]);
    if dims > 2, plot3(xy(rte,1),xy(rte,2),xy(rte,3),'r.-');
    else plot(xy(rte,1),xy(rte,2),'r.-'); end
    title(sprintf('Total Distance = %1.4f',minDist));
    % Plots the NN Results
    figure('Name','TSP_NN | Results','Numbertitle','off');
    subplot(2,2,1);
    pclr = ~get(0,'DefaultAxesColor');
    if dims > 2, plot3(xy(:,1),xy(:,2),xy(:,3),'.','Color',pclr);
    else plot(xy(:,1),xy(:,2),'.','Color',pclr); end
    title('City Locations');
    subplot(2,2,2);
    imagesc(dmat(optRoute,optRoute));
    title('Distance Matrix');
    subplot(2,2,3);
    rte = optRoute([1:n 1]);
    if dims > 2, plot3(xy(rte,1),xy(rte,2),xy(rte,3),'r.-');
    else plot(xy(rte,1),xy(rte,2),'r.-'); end
    title(sprintf('Total Distance = %1.4f',minDist));
    subplot(2,2,4);
    plot(sort(distHistory,'descend'),'b','LineWidth',2);
    title('Distances');
    set(gca,'XLim',[0 popSize+1],'YLim',[0 1.1*max([1 distHistory])]);
end

% Return Outputs
if nargout
    varargout{1} = optRoute;
    varargout{2} = minDist;
    varargout{3} = pop;
end
