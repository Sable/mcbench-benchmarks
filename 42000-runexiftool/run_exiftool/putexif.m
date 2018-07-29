function [status] = putexif(dat,fname, refname)
%[status] = putexif(dat,fname, refname) save and image with Exif data from
%                  a reference image file
% dat     = array of image data
% fname   = name of image file to be saved, e.g., 'myfile.jpg'
% refname = name (path) of reference image file
%
%Needs ExifTool.exe, written by Phil Harvey
% http://www.sno.phy.queensu.ca/~phil/exiftool/
% 1. Download the file, exiftool(-k).exe
% 2. Rename this file, exiftool.exe
% 3. Save this file in a folder on your Matlab path, e.g. .../matlab
%Peter Burns, 28 May 2013
%             22 July 2013, following suggestions from jhh and Jonathan via
%                           Matlab Central.

test = which('exiftool.exe');
if isempty(test)
    disp('ExifTool not available:');
    disp('Please download from,')
    disp('   http://www.sno.phy.queensu.ca/~phil/exiftool/')
    disp('or make sure that the installed exiftool.exe is on your Matlab path')
    beep
    status =1;
    return
else
    
    [exifdata, nf] = getexif(refname);
   % Save data as image file with Matlab metadata
    imwrite(dat, fname, 'quality', 100);
    [exifdata2, nf2] = getexif(fname);
   % Replace matadata from this file with desired tags from reference file
   % temp1=['exiftool -m -tagsfromfile ',refname,' -all:all ', fname];
    temp1=['"' test '" -m -tagsfromfile "',refname,'" -all:all "', fname, '"'];
    
    %[status, junk] = system(temp1);
    %Second output variable appears to suppress '1 image files updated'
    % being returned to Command window (~ also works).
    [status, junk] = system(temp1);
   
   % Approximate check
    [exifdata3, nf3] = getexif(fname);
    
   % Delete extra copy of reference image file
    temp3 = ['del "',fname,'_original"'];
    status = system(temp3);
    
   % Test approx. number of tags
    if abs(nf3-nf2<10)
        disp('Warning: Exif tags may not have been copied');
        status = 1;
    end
    
end


