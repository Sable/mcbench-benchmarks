% Program for Fast Decoupled Load Flow Analysis..
% Written by Kuenrg

% clear all;
busd = Bus_Data;
nbus = max(busd(:,1));

Y = ybusppg(nbus, Line_Data);   % Calling ybusppg.m to get Y-Bus Matrix..


BaseMVA = 100;                  % Base MVA..
bus_num = busd(:,1);            % Bus Number..
bus_type = busd(:,2);           % Type of Bus 1-Slack, 2-PV, 3-PQ..
V = busd(:,3);                  % Specified Voltage..
theta = busd(:,4);              % Voltage Angle..
Pgen = busd(:,5)/BaseMVA;       % PGi..
Qgen = busd(:,6)/BaseMVA;       % Qgeni..
Pload = busd(:,7)/BaseMVA;      % Ploadi..
Qload = busd(:,8)/BaseMVA;      % Qloadi..
Qmin = busd(:,9)/BaseMVA;       % Minimum Reactive Power Limit..
Qmax = busd(:,10)/BaseMVA;      % Maximum Reactive Power Limit..
dPbyV = (-Pgen+Pload)./abs(V);        % Pi = Pgeni - Ploadi..
dQbyV = (-Qgen+Qload)./abs(V);        % Qi = Qgeni - Qloadi..
Pspec = dPbyV;                  % P Specified..
Qspec = dQbyV;                  % Q Specified..
G = real(Y);                    % Conductance matrix..
B = imag(Y);                    % Susceptance matrix..

pv = find(bus_type == 2 | bus_type == 1);   % PV Buses..
pq = find(bus_type == 3);               % PQ Buses..
npv = length(pv);                   % No. of PV buses..
npq = length(pq);                   % No. of PQ buses..

Tol = 1;  
Iter = 1;

%Calculate B^-1 matrix
slack_bus = find(bus_type==1);
B_P = B;
B_P(:,slack_bus) = [];
B_P(slack_bus,:) = [];

B_Q = B;
for i=1:npv
    B_Q(:,pv(i)-i+1) = [];
    B_Q(pv(i)-i+1,:) = [];
end

BMva = 100;                 % Base MVA..

while (Tol > 1e-5 && Iter < 10)              % Iteration starting..
    
    dPbyV = zeros(nbus,1);
    dQbyV = zeros(nbus,1);
    % Calculate P and Q
    for i = 1:nbus
        for k = 1:nbus
            dPbyV(i) = dPbyV(i) + V(k)*(G(i,k)*cos(theta(i)-theta(k)) + B(i,k)*sin(theta(i)-theta(k)));
            dQbyV(i) = dQbyV(i) + V(k)*(G(i,k)*sin(theta(i)-theta(k)) - B(i,k)*cos(theta(i)-theta(k)));
        end
    end
    
    % Checking Q-limit violations..
    if Iter <= 7 && Iter > 2    % Only checked up to 7th iterations..
        for n = 2:nbus
            if bus_type(n) == 2
                QG = dQbyV(n)*V(n)+Qload(n);
                if QG < Qmin(n)
                    V(n) = V(n) + 0.01;
                elseif QG > Qmax(n)
                    V(n) = V(n) - 0.01;
                end
            end
         end
    end
    
    % Calculate change from specified value
    dPa = Pspec-dPbyV;
    dQa = Qspec-dQbyV;

    k = 1;
    dQ = zeros(npq,1);
    for i = 1:nbus
        if bus_type(i) == 3
            dQ(k,1) = dQa(i); 
            k = k+1;
        end
    end
    dP = dPa(2:nbus); 
    M = [dP; dQ];       % Mismatch Vector
    
    deltaTh = (-B_P)\dP; 
    deltaV = (-B_Q)\dQ; 
    
    % Updating State Vectors..
    theta(2:nbus) = deltaTh + theta(2:nbus);    % Voltage Angle..
    k = 1;
    for i = 2:nbus
        if bus_type(i) == 3
            V(i) = deltaV(k) + V(i);        % Voltage Magnitude..
            k = k+1;
        end
    end
    
    Iter = Iter + 1;
    Tol = max(abs(M));     % Tolerance..
        
end
[Load_Flow Line_Flow] = loadflow(nbus,V,theta,BaseMVA,Line_Data, Bus_Data);              % Calling Loadflow.m..