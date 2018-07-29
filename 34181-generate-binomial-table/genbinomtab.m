function binomvtot = genbinomtab(nmax,~)

%this function generates all the possible binomial coefficients of the form
% nchoosek(n,k) with n <= nmax note that only k <= n are considered
% n and k both start from zero but matlab arrays start from one hence
% nchoosek(n,k) = binomvtot(n+1,k+1)
binomvtot = zeros(nmax+1); 

% if a second argument is given it will generate the log of this function

if nargin==1
 
 % This is no longer used as it isn't as good!
 
%  for n = 1:nmax  %note n=a but index is offset by 1
%     binomvtot(n+1,1:n+1) = [binomvtot(n,1:n)./(1:-1/n:1/n),1];   
%  end
 
 %use instead n choose k = [(n-1) choose k-1 ] + [n choose k -1 ]
binomvtot(:,1)=1;
 for n = 2:nmax+1  %note n=a but index is offset by 1
        binomvtot(n,2:n) = binomvtot(n-1,2:n)+binomvtot(n-1,1:n-1);
 end
 
else %take logs, note that biomial coeffs are given by exp of this
     %this uses the recurrsion relation valid for k \le n-1
 % nchoosek(n,k) = nchoosek(n-1,k) *n/(n-k)    n/(n-k) = 1/(1-k/n)
 % and nchoosek(a,a) == 1
 for n = 1:nmax  %note n=a but index is offset by 1
    binomvtot(n+1,1:n) = binomvtot(n,1:n)-log(1:-1/n:1/n);   
 end        
end

 %uncomment to test, I have found the relative differences, i.e. elements
 %of (binomvtot - binomvtot2)./binomvtot2 to be of order eps 
% tic
% binomvtot2 = zeros(nmax+1); 
% for n = 0:nmax
%     for nn=0:n
%     binomvtot2(n+1,nn+1) = nchoosek(n,nn);
%     end
%  end
% toc
% diff = (binomvtot - binomvtot2)./binomvtot2;
% diff(isnan(diff))=0
% max(abs(diff))


