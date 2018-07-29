function [matrix] = getframe (movie, index)
% GETFRAME (avi class name, index) takes movie and index, returns a matrix
% The index must be > 0 and < getnumframe(avi class name)

JUNK         = [74 85 78 75];

if (~isa (movie, 'avi'))
   error ('#AVI Error: first argument must be avi class');
elseif (~isa (index, 'double'))
   error ('#AVI Error: second argument must be a double');
elseif (index < 1)
   error ('#AVI Error: index is too low');
elseif (movie.num_frames ~= 0 & index > movie.num_frames)
   error ('#AVI Error: index is too great');
elseif (movie.fid < 3)
   error ('#AVI Error: file must be open prior to read');
else
   if (movie.idx1 == 1)
   	fseek(movie.fid,movie.movi_loc+7+movie.index(index),-1);
   else
		fseek(movie.fid, movie.movi_loc+3+(movie.frame_length+8)*(index-1), -1);
		f_header = uint8(fread(movie.fid, 8, 'uint8')');
		f_length = parse (f_header(5:8));

		while 1;
    		if (f_header(1:4)==JUNK );
    		  %found a JUNK frame and skipping it...
    		  fseek(movie.fid, f_length, 0);
    		  f_header = uint8(fread(movie.fid, 8, 'uint8')');
    		  f_length = parse (f_header(5:8));    
   		elseif f_length==0;
      	  %found empty frame and skipping it...
           f_header = uint8(fread(movie.fid, 8, 'uint8')');
   	     f_length = parse (f_header(5:8));    
  			else
      	  %found valid frame....
   		  break;
			end   
      end
   end
   for u=movie.lines:-1:1
      matrix(u,:) = uint8(fread(movie.fid, (movie.frame_length/movie.bytes)/(movie.lines), 'uint8'));
   end
end
