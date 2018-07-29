function [Predicted_pressure_value,Predicted_G_values] = compute_predicted_G(F_p,G_p,P_p,Gamma,i)
for j = 1:401,
    A_p = ((F_p.F3_p(j,i+1)^2)/(2*F_p.F1_p(j,i+1))) - F_p.F4_p(j,i+1);
    B_p = (Gamma/(Gamma - 1))*F_p.F1_p(j,i+1)*F_p.F2_p(j,i+1);
    C_p = -(((Gamma + 1)/(2*(Gamma - 1)))*(F_p.F1_p(j,i+1)^3));
    Rho_p = (-B_p + (sqrt((B_p^2) - (4*A_p*C_p))))/(2*A_p);
    P_p(j) = F_p.F2_p(j,i+1) - ((F_p.F1_p(j,i+1)^2)/Rho_p);
    G_p.G1_p(j,i+1) = Rho_p*(F_p.F3_p(j,i+1)/F_p.F1_p(j,i+1));
    G_p.G2_p(j,i+1) = F_p.F3_p(j,i+1);
    G_p.G3_p(j,i+1) = (Rho_p*((F_p.F3_p(j,i+1)/F_p.F1_p(j,i+1))^2)) + F_p.F2_p(j,i+1) - ((F_p.F1_p(j,i+1)^2)/Rho_p);
    G_p.G4_p(j,i+1) = ((Gamma/(Gamma - 1))*((F_p.F2_p(j,i+1)) - ((F_p.F1_p(j,i+1)^2)/Rho_p))*(F_p.F3_p(j,i+1)/F_p.F1_p(j,i+1))) + (((Rho_p*F_p.F3_p(j,i+1))/(2*F_p.F1_p(j,i+1)))*(((F_p.F1_p(j,i+1)/Rho_p)^2) + ((F_p.F3_p(j,i+1)/F_p.F1_p(j,i+1))^2)));
end
Predicted_pressure_value = P_p;
Predicted_G_values = G_p;
end