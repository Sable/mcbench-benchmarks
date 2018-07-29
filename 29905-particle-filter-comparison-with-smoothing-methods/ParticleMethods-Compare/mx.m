function y=mx(a,x)
if length(a)==1
%y=(1-a)*x;
y=a*x;
else
%y=(1-a(1))*x+a(2);
y=a(1)*x+a(2);
end