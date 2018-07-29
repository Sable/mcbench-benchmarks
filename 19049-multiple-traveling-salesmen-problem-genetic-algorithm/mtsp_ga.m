% MTSP_GA Multiple Traveling Salesmen Problem (M-TSP) Genetic Algorithm (GA)
%   Finds a (near) optimal solution to the M-TSP by setting up a GA to search
%   for the shortest route (least distance needed for the salesmen to travel
%   to each city exactly once and return to their starting locations)
%
% Summary:
%     1. Each salesman travels to a unique set of cities and completes the
%        route by returning to the city he started from
%     2. Each city is visited by exactly one salesman
%
% Input:
%     XY (float) is an Nx2 matrix of city locations, where N is the number of cities
%     DMAT (float) is an NxN matrix of city-to-city distances or costs
%     NSALESMEN (scalar integer) is the number of salesmen to visit the cities
%     MINTOUR (scalar integer) is the minimum tour length for any of the salesmen
%     POPSIZE (scalar integer) is the size of the population (should be divisible by 8)
%     NUMITER (scalar integer) is the number of desired iterations for the algorithm to run
%     SHOWPROG (scalar logical) shows the GA progress if true
%     SHOWRESULT (scalar logical) shows the GA results if true
%
% Output:
%     OPTROUTE (integer array) is the best route found by the algorithm
%     OPTBREAK (integer array) is the list of route break points (these specify the indices
%         into the route used to obtain the individual salesman routes)
%     MINDIST (scalar float) is the total distance traveled by the salesmen
%
% Route/Breakpoint Details:
%     If there are 10 cities and 3 salesmen, a possible route/break
%     combination might be: rte = [5 6 9 1 4 2 8 10 3 7], brks = [3 7]
%     Taken together, these represent the solution [5 6 9][1 4 2 8][10 3 7],
%     which designates the routes for the 3 salesmen as follows:
%         . Salesman 1 travels from city 5 to 6 to 9 and back to 5
%         . Salesman 2 travels from city 1 to 4 to 2 to 8 and back to 1
%         . Salesman 3 travels from city 10 to 3 to 7 and back to 10
%
% Example:
%     n = 35;
%     xy = 10*rand(n,2);
%     nSalesmen = 5;
%     minTour = 3;
%     popSize = 80;
%     numIter = 5e3;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,optBreak,minDist] = mtsp_ga(xy,dmat,nSalesmen,minTour, ...
%         popSize,numIter,1,1);
%
% Example:
%     n = 50;
%     phi = (sqrt(5)-1)/2;
%     theta = 2*pi*phi*(0:n-1);
%     rho = (1:n).^phi;
%     [x,y] = pol2cart(theta(:),rho(:));
%     xy = 10*([x y]-min([x;y]))/(max([x;y])-min([x;y]));
%     nSalesmen = 5;
%     minTour = 3;
%     popSize = 80;
%     numIter = 1e4;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,optBreak,minDist] = mtsp_ga(xy,dmat,nSalesmen,minTour, ...
%         popSize,numIter,1,1);
%
% Example:
%     n = 35;
%     xyz = 10*rand(n,3);
%     nSalesmen = 5;
%     minTour = 3;
%     popSize = 80;
%     numIter = 5e3;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xyz(a,:)-xyz(a',:)).^2,2)),n,n);
%     [optRoute,optBreak,minDist] = mtsp_ga(xyz,dmat,nSalesmen,minTour, ...
%         popSize,numIter,1,1);
%
% See also: tsp_ga, mtspf_ga, mtspo_ga, mtspof_ga, mtspofs_ga, mtspv_ga, distmat
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 1.5
% Release Date: 11/07/11
function varargout = mtsp_ga(xy,dmat,nSalesmen,minTour,popSize,numIter,showProg,showResult)

% Process Inputs and Initialize Defaults
nargs = 8;
for k = nargin:nargs-1
    switch k
        case 0
            xy = 10*rand(40,2);
        case 1
            N = size(xy,1);
            a = meshgrid(1:N);
            dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),N,N);
        case 2
            nSalesmen = 5;
        case 3
            minTour = 3;
        case 4
            popSize = 80;
        case 5
            numIter = 5e3;
        case 6
            showProg = 1;
        case 7
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
nSalesmen = max(1,min(n,round(real(nSalesmen(1)))));
minTour = max(1,min(floor(n/nSalesmen),round(real(minTour(1)))));
popSize = max(8,8*ceil(popSize(1)/8));
numIter = max(1,round(real(numIter(1))));
showProg = logical(showProg(1));
showResult = logical(showResult(1));

% Initializations for Route Break Point Selection
nBreaks = nSalesmen-1;
dof = n - minTour*nSalesmen;          % degrees of freedom
addto = ones(1,dof+1);
for k = 2:nBreaks
    addto = cumsum(addto);
end
cumProb = cumsum(addto)/sum(addto);

% Initialize the Populations
popRoute = zeros(popSize,n);         % population of routes
popBreak = zeros(popSize,nBreaks);   % population of breaks
popRoute(1,:) = (1:n);
popBreak(1,:) = rand_breaks();
for k = 2:popSize
    popRoute(k,:) = randperm(n);
    popBreak(k,:) = rand_breaks();
end

% Select the Colors for the Plotted Routes
pclr = ~get(0,'DefaultAxesColor');
clr = [1 0 0; 0 0 1; 0.67 0 1; 0 1 0; 1 0.5 0];
if nSalesmen > 5
    clr = hsv(nSalesmen);
end

% Run the GA
globalMin = Inf;
totalDist = zeros(1,popSize);
distHistory = zeros(1,numIter);
tmpPopRoute = zeros(8,n);
tmpPopBreak = zeros(8,nBreaks);
newPopRoute = zeros(popSize,n);
newPopBreak = zeros(popSize,nBreaks);
if showProg
    pfig = figure('Name','MTSP_GA | Current Best Solution','Numbertitle','off');
end
for iter = 1:numIter
    % Evaluate Members of the Population
    for p = 1:popSize
        d = 0;
        pRoute = popRoute(p,:);
        pBreak = popBreak(p,:);
        rng = [[1 pBreak+1];[pBreak n]]';
        for s = 1:nSalesmen
            d = d + dmat(pRoute(rng(s,2)),pRoute(rng(s,1)));
            for k = rng(s,1):rng(s,2)-1
                d = d + dmat(pRoute(k),pRoute(k+1));
            end
        end
        totalDist(p) = d;
    end

    % Find the Best Route in the Population
    [minDist,index] = min(totalDist);
    distHistory(iter) = minDist;
    if minDist < globalMin
        globalMin = minDist;
        optRoute = popRoute(index,:);
        optBreak = popBreak(index,:);
        rng = [[1 optBreak+1];[optBreak n]]';
        if showProg
            % Plot the Best Route
            figure(pfig);
            for s = 1:nSalesmen
                rte = optRoute([rng(s,1):rng(s,2) rng(s,1)]);
                if dims > 2, plot3(xy(rte,1),xy(rte,2),xy(rte,3),'.-','Color',clr(s,:));
                else plot(xy(rte,1),xy(rte,2),'.-','Color',clr(s,:)); end
                title(sprintf('Total Distance = %1.4f, Iteration = %d',minDist,iter));
                hold on
            end
            hold off
        end
    end

    % Genetic Algorithm Operators
    randomOrder = randperm(popSize);
    for p = 8:8:popSize
        rtes = popRoute(randomOrder(p-7:p),:);
        brks = popBreak(randomOrder(p-7:p),:);
        dists = totalDist(randomOrder(p-7:p));
        [ignore,idx] = min(dists); %#ok
        bestOf8Route = rtes(idx,:);
        bestOf8Break = brks(idx,:);
        routeInsertionPoints = sort(ceil(n*rand(1,2)));
        I = routeInsertionPoints(1);
        J = routeInsertionPoints(2);
        for k = 1:8 % Generate New Solutions
            tmpPopRoute(k,:) = bestOf8Route;
            tmpPopBreak(k,:) = bestOf8Break;
            switch k
                case 2 % Flip
                    tmpPopRoute(k,I:J) = tmpPopRoute(k,J:-1:I);
                case 3 % Swap
                    tmpPopRoute(k,[I J]) = tmpPopRoute(k,[J I]);
                case 4 % Slide
                    tmpPopRoute(k,I:J) = tmpPopRoute(k,[I+1:J I]);
                case 5 % Modify Breaks
                    tmpPopBreak(k,:) = rand_breaks();
                case 6 % Flip, Modify Breaks
                    tmpPopRoute(k,I:J) = tmpPopRoute(k,J:-1:I);
                    tmpPopBreak(k,:) = rand_breaks();
                case 7 % Swap, Modify Breaks
                    tmpPopRoute(k,[I J]) = tmpPopRoute(k,[J I]);
                    tmpPopBreak(k,:) = rand_breaks();
                case 8 % Slide, Modify Breaks
                    tmpPopRoute(k,I:J) = tmpPopRoute(k,[I+1:J I]);
                    tmpPopBreak(k,:) = rand_breaks();
                otherwise % Do Nothing
            end
        end
        newPopRoute(p-7:p,:) = tmpPopRoute;
        newPopBreak(p-7:p,:) = tmpPopBreak;
    end
    popRoute = newPopRoute;
    popBreak = newPopBreak;
end

if showResult
% Plots
    figure('Name','MTSP_GA | Results','Numbertitle','off');
    subplot(2,2,1);
    if dims > 2, plot3(xy(:,1),xy(:,2),xy(:,3),'.','Color',pclr);
    else plot(xy(:,1),xy(:,2),'.','Color',pclr); end
    title('City Locations');
    subplot(2,2,2);
    imagesc(dmat(optRoute,optRoute));
    title('Distance Matrix');
    subplot(2,2,3);
    rng = [[1 optBreak+1];[optBreak n]]';
    for s = 1:nSalesmen
        rte = optRoute([rng(s,1):rng(s,2) rng(s,1)]);
        if dims > 2, plot3(xy(rte,1),xy(rte,2),xy(rte,3),'.-','Color',clr(s,:));
        else plot(xy(rte,1),xy(rte,2),'.-','Color',clr(s,:)); end
        title(sprintf('Total Distance = %1.4f',minDist));
        hold on;
    end
    subplot(2,2,4);
    plot(distHistory,'b','LineWidth',2);
    title('Best Solution History');
    set(gca,'XLim',[0 numIter+1],'YLim',[0 1.1*max([1 distHistory])]);
end

% Return Outputs
if nargout
    varargout{1} = optRoute;
    varargout{2} = optBreak;
    varargout{3} = minDist;
end

    % Generate Random Set of Break Points
    function breaks = rand_breaks()
        if minTour == 1 % No Constraints on Breaks
            tmpBreaks = randperm(n-1);
            breaks = sort(tmpBreaks(1:nBreaks));
        else % Force Breaks to be at Least the Minimum Tour Length
            nAdjust = find(rand < cumProb,1)-1;
            spaces = ceil(nBreaks*rand(1,nAdjust));
            adjust = zeros(1,nBreaks);
            for kk = 1:nBreaks
                adjust(kk) = sum(spaces == kk);
            end
            breaks = minTour*(1:nBreaks) + cumsum(adjust);
        end
    end
end

