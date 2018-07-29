function dx = stirred_particular(t,x)

%x(1) = x1
%x(2) = x2
%x(3) = p1
%x(4) = p2
global A E
dx = zeros(1,4);

dx(1) = A(1,1)*x(1)+A(1,2)*x(2)+A(1,3)*x(3)+A(1,4)*x(4)+E(1);
dx(2) = A(2,1)*x(1)+A(2,2)*x(2)+A(2,3)*x(3)+A(2,4)*x(4)+E(2);
dx(3) = A(3,1)*x(1)+A(3,2)*x(2)+A(3,3)*x(3)+A(3,4)*x(4)+E(3);
dx(4) = A(4,1)*x(1)+A(4,2)*x(2)+A(4,3)*x(3)+A(4,4)*x(4)+E(4);

dx = [dx(1) dx(2) dx(3) dx(4)]';