function [exifdata, nf] = getexif(fname)
%[status] = getexif(fname) read Exif data from an image file
% fname   = name of image file, e.g., 'myfile.jpg'
%
%Needs ExifTool.exe, written by Phil Harvey
% http://www.sno.phy.queensu.ca/~phil/exiftool/
% 1. Download the file, exiftool(-k).exe
% 2. Rename this file, exiftool.exe
% 3. Save this file in a folder on your Matlab path, e.g. .../matlab/
%Peter Burns, 28 May 2013
%             22 July 2013, following suggestions from jhh and Jonathan via
%                           Matlab Central.

test = which('exiftool.exe');
if isempty(test)
    disp('ExifTool not available:');
    disp('Please download from,')
    disp('   http://www.sno.phy.queensu.ca/~phil/exiftool/')
    disp('make sure that the installed exiftool.exe is on your Matlab path')
    beep
    exifdata=[];
    nf = 0;
    return
else
    
TS=[ '"' test '" -s "' fname '"']; 
[status, exifdata] = system(TS); 
       
nf = find(exifdata==':');
nf = length(nf);
end
