function movie = close (movie)
% CLOSE (avi class name) closes the class deletes all values
% NOTE: You must set the class equal to this function

fclose (movie.fid);
clear movie;