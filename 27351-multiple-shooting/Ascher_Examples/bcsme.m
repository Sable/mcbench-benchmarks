function res = bcsme(ya,yb)
res = eye(3)*ya+eye(3)*yb-[(1+exp(6));(1+exp(6));(1+exp(6))];