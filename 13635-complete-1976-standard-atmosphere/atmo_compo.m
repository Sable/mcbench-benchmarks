function n_i_array = atmo_compo(alt,division)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program:    High Altitude Atmospheric Composition Calculation
%   Author:     Brent Lewis(RocketLion@gmail.com)
%               University of Colorado-Boulder
%   History:    Original-1/10/2007
%               Revision-1/12/2007-Corrected for changes in Matlab versions
%               for backward compatability-Many thanks to Rich
%               Rieber(rrieber@gmail.com)
%   Input:      alt:        Geometric Altitude of desired altitude[scalar][km] 
%               division:   Desired output altitudes
%   Output:     n_i_array:  Array of compositions of [N2 O O2 Ar He H] at
%                           desired reporting altitudes using equations
%                           from 1976 Standard Atmosphere
%   Note:       Only Valid Between 86 km and 1000 km
%               Division must be a multiple of 10 m;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Z_i = [86 91 95 97 100 110 115 120 150 500 1000];
step = .01;

if alt < Z_i(1) || alt>Z_i(length(Z_i))
    n_i_array = [];
    return;
end

%   Gas coefficients
alpha_i = [0; 0; 0; 0; -.4; -.25];
a_i = [0; 6.986e20; 4.863e20; 4.487e20; 1.7e21; 3.305e21];
b_i = [0; .75; .75; .87; .691; .5];
Q_i = [0; -5.809644e-4; 1.366212e-4; 9.434079e-5; -2.457369e-4];
q_i = [0; -3.416248e-3; 0; 0; 0];
U_i = [0; 56.90311; 86; 86; 86];
u_i = [0; 97; 0; 0; 0];
W_i = [0; 2.70624e-5; 8.333333e-5; 8.333333e-5; 6.666667e-4];
w_i = [0; 5.008765e-4; 0; 0; 0];

%   Gas Data
R = 8.31432e3;
phi = 7.2e11;
T_7 = 186.8673;
T_11 = 999.2356;
%   Molecular Weight & Number Density based on values at 86 km & 500 km for
%   Hydrogen
n_i_86 = [1.129794e20; 8.6e16; 3.030898e19; 1.3514e18; 7.5817e14; 8e10];
n_i_alt = n_i_86;
sum_n = [ones(3,1)*n_i_86(1);ones(2,1)*sum(n_i_86(1:3));sum(n_i_86(1:5))];
M_i = [28.0134; 15.9994; 31.9988; 39.948; 4.0026; 1.00797];
M_0 = 28.9644;

n_int = zeros(size(n_i_86));
j = 1;
n_i_array = zeros(floor((alt-86)/division)+1,6);
for i = 1 : length(Z_i)-1
    if alt > Z_i(i)
        Z_start = Z_i(i);
        if alt > Z_i(i+1)
            Z_end = Z_i(i+1);
        else
            Z_end = alt;
        end
        for Z_0 = Z_start:step:Z_end-step
            Z_1 = Z_0+step;
            if Z_1 <= Z_i(5)
                M = ones(size(M_i))*M_0;
            else
                M = [(n_i_alt(1)*M_i(1))./sum_n(1:3);...
                    sum((n_i_alt(1:3).*M_i(1:3)))./sum_n(4:5);...
                    sum((n_i_alt(1:5).*M_i(1:5)))./sum_n(6)];
            end
            sum_n = [ones(3,1)*n_i_alt(1);ones(2,1)*sum(n_i_alt(1:3));sum(n_i_alt(1:5))];
            n_int = f_n(a_i,alpha_i,b_i,M,M_i,n_int,phi,...
                Q_i,q_i,R,sum_n,U_i,u_i,W_i,w_i,Z_i,Z_0,Z_1);
            n_i_alt(1:5) = n_i_86(1:5)*T_7/atmo_temp(Z_1).*exp(-n_int(1:5));
            if Z_1 < Z_i(9)
                n_i_alt(6) = 0;
            else
                tau = int_tau(alt);
                n_i_alt(6) = (T_11/atmo_temp(Z_1))^(1+alpha_i(6))*...
                    (n_i_86(6)*exp(-tau)-n_int(6));
            end
            if mod(Z_0,division) == 0
                n_i_array(j,:) = n_i_alt';
                j = j+1;
            end
                
        end
    end
end
n_i_end(1:5) = n_i_86(1:5)*T_7/atmo_temp(alt).*exp(-n_int(1:5));
if alt < Z_i(9)
    n_i_end(6) = 0;
else
    tau = int_tau(alt);
    n_i_end(6) = (T_11/atmo_temp(Z_1))^(1+alpha_i(6))*...
        (n_i_86(6)*exp(-tau)-n_int(6));
end
n_i_array(j,:) = n_i_end;