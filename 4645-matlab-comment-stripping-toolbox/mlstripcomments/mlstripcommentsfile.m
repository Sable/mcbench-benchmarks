function mlstripcommentsfile(infile, outfile)
%MLSTRIPCOMMENTSFILE Strip comments from a file with MATLAB code.
%
%   MLSTRIPCOMMENTSFILE(INFILE, OUTFILE) reads the m-file INFILE, line by line,
%   strips all MATLAB comments , and writes the result to the file OUTFILE.
%
%   Note that you should never specify the same value for INFILE and OUTFILE.
%   Since the output file is opened for writing before any data is read from
%   the input file, the file will be empty and the data will be lost.
%
%   See also MLSTRIPCOMMENTSFID, MLSTRIPCOMMENTSSTR.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-03-18 08:23:19 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 2, nargin));

   % See if the input file exists.
   if ~exist(infile, 'file')
      error([infile ': no such file or directory.']);
   end

   % Open the input file for reading.
   ifid = fopen(infile, 'rt');
   if ifid < 0
      error([infile ': can''t open file for reading.']);
   end

   % Open the output file for writing.
   ofid = fopen(outfile, 'wt');
   if ofid < 0
      closefid(ifid, infile);
      error([outfile ': can''t open file for writing.']);
   end

   % Strip MATLAB comments.
   status = mlstripcommentsfid(ifid, ofid);

   % See if an error occurred while writing to file.
   if status < 0
      closefid(ifid, infile);
      closefid(ofid, outfile);
      error([outfile ': error while writing to file.']);
   end

   % Close input and output file handles.
   closefid(ifid, infile);
   closefid(ofid, outfile);

function closefid(fid, filename)
%CLOSEFID Close a file identifier.
%
%   CLOSEFID(IFID, FILENAME) closes the specified file identifier.

   status = fclose(fid);
   if status < 0
      error([filename ': can''t close file.']);
   end
