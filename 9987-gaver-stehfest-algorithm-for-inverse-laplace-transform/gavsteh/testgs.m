%
% testing the gaver-stehfest module
function y=testgs(L)
% L is the number of coefficients 
% (examples: L=8, 10, 12, 14, 16, so on..)
sum=0.0;
for l=1:20
    t(l)=l * 0.1;
    calcv(l)=gavsteh('fun1',t(l),L);
    exactv(l)=t(l);
    sum=sum+(1- exactv/calcv)^2;
end
result1=[exactv' calcv' calcv'-exactv']
relerr=sqrt(sum)

%another example
sum=0.0;
for l=1:20
    t(l)=l * 0.1;
    calcv(l)=gavsteh('fun2',t(l),L);
    exactv(l)=sin(t(l));
    sum=sum+(1- exactv/calcv)^2;
end
result2=[exactv' calcv' calcv'-exactv']
relerr=sqrt(sum)