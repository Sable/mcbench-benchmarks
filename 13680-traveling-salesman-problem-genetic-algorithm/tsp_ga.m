%TSP_GA Traveling Salesman Problem (TSP) Genetic Algorithm (GA)
%   Finds a (near) optimal solution to the TSP by setting up a GA to search
%   for the shortest route (least distance for the salesman to travel to
%   each city exactly once and return to the starting city)
%
% Summary:
%     1. A single salesman travels to each of the cities and completes the
%        route by returning to the city he started from
%     2. Each city is visited by the salesman exactly once
%
% Input:
%     XY (float) is an Nx2 matrix of city locations, where N is the number of cities
%     DMAT (float) is an NxN matrix of point to point distances/costs
%     POPSIZE (scalar integer) is the size of the population (should be divisible by 4)
%     NUMITER (scalar integer) is the number of desired iterations for the algorithm to run
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
%     popSize = 60;
%     numIter = 1e4;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tsp_ga(xy,dmat,popSize,numIter,showProg,showResult);
%
% Example:
%     n = 100;
%     phi = (sqrt(5)-1)/2;
%     theta = 2*pi*phi*(0:n-1);
%     rho = (1:n).^phi;
%     [x,y] = pol2cart(theta(:),rho(:));
%     xy = 10*([x y]-min([x;y]))/(max([x;y])-min([x;y]));
%     popSize = 60;
%     numIter = 2e4;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tsp_ga(xy,dmat,popSize,numIter,1,1);
%
% Example:
%     n = 50;
%     xyz = 10*rand(n,3);
%     popSize = 60;
%     numIter = 1e4;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xyz(a,:)-xyz(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tsp_ga(xyz,dmat,popSize,numIter,showProg,showResult);
%
% See also: mtsp_ga, tsp_nn, tspo_ga, tspof_ga, tspofs_ga, distmat
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 2.3
% Release Date: 11/07/11
function varargout = tsp_ga(xy,dmat,popSize,numIter,showProg,showResult)

% Process Inputs and Initialize Defaults
nargs = 6;
for k = nargin:nargs-1
    switch k
        case 0
            xy = 10*rand(50,2);
        case 1
            N = size(xy,1);
            a = meshgrid(1:N);
            dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),N,N);
        case 2
            popSize = 100;
        case 3
            numIter = 1e4;
        case 4
            showProg = 1;
        case 5
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
popSize = 4*ceil(popSize/4);
numIter = max(1,round(real(numIter(1))));
showProg = logical(showProg(1));
showResult = logical(showResult(1));

% Initialize the Population
pop = zeros(popSize,n);
pop(1,:) = (1:n);
for k = 2:popSize
    pop(k,:) = randperm(n);
end

% Run the GA
globalMin = Inf;
totalDist = zeros(1,popSize);
distHistory = zeros(1,numIter);
tmpPop = zeros(4,n);
newPop = zeros(popSize,n);
if showProg
    pfig = figure('Name','TSP_GA | Current Best Solution','Numbertitle','off');
end
for iter = 1:numIter
    % Evaluate Each Population Member (Calculate Total Distance)
    for p = 1:popSize
        d = dmat(pop(p,n),pop(p,1)); % Closed Path
        for k = 2:n
            d = d + dmat(pop(p,k-1),pop(p,k));
        end
        totalDist(p) = d;
    end

    % Find the Best Route in the Population
    [minDist,index] = min(totalDist);
    distHistory(iter) = minDist;
    if minDist < globalMin
        globalMin = minDist;
        optRoute = pop(index,:);
        if showProg
            % Plot the Best Route
            figure(pfig);
            rte = optRoute([1:n 1]);
            if dims > 2, plot3(xy(rte,1),xy(rte,2),xy(rte,3),'r.-');
            else plot(xy(rte,1),xy(rte,2),'r.-'); end
            title(sprintf('Total Distance = %1.4f, Iteration = %d',minDist,iter));
        end
    end

    % Genetic Algorithm Operators
    randomOrder = randperm(popSize);
    for p = 4:4:popSize
        rtes = pop(randomOrder(p-3:p),:);
        dists = totalDist(randomOrder(p-3:p));
        [ignore,idx] = min(dists); %#ok
        bestOf4Route = rtes(idx,:);
        routeInsertionPoints = sort(ceil(n*rand(1,2)));
        I = routeInsertionPoints(1);
        J = routeInsertionPoints(2);
        for k = 1:4 % Mutate the Best to get Three New Routes
            tmpPop(k,:) = bestOf4Route;
            switch k
                case 2 % Flip
                    tmpPop(k,I:J) = tmpPop(k,J:-1:I);
                case 3 % Swap
                    tmpPop(k,[I J]) = tmpPop(k,[J I]);
                case 4 % Slide
                    tmpPop(k,I:J) = tmpPop(k,[I+1:J I]);
                otherwise % Do Nothing
            end
        end
        newPop(p-3:p,:) = tmpPop;
    end
    pop = newPop;
end

if showResult
    % Plots the GA Results
    figure('Name','TSP_GA | Results','Numbertitle','off');
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
    plot(distHistory,'b','LineWidth',2);
    title('Best Solution History');
    set(gca,'XLim',[0 numIter+1],'YLim',[0 1.1*max([1 distHistory])]);
end

% Return Outputs
if nargout
    varargout{1} = optRoute;
    varargout{2} = minDist;
end
