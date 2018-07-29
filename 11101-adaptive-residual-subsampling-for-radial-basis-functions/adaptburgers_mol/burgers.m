function dudt = burgers(t,u,epsilon,D1,D2)

dudt = epsilon*D2*u - u.*(D1*u);