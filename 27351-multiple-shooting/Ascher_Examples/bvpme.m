function y=bvpme(t,x,flag,U)
A=[1-2*cos(2*t) 0 1+2*sin(2*t);
    0 2 0;
    -1+2*sin(2*t) 0 1+2*cos(2*t);];
q=exp(t)*[-1+2*cos(2*t)-2*sin(2*t);
    -1;
    1-2*cos(2*t)-2*sin(2*t);];
y = A*x+q;
end

