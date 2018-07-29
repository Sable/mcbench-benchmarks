function [A, b, groups, x0] = GenGroupSparseProblem(m, n, nGroups, activeGroups)

% Initialize random number generator
    randn('state',0); rand('state',2); % 2
    
    % Set problem size and number of groups
%     m = 100; n = 150; nGroups = 25; 
    groups = [];
    B = randn(m,n);
    
    % Generate groups with desired number of unique groups
    while (length(unique(groups)) ~= nGroups)
       groups  = sort(ceil(rand(n,1) * nGroups)); % Sort for display purpose
    end

    % Determine weight for each group
    weights = activeGroups*rand(nGroups,1) + 0.1;
    W       = spdiags(1./weights(groups),0,n,n);

    % Create sparse vector x0 and observation vector b
    p   = randperm(nGroups); p = p(1:activeGroups);
    idx = ismember(groups,p);
    x0  = zeros(n,1); x0(idx) = randn(sum(idx),1);
    A = matrix_normalizer(B*W);
    b = A*x0;