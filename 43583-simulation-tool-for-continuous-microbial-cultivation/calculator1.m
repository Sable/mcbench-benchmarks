function xdot = calculator1(t,x)

global D S_0 Y_XS Y_PX mu_max K_S

xdot = [x(1)*(x(4)-D);
    D*S_0 - D*x(2)-1/Y_XS*x(1)*x(4);
    x(3)*(-D)+Y_PX*x(1)*x(4);
    ((mu_max*(K_S+x(2))-mu_max*x(2))/(K_S+x(2))^2)*(D*S_0 - D*x(2)-1/Y_XS*x(1)*x(4))];

end