function VAL=bipval(BIP,ROWCOL) 
%	    BIPolynomial VALue (matrix of size ROWCOL)
%       (based on POLYVAC). 
% Call
%       VAL=bipval(BIP,ROWCOL); 
%Input:		
%		BIP = a BIPolynomial, matrix 
%       of size (ORDVER+1)*(ORDHOR+1),
%       ORDVER, ORDHOR VERtical and HORizontal ORDers
%		ROWCOL = size(VAL), vector [ROW COL]
%       if ROWCOL is a scalar, then COL = ROW
%Output:	
%		VAL = "VALue" of bipolynomial BIP on ROWCOL:
%       matrix of size ROW*COL
%-------------------------------------
% Demo:
%       y=linspace(-1,1,500);
%       x=linspace(-1,1,600); 
%       [X,Y]=meshgrid(x,y);
%       D=X.^3 - X.*Y + 3*Y -Y.^2 +2 ;
%       BIP=bipfit(D,2:3);
%       DD=bipval(BIP,size(D));
%       error=std(D(:)-DD(:))
% ----------------------------------
%See also:   BIPFIT, SURFIT
%          Vassili Pastushenko	12.11.2004
%==============================================================
NAR=nargin;
if NAR<1,
    error('Bipolynomial needed');
end


if NAR<2,
    error('Size of bipolynomial VALue needed');
end

R = ROWCOL(1);
if length(ROWCOL)==1
    C=R;
else
    C=ROWCOL(2);
end
    x=linspace(-1,1,C); 
    y=linspace(-1,1,R);
    BAS=polyvac(BIP.',x);
    VAL=polyvac(BAS.',y);
   