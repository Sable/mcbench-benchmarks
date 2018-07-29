function [A,b] = fourmotz(A,b,nvar);
% function [result] = fourmotz(A,b);
% Fourier-Motzkin Elimination for the problem A*x <= b
% with elimination of redundant inequalities
%   Input:  A ... matrix of size m x n
%           b ... vector of size m x 1
%           nvar (optional) ... number of variables that shall remain
%   Output: [A,b] reduced system of inequalities with all but nvar eliminated variables
%   calls:  reduce_rows
%   Programming acc. to /Sch86a/ pages 155-156
%
%    @book{Sch86a,
%       author    = {Schrijver, A.},
%       title     = {Theory of {L}inear and {I}nteger {P}rogramming},
%       year      = 1986,
%       publisher = {John Wiley \& Sons ltd.}
%    }
%
%   (c) Sebastian Siegel, created: 2005/06/08, last modified: 2005/06/08

if nargin < 3,
	nvar = 1; 			% if nvar was not specified: choose 1
end

[m,n] = size(A);

if n > nvar,
	temp = [A,b];			% compound matrix [A|b]
	temp = sortrows(temp,1);	% sort according to first column
	nneg = sum(temp(:,1)<0);	% count negative entries in first column
	nzer = sum(temp(:,1)==0);	% count zero entries in first column
	npos = sum(temp(:,1)>0);	% count positive entries in first column
	% realign the matrix => entries in first column: pos, neg, zero:
	temp = [temp(nneg+nzer+1:m,:);temp(1:nneg,:);temp(nneg+1:nneg+nzer,:)];
	% divide according to entries in first column (see /Sch86a/: page 155, (16)):
	temp(1:npos+nneg,:) =...
	     temp(1:npos+nneg,:)./abs(temp(1:npos+nneg,1)*ones(1,n+1));
	     
	A = zeros(npos*nneg+nzer,n);	% provide A of "appropriate" size
	for i=1:npos,
		% (see /Sch86a/: page 155, (19))
		A((i-1)*nneg+1:i*nneg,:) =...
		    ones(nneg,1)*temp(i,2:n+1)+temp(npos+1:npos+nneg,2:n+1);
	end
	% append inequalities whose first column had a factor of zero:
	A(npos*nneg+1:npos*nneg+nzer,:) = temp(npos+nneg+1:m,2:n+1);

	A = reduce_rows(A);		% reduce size by deleting redundant entries
					% my own idea
		
	b = A(:,n);			% extract vector b
	A = A(:,1:n-1);			% reduce to the relevant A
	
	[A,b] = fourmotz(A,b,nvar);		% recursive call
elseif n > 0,	% reduction allowed, but no (further) fourier-motzkin elimination:
	temp = reduce_rows([A,b]);		% reduce size by deleting redundant 
						% entries, my own idea

	b = temp(:,n+1);			% extract vector b
	A = temp(:,1:n);			% reduce to the relevant A
end
