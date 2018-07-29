% Example for FDK reconstruction
%
% Author: Rene Willemink (Signals and Systems Group, University of Twente)
% Date: 2009-03-11
%
% Given a sinogram P [IxJxN]
%   with N conebeam projections, distributed over 360 degrees
% 
% The center of rotation is assumed to be positioned at the center of the
% image plane (IxJ) and the x-ray source is positioned along the line from
% the center of the image through the center of rotation
%

% Check if the sinogram exists
if ~exist('P', 'var')
    error('Please load your own conebeam sinogram in the variable P first')
end

% Check if mex_iconebeam_fdk.cpp was compiled
if exist('mex_iconebeam_fdk', 'file')~=3
    error('Please compile the mex_iconebeam_fdk.cpp mex file first. Use the supplied compile.m script')
end

% The variable D represents the distance of the center of rotation to the
% x-ray source. Adjust this value to your own geometry
D = 3500;

% We first have to pre-filter the sinogram, a filter ('Hamming', 'Hann', etc.)
% can be specified here
P = fdkPreFilter(P, D, 'None');

% Now we can reconstruct any slice we want (slices range from 1..J)
SliceNr=300;

% Select the output size
OutputSize = [512 512];

% Specify the number of threads to use in the reconstruction (typically
% this is set to equal to the number of available cores in the machine)
nThreads = maxNumCompThreads;

% And perform the back projection
ImSlice = mex_iconebeam_fdk(P, D, ...
    'OutputSize', OutputSize, ...
    'SliceHeight', SliceNr, ...
    'nThreads', nThreads);
