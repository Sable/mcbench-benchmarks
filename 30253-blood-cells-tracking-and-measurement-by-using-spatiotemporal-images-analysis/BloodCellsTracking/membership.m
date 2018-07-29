function y = membership(x,delta)

a = 1-delta;
b = 1+delta;
if  x < a;
    y = 0;
elseif  x>= a && x<= b 
        y = 0.5+0.5*sin((pi/(b-a)).*(x-(b+a)/2));
elseif  x > b
        y = 1;
end


