function nconsec = nconsecutive(x)
% NCONSEC = NCONSECUTIVE(X) returns a vector containing the maximum number of
%    consecutive integers in each row of matrix x.
%
% Note that while this code is not vectorized, it was tested against two different 
%    vectorized versions; the for-loop code ran about twice as fast as the vectorized versions.
%
% Example:
%    nconsec = nconsecutive([1 2 3 5 6 7; 8 7 6 2 4 1; 2:7; 9:-1:5 5])
%
% Written by Brett Shoelson, Ph.D.
% brett.shoelson@joslin.harvard.edu
% 10/15/01

[rows,cols]=size(x);
nconsec = ones(rows,1);

for rowind = 1:rows
	tmp = diff(x(rowind,:));
	if ~isempty(find(tmp == 1))
		indother = [0 find(tmp ~= 1)];
		indother = [indother cols];
		diff1 = diff(indother);
	else
		diff1 = 1;
	end
	
	if ~isempty(find(tmp == -1))
		indother = [0 find(tmp ~= -1)];
		indother = [indother cols];
		diff2 = diff(indother);
	else
		diff2 = 1;
	end
	nconsec(rowind) = max([diff1 diff2]);
end