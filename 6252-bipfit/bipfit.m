function BIP=bipfit(D,VERHOR)
%	   FIT  BIPolynomial to a matrix 
%      (bipfit is based on POLYFIC) 
%Input:		
%		D = data matrix
%		VERHOR = size( BIP), or 
%       VERHOR = orders of BIP in VERtical
%       and HORizontal directions; 
%       if VERHOR is scalar, VERHOR(2)=VERHOR(1)
%Output:
%       BIP = approximating BIPolynomial, 
%       matrix of size VER*HOR
%--------------------------------
% Demo:
%       y=linspace(-1,1,500);
%       x=linspace(-1,1,600); 
%       [X,Y]=meshgrid(x,y);
%       D=X.^3 - X.*Y + 3*Y -Y.^2 +2 ;
%       tic,BIP=bipfit(D,2:3);toc
%       BIP
% ----------------------------------
%See also: BIPVAL, SURFIT
%    Vassili Pastushenko,	12.11.2004. 
%==============================================================
NAR=nargin;
if NAR<1, error('Data needed'),end
if NAR<2,
    error('Size of bipolynomial needed')
end
LV=length(VERHOR);

if LV==1
    VERHOR(2)=VERHOR(1);
end
VER=VERHOR(1);
HOR=VERHOR(2);

[R,C]=size(D);
y=linspace(-1,1,R);
x=linspace(-1,1,C); 
BAS=polyfic(y,D,VER);
BIP=polyfic(x,BAS',HOR);
