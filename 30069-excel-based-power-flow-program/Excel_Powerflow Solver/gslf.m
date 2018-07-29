%{
% IMPLEMENTATION OF GAUSS SEIDEL METHOD IN MATLAB
% DESIGNED BY: 
%               HAFIZ KASHIF KHALEEL  B-12588
% CREATED: 19-DEC-2009
% SEMESTER # 7, EE(POWER).
% SUBJECT: POWER SYSTEM OPERATION AND CONTROL.
% TEXT BOOK: POWER SYSTEM ANALYSIS BY WILLIAM D. STEVENSON, JR.
% UNIVERSITY OF SOUTH ASIA. LAHORE. PAKISTAN.

%======================================================= DATA INPUT =======================================================%

format short g
disp (' TABLE 9.2 PAGE # 337   LINE DATA FOR EXAMPLE 9.2 ')
linedata=[1     2       0.01008,    0.05040,   3.815629,     -19.078144,     10.25,  0.05125;
          1     3       0.00744,    0.03720,   5.169561,     -25.847809,     7.75,   0.03875;
          2     4       0.00744,    0.03720,   5.169561,     -25.847809,     7.75,   0.03875;
          3     4       0.01272,    0.06360,   3.023705,     -15.118528,     12.75,  0.06375]
      
      
disp (' TABLE 9.3 PAGE # 338   BUS DATA FOR EXAMPLE 9.2 ')    
busdata=[1   0,     0,  50,     30.99,  1.00,   0   1;
         2   0,     0,  170,    105.35, 1.00,   0   2;
         3   0,     0,  200,    123.94, 1.00,   0   2;
         4   318,   0 , 80,     49.58,  1.02,   0   3]

     %  Last column shows Bus Type: 1.Slack Bus    2.PQ Bus    3.PV Bus
     
%=================================================== PROGRAM STARTS HERE ===================================================%     
%}
%{
  
%}
% ------ INITIALLIZING YBUS ------


line_data = Line_Data; % so as not to mess up originals
bus_data = Bus_Data;
num_bus = max(bus_data(:,1));
Ybus = ybusppg(num_bus, Line_Data);
B_MVA = 100;
z=zeros(num_bus,8);
bus_num=bus_data(:,1);
Pgen=bus_data(:,5);
Qgen=bus_data(:,6);
Pload=bus_data(:,7);
Qload=bus_data(:,8);
V=bus_data(:,3);
V_calc=V;
V_acc = zeros(length(V),1);
V_temp = zeros(length(V),1);
theta=bus_data(:,4);
type = bus_data(:,2);
%{
bus_adm=1i*line_data(:,5);     % Y/2

y=line_data(:,3)+1i*line_data(:,4);
 %num_bus = max(max(line_data(:,1)),max(linedata(:,2)));    % total buses
num_lines = length(line_data(:,1));                      % no. of branches
Ybus = zeros(num_bus,num_bus);

for n=1:num_lines
    Ybus((line_data(n,1)),(line_data(n,2)))=-y(n);
    Ybus((line_data(n,2)),(line_data(n,1))) = Ybus((line_data(n,1)),(line_data(n,2)));
    
end

 for n=1:num_bus
     for m=1:num_lines
         if line_data(m,1) == n || line_data(m,2) == n
             Ybus(n,n) = Ybus(n,n) + y(m) + bus_adm(m);
         end
     end
 end
%}
P = (Pgen-Pload)./B_MVA;    % per unit active power at buses
Q = (Qgen-Qload)./B_MVA;    % per unit reactive power at buses
Tol=1;
Iter=0;

acc_fac=1.6;            % acceleration constant
while (Tol > 1e-5 && Iter < 100)
    
    for n = 2:num_bus
    
      YV = 0;
        
        for m = 1:num_bus
            if n~=m
                YV = YV + Ybus(n,m)* V(m);  % multiplying admittance & voltage
            end
        YV;
        end
        if bus_data(n,2) == 2     %Calculating Qi for PV bus
            
            Q(n) =  -imag(conj(V(n))*(YV + Ybus(n,n)*V(n)));
            bus_data(n,6)=Q(n);
            
        end  
        if bus_data(n,2) == 2        
                z(n,6)=(Q(n)*100)+bus_data(n,8);
        end
        
       % end
        V(n) = (1/Ybus(n,n))*((P(n)-1i*Q(n))/conj(V(n)) - YV); % Compute Bus Voltages.
        
         % Calculating Corrected Voltage for PV bus
       if bus_data(n,2) == 2
       
           V_temp(n)=abs(V_calc(n))*(V(n)/abs(V(n)));
           bus_data(n,3)=V_temp(n);
           V(n)=V_temp(n);
       end

           
      % Calculating Accelerated Voltage for PQ bus
       if bus_data(n,2) == 3
        V_acc(n)= V_calc(n)+acc_fac*(V(n)-V_calc(n));
        bus_data(n,3)=V_acc(n);
        V(n)=V_acc(n);
       end
        %V(i)=V;
       
    end
    
    Iter = Iter + 1;      % Increment iteration count.
    Tol = max(abs(abs(V) - abs(V_calc)));     % Calculate tolerance.
    V_calc = V;
end
%{
iter
YV;
V;

%-------------------------DISPLAYING OUTPUTS---------------------------%
%real(VACC')
z(1:totalbuses,1)=busdata(:,1);
z(1:totalbuses,2)=busdata(:,8);
z(1:totalbuses,3)=abs(busdata(:,6));
z(1:totalbuses,4)=radtodeg(angle(V));
z(1:totalbuses,5)=PG;
z(1:totalbuses,7)=busdata(:,4);
z(1:totalbuses,8)=busdata(:,5);
%}

[Load_Flow Line_Flow] = loadflow(num_bus,abs(V),radtodeg(angle(V)),B_MVA,Line_Data, Bus_Data);
%{
%disp('           Bus No.   Bus Type     Voltage      Angle  ');
%disp('  Bus No.   Bus Type    Voltage     Angle   MW(G)      Mvar(G)   MW(L)      Mvar(L) ');
%disp('           Bus No.   Bus Type    Voltage      Angle         MW(G)       Mvar(G)        MW(L)     Mvar(L) ');
disp('         |Bus No.|   |Bus Type|  |Voltage|    |Angle|       |MW(G)|     |Mvar(G)|     |MW(L)|   |Mvar(L)| ');

format short g
z

%}