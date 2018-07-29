function movie = open (movie, filename)
% OPEN (avi class, filename) opens a file for avi class
% NOTE: You must set the class equal to this function

if (~isa(filename, 'char'))
   error ('#AVI Error: open() must accept a string');
else
	movie.filename = filename;
   movie = analyze (movie);
   movie.fid = fopen (movie.filename, 'r');
   if movie.fid < 3
   	error(['#AVI Error: ', filename, ' not found.']);
   end
end 