function I=gausslaguerr(f2,a,b,n)

%I=gausslaguerr(f,a,b,n)
%Aproximates integral using Gauss-Laguerre method

%Laguerre polynomial
p=polelague(n);
%Roots
x=roots(p(n+1,:));

G=feval(f2,x);		%Function evaluation on the nodes

%Coeficients
for i=1:n
   C(i)=((factorial(n).^2).*x(i))./(polyval(p(n+1,:),(x(i))).^2);
end


I=dot(C,G);
