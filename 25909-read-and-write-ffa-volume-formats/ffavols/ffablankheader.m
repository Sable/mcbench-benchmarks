function [ header ] = ffablankheader()

%   function [ header ] = ffaBlankHeader()
%
%   Returns a blank header ffa format header. Valid settings for the
%   available fields are:
%
%   ffaid           = 1.1
%   signflag        = 1 for signed char, short, int, 0 otherwise
%   floatflag       = 1 for floating point types
%   databits        = number of bits in datatype; 8, 16, 32, 64
%   voxelbits       = as databits
%   size            = length 3 vector of sizes [x y z]
%   origin          = length 3 vector forhte origin [sx sy sz]
%   label.x/y/z     = arbitrary labels for the 3 dimensions
%   scale           = length 3 vector of scale factors 
%   unitname.x/y/z  = string to depict the unit, see note below.
%   machineformat   = matlab identifier for the current platform, see note
%   binarytype      = matlab type identifier, see note.
%
%
%   SCALE:
%   * For seismic data the scale vector is usually used to represent
%   increments in x and y. z usually hold the scale factor in units and is
%   usually negative in line wiht the .vol Volume format convention,
%   although SVI Pro can load both +1 and -1 z-increment volumes.
%
%   UNITNAME:
%   * ffA software expects set stings to identify the units used, these
%   are: 'none','kilometres','metres','feet', 'seconds', 'milliseconds'.
%
%   MACHINEFORMAT:
%   See matlab documentation for rules on machine format specifiers
%
%   BINARYTYPE:
%   A matlab specific precision specifier. Once the rest of the header
%   is complete use ffahdr2precision.m to generate the appropriate string.

header.ffaid = 1.1;
header.signflag = 0;
header.floatflag = 0;
header.databits = 0;
header.voxelbits = 0;
header.numdims = 0;
header.size = [0 0 0];
header.origin = [0 0 0];
header.label.x = 'X';
header.label.y = 'Y';
header.label.z = 'Z';
header.scale = [1 1 1];
header.unitname.x = '';
header.unitname.y = '';
header.unitname.z = '';
header.machineformat = 'ieee-le';
header.binarytype = 'uint8';

end
