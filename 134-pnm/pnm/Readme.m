% README file for the Portable pixelmap utilities.
% 11 May 1998
%
% Description
% ===========
%
% The PNM Toolbox is a collection of programs for reading and writing
% PNM images. PNM images include portable pixelmaps (PPM), portable
% graymaps (PGM) and portable bitmaps (PBM). There is no file format
% associated with PNM itself. Ascii/plain encoding and binary/raw
% encoding is supported for both reading and writing. User-specified
% maximum color-component value is supported.
%
% Robustness
% ==========
%
% The image reading functions are more robust than ever when reading PNM
% images. Comments in the pixel area of ascii encoded PNM images are
% allowed by the image format specifications but not by many tools
% reading PNM images. This toolbox now allows this. In addition, any
% garbage (characters other than digits and whitespace) is ignored.
% Also, the functions scan the whole file if necessary in search for a
% PNM magic number. As a consequence, the functions can read the example
% images directly out of the formatted UNIX manual pages pbm(5), pgm(5)
% and ppm(5)!
%
% The image format specification states that no line in an ascii encoded
% PNM image should have more than 70 characters. Tools writing PNM
% images often ignore this, but this toolbox follows the specification.
%
% Installing
% ==========
%
% Once the archive file is unpacked, a subdirectory called pnm is
% created. To make the PNM Toolbox available allways, add the directory
% to the Matlab path by editing the global path initialization file
% pathdef.m or by using the addpath function in the personal
% initialization file startup.m.
%
% Tips
% ====
%
% Binary encoded images are written and read much faster than ascii
% encoded images and are much smaller. However, they are also less
% general and less portable.
%
% Use IM2IND to convert any image to an indexed image with a color map
% tha contains only the colors actually used in the image and only one
% copy of each (duplicate colors and unused colors are removed).
%
% Limitations
% ===========
%
% * Binary encoded portable pixelmaps and portable graymaps can not have
%   a maximum pixel value less than 255.
% * User-specified comments are not supported.
% * 3D image matrices and the new datatypes introduced in Matlab 5 are
%   not yet suported.
%
% Things to do
% ============
%
% * Remove the limitations mentioned above.
% * Make toolbox more compatible with the image files in matlab/iofun.
% * Speed up the writing of ascii (plain) images. It's much too slow.
%
% Versions and platforms
% ======================
%
% The PNM toolbox requires Matlab 5. It has been tested and seems to run
% without problems on the following versions and platforms:
%
%   5.2.0.3084 on Linux 2.0.33
%   5.1.0.421  on IRIX 6.2
%   5.1.0.421  on IRIX 5.3
%   5.1.0.421  on SunOS 5.5.1
%   5.1.0.421  on Windows95
%
% Home Page
% =========
%
% The home page of the PNM Toolbox on the World Wide Web is
% http://www.math.uio.no/~jacklam/matlab/pnm/index.html
%
% Author
% ======
%
% Comments, suggestions, questions, and bug reports are welcome. Please
% note, however, that I work on these programs on my spare time, so be
% patient.
%
% Author:      Peter J. Acklam
% Time-stamp:  1998-05-11 18:43:26
% E-mail:      jacklam@math.uio.no (Internet)
% URL:         http://www.math.uio.no/~jacklam
