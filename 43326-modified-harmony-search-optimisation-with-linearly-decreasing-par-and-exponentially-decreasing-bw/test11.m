% "Trid test function which has n decision variables, has no local optima.
%has one global optimum. all decision variables are bounded in [-n^2
% n^2]. One global minimum   with f(x)=-50 for n=6 and f(x)=-200 for n=10.



function s=test11(x)
k1=0;
k2=0;

for i=1:numel(x)
    k1=k1+(x(i)-1).^2;
end
for j=2:numel(x)
    k2=k2+(x(j)*x(j-1));
end
s=k1-k2;