
m = [1:99] * 0.01;
k = sqrt(m);
phi = pi/2.0;

K = lellipf(phi, k, 1.0e-10);

E = lellipe(phi, k, 1.0e-10);

n = -0.7;
alpha = [0:15:90] * pi / 180;
kp = sin(alpha);
EPi = lellippi(phi, kp, n, 1.0e-10);

%[m;K]'