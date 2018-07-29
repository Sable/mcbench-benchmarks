 function [area, contr_signal] = dir_valve_area_characterization(valve_data)
 % The function computes values of orifice area as a function of valve
 % control signal to be used in approximating equation 
 % q = C_d * area(x) * sqrt(2/rho * p). The computation is based on the set
 % of experimental data provided in the 'valve_data' structure.
 % Copyright 2010 MathWorks, Inc.
 
 % contr_signal - vector of control signals (1 x m)
 % area  - matrix (5 x m) containing area values for orifices 1, 2, 3, and
 %              4 in the order control signal are arranged in the 
 %              contr_signal vector. The fifth raw contains average values
 %              of the area
 % valve_data - structure with valve data. The description of the structure
 %              is provided in the 'valve_data_file.m' file
    
   p_S = valve_data.p_S;                    % Supply pressure
   p_R = valve_data.p_R;                    % Return pressure
   C_d = valve_data.C_d;                    % Flow discharge coefficient
   density = valve_data.density;
   contr_signal = valve_data.contr_signal;  % Set of control signals
   
   p_0 = (p_S + p_R) / 2;                   % Pressure at port A and B at
                                            % no load
   or = valve_data.orifice_orientation;     % Orifice orientation
   
   m = length(contr_signal);                % Number of measurements
   
   for j = 1:m
       
       p_A = valve_data.p_A(j);
       p_B = valve_data.p_B(j);
       ext_flow = valve_data.q_external(j);
       leak_flow = valve_data.q_leak(j);
       
       % Filling out the matrix
       A(1,1) = -sqrt(p_0 - p_R);
       A(1,2) = sqrt(p_S - p_0);
       A(2,3) = sqrt(p_S - p_0);
       A(2,4) = -sqrt(p_0 - p_R);
       A(3,2) = sqrt(p_S - p_A);
       A(3,3) = sqrt(p_S - p_B);
       A(4,1) = sqrt(p_A - p_R);
       A(4,4) = sqrt(p_B - p_R);
       
       % Right-hand vector      
       B(1) = ext_flow;
       B(2) = -ext_flow;
       B(3) = leak_flow;
       B(4) = leak_flow;
       
       % Computing area values at a particular control signal       
       area_inst = (A \ B') / C_d / sqrt(2/density);
       
       % Filling out the area matrix
       for i = 1:4;
           if or(i) > 0         % Orifice opens in positive direction
                area(i,j) = area_inst(i);
           else                 % Orifice opens in negative direction
                area(i,m-j+1) = area_inst(i);
           end
       end
    
   end
   
   % Checking for non-increasing values
   for i=1:4
       for j=4:m
           if area(i,j) <= area(i,j-1)
               gain = (area(i,j-1) - area(i,j-2)) / ...
                   (contr_signal(j-1) - contr_signal(j-2));
               area(i,j) = area(i,j-1) + gain * ...
                   (contr_signal(j) - contr_signal(j-1));
           end
       end
   end
   
   % Computing avarage value of the area
   for j = 1:m
       area_aux = 0;
       for i = 1:4
           area_aux = area_aux + area(i,j);
       end
       area(5,j) = area_aux/4;
   end
   
        