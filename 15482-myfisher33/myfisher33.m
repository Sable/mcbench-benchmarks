function Pvalue=myfisher33(x)
%P=MYFISHER33(X)- Fisher's Exact Probability Test on 3x3 matrix.
%Fisher's exact test of 3x3 contingency tables permits calculation of
%precise probabilities in situation where, as a consequence of small cell
%frequencies, the much more rapid normal approximation and chi-square
%calculations are liable to be inaccurate. The Fisher's exact test involves
%the computations of several factorials to obtain the probability of the
%observed and each of the more extreme tables. Factorials growth quickly,
%so it's necessary use logarithms of factorials. This computations is very
%easy in Matlab because x!=gamma(x+1) and log(x!)=gammaln(x+1). This
%function is now fully vectorized to speed up the computation.
% Syntax: 	myfisher33(x)
%      
%     Inputs:
%           X - 3x3 data matrix 
%     Outputs:
%           P - 2-tailed p-value
%
%   Example:
%
%                A   B   C
%           -------------------
%      X         4   1   1
%           -------------------    
%      Y         1   3   1
%           -------------------
%      Z         0   1   5
%           -------------------
%
%   x=[4 1 1; 1 3 1; 0 1 5];
%
%   Calling on Matlab the function: 
%             myfisher33(x)
%
% 3x3 matrix Fisher's exact test: 301 tables were evaluated
% -------------------------------------------------------
% 2-tail p-value = 0.0322177822
% -------------------------------------------------------
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2007) MyFisher33: a very compact routine for Fisher's exact
% test on 3x3 matrix
% http://www.mathworks.com/matlabcentral/fileexchange/15482

%Input Error handling
if ~isequal(size(x),[3 3])
    error('Input matrix must be a 3x3 matrix')
end
if ~all(isfinite(x(:))) || ~all(isnumeric(x(:)))
    error('Warning: all X values must be numeric and finite')
end
if ~isequal(x(:),round(x(:)))
    error('Warning: X data matrix values must be whole numbers')
end

Rs=sum(x,2); %rows sum
Cs=sum(x); %columns sum
N=sum(Rs); %Number of observations

%If necessed, rearrange matrix
if ~issorted(Cs)
    [Cs,ind]=sort(Cs);
    x=x(:,ind);
end
if ~issorted(Rs)
    [Rs,ind]=sort(Rs);
    x=x(ind,:);
end

Kf=sum(gammaln([Rs' Cs]+1))-gammaln(N+1); %The costant factor K=log(prod(R!)*prod(C!)/N!)
zf=gammaln(x+1); %compute log(x!)
op=exp(Kf-sum(zf(:))); %compute the p-value of the observed matrix

% First step: Compute all possible primary tables (play on the first two
% degrees of freedom)
I=0:1:min(Rs(1),Cs(1)); %all possible values of X(1,1)
J=min(Rs(1)-I,Cs(2)); %max value of X(1,2) given X(1,1)
et=sum(J+1); %primary tables to evaluate
m1=zeros(et,3); %matrix preallocation
%set the arrays of indices
idxAstop=cumsum(J+1); 
idxAstart=[1 idxAstop(1:end-1)+1];
%Build-up the matrix
for K=1:length(I)
    m1(idxAstart(K):idxAstop(K),1)=I(K);
    m1(idxAstart(K):idxAstop(K),2)=0:1:J(K);
end
%Put all the possible values of X(1,3) given X(1,1) and X(1,2)
m1(:,3)=Rs(1)-sum(m1(:,1:2),2);

%Second step:
%Compute all possible secondary tables (play on the second two
% degrees of freedom)
m2=repmat(Cs,et,1);
Cs2=m2-m1; %Residual sum of rows given the first row
L=min(Rs(2),Cs2(:,1)); %find the max values of X(2,1) given X(1,1) and X(1,2)
KK=max(L)+1; %Remember that zero is a possible value...
%matrix preallocation
UpB=zeros(et,KK); 
for K=1:KK
%find the max values of X(2,2) given X(1,1), X(1,2) and X(2,2)
    UpB(:,K)=min(Cs2(:,2),Rs(2)-(K-1)); 
end
%matrix preallocation
LoB=zeros(et,KK); InT=repmat(NaN,et,KK);
sectab=zeros(1,et); %array preallocation
for K=1:et
    %find the min values of X(2,2) given X(1,1), X(1,2) and X(2,2)
    z=L(K)+1;
    a=0:1:L(K);
    LoB(K,1:z)=max(0,Rs(2)-a-Cs2(K,3));
    %Compute the range of variation of X(2,2)
    InT(K,1:z)=UpB(K,1:z)-LoB(K,1:z)+1;
    %Compute how many secondary tables are generated from each primary table
    sectab(K)=sum(InT(K,1:z),2);
end
et2=sum(sectab); %total tables to evaluate
%Matrix and vector preallocation
M=zeros(et2,9); 
%Set indices
InT=InT'; InT(isnan(InT))=[];
idxAstop=cumsum(InT(:))';
idxAstart=[1 idxAstop(1:end-1)+1];
idxBstop=cumsum(sectab); idxBstart=[1 idxBstop(1:end-1)+1];
%Build-up the secondary tables
z=1;
for K=1:et
    %Expand the primary table
    M(idxBstart(K):idxBstop(K),1:3)=repmat(m1(K,:),sectab(K),1);
    I=0:1:L(K); %values of X(2,1) given X(1,1) and X(1,2)
    %Put them in the matrix in the correct position
    for J=1:length(I)
        M(idxAstart(z):idxAstop(z),4)=I(J);
        M(idxAstart(z):idxAstop(z),5)=LoB(K,J):1:UpB(K,J); %values of X(2,2) given X(1,1), X(1,2) and X(2,2)
        z=z+1;
    end
end
%Complete the table
M(:,6)=Rs(2)-sum(M(:,4:5),2);
M(:,7:9)=repmat(Cs,et2,1)-M(:,1:3)-M(:,4:6);
zf=gammaln(M+1); %compute log(x!)
np=exp(Kf-sum(zf,2)); %compute the p-value of each possible matrix
P=sum(np(np<op));

%display results
tr=repmat('-',1,55); %Set up the divisor
fprintf('3x3 matrix Fisher''s exact test: %0.0f tables were evaluated\n',et2)
disp(tr)
fprintf('2-tail p-value = %0.10f\n',P);
disp(tr)
if nargout
    Pvalue=P;
end
