function ind=qilv(I,I2,Ws)

% QILV() 
%==================================================================
% Quality Index based on Local Variance
% Santiago Aja-Fernandez
%
% santi@bwh.harhard.edu
% Accorging to
%
% S. Aja-Fernández, R. San José Estépar, C. Alberola-López and C.F. Westin,
% "Image quality assessment based on local variance", EMBC 2006, 
% New York, Sept. 2006.
%
%------------------------------------------------------------------
%
% The function calculates a global compatibility measure
% between two images, based on their local variance distribution.
%
%------------------------------------------------------------------
%
% INPUT:   (1) I: The first image being compared
%          (2) I2: the second image being compared
%          (3) Ws: window for the estimation of statistics:
%		If Ws=0: default gaussian window
%               If Ws=[M N] MxN square window
%  
%
% OUTPUT:
%          (1) ind: Quality index (between 0 and 1)
%
% Default usage:
%
%   ind=s_correct(I,I2,0);
%
% 
%==================================================================



%the following variables can be added to avoid NaN, but
%usually it is not necessary

L=255;
K=[0.01 0.03];
C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
%C1=0;
%C2=0;

%Window
if Ws==0
	window = fspecial('gaussian', 11, 1.5);
else
	window=ones(Ws);
end
window = window/sum(window(:));


%Local means
M1=filter2(window, I, 'valid') ;
M2=filter2(window, I2, 'valid') ;
%Local Variances
V1 = filter2(window, I.^ 2, 'valid') - M1.^ 2;
V2 = filter2(window, I2.^ 2, 'valid') - M2.^ 2;


%Global statistics:

m1=mean(V1(:));
m2=mean(V2(:));
s1=std(V1(:));
s2=std(V2(:));
s12=mean2((V1-m1).*(V2-m2));

%Index
ind1=((2*m1*m2+C1)./(m1.^2+m2.^ 2+C1));
ind2=(2*s1*s2+C2)./(s1.^ 2+s2.^ 2+C2);
ind3=(s12+C2/2)./(s1*s2+C2/2);
ind=ind1.*ind2.*ind3;

