%% Carving a Dinosaur
% This is a demo of reconstructing a 3D shape from multiple images using a
% simple space-carving approach. This technique is usually used when you
% need a 3D model of a small artefact which can be placed on a turntable,
% allowing dozens, even hundreds of images to be captured from around the
% object. It has been used pretty successfully by museums and the like to
% create online virtual galleries.
%
% _Note: This demo requires the
% <http://www.mathworks.com/access/helpdesk/help/toolbox/images |Image Processing Toolbox|>._
%
% Author: Ben Tordoff
%
% Copyright 2005-2009 The MathWorks, Inc.

%% Introduction
% A little while ago (is it really four years?!) I was asked to prepare a
% demonstration for a customer visit. The customer had some samples that
% they wanted to photograph in order to estimate the volume occupied before
% and after a chemical process. These samples were smooth but irregularly
% shaped such that a simple "volume of revolution" calculation was
% inaccurate. They wanted to know if accurate volume estimation from images
% was possible, and if so how you might do it.
%
% The demo I produced is enumerated below and is the most basic form of a
% technique called "space carving" or "shape from silhouettes", where each
% image is just used as a mask. A lump of voxel "clay" is placed in the
% middle of the scene and from each image we simply look and see what is
% outside the object silhouette. Anything outside is carved away.
% Obviously, this requires us to know where the camera was relative to the
% object when the picture was taken, which is a whole separate problem.
%
% This technique has been refined over the last decade and can be
% done in some computationally and memory efficient ways. My approach is
% neither of these - I went for simplicity over efficiency since my only
% aim was to explain the technique and show it in MATLAB.
%
% *Acknowledgements*
%
% The dinosaur images used here were provided by Wolfgang Niem at
% the University of Hannover.
%
% The camera data used in this example was provided by
% <http://research.microsoft.com/en-us/um/people/awf |Dr A. W. Fitzgibbon|>
% and <http://www.robots.ox.ac.uk/~az |Prof A. Zisserman|>
% from the <http://www.robots.ox.ac.uk |University of Oxford Robotics Research Group|>.
%
% The images and camera data can both be downloaded from the <http://www.robots.ox.ac.uk/~vgg/data/data-mview.html
% |Visual Geometry Group web-pages|> at the <http://www.robots.ox.ac.uk
% |University of Oxford Robotics Research Group|>.

%% Setup
% All functions for this demo are in the "spacecarving" package and the
% data in the "DinosaurData" folder.
import spacecarving.*;
datadir = fullfile( fileparts( mfilename( 'fullpath' ) ), 'DinosaurData' );
close all;


%% Load the Camera and Image Data
% This reads the "Dinosaur" directory, loading the camera definitions
% (internal and external calibration) and image file for each camera. These
% calibrations have previously been determined from the
% images using an automatic process that we won't worry about here.
cameras = loadcameradata( datadir )

montage( cat( 4, cameras.Image ) );
set( gcf(), 'Position', [100 100 600 600] )
axis off;

%% Convert the Images into Silhouettes
% The image in each camera is converted to a binary image using the
% blue-screen background and some morphological operators to clean up the
% edges. This becomes the "mask" referred to above. Holes in this mask are
% particularly dangerous as they will cause voxels to be carved away that
% shouldn't be - we can end up drilling a hole through the object! The
% Image Processing Toolbox functions
% <http://www.mathworks.com/access/helpdesk/help/toolbox/images/bwareaopen.html |bwareaopen|>
% and <http://www.mathworks.com/access/helpdesk/help/toolbox/images/imclose.html |imclose|>
% are your friends for this job!
for c=1:numel(cameras)
    cameras(c).Silhouette = getsilhouette( cameras(c).Image );
end

figure('Position',[100 100 600 300]);

subplot(1,2,1)
imshow( cameras(c).Image );
title( 'Original Image' )
axis off

subplot(1,2,2)
imshow( cameras(c).Silhouette );
title( 'Silhouette' )
axis off

makeFullAxes( gcf );

%% Work out the space occupied by the scene
% Initially we have no idea where to look for the model. We will assume
% that the model lies in the space spanned by the cameras and their
% principal view directions. We then perform a very low-res space-carve
% using all the cameras to narrow down exactly where the object is. This
% isn't foolproof, but good enough for this demo.
[xlim,ylim,zlim] = findmodel( cameras );


%% Create a Voxel Array
% This creates a regular 3D grid of elements ready for carving away. The
% input arguments set the bounding box and the approximate number of voxels
% to create. Since the voxels must be cubes, the actual number generated
% may be a little more or less. We'll start with about six million voxels
% (you may need to reduce this if you don't have enough memory).
%
% For "real world" implementations of space carving you certainly wouldn't
% create a uniform 3D matrix like this. OctTrees and other refinement
% representations give much better efficiency, both in memory and
% computational time.
voxels = makevoxels( xlim, ylim, zlim, 6000000 );
starting_volume = numel( voxels.XData );

% Show the whole scene
figure('Position',[100 100 600 400]);
showscene( cameras, voxels );

%% Carve the Voxels Using the First Camera Image
% The silhouette is projected onto the voxel array.
% Any voxels that lie outside the silhouette are carved away, leaving only
% points inside the model. Using just one camera, we end up with a
% dinosaur-prism - a single camera provides no information on depth.
voxels = carve( voxels, cameras(1) );

% Show Result
figure('Position',[100 100 600 300]);
subplot(1,2,1)
showscene( cameras(1), voxels );
title( '1 camera' )
subplot(1,2,2)
showsurface( voxels )
title( 'Result after 1 carving' )

%% Add More Views
% Adding more views refines the shape. If we include two more, we already
% have something recognisable, albeit a bit "boxy".
voxels = carve( voxels, cameras(4) );
voxels = carve( voxels, cameras(7) );

% Show Result
figure('Position',[100 100 600 300]);
subplot(1,2,1)
title( '3 cameras' )
showscene( cameras([1 4 7]), voxels );
subplot(1,2,2)
showsurface(voxels)
title( 'Result after 3 carvings' )


%% Now Include All the Views
% In this case we have 36 views (roughly every 10 degrees). For a very
% detailed model and if you have an automatic capture rig you would use far
% more - the only limit being time and disk-space. When using a computer
% controlled turn-table (as is done in museums) storage is the only real
% limitation.
for ii=1:numel(cameras)
    voxels = carve( voxels, cameras(ii) );
end
figure('Position',[100 100 600 700]);
showsurface(voxels)
set(gca,'Position',[-0.2 0 1.4 0.95])
axis off
title( 'Result after 36 carvings' )

final_volume = numel( voxels.XData );
fprintf( 'Final volume is %d (%1.2f%%)\n', ...
    final_volume, 100 * final_volume / starting_volume )

%% Get real values
% We ideally want much higher resolution, but would run out of memory.
% Instead we can use a trick and assign real values to each voxel instead
% of a binary value. We do this by moving all voxels a third of a square in
% each direction then seeing if they get carved off. The ratio of carved to
% non-carved for each voxel gives its score (which is roughly equivalent to
% estimating how much of the voxel is inside).
offset_vec = 1/3 * voxels.Resolution * [-1 0 1];
[off_x, off_y, off_z] = meshgrid( offset_vec, offset_vec, offset_vec );

num_voxels = numel( voxels.Value );
num_offsets = numel( off_x );
scores = zeros( num_voxels, 1 );
for jj=1:num_offsets
    keep = true( num_voxels, 1 );
    myvoxels = voxels;
    myvoxels.XData = voxels.XData + off_x(jj);
    myvoxels.YData = voxels.YData + off_y(jj);
    myvoxels.ZData = voxels.ZData + off_z(jj);
    for ii=1:numel( cameras )
        [~,mykeep] = carve( myvoxels, cameras(ii) );
        keep(setdiff( 1:num_voxels, mykeep )) = false;
    end
    scores(keep) = scores(keep) + 1;
end
voxels.Value = scores / num_offsets;
figure('Position',[100 100 600 700]);
showsurface( voxels );
set(gca,'Position',[-0.2 0 1.4 0.95])
axis off
title( 'Result after 36 carvings with refinement' )


%% Final Result
% For online galleries and the like we would colour each voxel from the
% image with the best view (i.e. nearest normal vector), leading to a
% colour 3D model. This makes zero difference to the volume estimate (which
% was the main purpose of the demo), but does look pretty!
figure('Position',[100 100 600 700]);
ptch = showsurface( voxels );
colorsurface( ptch, cameras );
set(gca,'Position',[-0.2 0 1.4 0.95])
axis off
title( 'Result after 36 carvings with refinement and colour' )


%% Conclusion
% Hopefully this demo has given you a taste for what is possible by simple
% image masking and space-carving. If this has whetted your appetite, have
% a look at the references below. Converting each image to a binary mask
% throws away a lot of information. Instead of using these silhouettes, we
% could use the image values (either greyscale or colour) and a
% photo-consistency constraint. This is *much* harder to get right, but
% copes much better with concavities and holes in the model.
%
% Have you ever been asked about volume estimation from images? Do you
% fancy trying this at home? Perhaps you've implemented a better way to do
% this? I'd love to hear from you
% <http://blogs.mathworks.com/loren/?p=210#respond here>.
%
%
%% File Availability
% The functions created for this demo will ultimately appear on the File Exchange.
% Once they are available, we'll update this post.  As a reminder, there's a link
% above for getting the data.
%
%% References
% Some good references for this (including the original paper that used these images) are:
%
% * *Automatic 3D model construction for turn-table sequences*, _A. W. Fitzgibbon, G. Cross, and A. Zisserman,
% In 3D Structure from Multiple Images of Large-Scale Environments, Springer LNCS 1506, pages 155--170, 1998_
% * *A Theory of Shape by Space Carving*, _K. N. Kutulakos & S. M. Seitz,
% International Journal of Computer Vision 38(3), 199–218, 2000_
% * *Foundations of Image Understanding*, Chapter 16, _edited by L. S. Davis,
% Kluwer, 2001_
