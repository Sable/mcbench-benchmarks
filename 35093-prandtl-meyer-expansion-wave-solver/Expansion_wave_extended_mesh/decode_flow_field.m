function [Updated_flow_field,Updated_G] = decode_flow_field(i,F,G,Flow_field,Grid,Gamma,R_air,Theta,E)
for j = 1:401,
    A = ((F.F3(j,i+1)^2)/(2*F.F1(j,i+1))) - F.F4(j,i+1);
    B = (Gamma/(Gamma - 1))*F.F1(j,i+1)*F.F2(j,i+1);
    C = -(((Gamma + 1)/(2*(Gamma - 1)))*(F.F1(j,i+1)^3));
    if (j == 1) % Apply Abbett's wall boundary condition
        Rho_cal = (-B + (sqrt((B^2) - (4*A*C))))/(2*A);
        u_cal = F.F1(j,i+1)/Rho_cal;
        v_cal = F.F3(j,i+1)/F.F1(j,i+1);
        P_cal = F.F2(j,i+1) - (F.F1(j,i+1)*u_cal);
        T_cal = P_cal/(R_air*Rho_cal);
        M_cal = (sqrt((u_cal^2) + (v_cal)^2))/(sqrt(Gamma*R_air*T_cal));
        if (Grid.x(i) < E)
            phi = atan(v_cal/u_cal);
        else
            phi = Theta - (atan(abs(v_cal)/u_cal));
        end
        f_cal = sqrt((Gamma + 1)/(Gamma - 1))*(atan(sqrt(((Gamma - 1)/(Gamma + 1))*(M_cal^2 - 1)))) - (atan(sqrt((M_cal^2) - 1))); % Prandtl-Meyer function
        f_act = f_cal + phi; % Rotated Prandtl-Meyer function
        % We need to find the Mach number corresponding to a Prandtl-Meyer
        % function of value "f_act". Anderson suggests a simple trial and
        % error computation, but I have used a bisection method that I think should be
        % more efficient.
        a_int = 1.1; % Left limit of the interval 
        b_int = 2.9; % Right limit of the interval
        precision = 0.0000001; % Max error 
        zero_f1 = sqrt((Gamma + 1)/(Gamma - 1))*(atan(sqrt(((Gamma - 1)/(Gamma + 1))*(a_int^2 - 1)))) - (atan(sqrt((a_int^2) - 1))) - f_act; % Function used to find its zero
        zero_f2 = sqrt((Gamma + 1)/(Gamma - 1))*(atan(sqrt(((Gamma - 1)/(Gamma + 1))*(((a_int + b_int)/2)^2 - 1)))) - (atan(sqrt((((a_int + b_int)/2)^2) - 1))) - f_act;
        while ((b_int-a_int)/2 > precision)
            if (zero_f1*zero_f2 <=0)
                b_int = (a_int + b_int)/2;
            else
                a_int = (a_int + b_int)/2;
            end
            zero_f1 = sqrt((Gamma + 1)/(Gamma - 1))*(atan(sqrt(((Gamma - 1)/(Gamma + 1))*(a_int^2 - 1)))) - (atan(sqrt((a_int^2) - 1))) - f_act;
            zero_f2 = sqrt((Gamma + 1)/(Gamma - 1))*(atan(sqrt(((Gamma - 1)/(Gamma + 1))*(((a_int + b_int)/2)^2 - 1)))) - (atan(sqrt((((a_int + b_int)/2)^2) - 1))) - f_act;
        end
        M_act = (a_int + b_int)/2; % Corrected Mach number
        Flow_field.M(j,i+1) = M_act;
        Flow_field.M_angle(j,i+1) = (asin(1/Flow_field.M(j,i+1)));
        Flow_field.P(j,i+1) = P_cal*(((1 + ((Gamma - 1)/2)*(M_cal^2))/(1 + ((Gamma - 1)/2)*(M_act^2)))^(Gamma/(Gamma - 1)));
        Flow_field.T(j,i+1) = T_cal*((1 + ((Gamma - 1)/2)*(M_cal^2))/(1 + ((Gamma - 1)/2)*(M_act^2)));
        Flow_field.Rho(j,i+1) = Flow_field.P(j,i+1)/(R_air*Flow_field.T(j,i+1));
        Flow_field.u(j,i+1) = u_cal;
        Flow_field.a(j,i+1) = sqrt(Gamma*R_air*Flow_field.T(j,i+1));
        if (Grid.x(i) > E)
            Flow_field.v(j,i+1) = -(Flow_field.u(j,i+1)*tan(Theta));
        else
            Flow_field.v(j,i+1) = 0;
        end
        % Finally we correct the F terms
        F.F1(j,i+1) = Flow_field.Rho(j,i+1)*Flow_field.u(j,i+1);
        F.F2(j,i+1) = (Flow_field.Rho(j,i+1)*(Flow_field.u(j,i+1)^2)) + Flow_field.P(j,i+1);
        F.F3(j,i+1) = Flow_field.Rho(j,i+1)*Flow_field.u(j,i+1)*Flow_field.v(j,i+1);
        F.F4(j,i+1) = ((Gamma/(Gamma - 1))*Flow_field.P(j,i+1)*Flow_field.u(j,i+1)) + (Flow_field.Rho(j,i+1)*Flow_field.u(j,i+1)*(((Flow_field.u(j,i+1)^2) + (Flow_field.v(j,i+1)^2)))/2);
    else
        Flow_field.Rho(j,i+1) = (-B + (sqrt((B^2) - (4*A*C))))/(2*A);
        Flow_field.u(j,i+1) = F.F1(j,i+1)/Flow_field.Rho(j,i+1);
        Flow_field.v(j,i+1) = F.F3(j,i+1)/F.F1(j,i+1);
        Flow_field.P(j,i+1) = F.F2(j,i+1) - (F.F1(j,i+1)*Flow_field.u(j,i+1));
        Flow_field.T(j,i+1) = Flow_field.P(j,i+1)/(R_air*Flow_field.Rho(j,i+1));
        Flow_field.a(j,i+1) = sqrt(Gamma*R_air*Flow_field.T(j,i+1));
        Flow_field.M(j,i+1) = (sqrt((Flow_field.u(j,i+1)^2) + (Flow_field.v(j,i+1)^2)))/Flow_field.a(j,i+1);
        Flow_field.M_angle(j,i+1) = asin(1/Flow_field.M(j,i+1));
    end
    G.G1(j,i+1) = Flow_field.Rho(j,i+1)*(F.F3(j,i+1)/F.F1(j,i+1));
    G.G2(j,i+1) = F.F3(j,i+1);
    G.G3(j,i+1) = (Flow_field.Rho(j,i+1)*((F.F3(j,i+1)/F.F1(j,i+1))^2)) + F.F2(j,i+1) - ((F.F1(j,i+1)^2)/Flow_field.Rho(j,i+1));
    G.G4(j,i+1) = ((Gamma/(Gamma - 1))*((F.F2(j,i+1)) - ((F.F1(j,i+1)^2)/Flow_field.Rho(j,i+1)))*(F.F3(j,i+1)/F.F1(j,i+1))) + (((Flow_field.Rho(j,i+1)*F.F3(j,i+1))/(2*F.F1(j,i+1)))*(((F.F1(j,i+1)/Flow_field.Rho(j,i+1))^2) + ((F.F3(j,i+1)/F.F1(j,i+1))^2)));
end
Updated_flow_field = Flow_field;
Updated_G = G;
end