function cameras = loadcameradata(dataDir, idx)
%LOADCAMERADATA: Load the dino data
%
%   CAMERAS = LOADCAMERADATA() loads the dinosaur data and returns a
%   structure array containing the camera definitions. Each camera contains
%   the image, internal calibration and external calibration.
%
%   CAMERAS = LOADCAMERADATA(IDX) loads only the specified file indices.
%
%   Example:
%   >> cameras = loadcameradata(1:3);
%   >> showcamera(cameras)
%
%   See also: SHOWCAMERA

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $

if nargin<2
    idx = 1:36;
end

cameras = struct( ...
    'Image', {}, ...
    'P', {}, ...
    'K', {}, ...
    'R', {}, ...
    'T', {}, ...
    'Silhouette', {} );

%% First, import the camera Pmatrices
rawP = load( fullfile( dataDir, 'dino_Ps.mat') );

%% Now loop through loading the images
tmwMultiWaitbar('Loading images',0);
for ii=idx(:)'
    % We try both JPG and PPM extensions, trying JPEG first since it is
    % the faster to load
    filename = fullfile( dataDir, sprintf( 'viff.%03d.jpg', ii ) );
    if exist( filename, 'file' )~=2
        % Try PPM
        filename = fullfile( dataDir, sprintf( 'viff.%03d.ppm', ii ) );
        if exist( filename, 'file' )~=2
            % Failed
            error( 'SpaceCarving:ImageNotFound', ...
                'Could not find image %d (''viff.%03d.jpg/.ppm'')', ...
                ii, ii );
        end
    end
     
    [K,R,t] = spacecarving.decomposeP(rawP.P{ii});
    cameras(ii).rawP = rawP.P{ii};
    cameras(ii).P = rawP.P{ii};
    cameras(ii).K = K/K(3,3);
    cameras(ii).R = R;
    cameras(ii).T = -R'*t;
    cameras(ii).Image = imread( filename );
    cameras(ii).Silhouette = [];
    tmwMultiWaitbar('Loading images',ii/max(idx));
end
tmwMultiWaitbar('Loading images','close');

