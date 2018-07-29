function enviwrite(D,info,datafile,hdrfile)
%enviread: Read binary image files using ENVI header information
%[D,info,x,y]=enviread(datafile) where the header file is named
%filename.hdr and exists in the same directory. Otherwise use
%[D,info,x,y]=enviread(datafile,hdrfile) The output contains D, info, x and
%y containing the images data, header info, x-coordinate vector and
%y-coordinate vector, respectively. D will be in whatever number format
%(double, int, etc.) as in the ENVI file.

if nargin < 3
    error('You must specify at least three inputs');
elseif nargin < 4
    hdrfile=[deblank(datafile),'.hdr']; %implicit name
end

envihdrwrite(info,hdrfile);
envidatawrite(D,datafile,info);


