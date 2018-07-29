function check_point = terminate(xi_1,xi,pi_1,pi)

temp1 = max(abs(xi_1(1,:)-xi(1,:))) + max(abs(pi_1(1,:)-pi(1,:)));
temp2 = max(abs(xi_1(2,:)-xi(2,:))) + max(abs(pi_1(2,:)-pi(2,:)));

check_point  = temp1+temp2;