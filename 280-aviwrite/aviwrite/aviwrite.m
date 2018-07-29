function varargout = aviwrite(Filename, MM, varargin)
%AVIWRITE  Write an AVI file.
%
%   AVIWRITE(FILENAME,M) writes the movie M, which must be an array
%   of movie frames produced by GETINDEXEDFRAME, to the file FILENAME.
%   FILENAME should have an extension of ".avi" to be recognized by the
%   built-in Windows .avi viewer.
%
%   AVIWRITE(FILENAME,M,FPS) writes a movie that *attempts* to play at 
%   a speed of FPS frames per second.  The default is 10.  FPS must be 
%   an integer between 1 and 255, although high frame rates may not be 
%   playable at full speed on your computer.  
%
%   AVIWRITE(FILENAME,M,FPS,'menu') pops up a window that allows you to
%   choose a compression/decompression algorithm ("codec") from a menu.
%   The default is "Microsoft Video 1" with a Compression Quality of 
%   100 and a maximum of 60 frames between each key frame.  (A "key 
%   frame" is always recorded explicitly, pixel by pixel; other frames 
%   may be encoded relative to the preceding or following frame in 
%   order to reduce the file size.)
%
%   Note: the codecs may not all work, depending on your computer's 
%   configuration; also, some will perform much better than others in 
%   terms of quality and compression ratio.  Trial and error is the
%   only way to find out which codec is the most effective for your 
%   particular application.
%
   
%----------------------> Check validity of input arguments. <-------------------------
if ~ischar(Filename),
   fprintf(1,'??? aviwrite: First argument (filename) must be a string.\n')
   return;
end;
if max(isspace(Filename)),
   fprintf(1,'!!! aviwrite: Warning: white space characters found in file/path name.\n');
   fprintf(1,'              Results are unpredictable.\n');
end;

if (~isstruct(MM) | ~isfield(MM,'colormap') | ~isfield(MM,'cdata') | min(size(MM)) ~= 1 ),
   fprintf(1,'??? aviwrite: Second argument (movie) must be a vector; each element\n');
   fprintf(1,'    should be a structure created by GETFRAME or GETINDEXEDFRAME.\n');
end;

ChooseCodec=my_uint8(0);
FPS=my_uint8(10);

if nargin>=3,
   if (~isa(varargin{1},'double') | varargin{1}>255 | varargin{1}<1),
      fprintf(1,'??? aviwrite: Third argument (frames per second) must be a number\n');
      fprintf(1,'between 1 and 255.\n');
      return;
   else
      FPS=my_uint8(round(varargin{1}));
   end;
end;

if nargin>=4,
   if ~ischar(varargin{2}),
      fprintf(1,'??? aviwrite: Fourth argument should be a string (or omitted).\n');
      return;
   elseif strcmpi(varargin{2},'menu'),
      ChooseCodec=my_uint8(1);
   end;
end;

if nargin>=5,
   fprintf(1,'??? aviwrite: arguments after the first four will be ignored.\n');
end;

%---------------------------> Attempt to write the AVI file. <---------------------------------

CMakeAVI(Filename,MM,FPS,ChooseCodec);

return;

