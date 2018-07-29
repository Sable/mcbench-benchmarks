function dispersion = calculate_dispersion(data, k)

% -----------------------------------------------------------------------
%   FUNCTION
%   Calculate Dispersion (calculate_dispersion.m)
%
%   DESCRIPTION
%   This function is called in gap_statistics.m and it computes the 
%   dispersion for a given k using the MATLAB kmeans algorithm.
%
%   AUTHOR
%   Alessandro Scoccia Pappagallo, 2013
%   Under the supervision of Ryota Kanai
%   University of Sussex, Psychology Dep.
% -----------------------------------------------------------------------

stop_w = warning('off', 'stats:kmeans:EmptyCluster');
stop_w2 = warning('off', 'stats:kmeans:EmptyClusterRep');

opts = statset('MaxIter', 400);

[idx, C, sumD] = kmeans(data, k, 'EmptyAction', 'singleton', 'options', opts, 'Replicates', 2);
dispersion = sum(sumD);

end