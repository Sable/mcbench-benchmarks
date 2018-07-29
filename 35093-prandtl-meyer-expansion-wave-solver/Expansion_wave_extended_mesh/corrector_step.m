function [F_values] = corrector_step(i,F,F_p,G_p,P_p,dF_x,dF_p_x,Grid,delta_x)
for j = 1:401,
    if (j == 1) % Forward difference without artificial viscosity (no artificial viscosity in the boundaries)
        dF_p_x.dF1_p_x(j) = (Grid.m1(j,i)*((F_p.F1_p(j,i+1) - F_p.F1_p(j+1,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G1_p(j,i+1) - G_p.G1_p(j+1,i+1))/Grid.delta_y_t)); % The derivative of F1_p with respect to x (Xi) at the point j,i+1
        dF_p_x.dF2_p_x(j) = (Grid.m1(j,i)*((F_p.F2_p(j,i+1) - F_p.F2_p(j+1,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G2_p(j,i+1) - G_p.G2_p(j+1,i+1))/Grid.delta_y_t));
        dF_p_x.dF3_p_x(j) = (Grid.m1(j,i)*((F_p.F3_p(j,i+1) - F_p.F3_p(j+1,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G3_p(j,i+1) - G_p.G3_p(j+1,i+1))/Grid.delta_y_t));
        dF_p_x.dF4_p_x(j) = (Grid.m1(j,i)*((F_p.F4_p(j,i+1) - F_p.F4_p(j+1,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G4_p(j,i+1) - G_p.G4_p(j+1,i+1))/Grid.delta_y_t));
    elseif (j == 401) % Rearward difference without artificial viscosity
        dF_p_x.dF1_p_x(j) = (Grid.m1(j,i)*((F_p.F1_p(j-1,i+1) - F_p.F1_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G1_p(j-1,i+1) - G_p.G1_p(j,i+1))/Grid.delta_y_t));
        dF_p_x.dF2_p_x(j) = (Grid.m1(j,i)*((F_p.F2_p(j-1,i+1) - F_p.F2_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G2_p(j-1,i+1) - G_p.G2_p(j,i+1))/Grid.delta_y_t));
        dF_p_x.dF3_p_x(j) = (Grid.m1(j,i)*((F_p.F3_p(j-1,i+1) - F_p.F3_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G3_p(j-1,i+1) - G_p.G3_p(j,i+1))/Grid.delta_y_t));
        dF_p_x.dF4_p_x(j) = (Grid.m1(j,i)*((F_p.F4_p(j-1,i+1) - F_p.F4_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G4_p(j-1,i+1) - G_p.G4_p(j,i+1))/Grid.delta_y_t));
    else % Rearward difference with artificial viscosity
        dF_p_x.dF1_p_x(j) = (Grid.m1(j,i)*((F_p.F1_p(j-1,i+1) - F_p.F1_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G1_p(j-1,i+1) - G_p.G1_p(j,i+1))/Grid.delta_y_t));
        dF_p_x.dF2_p_x(j) = (Grid.m1(j,i)*((F_p.F2_p(j-1,i+1) - F_p.F2_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G2_p(j-1,i+1) - G_p.G2_p(j,i+1))/Grid.delta_y_t));
        dF_p_x.dF3_p_x(j) = (Grid.m1(j,i)*((F_p.F3_p(j-1,i+1) - F_p.F3_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G3_p(j-1,i+1) - G_p.G3_p(j,i+1))/Grid.delta_y_t));
        dF_p_x.dF4_p_x(j) = (Grid.m1(j,i)*((F_p.F4_p(j-1,i+1) - F_p.F4_p(j,i+1))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G_p.G4_p(j-1,i+1) - G_p.G4_p(j,i+1))/Grid.delta_y_t));
        
        SF1_p = (((0.6*(abs(P_p(j+1)) - (2*P_p(j)) + P_p(j-1))))/(P_p(j+1) + 2*P_p(j) + P_p(j-1)))*(F_p.F1_p(j+1,i+1) - (2*F_p.F1_p(j,i+1)) + F_p.F1_p(j-1,i+1)); % Predicted value of artificial viscosity at j,i+1
        SF2_p = (((0.6*(abs(P_p(j+1)) - (2*P_p(j)) + P_p(j-1))))/(P_p(j+1) + 2*P_p(j) + P_p(j-1)))*(F_p.F2_p(j+1,i+1) - (2*F_p.F2_p(j,i+1)) + F_p.F2_p(j-1,i+1));
        SF3_p = (((0.6*(abs(P_p(j+1)) - (2*P_p(j)) + P_p(j-1))))/(P_p(j+1) + 2*P_p(j) + P_p(j-1)))*(F_p.F3_p(j+1,i+1) - (2*F_p.F3_p(j,i+1)) + F_p.F3_p(j-1,i+1));
        SF4_p = (((0.6*(abs(P_p(j+1)) - (2*P_p(j)) + P_p(j-1))))/(P_p(j+1) + 2*P_p(j) + P_p(j-1)))*(F_p.F4_p(j+1,i+1) - (2*F_p.F4_p(j,i+1)) + F_p.F4_p(j-1,i+1));
    end
    
    dF1_x_av = 0.5*(dF_x.dF1_x(j) + dF_p_x.dF1_p_x(j));
    dF2_x_av = 0.5*(dF_x.dF2_x(j) + dF_p_x.dF2_p_x(j));
    dF3_x_av = 0.5*(dF_x.dF3_x(j) + dF_p_x.dF3_p_x(j));
    dF4_x_av = 0.5*(dF_x.dF4_x(j) + dF_p_x.dF4_p_x(j));
        
    if (j == 1 || j == 401)
        F.F1(j,i+1) = F.F1(j,i) + (dF1_x_av*delta_x);
        F.F2(j,i+1) = F.F2(j,i) + (dF2_x_av*delta_x);
        F.F3(j,i+1) = F.F3(j,i) + (dF3_x_av*delta_x);
        F.F4(j,i+1) = F.F4(j,i) + (dF4_x_av*delta_x);
    else
        F.F1(j,i+1) = F.F1(j,i) + (dF1_x_av*delta_x) + SF1_p;
        F.F2(j,i+1) = F.F2(j,i) + (dF2_x_av*delta_x) + SF2_p;
        F.F3(j,i+1) = F.F3(j,i) + (dF3_x_av*delta_x) + SF3_p;
        F.F4(j,i+1) = F.F4(j,i) + (dF4_x_av*delta_x) + SF4_p;
    end
end
F_values = F;
end