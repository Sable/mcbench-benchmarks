function g=mylocstat(Iloc,M,D,E,k)
%MYLOCSTAT - perform single-back gray value 
%	imadjustation based on local statistics for sliding block operation.
% Motivation: try local statistics enhancement operation.
% Parameters:
%	Iloc - the local neighbourhood of image to be processed.
%	M - the global mean of image's gray values.
%	D - the global variance of image's gray values.
%	E - the ehancement constant
%	k - the 1x3 sized threshold vector:
%		- k(1) is mean threshold
%		- k(2) and k(3) are variance threshold

% Copyright by Alex Zuo.

%Localize the center of the block.
Bcenter=floor((size(Iloc)+1)/2);
xc=Bcenter(1);yc=Bcenter(2);
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
Mloc=mean2(Iloc);
Dloc=std2(Iloc);
%Build the local response.
if (Mloc<=k(1)*M) && (Dloc>=k(2)*D) && (Dloc<=k(3)*D)
      g=E*Iloc(xc,yc);
else
      g=Iloc(xc,yc);
end
