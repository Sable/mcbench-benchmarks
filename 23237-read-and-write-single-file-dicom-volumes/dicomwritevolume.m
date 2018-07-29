function [] = dicomwritevolume(fname, V, VS)
%DICOMWRITEVOLUME   Write a volume as DICOM slices in a zip file.
%   DICOMWRITEVOLUME(FNAME, V) writes the 3-D volume data V to
%   the zip-file FNAME. The voxel size is assummed to be 1 mm
%   in each dimension.
%
%   DICOMWRITE(FNAME, V, VS) writes the 3-D volume data V to the
%   zip-file FNAME with the voxel spacing VS. VS is either a scalar
%   for isotropic volumes or a 3-dimensional array.
%
%   See also DICOMREADVOLUME, DICOMWRITE, DICOMREAD
%
%   Author: medical-image-processing.com

if nargin<3
    VS = [1 1 1];
end

if numel(VS)==1
   VS = [VS(1) VS(1) VS(1)]; 
end

if numel(VS) ~= 3
   error('VS needs to be either a scalar or 3-d vector.'); 
end

% create a dicom header with the relevant information
info.SliceThickness = VS(3);
info.ImagerPixelSpacing = VS(1:2);
info.PixelSpacing = VS(1:2);
info.Width = size(V,1);
info.Height = size(V,2);
info.ColorType = 'grayscale';
info.MediaStorageSOPClassUID = '1.2.840.10008.5.1.4.1.1.2'; % CT image storage
info.TransferSyntaxUID = '1.2.840.10008.1.2.1'; % Explicit VR Little Endian
info.SOPClassUID = '1.2.840.10008.5.1.4.1.1.2'; % CT Image Storage
info.PhotometricInterpretation = 'MONOCHROME2';
info.PixelRepresentation = 0;
info.WindowCenter = 0;
info.WindowWidth = 1000;
info.RescaleIntercept = -1024;
info.RescaleSlope = 1;
info.RescaleType = 'HU';

% create dicom slices
fnames = cell(0);
for i=1:size(V,3)
    I = V(:,:,i);
    cfn = sprintf('img_%d.dcm', i);
    info.ImagePositionPatient = [0 0 i*VS(3)];
    dicomwrite(I, cfn, info, 'CreateMode', 'copy');
    fnames{i} = cfn;
end

% zip the dicom slices
zip(fname, fnames);

% finally cleanup all slices
for i=1:numel(fnames)
   delete(fnames{i}); 
end
