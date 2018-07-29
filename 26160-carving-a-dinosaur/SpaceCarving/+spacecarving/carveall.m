function voxels = carveall( voxels, cameras )
%CARVEALL  carve away voxels using all cameras
%
%   VOXELS = CARVEALL(VOXELS, CAMERAS) simple calls CARVE for each of the
%   cameras specified

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

for ii=1:numel(cameras);
    voxels = carve(voxels,cameras(ii));
end