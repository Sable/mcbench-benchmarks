function pbmwrite(arg1,arg2,arg3,arg4)
%PBMWRITE Write a PBM (portable bitmap) file to disk.
%
%   PBMWRITE(X,MAP,'FILENAME') writes a PBM file containing the indexed
%   image X and color map MAP to the file 'FILENAME'.
%
%   PBMWRITE(X,MAP,'FILENAME','ENCODING') where 'ENCODING' is either
%   'ascii' (or 'plain') or 'binary' (or 'raw') lets the user specify
%   whether the PBM file should be ascii or binary encoded. Default is
%   'ascii'.
%
%   PBMWRITE(I,'FILENAME') writes a PBM file containing the black and
%   white image in the matrix I to the file 'FILENAME'.
%
%   PBMWRITE(I,'FILENAME','ENCODING') allows the user to specify the
%   encoding as described above.
%
%   The 'ascii' format is the most portable and is the only that allows
%   a MAXVALUE larger than 255, so it is also the most general. The
%   'binary' format files are, however, much smaller and many times
%   faster to read and write than the 'ascii' format.
%
%   If file name has no suffix, '.pbm' is used.
%
%   See also: PBMREAD, PGMREAD, PGMWRITE, PPMREAD, PPMWRITE.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-15 21:26:36
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

nargs = nargin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check number of input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

error( nargchk( 2, 4, nargs ) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Identify input arguments.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( nargs == 2 )               % 2 input arguments

   %
   % PBMWRITE(I,'FILENAME')
   %
   I = arg1;
   filename = arg2;
   encoding = 'ascii';
   isindexed = 0;

elseif ( nargs == 4 )           % 4 input arguments

   %
   % PBMWRITE(X,MAP,'FILENAME','ENCODING')
   %
   X = arg1;
   map = arg2;
   filename = arg3;
   encoding = arg4;
   isindexed = 1;

else                            % 3 input arguments

   if ( ischar(arg2) & ischar(arg3) )

      %
      % PBMWRITE(I,'FILENAME','ENCODING')
      %
      I = arg1;
      filename = arg2;
      encoding = arg3;
      isindexed = 0;

   else

      %
      % PBMWRITE(X,MAP,'FILENAME')
      %
      X = arg1;
      map = arg2;
      filename = arg3;
      encoding = 'ascii';
      isindexed = 1;

   end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are no longer needed, so delete them to save memory.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear arg1 arg2 arg3 arg4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check filename.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~ischar(filename) | isempty(filename)
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
   filename = [ filename '.pbm' ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check and simplify the encoding specification.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~ischar( encoding )
   error( 'Encoding specification must be a string.' );
end

if any( encoding(1) == 'aApP' )         % Ascii (or plain) format.
   isascii = 1;
elseif any( encoding(1) == 'bBrR' )     % Binary (or raw) format.
   isascii = 0;
else
   error( 'Illegal encoding specification.' );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open output file for writing.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid = fopen( filename, 'w', 'ieee-be' );    % Big-endian byte ordering.
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
   magic = 'P1';
else
   magic = 'P4';
end

% Write header. Use FLOOR( CLOCK ) to avoid a second value of 60.
fprintf( fid, [ ...
   '%s\n', ...
   '# Created by Matlab (%s) %04d-%02d-%02d %02d:%02d:%02d\n', ...
   '%d %d\n', ...
   ], magic, mfilename, floor( clock ), cols, rows );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Write image. Color images are first converted to grayscale.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

w = [ 0.298936 ; 0.587043 ; 0.114021 ];

if isascii
   bits_on_this_line = 0;
   bits_on_each_line = 35;
   format = [ '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d ' ...
              '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d ' ...
              '%d %d %d %d %d\n' ];
else
   cols8 = 8*ceil( cols/8 );
end

for row = 1:rows

   % Convert to ones (black) and zeros (white).
   if isindexed
      bits = 1 - round( map(X(row,1:cols),:)*w );
   else
      bits = 1 - round( I(row,1:cols))';
   end

   if isascii           % Write ascii format.

      % If we are to fill more characters on a line already begun.
      if bits_on_this_line > 0

         % Get the format to be used when filling the rest of this line
         % and the number of bits that can be fit on this line.
         sub_format = format(bits_on_this_line*3+1:length(format));
         bits_to_eol = bits_on_each_line - bits_on_this_line;

         % Get the bits to write on this line and the remaining bits.
         bits_to_write_now = min( length(bits), bits_to_eol );
         sub_bits = bits(1:bits_to_eol);
         bits = bits(bits_to_eol+1:length(bits));

         % Write bits to file and increment number of bits on this line.
         fprintf( fid, sub_format, sub_bits );
         bits_on_this_line = bits_on_this_line + bits_to_write_now;
         bits_on_this_line = rem( bits_on_this_line, bits_on_each_line );

      end

      % If we are to begin writing on a new line.
      if bits_on_this_line == 0

         % Write bits to file and get number of bits on last line.
         fprintf( fid, format, bits );
         bits_on_this_line = rem( length(bits), bits_on_each_line );

      end

   else                 % Write binary format.

      newbits = zeros( 1, cols8 );
      newbits(1:cols) = bits;
      fwrite( fid, newbits, 'ubit1' );

   end

end

fclose( fid );          % Close file.
