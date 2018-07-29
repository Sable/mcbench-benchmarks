function [ i, j, S ] = pendulumDF( y )
%pendulumDF Jacobian of the pendulum equations.

    g = 1;
    m = 1;
    l = 1;

    it = [ 1  3         3          2  4         4         5      5      5      5];
    jt = [ 3  5         1          4  5         2         1      2      3      4 ];
    S = [1  -y(1,1)/m -y(5,1)/m  1  -y(2,1)/m -y(5,1)/m y(3,1) y(4,1) y(1,1) y(2,1) ];
    i = it;
    j = jt;

end

