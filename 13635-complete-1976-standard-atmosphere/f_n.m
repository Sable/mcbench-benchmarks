function n_int = f_n(a_i,alpha_i,b_i,M,M_i,n_int,phi,...
    Q_i,q_i,R,sum_n,U_i,u_i,W_i,w_i,Z_i,Z_0,Z_1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program:    Gas Integral Program
%   Author:     Brent Lewis(RocketLion@gmail.com)
%               University of Colorado-Boulder
%   History:    Original-1/10/2007
%   Input:      As defined in 1976 Standard Atmosphere
%   Output:     n_int:  Integral values computed using 5-point Simpsons
%                       Rule
%   Note:       Created for running in Atmospheric Program
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Constants
g_0 = 9.80665;
r_E = 6.356766e3;
T_c = 263.1905;
A_8 = -76.3232;
a_8 = 19.9429;
L_K_9 = 12;
T_7 = 186.8673;
T_9 = 240;
T_10 = 360;
T_11 = 999.2356;
T_inf = 1000;

%   Molecular Diffusion Coeffiecients
K_7 = 1.2e2;

alt_j = linspace(Z_0,Z_1,5);
n_i = zeros(6,length(alt_j));
for j = 1 : length(alt_j)
    Z = alt_j(j);
    %     Temperature Values
    if Z < Z_i(2)
        T = T_7;
        dT_dZ = 0;
    elseif Z < Z_i(6)
        T = T_c+A_8*sqrt(1-((Z-Z_i(2))/a_8)^2);
        dT_dZ = -A_8/a_8^2*(Z-Z_i(2))*(1-((Z-Z_i(2))/a_8)^2)^-.5;
    elseif Z < Z_i(8)
        T = T_9+L_K_9*(Z-Z_i(6));
        dT_dZ = L_K_9;
    elseif Z >= Z_i(8)
        lambda = L_K_9/(T_inf-T_10);
        xi = (Z-Z_i(8))*(r_E+Z_i(8))/(r_E+Z);
        T = T_inf-(T_inf-T_10)*exp(-lambda*xi);
        dT_dZ = lambda*(T_inf-T_10)*((r_E+Z_i(8))/(r_E+Z))^2*exp(-lambda*xi);
    end
    %     K Values
    if Z < Z_i(3)
        K = K_7;
    elseif Z < Z_i(7)
        K = K_7*exp(1-400/(400-(Z-95)^2));
    elseif Z >= Z_i(7)
        K = 0;
    end
    %     Gravity
    g = g_0*(r_E/(r_E+Z))^2;

    %     N
    if Z <= Z_i(5)
        M_N2 = M(1);
    else
        M_N2 = M_i(1);
    end
    n_i(1,j) = M_N2*g/(T*R)*1e3;
    %     O O2 Ar He
    D = a_i(2:5).*exp(b_i(2:5).*log(T/273.15))./sum_n(2:5);
    if K ~= 0
        f_Z = (g/(R*T)*D./(D+K).*(M_i(2:5)+M(2:5)*K./D+...
            alpha_i(2:5)*R/g*dT_dZ/1e3))*1e3;
    else
        f_Z = (g/(R*T)*(M_i(2:5)+alpha_i(2:5)*R/g*dT_dZ/1e3))*1e3;
    end
    if Z <= Z_i(4)
        vdk = Q_i(2:5).*([Z;Z;Z;Z]-U_i(2:5)).^2.*exp(-W_i(2:5).*...
            ([Z;Z;Z;Z]-U_i(2:5)).^3)+q_i(2:5).*(u_i(2:5)-[Z;Z;Z;Z]).^2.*...
            exp(-w_i(2:5).*(u_i(2:5)-[Z;Z;Z;Z]).^3);
    else
        vdk = Q_i(2:5).*([Z;Z;Z;Z]-U_i(2:5)).^2.*exp(-W_i(2:5).*...
            ([Z;Z;Z;Z]-U_i(2:5)).^3);
    end
    n_i(2:5,j) = f_Z+vdk;
    %     H
    if Z_1 < 150 || Z_1 > 500
        n_i(6,j) = 0;
    else
        D_H = a_i(6)*exp(b_i(6)*log(T/273.15))/sum_n(6);
        n_i(6,j) = phi/D_H*(T/T_11)^(1+alpha_i(6));
    end

end
h = alt_j(2)-alt_j(1);
n_int = n_int+(2*h/45*(7*n_i(:,1)+32*n_i(:,2)+12*n_i(:,3)+32*n_i(:,4)+7*n_i(:,5)));