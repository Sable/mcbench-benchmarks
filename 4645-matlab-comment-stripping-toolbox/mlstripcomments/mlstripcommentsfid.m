function status_out = mlstripcommentsfid(ifid, ofid)
%MLSTRIPCOMMENTSFID Strip comments from code read from file identifier.
%
%   STATUS = MLSTRIPCOMMENTSFID(IFID, OFID) reads MATLAB code, line by line,
%   from the file identifier IFID, strips all MATLAB comments, and writes the
%   result on the output file identifier OFID.  For instance, setting OFID to 1
%   (standard output) will print the result on the screen.  STATUS is 0 if all
%   output was written successfully, and -1 if an error occurred.
%
%   See also MLSTRIPCOMMENTSFILE, MLSTRIPCOMMENTSSTR.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-03-18 08:23:19 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Status is 0 if all output was written successfully, and -1 otherwise.
   status = 0;

   while 1

      % Read input line.
      line = fgetl(ifid);
      if ~ischar(line)
         break;
      end

      % Strip MATLAB comments.
      line = mlstripcommentsstr(line);

      % Write output line.
      count = fprintf(ofid, '%s\n', line);

      % See if an error occurred while writing.
      if count < length(line)
         status = -1;
         break;
      end

   end

   % Only set output variable if it is wanted.
   if nargout
      status_out = status;
   end
