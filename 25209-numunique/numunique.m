function [x, p, f]=numunique(x)
%NUMUNIQUE Numerical set unique.
% [B P F]=numunique(A) for the array A returns the same values as in A but
% with no repetitions. B will also be sorted. A can only be numerical, 
% as the name of the function suggests.
%
% The second output, P, is a row of cells, containing the indices of A, 
% such that, A(p{n})=B(n) is true. P has the same number of cells as the 
% number of elements in B.
%
% Note that each cell of P lists all the indices of A, not only the first 
% or last occurrence, which have the repetitious values. It is this nature
% of the second output makes this function different to the Mathwork's
% function UNIQUE. Sometimes we need to know all the indices of which A 
% have the same values. 
% 
% The third optional output, F, is for the indices of the first occurrences
% of repetitious values, so that B==A(F) is true.
%
% Example, let  A = [1 1 5 6 2 3 3 9 8 6 2 4], then
%            [B P F]=numunique(A)
% results in 
%            B =[1 2 3 4 5 6 8 9],
% P = 
%  [1x2 double] [1x2 double] [1x2 double]  [12]  [3]  [1x2 double] [9] [8]
% and
% F =
%    1     5     6    12     3     4     9     8
%
% Check for the second element B for example, P{2}=[5 11],
% A([5 11])=[2 2], which are all equal to B(2). And of course, B-A(F) 
% gives all 0's.
% 
% Note that the first output can be a row or column vector depends on the
% input is a row vector or otherwise (column or matrix). However the second
% output P is always a row of cells. To force P in a row order has an
% advantage, so that you can get A sorted with a shortcut of A([P{:}]).
%
% See also UNIQUE
%
% Zhigang Xu. 02-Sep-2009. Updated on 05-Sep-2009.

isrowvec=size(x,1)==1;

if nargout<=1
	x=sort(x(:));
	n=[true; diff(x)~=0];
	x=x(n);
	if isrowvec, x=x.'; end
	return
end

[x s]=sort(x(:));
s=s.';
N=numel(x);
n=find([true; diff(x)~=0]);
x=x(n);
K=numel(x);
if isrowvec, x=x.'; end

switch(nargout)
	case{2}
		if K==1
			p{1}=s;
		else
			p{K}=s(n(K):N);
			for k=1:K-1
				p{k}=s(n(k):n(k+1)-1);
			end
		end
	case{3}
		if K==1
			p{1}=s;
			f(1)=p{1}(1);
		else
			p{K}=s(n(K):N);
			f(K)=p{K}(1);
			for k=1:K-1
				p{k}=s(n(k):n(k+1)-1);
				f(k)=p{k}(1);
			end
		end
	otherwise
		error('More than 3 outputs are not allowed!')
end
end
