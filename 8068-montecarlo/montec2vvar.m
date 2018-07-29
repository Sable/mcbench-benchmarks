function I=montec2vvar(g,cx,dx,a,b,c,d,n)

%I=montec2vvar('g',cx,dx,a,b,c,d,n)
%Calculates integral on no rectangular space using monte-carlo method
%a,b, fixed boundaries
%cx,dx, variable boundaries (of x)
%c,d fixed boundaries (of y) that form a rectangular space with a and b
%boundaries.
t=rand(1,n);
u=rand(1,n);
x=a+t.*(b-a);			%extremos a,b fijos
y=c+u.*(d-c);			%extremos c,d variabales

cont=0;
s=0;

for i=1:n
   if (y(i)>feval(cx,x(i))&&y(i)<feval(dx,x(i)))
      cont=cont+1;
      fx=feval(g,x(i),y(i));
      s=s+fx;
   end
end

area=(simpson(dx,a,b,20)-simpson(cx,a,b,20))
I=((area./cont).*s);

