function [i]=simpson(f,a,b,n)

% [i]=simpson(f,a,b,n)
% f: function to integrate
% a,b: Integration interval
% n: Number of subintervals (must be an even number)

h=(b-a)/n			
x=a:h:b;			
y=feval(f,x);		

p(1)=1;
for k=2:2:n
   p(k)=4;
   p(k+1)=2;
end
p(n+1)=1;
p=p.*h/3;
% p: vector de pasos

i=p*y';