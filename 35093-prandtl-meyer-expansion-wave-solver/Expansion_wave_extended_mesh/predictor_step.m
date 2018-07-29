function [Updated_derivatives, Predicted_F_values] = predictor_step(i,F,G,Grid,F_p,dF_x,P,delta_x)
for j = 1:401,
    if (j == 1) % Forward difference without artificial viscosity (no artificial viscosity in the boundaries)
        dF_x.dF1_x(j) = (Grid.m1(j,i)*((F.F1(j,i) - F.F1(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G1(j,i) - G.G1(j+1,i))/Grid.delta_y_t)); % The derivative of F1 with respect to x (Xi) at the point j,i
        dF_x.dF2_x(j) = (Grid.m1(j,i)*((F.F2(j,i) - F.F2(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G2(j,i) - G.G2(j+1,i))/Grid.delta_y_t));
        dF_x.dF3_x(j) = (Grid.m1(j,i)*((F.F3(j,i) - F.F3(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G3(j,i) - G.G3(j+1,i))/Grid.delta_y_t));
        dF_x.dF4_x(j) = (Grid.m1(j,i)*((F.F4(j,i) - F.F4(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G4(j,i) - G.G4(j+1,i))/Grid.delta_y_t));
        F_p.F1_p(j,i+1) = F.F1(j,i) + (dF_x.dF1_x(j)*delta_x); % By the Euler numerical method advance F1 to the next downstream point and obtain its predicted value
        F_p.F2_p(j,i+1) = F.F2(j,i) + (dF_x.dF2_x(j)*delta_x);
        F_p.F3_p(j,i+1) = F.F3(j,i) + (dF_x.dF3_x(j)*delta_x);
        F_p.F4_p(j,i+1) = F.F4(j,i) + (dF_x.dF4_x(j)*delta_x);
    elseif (j == 401) % Rearward difference without artificial viscosity
        dF_x.dF1_x(j) = (Grid.m1(j,i)*((F.F1(j-1,i) - F.F1(j,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G1(j-1,i) - G.G1(j,i))/Grid.delta_y_t));
        dF_x.dF2_x(j) = (Grid.m1(j,i)*((F.F2(j-1,i) - F.F2(j,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G2(j-1,i) - G.G2(j,i))/Grid.delta_y_t));
        dF_x.dF3_x(j) = (Grid.m1(j,i)*((F.F3(j-1,i) - F.F3(j,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G3(j-1,i) - G.G3(j,i))/Grid.delta_y_t));
        dF_x.dF4_x(j) = (Grid.m1(j,i)*((F.F4(j-1,i) - F.F4(j,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G4(j-1,i) - G.G4(j,i))/Grid.delta_y_t));
        F_p.F1_p(j,i+1) = F.F1(j,i) + (dF_x.dF1_x(j)*delta_x);
        F_p.F2_p(j,i+1) = F.F2(j,i) + (dF_x.dF2_x(j)*delta_x);
        F_p.F3_p(j,i+1) = F.F3(j,i) + (dF_x.dF3_x(j)*delta_x);
        F_p.F4_p(j,i+1) = F.F4(j,i) + (dF_x.dF4_x(j)*delta_x);
    else % Forward difference with artificial viscosity
        dF_x.dF1_x(j) = (Grid.m1(j,i)*((F.F1(j,i) - F.F1(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G1(j,i) - G.G1(j+1,i))/Grid.delta_y_t));
        dF_x.dF2_x(j) = (Grid.m1(j,i)*((F.F2(j,i) - F.F2(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G2(j,i) - G.G2(j+1,i))/Grid.delta_y_t));
        dF_x.dF3_x(j) = (Grid.m1(j,i)*((F.F3(j,i) - F.F3(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G3(j,i) - G.G3(j+1,i))/Grid.delta_y_t));
        dF_x.dF4_x(j) = (Grid.m1(j,i)*((F.F4(j,i) - F.F4(j+1,i))/Grid.delta_y_t)) + (Grid.m2(j,i)*((G.G4(j,i) - G.G4(j+1,i))/Grid.delta_y_t));
        SF1 = ((0.6*(abs((P(j+1,i)) - (2*P(j,i)) + P(j-1,i))))/(P(j+1,i) + 2*P(j,i) + P(j-1,i)))*(F.F1(j+1,i) - (2*F.F1(j,i)) + F.F1(j-1,i)); % Value of artificial viscosity at j,i
        SF2 = ((0.6*(abs((P(j+1,i)) - (2*P(j,i)) + P(j-1,i))))/(P(j+1,i) + 2*P(j,i) + P(j-1,i)))*(F.F2(j+1,i) - (2*F.F2(j,i)) + F.F2(j-1,i));
        SF3 = ((0.6*(abs((P(j+1,i)) - (2*P(j,i)) + P(j-1,i))))/(P(j+1,i) + 2*P(j,i) + P(j-1,i)))*(F.F3(j+1,i) - (2*F.F3(j,i)) + F.F3(j-1,i));
        SF4 = ((0.6*(abs((P(j+1,i)) - (2*P(j,i)) + P(j-1,i))))/(P(j+1,i) + 2*P(j,i) + P(j-1,i)))*(F.F4(j+1,i) - (2*F.F4(j,i)) + F.F4(j-1,i));
        F_p.F1_p(j,i+1) = F.F1(j,i) + (dF_x.dF1_x(j)*delta_x) + SF1;
        F_p.F2_p(j,i+1) = F.F2(j,i) + (dF_x.dF2_x(j)*delta_x) + SF2;
        F_p.F3_p(j,i+1) = F.F3(j,i) + (dF_x.dF3_x(j)*delta_x) + SF3;
        F_p.F4_p(j,i+1) = F.F4(j,i) + (dF_x.dF4_x(j)*delta_x) + SF4;
    end
end
Updated_derivatives = dF_x;
Predicted_F_values = F_p;
end