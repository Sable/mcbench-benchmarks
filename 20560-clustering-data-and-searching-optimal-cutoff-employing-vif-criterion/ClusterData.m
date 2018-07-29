%% Performs clustering data and finds optimal cutoff using VIF criterion
function[ClusterTree, Cutoff] = ClusterData(data, method, VIF, cutoff)

% Performs hierarchical clustering of data using specified method and
% seraches for optimal cutoff (if cutoff = 1) empoying VIF criterion.
% Namely, it searches cutoff where groups are independent.
% The techinque uses an econometric approach of verifying that variables in
% multiple regression are linearly independent: if all the diagonal
% elements of inverse correlation matrix of data are less than VIF (as
% rule of thumb VIF=10).
% Searching procedure is the variaition of bisection method, so it's
% complexity is log(n) at most. At each iteration it chooses one item
% from every clusters, constructs correlation matrix of these items and
% look at diagonal element of its inverse (calculating 'VIF factor').
%
% Input:
% data: data matrix to cluster;
% method: method used in linkage() function;
% VIF: value of VIF criterion;
% cutoff: searches cutoff if 1.

    % Check input
    if nargin < 4,
        error('ClusterData:missingInput','Enter all the input parameters..')
    end

    % Cluster data
    y = pdist(data', 'correlation');
    y = (y*2).^ 0.5;
    
    ClusterTree = linkage(y, method); 
    
    % Find optimal cutoff
    if cutoff == 1
        y = 1 - squareform((y.^ 2) / 2);
        n = size(ClusterTree, 1);
    
        % Recursive proc
        Cutoff = SearchCutoff(ClusterTree, y, VIF, round(n/2), -1, n, 1);
    else
        Cutoff = [];
    end
    
end

%% Searches optimal cutoff
function[cutoff]  = SearchCutoff(clusterTree, corrData, VIF, n, nmin, nmax, iter)

    % Calculate cutoff and VIF factor: # of diagonal elements of inverse
    % correlation matrix greater than VIF.
    [cut, value] = CalcVif(clusterTree, corrData, VIF, n, nmax);
    
    % Recurcive step
    if iter <= size(clusterTree, 1) + 1
        if value > 0
            if n < nmax
                nmin = n;
                n = ceil((nmin + nmax)/2);
                cut = SearchCutoff(clusterTree, corrData, VIF, n, nmin, nmax, iter + 1); % Recursive step
            end
        else
            if n > nmin + 1 %to exit when n=nmax
                nmax = n;
                n = floor((nmin + nmax)/2);
                cut = SearchCutoff(clusterTree, corrData, VIF, n, nmin, nmax, iter + 1); % Recursive step
            end
        end 
    else
        error('Could not find optimal cutoff');
    end

    cutoff = sortrows(cut, 1);
    
end

%%  Calculates cutoff and VIF factor
function[cutoff, value] = CalcVif(clusterTree, corrData, VIF, n, nmax)

    y = corrData;
    dim = size(corrData, 1);
    
    if n  ==  0
        cutoff = [(1:dim)', (1:dim)'];
    else
        cutValue = clusterTree(n, 3);
        
        if cutValue > 0 % CUTOFF must be positive
            cutoff = cluster(clusterTree, 'cutoff', cutValue, 'criterion', 'distance');
            cutoff = sortrows([(1:size(cutoff))', cutoff], -2);
          
            if n < nmax
                % Determining rows that will be deleted in correlation matrix
                % (reduced correlation matrix will consist of first element of each cluster)
                x = cutoff(:, 2);
                x(size(x, 1)) = [];
                x = [(x(1) + 1); x];
            
                x = cutoff(logical((x - cutoff(:, 2)) == 0), 1);
            
                % Deleting rows in covariance matrix
                y(x, :) = [];
                y(:, x) = [];
            end
        else
             cutoff = [(1:dim)', (1:dim)'];
        end
     end
    
    % Checking whether there are diagonal elements of inverse of
    % correlation matrix greater than VIF
    if n <  nmax
        value = sum(diag(inv(y)) > VIF);
    else
        value = 0;
    end

end