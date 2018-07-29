function a = reduce_rows(a);
% function a = reduce_rows(a);
% reduction of inequalities of the form A*x <= b where a = [A,b] due to redundancies
%   Input:  a ... matrix of size m x n
%   Output: a ... matrix of size ... x n
%   (c) Sebastian Siegel, created: 2005/06/08, last modified: 2005/07/06

[m,n] = size(a);
a = sortrows(a);	% sort rows according to 1., 2., 3., ... column (ascending)
			% purpose: "normalize" according to first column later

% before actually reducing similar rows, let's also check if there are similarities that differ by a factor (therefore "normalize")

nneg = sum(a(:,1)<0);	% count negative entries in first column
nzer = sum(a(:,1)==0);	% count zero entries in first column
npos = sum(a(:,1)>0);	% count positive entries in first column

a = [a a]; % purpose: will work on "normalized" a and original a
% divide according to entries in first column (if not zero):
a(1:nneg,1:n) = a(1:nneg,1:n)./-(a(1:nneg,1)*ones(1,n)); % the negative part
a(nneg+nzer+1:m,1:n) = a(nneg+nzer+1:m,1:n)./(a(nneg+nzer+1:m,1)*ones(1,n)); % the positive part
% now a(:,1:n) is "normalized" and a(:,n+1:2*n) is still the original a

% sort according to "normalized" a
a = sortrows(a,1:n);

% delete similar rows (according to a(:,1:n-1)) => (save the min value of b):
nsimilar = sum(sum((a(1:m-1,1:n-1) == a(2:m,1:n-1)),2)==n-1); % ...
% (a(1:m-1,1:n-1) == a(2:m,1:n-1)) ... similar neighbored rows (disregard 
%    column n which represents b) will produce [1 1 1 ...], other have entries with '0'
% sum( expression above ,2) ... add entries in a row
% expression above == n-1 ... test if all entries in a row were 1 
% sum( expression above ) ... get the number of similar rows
if nsimilar > 0, % true if redundant rows exist
	a(:,n+1:2*n)=a(:,n+1:2*n).*([1;(1-(sum((a(1:m-1,1:n-1) == ...
	    a(2:m,1:n-1)),2)==n-1))]*ones(1,n)); % ...
	% [1;(1-(sum((a(1:m-1,1:n-1) == a(2:m,1:n-1)),2)==n-1))] ... column vector
	%      where each '0' represents a row which is similar to the one above
	% ( expression above *ones(1,n)) ... expand column vector to matrix where
	%      each row consists of the same entries
	% a(:,n+1:2*n).* expression above ... now each redundant row has entries with %      zeros only in the right half of a
	a = sortrows(a(:,n+1:2*n)); % sort rows according to n+1., n+2., n+3., ... 
	%      column (ascending) of a and save result to a 
	%      (now a has only n columns again)
	[temp,position]= max(sum(a==zeros(m,n),2)==n); % ...
	% find position of the first redundant row
	a = [a(1:position-1,:); a(position+nsimilar:m,:)]; % assemble a without
	%      redundant rows
else
	a = a(:,n+1:2*n); % reduce a to original part (right half)
end
