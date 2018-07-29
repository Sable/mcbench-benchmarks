function weights=Ohaganw(n,alpha)
total=[];
l=alpha;
x0 = 0;           % Make a starting guess at the solution
[x,fval,exitflag,output] = fsolve(@ (w1) (w1*((n-1)*l+1-n*w1)^n )-( ((n-1)*l)^(n-1)*(((n-1)*l-n)*w1+1) ),x0,optimset('Display','off'));  % Call solver
w1=x;
wn=( ((n-1)*l-n)*w1+1)/( (n-1)*l+1-n*w1  );
we=[];
for i=2:n-1
    w=(w1^(n-i)*wn^(i-1))^(1/(n-1));
    we=[we w];
end
weights=[w1,we,wn];
tot=sum(weights);
w=weights/tot;
total=[total; w];
weights=total;
