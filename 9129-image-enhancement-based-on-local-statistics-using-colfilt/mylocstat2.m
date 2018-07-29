function g=mylocstat2(Icol,M,D,E,k)
%MYLOCSTAT2 - perform single-back gray value 
%	imadjustation based on local statistics for sliding block operation.
% Motivation: try local statistics enhancement operation.
% Parameters:
%	Icol - the matrix includes the columns of all local neighbourhoods.
%	M - the global mean of image's gray values.
%	D - the global variance of image's gray values.
%	E - the ehancement constant
%	k - the 1x3 sized threshold vector:
%		- k(1) is mean threshold
%		- k(2) and k(3) are variance threshold

% Copyright by Alex Zuo.

%Localize the center of the each columnwise block.
Bcenter=floor((size(Icol,1)+1)/2);
g=Icol(Bcenter,:);
%Preprocess the input parameters.
if (nargin<5)
      k=[0.4 0.02 0.4];
end
if (nargin<4)
      E=4.0;
end
if (nargin<3)
      display('Mean and Variance must be provided!');
end
%Compute the local mean and variance.
Mcol=mean(Icol);
Dcol=std(Icol);
%Build the local response.
resind=find((Mcol<=k(1)*M) & (Dcol>=k(2)*D) & (Dcol<=k(3)*D));
g(resind)=E*Icol(Bcenter,resind);