% function m = evalf(trueclass,cl,x,sfct)
% DESCRIPTION
%   computes f1 measure
%   ignores x and sfct - just for compatibility
% Copyright (c) 1998-2002 by Alexander Strehl
function m = evalf(trueclass,cl,x,sfct)

remappedcl = zeros(size(cl));

A = zeros(max(cl),2+max(trueclass));
for i=1:max(cl),
 activepoints = find(cl==i);                             
 nu1=trueclass(activepoints);                              
 num=max(trueclass);
 composition = hist(nu1,1:num);
 j = find(composition==max(composition));
 j = j(1);
 A(i,:) = [j i composition];
end;
A = sortrows(A);
A = A(:,3:size(A,2));
nha = sum(A,1);
nell = sum(A,2);
nhamatrix = ones(length(nell),1) * nha;
nellmatrix = nell * ones(1,length(nha));
fmatrix = (2*A) ./ (nhamatrix+nellmatrix);
m = sum(max(fmatrix,[],1) .* nha) / length(trueclass);

