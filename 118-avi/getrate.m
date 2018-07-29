function rate = getrate (movie)
% GETRATE (avi class name) returns the frame rate of the movie
% NOTE: some movies will not specify the framerate,
%		  at which point this will be equal to zero
rate = movie.rate;