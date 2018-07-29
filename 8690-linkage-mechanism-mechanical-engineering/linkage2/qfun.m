   function [y1,y2] = qfun(a,b,c)
   % it is the root of a quadratic function
        y1 = (-b + sqrt(b^2-4*a*c))/(2*a);
        y2 = (-b - sqrt(b^2-4*a*c))/(2*a);