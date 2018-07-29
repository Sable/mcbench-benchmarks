function [ V VS ] = dicomreadvolume(zipfile)
%DICOMREADVOLUME   Read a zip-file with DICOM slices as volume.
%   [V VS] = DICOMREADVOLUME(FNAME) loads the 3-D volume data V from
%   the volume dicom slices in the zip-file FNAME. 
%   The voxel size is returned by VS.
%
%   See also DICOMWRITEVOLUME, DICOMWRITE, DICOMREAD
%
%   Author: medical-image-processing.com


% extract the zip file to the temporary directory
fnames = unzip(zipfile, tempdir);

% number of files
N = numel(fnames);

if (N<1)
    error('Empty zip file');
end

% read first slice for determining slice properties
S = squeeze(dicomread(fnames{1}));
I1 = dicominfo(fnames{1});

% voxel size information
VS = [I1.PixelSpacing(:) ; I1.SliceThickness];

% slice size and datatype
sz = size(S);
tp = class(S);

% pre-allocate data
VT = zeros([sz N], tp);
V = VT;
POS = zeros(N,2);

% load each slice and its properties
for i=1:N
    VT(:,:,i) = squeeze(dicomread(fnames{i}));
    info = dicominfo(fnames{i});
    if isfield(info, 'ImagePositionPatient')
        POS(i,:) = [info.ImagePositionPatient(3) i];
    else
        POS(i,:) = [i i];
    end
    delete(fnames{i});
end

% resort the slices according to the image position
POS = sortrows(POS,1);
for i=1:N
   V(:,:,i) = VT(:,:,POS(i,2)); 
end


