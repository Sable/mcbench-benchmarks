% Returns a 3-column matrix [minIndex maxIndex persistence]
% of paired extrema whose persistence is greater than threshold
function [filtered_pairs] = filter_features_by_persistence(min, max, persistence, threshold)

    persistence_features_indices = persistence > threshold;  

    %create a vector with all extrema features
    filtered_pairs = [min(persistence_features_indices) max(persistence_features_indices), persistence(persistence_features_indices)];
    
end