function [nearest_neighbours] = find_nearest_neighbours( database, desc, dist_ratio, max_dist )

% [nearest_neighbours] = find_nearest_neighbours( database, desc, max_dist )
%
% Find the indices of the nearest neighbours of the given desriptors in the
% specified database.  Uses euclidean distance.
%
% Input:
% database - descriptor database created by add_descriptors_to_database.
% desc - descriptors from the SIFT function.
% dist_ratio - maximum ratio between distances of nearest and second closest 
%   neighbour for a match to be allowed.
%
% Output:
% nearest_neighbours - indices of the nearest neighbours for the descriptors
%   (descriptors with no neighbour closer than max_dist will have index 0).
%
% Thomas F. El-Maraghi
% May 2004
%%
%if ~exist( 'dist_ratio' )
%   dist_ratio = 0.8;
%end
%%
nearest_neighbours = zeros(size(desc,1),1);
for k = 1:size(desc,1)
 
   dist = sqrt(sum((database.desc - repmat(desc(k,:),size(database.desc,1),1)).^2,2));  % thid is a column vector of euclidean distances (one element for each database descriptor)
   [nn1_dist idx] = min(dist);
   dist(idx) = max(dist);
   nn2_dist = min(dist);   
   if nn1_dist/nn2_dist >= dist_ratio || nn1_dist>max_dist %%%%% I added the last bit (&& ...)
      idx = 0;
   end
   nearest_neighbours(k,1:2) = [idx nn1_dist];
end