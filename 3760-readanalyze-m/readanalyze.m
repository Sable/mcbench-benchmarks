function [out,pixdim,dtype] = readanalyze(filename)
% READANALYZE  - Read MRI files in the Analyze format
%
%    usage: [data,pixdim,dtype] = readanalyze(filename);
%
%        filename - is the name of the file
%              (both a header (.hdr) and image (.img) file must exist)
%              (filename can include either the .hdr or .img
%              extensions or just the base filename.)
%
%            data - is a n-dimensional matrix of the data
%          pixdim - is the size of each voxel (mm)
%           dtype - datatype (ie 'uint8', 'int16', etc)
%

% Written by Colin Humphries
%   Jan, 2000
%   University of California, Irvine
%   colin@alumni.caltech.edu

% Copywrite (c) 2000, Colin J. Humphries, All Rights Reserved

% Info on Analyze format: 
%    http://www.mayo.edu/bir/analyze/AnalyzeFileInfo.html
%    Note: I checked this link and it no longer works. There should be
%    some info on the Analyze web site.

% %%%% User parameters %%%%%%%%%%%%%%%%%%%%%
RESHAPE_DATA = 1; % When this flag is set to 1 the data is reshaped into
                  % an n-dimensional matrix. Otherwise readanalyze will
                  % just output a vector. 
FLIP_DATA = 0;    % When this flag is set to 1 the outputed image is
                  % flipped in the first three dimensions.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Note: FLIP_DATA has no effect when RESHAPE_DATA is 0.

% Get rid of possible file extensions
ind = findstr(filename,'.img');
if ~isempty(ind)
  filename = filename(1:ind-1);
end

ind = findstr(filename,'.hdr');
if ~isempty(ind)
  filename = filename(1:ind-1);
end

% Open Header
fid = fopen([filename,'.hdr'],'r');
if fid < 0
  error('Error opening header file');
end
fseek(fid,40,'bof');
dimension = fread(fid,8,'int16');
byteswap = 'n';

% The next part tries to figure out if we have a byte swapping problem by
% looking at the dimension bit in the header file. If it's bigger than 10
% (we probably aren't dealing with more than 10-dimensional data) then it
% tries byte swapping. If it still fails then it outputs an error.
if (dimension(1) > 10)
  byteswap = 'b';
  fclose(fid);
  fid = fopen([filename,'.hdr'],'r','b');
  fseek(fid,40,'bof');
  dimension = fread(fid,8,'int16');
  if (dimension(1) > 10)
    byteswap = 'l'
    fclose(fid);
    fid = fopen([filename,'.hdr'],'r','l');
    fseek(fid,40,'bof');
    dimension = fread(fid,8,'int16');
    if (dimension(1) > 10)
      error('Error opening file. Dimension argument is not valid');
    end
  end
end

% Read information from header file
% datatype
fseek(fid,40+30,'bof');
datatype = fread(fid,1,'int16');

% pixel dimension
fseek(fid,40+36,'bof');
pixdim = fread(fid,8,'float');

% orient
fseek(fid,40+108+104,'bof');
orient = fread(fid,1,'uint8');
% Currently orient is not used.
%  orient:     slice orientation for this dataset. 
%       0      transverse unflipped 
%       1      coronal unflipped 
%       2      sagittal unflipped 
%       3      transverse flipped 
%       4      coronal flipped 
%       5      sagittal flipped 

% Close header file
fclose(fid);

% Open Data File
fid = fopen([filename,'.img'],'r',byteswap);

if fid < 0
  error('Error opening data file');
end

switch datatype
  case 2
    dtype = 'uint8';
  case 4
    dtype = 'int16';
  case 8
    dtype = 'int32';
  case 16
    dtype = 'float';
  case 64
    dtype = 'double';
  case 132
    dtype = 'int16';
  otherwise
    error('Unsupported datatype');
end

% Read binary data
out = fread(fid,inf,dtype);

% Close data file
fclose(fid);

if RESHAPE_DATA
  % Reshape data
  switch dimension(1)
    case 4
      % 4-dimensional data
      if dimension(5) == 1
	out = reshape(out,dimension(2),dimension(3),dimension(4));
	if FLIP_DATA
	  out = flipdim(out,1);
	  out = flipdim(out,2);
	  out = flipdim(out,3);
	end
	% %%%%%%%%%%%%%%%%%%%
      else
	out = reshape(out,dimension(2),dimension(3),dimension(4), ...
		      dimension(5));
	if FLIP_DATA
	  out = flipdim(out,1);
	  out = flipdim(out,2);
	  out = flipdim(out,3);
	end
      end
    case 3
      % 3-dimensional data
      out = reshape(out,dimension(2),dimension(3),dimension(4));
      if FLIP_DATA
	out = flipdim(out,1);
	out = flipdim(out,2);
	out = flipdim(out,3);
      end
      % %%%%%%%%%%%%%%%%%%%
    case 2
      % 2-dimensional data
      out = reshape(out,dimension(2),dimension(3));
    case 1
      % 1-d data
    otherwise
      printf('Warning: data not reshaped\n');
  end
end

ii = find(pixdim);
pixdim = pixdim(ii);
  

  
  
  