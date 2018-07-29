function [dicomVolume,isotropicVoxelDimension,dicomHeaderInfo]=ReadDicom(sequenceStartNo,sequenceEndNo,basename,fileExtension)
% Created by Nipun Patel (nipunpatel@gmail.com) 
%     %Gives Volume Matrix conatining all the dicom files read in sequence
%
%   Output Arguments
%     dicomVolume                 =  MxNxP matrix where M x N is image
%                                    array and P indicates img no.
%     isotropicVoxelDimension     =  scalar element giving voxel
%                                    dimension based on the 
%                                    'dicomHeaderInfo'(described below).
%     dicomHeaderInfo             =  supplies dicom header info for the
%                                    first dicom file only.
%     NOTE: It is assumed that this is an isotropic volume and all dicom
%     files belong to the same volume. If you don't have isotrtopic you
%     will have to modify the input for 'isotropicVoxelDimension'.
%
%   Input Arguments
%     sequenceStartNo   =   Starting sequence number from the first dicom 
%                           image file to be read.
%                           (e.g xxx_0010.dcm...xxx_0500.dcm - "10" is
%                           your sequenceStartNo)
%     sequenceEndNo     =   Ending sequence number for the last dicom image
%                           file to be read. 
%                           (e.g xxx_0000.dcm...xxx_0500.dcm - "500" is
%                           your sequenceEndNo)
%     basename          =   Common name of the file sequence (e.g ATLAS_0001.dcm,
%                           ATLAS_0002.dcm,ATLAS_0003.dcm,...ATLAS_00199.dcm 
%                           has basename = 'ATLAS_')
%     fileExtension     =   extension of the image .dcm or dicom.
%
%   Assumptions
%     - All files are sequentially in the correct order.
%     - All files are dicom files belonging to the same volume.
%     - Numbering of dicom files consist of 4 digits
%       e.g 0001.dcm,0002.dcm,..9999.dcm

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
fileCount=1;
totalFiles = sequenceEndNo - sequenceStartNo;

if totalFiles < 0
    error('sequenceStartNo is higher than sequenceEndNo..consider flipping ')
    return;
end

for i=sequenceStartNo:sequenceEndNo
    if i < 10
        sequenceNo = strcat('000',num2str(i));
    elseif ((10 <= i ) & (i < 100))
        sequenceNo = strcat('00',num2str(i));
    elseif ((100 <= i ) & (i <1000))
        sequenceNo = strcat('0',num2str(i));
    elseif 1000 < i
        error('More than 1000 files selected')
    end

    filename=strcat(basename,sequenceNo,fileExtension);

    [dicomVolume(:,:,i+1)]= dicomread(filename);
    if fileCount == 1
        dicomHeaderInfo = dicominfo(filename)
        isotropicVoxelDimension = dicomHeaderInfo.PixelSpacing(1);
    end
    fileCount = fileCount + 1;
end


toc
