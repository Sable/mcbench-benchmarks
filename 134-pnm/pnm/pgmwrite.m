function pgmwrite(arg1,arg2,arg3,arg4,arg5)
%PGMWRITE Write a PGM (portable graymap) file to disk.
%
%   PGMWRITE(X,MAP,'FILENAME') writes a PGM file containing the indexed
%   image X and color map MAP to the file 'FILENAME'.
%
%   PGMWRITE(X,MAP,'FILENAME','ENCODING') where 'ENCODING' is either
%   'ascii' (or 'plain') or 'binary' (or 'raw') lets the user specify
%   whether the PGM file should be ascii or binary encoded. Default is
%   'ascii'.
%
%   PGMWRITE(I,'FILENAME') writes a PGM file containing the gray level
%   intensity image in the matrix I to the file 'FILENAME'.
%
%   PGMWRITE(I,'FILENAME','ENCODING') allows the user to specify the
%   encoding as described above.
%
%   PGMWRITE(X,MAP,'FILENAME',MAXVALUE) uses MAXVALUE as the maximum
%   gray value. This ables graymaps with more than 256 gray levels,
%   since the number of levels in the graymap is MAXVALUE+1.
%
%   PGMWRITE(X,MAP,'FILENAME',MAXVALUE,'ENCODING') lets the user specify
%   the output encoding as described above. Binary encoded graymaps can
%   not have MAXVALUE larger than 255, so a MAXVALUE larger than 255
%   will always give an ascii encoded file regardless of the specified
%   output encoding.
%
%   PGMWRITE(I,'FILENAME',MAXVALUE) and
%   PGMWRITE(I,'FILENAME',MAXVALUE,'ENCODING') works as described above,
%   but on a gray level intensity image.
%
%   The 'ascii' format is the most portable and is the only that allows
%   a MAXVALUE larger than 255, so it is also the most general. The
%   'binary' format files are, however, much smaller and many times
%   faster to read and write than the 'ascii' format.
%
%   If file name has no suffix, '.pgm' is used.
%
%   See also: PGMREAD, PBMREAD, PBMWRITE, PPMREAD, PPMWRITE.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 21:26:34
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

nargs = nargin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check number of input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error( nargchk( 2, 5, nargs ) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identify input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( nargs == 2 )               % 2 input arguments

   %
   % PGMWRITE(I,'FILENAME')
   %
   I = arg1;
   filename = arg2;
   maxval = 255;
   encoding = 'ascii';
   isindexed = 0;

elseif ( nargs == 5 )           % 5 input arguments

   %
   % PGMWRITE(X,MAP,'FILENAME',MAXVALUE,'ENCODING')
   %
   X = arg1;
   map = arg2;
   filename = arg3;
   maxval = arg4;
   encoding = arg5;
   isindexed = 1;

elseif ( nargs == 3 )           % 3 input arguments

   if ( ~ischar(arg2) & ischar(arg3) )

      %
      % PGMWRITE(X,MAP,'FILENAME')
      %
      X = arg1;
      map = arg2;
      filename = arg3;
      maxval = 255;
      encoding = 'ascii';
      isindexed = 1;

   elseif ( ischar(arg2) & ischar(arg3) )

      %
      % PGMWRITE(I,'FILENAME','ENCODING')
      %
      I = arg1;
      filename = arg2;
      encoding = arg3;
      maxval = 255;
      isindexed = 0;

   else

      %
      % PGMWRITE(I,'FILENAME',MAXVALUE)
      %
      I = arg1;
      filename = arg2;
      maxval = arg3;
      encoding = 'ascii';
      isindexed = 0;

   end

else                            % 4 input arguments

   if ( ischar(arg3) & ischar(arg4) )

      %
      % PGMWRITE(X,MAP,'FILENAME','ENCODING')
      %
      X = arg1;
      map = arg2;
      filename = arg3;
      encoding = arg4;
      maxval = 255;
      isindexed = 1;

   elseif ( ischar(arg3) & ~ischar(arg4) )

      %
      % PGMWRITE(X,MAP,'FILENAME',MAXVALUE)
      %
      X = arg1;
      map = arg2;
      filename = arg3;
      maxval = arg4;
      encoding = 'ascii';
      isindexed = 1;

   else

      %
      % PGMWRITE(I,'FILENAME',MAXVALUE,'ENCODING')
      %
      I = arg1;
      filename = arg2;
      maxval = arg3;
      encoding = arg4;
      isindexed = 0;

   end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are no longer needed, so delete them to save memory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear arg1 arg2 arg3 arg4 arg5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The blocksize is the number of pixels treated simultaneously.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

blocksize = 8192;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check filename.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( ~ischar(filename) | isempty(filename) )
   error( 'File name must be a non-empty string' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add suffix to file name if necessary.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k  = [ find( filename == filesep ) ];
if isempty(k)
   k = 0;
else
   k = max(k);
end
if all( filename(k+1:end) ~= '.' )
   filename = [ filename '.pgm' ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check the maximum pixel value.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ischar(maxval)
   error( 'Maximum pixel value must a positive integer' );
end

if ( maxval ~= round(maxval) ) | ( maxval < 1 )
   error( 'Maximum pixel value must be a positive integer.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check and simplify the encoding specification.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~ischar(encoding)
  error( 'Encoding specification must be a string.' );
end

if any( encoding(1) == 'aApP' )         % 'ascii' (or 'plain') format.
  isascii = 1;
elseif any( encoding(1) == 'bBrR' )     % 'binary' (or 'raw') format.
  isascii = 0;
else
  error( 'Illegal encoding specification.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum pixel value can not be larger than 255 with binary encoding.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isascii & ( maxval > 255 )
   disp( 'Warning:' );
   disp( 'Maximum pixel value must be <= 255 with binary encoding.' );
   disp( 'Using ascii encoding instead.' );
   encoding = 'ascii';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Maximum gray value smaller than 255 with binary encoding is not yet
% supported. :-(
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isascii & ( maxval < 255 )
   error( 'MAXVAL less than 255 with binary encoding not supported.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open output file for writing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen( filename, 'w' );
if ( fid == -1 )
   error( [ 'Can''t open file ''' filename ''' for writing.' ] );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get dimension of image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isindexed
   [ rows, cols ] = size( X );
else
   [ rows, cols ] = size( I );
end
pixels = rows*cols;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write file header.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Magic number.
if isascii
   magic = 'P2';
else
   magic = 'P5';
end

% Write header. Use FLOOR( CLOCK ) to avoid a second value of 60.
fprintf( fid, [ ...
   '%s\n', ...
   '# Created by Matlab (%s) %04d-%02d-%02d %02d:%02d:%02d\n', ...
   '%d %d\n', ...
   '%d\n' , ...
   ], magic, mfilename, floor( clock ), cols, rows, maxval );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write image. Color images are converted to grayscale images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pixels_written = 0;
pixels_on_this_line = 0;
w = [ 0.298936 ; 0.587043 ; 0.114021 ];

while ( pixels_written < pixels )

   % Lower and upper bounds for the pixels to write now.
   first_pixel = pixels_written + 1;
   last_pixel = min( pixels_written+blocksize, pixels );

   % The pixels are written row-wise but Matlab counts elements
   % column-wise so convert from row-wise to column-wise.
   pixel = (first_pixel:last_pixel)';    % Pixels counted row-wise.
   row = ceil( pixel/cols );             % Row number for each pixel.
   col = pixel - cols*(row-1);           % Column number for each pixel.
   pixel = row + rows*(col-1);           % Pixels counted column-wise.

   % Number of pixels to write now.
   pixels_to_write_now = last_pixel - first_pixel + 1;

   % Get the numeric value of the pixels.
   if isindexed
      int = round( map(X(pixel),:)*w*maxval );
   else
      int = round( I(pixel)*maxval );
   end

   if isascii                            % Ascii format.

      for i = 1:pixels_to_write_now
         str = sprintf( '%d', int(i) );         % Integer as string.
         nstr = length( str );                  % Length of string.
         if ( pixels_on_this_line+nstr >= 70 )  % If it does not fit on line...
            fprintf( fid, '\n' );               % ...add newline...
            pixels_on_this_line = 0;            % ...and reset counter...
         elseif ( pixels_on_this_line > 0 )     % If not beginning of line...
            fprintf( fid, ' ' );                % ...add blank...
            pixels_on_this_line = pixels_on_this_line + 1;  % ...and increment counter.
         end
         fprintf( fid, str );                   % Write string to file.
         pixels_on_this_line = pixels_on_this_line + nstr;  % Increment counter.
      end

   else                                  % Binary format.

      fwrite( fid, int, 'uint8' );       % Write as unsigned 8 bit ints.

   end

   pixels_written = pixels_written + pixels_to_write_now;

end

fclose( fid );  % Close file.
