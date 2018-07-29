function movie = avi (a)
% AVI Avi Reading Class
% AVI() creates an avi class with no set values
% AVI(avi class name) copies the contents of the passed avi class
% AVI(filename) opens the file with the passed filename

if nargin == 0
   movie.fid 				= 0;
   movie.filename 		= '';
   movie.lines 			= 0;
   movie.columns 			= 0;
   movie.bytes 			= 0;
   movie.color_depth		= 0;
   movie.num_frames 		= 0;
   movie.frame_length	= 0;
   movie.rate				= 0;
   movie.movi_loc			= 0;
   movie.num_input		= 5000;
   movie.idx1				= 0;
   movie.index				= 0;
   movie						= class (movie, 'avi');
elseif isa (a, 'avi')
   movie = a;
elseif isa (a, 'char')
   movie = avi;
   movie = open (movie, a);
else
   error ('#AVI Error: input arguments unacceptable');
end