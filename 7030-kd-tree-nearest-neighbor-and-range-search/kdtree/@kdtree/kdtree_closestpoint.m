% FUNCTION [idx,pout] = kdtree_closestpoint(kdtree, pin)
%
% AUTHOR:     Steven Michael
%             (smichael@ll.mit.edu)
%
% DATE:       2/17/05
%
% DESCRIPTION:
%
%  For a previously created kdtree (see kdtree_create), this function
%  returns an array of points "pout" in the tree where each element 
%  pout(i) is the point in the tree that is a minimum Euclidean distance
%  away from pin(i)
%
% INPUTS:
%
%   kdtree :    A KD Tree previously created with kdtree_create
%
%
%   pin    :    An array (Nxndim) of points.  Note that "ndim" must 
%               be equal to the dimension of the array that the
%               "kdtree" was created with.
%
% OUTPUTS:
%
%   idx    :    An array of indices to the original point array such that
%               if the kdtree was created with
%
%                             "kdtree = kdtree_create(points)" 
%
%               then the point with the closest Euclidian distance to
%               pin(i) would be points(i).
%
%   pout   :    An optional output of the nearest point itself. This is
%               points(i) from above.
%
% Example: 
% 
%    % Create a list of 1000 random points in 3d space
%    r = rand(1000,3);
% 
%    % Create a tree from this list
%    tree = kdtree(r);
% 
%    % Find the point closest to the origin
%    [pntidx,pntval] = kdtree_closestpoint(tree,[0 0 0]);
%
%    % Create a list "r2" of 100 random points in 3d space and
%    % find the points in "r" that are closest to each point in "r2"
%    [pntidx,pntval] = kdtree_closestpoint(tree,r2);
%
%    % Find all the points within the cube defined by "rng"
%    rng = [ [.45 .55]; [.45 .55]; ; [.45 .55] ];
%    pntidx = kdtree_range(tree,rng);
