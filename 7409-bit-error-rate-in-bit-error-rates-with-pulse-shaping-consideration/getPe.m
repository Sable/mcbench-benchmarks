function [Peg, Peh] = getPe(K, Ec, No, N, pulse);

[mew, sigma] = get_mean_var_G(K, N, Ec, pulse.m1);
Ig = sqrt(N*No/2 + mew);
Th = N*sqrt(Ec);       %Non- Coherent
Peg = qfunc(Th/Ig);
[mew, sigma] = get_mean_var_H(K, N, Ec, pulse.m1, pulse.m2, pulse.w1, pulse.w2);
I1 = sqrt(No*N/2 + mew);
I2 = sqrt(No*N/2 + (mew + sqrt(3) * sigma));
I3 = sqrt(No*N/2 + (mew - sqrt(3) * sigma));
Peh = 2/3*qfunc(Th/I1) + 1/6*qfunc(Th/I2) + 1/6*qfunc(Th/I3);

function [mew_MAI, sigma_MAI] = get_mean_var_H(K, N, P, m1, m2, w1, w2)
T =1;
mew_MAI = (N*P * (K-1)*m1);
sigma_MAI = (N*P) * ((K-1)*( (.375*w1 - m1^2) + ((N-1)/(N^2))*((1.5*w2) + (K-2)*(m2^2) )))^(.5);

function [mew_MAI, sigma_MAI] = get_mean_var_G(K, N, P, m1)
T =1;
mew_MAI = (N*P * (K-1)*m1);
sigma_MAI = 0;