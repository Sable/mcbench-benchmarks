    function  [y1,y2,y3] = x4fun(x1,x2,r3,l)
%     the three coefficients of x4 functions
           y1 = -2*x1*l + x2^2 + x1^2 + l^2;
           y2 = 2*l*x2*x1 - 2*x2*r3^2;
           y3 = -x1^2*r3^2 + x1^2*l^2-l^2*r3^2 + r3^4;