function B=cholhilb(n)

% Cholesky factorization of the Hilbert matrix of order n
% Based on analytic solution provided by Man-Duen Choi, "Tricks or Treats
% with the Hilbert Matrix", The American Mathematical Monthly, Vol. 90, No.
% 5, pp.301-312, 1983
% B(i,j)=sqrt(2j-1)((i-1)!)^2/((i+j-1)!(i-j)!) for i>=j, 0 otherwise.

% By Yi Cao, at Cranfield University, 2nd March 2006
% All rights reserved.

% Accuracy Test:
% n=100; B=cholhilb(n); A=hilb(n); max(max(B*B'-A))
% Speed Test:
% tic;B=cholhilb(1000);toc
% tic;for k=1:100,B=cholhilb(k);end;toc
%

B=zeros(n);
b=1;
for i=1:n,
    c=b;
    d=b;
    for j=1:i,
        c=c*(i+j-1);
        B(i,j)=sqrt(2*j-1)*b*b/(c*d);
        d=d/max(1,(i-j));
    end
    b=b*i;
end