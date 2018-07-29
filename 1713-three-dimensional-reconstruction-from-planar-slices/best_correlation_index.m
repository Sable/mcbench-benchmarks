function index_of_peak_correlation = best_correlation_index(indices_by_radius, params)
%BEST_CORRELATION_INDEX tells which of the indices (which correspond to 
%angular rotations) is the best one to use.  Different radii are
%more important than others because the onese at the center have too little
%data to be of use.  WEIGHTS correct for this by making the middle values
%of radius the most important.
%
number_of_radii = length(indices_by_radius);
weights = round([1:number_of_radii] .* (1 - cos([1:number_of_radii] * 2 * pi / number_of_radii)) / 2);

votes = [];
for j = 1 : number_of_radii
    votes = [votes repmat(indices_by_radius(j), [1, weights(j)])];
end

n = hist(votes,[1: params.number_angular_divisions]);

index_of_peak_correlation = min(find(n == max(n)));
%min gets rid of ties arbitrarily

if params.VERBOSE
    figure
    hist(indices_by_radius, [1: params.number_angular_divisions])
    title(['Unweighted Votes for angular rotation. Winner: ' num2str(index_of_peak_correlation)])
    xlabel('Index of angle')
    ylabel('Number of votes')
    
    figure
    plot(weights)
    title('Number of votes for each radius')
    xlabel('Radii')
    ylabel('Number of votes')
    
    figure
    hist(votes, [1 : params.number_angular_divisions])
    title(['Weighted Votes for angular rotation. Winner: ' num2str(index_of_peak_correlation)])
    xlabel('Index of angle')
    ylabel('Number of votes')
end

% Copyright 2002 - 2009 The MathWorks, Inc.