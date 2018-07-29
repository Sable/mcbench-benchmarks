function [ int, count, msg ] = pnmgeti( fid, n )
%PNMGETI Get integers from an ascii encoded PBM/PGM/PPM file.
%
%   [ INT, COUNT, MSG ] = PNMGETI( FID, N ) tries to read N integers
%   from the ascii encoded PBM/PGM/PPM file with file identifier FID and
%   returns the integers in the vector INT. COUNT is an optional output
%   argument that returns the number of elements successfully read. MSG
%   is an optional output argument that returns an error message string
%   if an error occurred or an empty matrix if an error did not occur.
%
%   If N is omitted, the whole remaining of the file is read.
%
%   The main difference between PNMGETI( FID ) and FSCANF( FID, '%d' )
%   is that PNMGETI ignores comments (from # to end of line). PNMGETI
%   also ignores garbage, which is anything that is neither whitespace,
%   digit nor comment.

%   Author:      Peter J. Acklam
%   Time-stamp:  1998-04-06 02:38:34
%   E-mail:      jacklam@math.uio.no (Internet)
%   URL:         http://www.math.uio.no/~jacklam

%
% Check number of input arguments and assign default value to omitted
% argument.
%
error( nargchk( 1, 2, nargin ) );
if nargin < 2
   n = Inf;
end

% Initialize output arguments.
int   = [];             % Image data vector.
count = 0;              % Number of elements read. Same as length(int).
msg   = '';             % Error message string.

while 1

   % Calculate number of integers missing and try to read that many.
   ints_missing = n - count;
   [ x, this_count ] = fscanf( fid, '%d', ints_missing );

   % Append new data to main data vector and increment counter.
   int = [ int ; x ];
   count = count + this_count;

   % Return if we have got the desired number of elements.
   if count == n
      return
   end

   % Return if we have reached EOF.
   if feof( fid )
      msg = 'End of file reached too early.';
      return
   end

   %
   % If we get here we have reached a comment or some garbage. Garbage
   % is anything that is neither whitespace, digit nor comment.
   %

   char = fscanf( fid, '%c', 1 );
   if ( char == '#' )

      % Found a comment, so skip the rest of the line and redo the loop.
      fgetl( fid );

   else

      % We found some garbage, so give a message.
      msg = 'Garbage found where image data was expected.';

      %
      % Read past the garbage and following whitespace (i.e., until
      % first number character). This would probably be faster if we
      % read and checked a whole vector of data, but it probably won't
      % be executed often. char is empty at EOF.
      %
      while ~isempty( char ) & ( char < '0' | char > '9' )
         char = fscanf( fid, '%c', 1 );
      end

      %
      % Return if we have reached EOF. This error message may overwrite
      % any error message telling about garbage, but that doesn't matter
      % since reaching EOF too early is a more serious error.
      %
      if feof( fid )
         msg = 'End of file reached too early.';
         return
      end

      %
      % We found a number character, so jump back one byte so fscanf
      % catches it.
      %
      fseek( fid, -1, 0 );

   end

end
