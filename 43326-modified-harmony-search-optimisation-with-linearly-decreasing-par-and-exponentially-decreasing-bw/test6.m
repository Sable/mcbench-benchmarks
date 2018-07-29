% Shubert test function which has 2 decision variables, has several local optima.
%has 18 global optimum. all decision variables are bounded in [-10
% 10].
%   with f(x)=-186.7309

function shubert=test6(x)
k=0;
h=0;

for i=1:5
    k=k+i*(cos((i+1)*x(1)+i));
     h=h+i*(cos((i+1)*x(2)+i));
end
 shubert=k*h;
