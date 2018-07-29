function I=mi(A,B,varargin) 
%MI Determines the mutual information of two images or signals
%
%   I=mi(A,B)   Mutual information of A and B, using 256 bins for
%   histograms
%   I=mi(A,B,L) Mutual information of A and B, using L bins for histograms
%
%   Assumption: 0*log(0)=0
%
%   See also ENTROPY.

%   jfd, 15-11-2006
%        01-09-2009, added case of non-double images
%        24-08-2011, speed improvements by Andrew Hill

if nargin>=3
    L=varargin{1};
else
    L=256;
end

A=double(A); 
B=double(B); 
     
na = hist(A(:),L); 
na = na/sum(na);

nb = hist(B(:),L); 
nb = nb/sum(nb);

n2 = hist2(A,B,L); 
n2 = n2/sum(n2(:));

I=sum(minf(n2,na'*nb)); 

% -----------------------

function y=minf(pab,papb)

I=find(papb(:)>1e-12 & pab(:)>1e-12); % function support 
y=pab(I).*log2(pab(I)./papb(I));
