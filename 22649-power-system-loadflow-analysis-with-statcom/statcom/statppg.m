% Program for Newton-Raphson Load Flow with STATCOM

Y = ybusppg();              % Calling ybusppg.m..
busdata = busdata30();       % Calling Busdata..
statdata = statdata30();     % Statcom Data..
baseMVA = 100;              % Base MVA..
bus = busdata(:,1);         % Bus Number..
type = busdata(:,2);        % Type of Bus 1-Slack, 2-PV, 3-PQ..
V = busdata(:,3);           % Specified Voltage..
del = busdata(:,4);         % Voltage Angle..
Pg = busdata(:,5);          % PGi..
Qg = busdata(:,6);          % QGi..
Pl = busdata(:,7);          % PLi..
Ql = busdata(:,8);          % QLi..
Qmin = busdata(:,9);        % Minimum Reactive Power Limit..
Qmax = busdata(:,10);       % Maximum Reactive Power Limit..
nbus = max(bus);            % To get no. of buses..
P = Pg - Pl;                % Pi = PGi - PLi..
Q = Qg - Ql;                % Qi = QGi - QLi..
P = P/baseMVA;              % Converting to p.u..
Q = Q/baseMVA;
Qmin = Qmin/baseMVA;
Qmax = Qmax/baseMVA;
Tol = 1;  
Iter = 1; 
Psp = P;
Qsp = Q;
G = real(Y);    % Conductance..
B = imag(Y);    % Susceptance..
Vsp = V;

% Details of STATCOM
statb = statdata(:,1); % Buses at which statcoms are placed..
Vsh = statdata(:,2);
Thst = statdata(:,3);
Qsmx = statdata(:,4);
Qsmn = statdata(:,5);
gsh = 0.9901;
bsh = -9.901;
Vshmx = 1.1; Vshmn = 0.9;
Thstmx = pi; Thstmn = -pi;
np = length(statb); % Number of STATCOMs..

pv = find(type == 2 | type == 1); % Index of PV Buses..
pq = find(type == 3); % Index of PQ Buses..

npv = length(pv); % Number of PV buses..
npq = length(pq); % Number of PQ buses..

while (Tol > 1e-5 && Iter <= 50)   % Iteration starting..
    
    P = zeros(nbus,1);
    Q = zeros(nbus,1);
    % Calculate P and Q
    for i = 1:nbus
        for k = 1:nbus
            P(i) = P(i) + V(i)* V(k)*(G(i,k)*cos(del(i)-del(k)) + B(i,k)*sin(del(i)-del(k)));
            Q(i) = Q(i) + V(i)* V(k)*(G(i,k)*sin(del(i)-del(k)) - B(i,k)*cos(del(i)-del(k)));
        end
        m = find(statb == i);
        if ~isempty(m)
            P(i) = P(i) + V(i)^2*gsh - V(i)*Vsh(m)*(gsh*cos(del(i)-Thst(m)) + bsh*sin(del(i)-Thst(m)));
            Q(i) = Q(i) - V(i)^2*bsh + V(i)*Vsh(m)*(bsh*cos(del(i)-Thst(m)) - gsh*sin(del(i)-Thst(m)));
        end
    end
      
    % Checking Q-limit violations..
    if Iter >= 2
        for n = 1:nbus
            if type(n) == 2
                if Q(n) < Qmin(n)
                    V(n) = V(n) + 0.01;
                elseif Q(n) > Qmax(n)
                    V(n) = V(n) - 0.01;
                end
            end
         end
    end
    
    % Calculating PE, 
    PE = zeros(np,1);
    for i = 1:np
        m = statb(i);
        PE(i) = Vsh(i)^2*gsh - V(m)*Vsh(i)*(gsh*cos(del(m)-Thst(i)) - bsh*sin(del(m)-Thst(i)));
    end
    
    % Calculate F, Control Variables
    F = zeros(np,1);
    for i = 1:np
        m = statb(i);
        F(i) = V(m) - Vsp(m);
    end
    
    % Calculate change from specified value
    dPa = Psp-P;
    dQa = Qsp-Q;
    dQ = zeros(npq,1);
    k = 1;
    for i = 1:nbus
        if type(i) == 3
            dQ(k,1) = dQa(i);
            k = k+1;
        end
    end
    dP = dPa(2:nbus);
    dPE = -PE;
    dF = -F;
    M = [dP; dQ; dPE; dF];       % Mismatch Vector
    
    % Jacobian
    % J11 - Derivative of Real Power Injections with Angles..
    J11 = zeros(nbus-1,nbus-1);
    for i = 1:(nbus-1)
        m = i+1;
        p = find(statb == m);
        for k = 1:(nbus-1)
            q = k+1;
            if q == m
                for n = 1:nbus
                    J11(i,k) = J11(i,k) + V(m)* V(n)*(-G(m,n)*sin(del(m)-del(n)) + B(m,n)*cos(del(m)-del(n)));
                end
                J11(i,k) = J11(i,k) - V(m)^2*B(m,m);
                if ~isempty(p)
                    J11(i,k) = J11(i,k) + V(m)*Vsh(p)*(gsh*sin(del(m)-Thst(p)) - bsh*cos(del(m)-Thst(p)));
                end
            else
                J11(i,k) = V(m)* V(q)*(G(m,q)*sin(del(m)-del(q)) - B(m,q)*cos(del(m)-del(q)));
            end
        end
    end
    
    % J12 - Derivative of Real Power Injections with V..
    J12 = zeros(nbus-1,npq);
    for i = 1:(nbus-1)
        m = i+1;
        p = find(statb == m);
        for k = 1:npq
            q = pq(k);
            if q == m
                for n = 1:nbus
                    J12(i,k) = J12(i,k) + V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                J12(i,k) = J12(i,k) + V(m)*G(m,m);
                if ~isempty(p)
                    J12(i,k) = J12(i,k) + 2*V(m)*gsh - Vsh(p)*(gsh*cos(del(m)-Thst(p)) + bsh*sin(del(m)-Thst(p)));
                end
            else
                J12(i,k) = V(m)*(G(m,q)*cos(del(m)-del(q)) + B(m,q)*sin(del(m)-del(q)));
            end
        end
    end
    
    % J13 - Derivative of Real Power Injections with Vsh..
    % J14 - Derivative of Real Power Injections with Thsh..
    J13 = zeros(nbus-1,np);
    J14 = zeros(nbus-1,np);
    for i = 1:(nbus-1)
        m = i+1;
        for k = 1:np
            p = statb(k);
            if m == p
                J13(i,k) = -V(m)*(gsh*cos(del(m)-Thst(k)) + bsh*sin(del(m)-Thst(k)));
                J14(i,k) = -V(m)*Vsh(k)*(gsh*sin(del(m)-Thst(k)) - bsh*cos(del(m)-Thst(k)));
            end
        end
    end
    
    % J21 - Derivative of Reactive Power Injections with Angles..
    J21 = zeros(npq,nbus-1);
    for i = 1:npq
        m = pq(i);
        p = find(statb == m);
        for k = 1:(nbus-1)
            q = k+1;
            if q == m
                for n = 1:nbus
                    J21(i,k) = J21(i,k) + V(m)* V(n)*(G(m,n)*cos(del(m)-del(n)) + B(m,n)*sin(del(m)-del(n)));
                end
                J21(i,k) = J21(i,k) - V(m)^2*G(m,m);
                if ~isempty(p)
                    J21(i,k) = J21(i,k) - V(m)*Vsh(p)*(gsh*cos(del(m)-Thst(p)) + bsh*sin(del(m)-Thst(p)));
                end
            else
                J21(i,k) = -V(m)* V(q)*(G(m,q)*cos(del(m)-del(q)) + B(m,q)*sin(del(m)-del(q)));
            end
        end
    end
    
    % J22 - Derivative of Reactive Power Injections with V..
    J22 = zeros(npq,npq);
    for i = 1:npq
        m = pq(i);
        p = find(statb == m);
        for k = 1:npq
            q = pq(k);
            if q == m
                for n = 1:nbus
                    J22(i,k) = J22(i,k) + V(n)*(G(m,n)*sin(del(m)-del(n)) - B(m,n)*cos(del(m)-del(n)));
                end
                J22(i,k) = J22(i,k) - V(m)*B(m,m);
                if ~isempty(p)
                    J22(i,k) = J22(i,k) - 2*V(m)*bsh - Vsh(p)*(gsh*sin(del(m)-Thst(p)) - bsh*cos(del(m)-Thst(p)));
                end
            else
                J22(i,k) = V(m)*(G(m,q)*sin(del(m)-del(q)) - B(m,q)*cos(del(m)-del(q)));
            end
        end
    end
    
    % J23 - Derivative of Reactive Power Injections with Vsh..
    % J24 - Derivative of Reactive Power Injections with Thsh..
    J23 = zeros(npq,np);
    J24 = zeros(npq,np);
    for i = 1:npq
        q = pq(i);
        m = i+1;
        for k = 1:np
            p = statb(k);
            if q == p
                J23(i,k) = -V(m)*(gsh*sin(del(m)-Thst(k)) - bsh*cos(del(m)-Thst(k)));
                J24(i,k) = V(m)*Vsh(k)*(gsh*cos(del(m)-Thst(k)) + bsh*sin(del(m)-Thst(k)));
            end
        end
    end
    
    % J31 - Derivative of PE with Angles..
    % J41 - Derivative of F with Angles..
    J31 = zeros(np,nbus-1);
    J41 = zeros(np,nbus-1);
    for i = 1:np
        m = statb(i);
        for k = 1:(nbus-1)
            if m == k+1
                J31(i,k) = V(m)*Vsh(i)*(gsh*sin(del(m)-Thst(i)) + bsh*cos(del(m)-Thst(i)));
            end
        end
    end
    
    % J32 - Derivative of PE with V..
    % J42 - Derivative of F with V..
    J32 = zeros(np,npq);
    J42 = zeros(np,npq);
    for i = 1:np
        m = statb(i);
        for k = 1:npq
            if m == pq(k)
                J32(i,k) = -Vsh(i)*(gsh*cos(del(m)-Thst(i)) - bsh*sin(del(m)-Thst(i)));
            end
            if m == pq(k)
                J42(i,k) = 1;
            end
        end
    end
    
    % J33 - Derivative of PE with Vsh..
    % J34 - Derivative of PE with Thsh..
    % J43 - Derivative of F with Vsh..
    % J44 - Derivative of F with Thsh..
    J33 = zeros(np,np);
    J34 = zeros(np,np);
    J43 = zeros(np,np);
    J44 = zeros(np,np);
    for i = 1:np
        m = statb(i);
        for k = 1:np
            p = statb(k);
            if m == p
                J33(i,k) = 2*Vsh(k)*gsh - V(m)*(gsh*cos(del(m)-Thst(k)) - bsh*sin(del(m)-Thst(k)));
                J34(i,k) = -V(m)*Vsh(k)*(gsh*sin(del(m)-Thst(k)) + bsh*cos(del(m)-Thst(k)));
            end
        end
    end
    
    J = [J11 J12 J13 J14; J21 J22 J23 J24; J31 J32 J33 J34; J41 J42 J43 J44];     % Jacobian
    clear J11 J12 J13 J14 J21 J22 J23 J24 J31 J32 J33 J34 J41 J42 J43 J44
    
    X = inv(J)*M;           % Correction Vector
    dTh = X(1:nbus-1);
    dV = X(nbus:nbus+npq-1);
    dVsh = X(nbus+npq:nbus+npq+np-1);
    dThst = X(nbus+npq+np:nbus+npq+2*np-1);
    del(2:nbus) = dTh + del(2:nbus);
    k = 1;
    for i = 2:nbus
        if type(i) == 3
            V(i) = dV(k) + V(i);
            k = k+1;
        end
    end
    Vsh = Vsh + dVsh;
    Thst = Thst + dThst;

    % Calculate Qsh..
    Qsh = zeros(np,1);
    for m = 1:np
        i = statb(m);
        Qsh(m) = -V(i)^2*bsh + V(i)*Vsh(m)*(bsh*cos(del(i)-Thst(m)) - gsh*sin(del(i)-Thst(m)));
    end
    Iter = Iter + 1;
    Tol = max(abs(M));
end
    
Iter = Iter - 1; % Number of Iterations took..
V;
Del = 180/pi*del;
Thst = 180/pi*Thst;
E2 = [V Del]; % Bus Voltages and angles..
disp('------------------------------');
disp('|  Bus  |    V    |  Angle   | ');
disp('|  No   |   pu    |  Degree  | ');
disp('------------------------------');
for m = 1:nbus
    fprintf('%4g', m), fprintf('    %8.4f', V(m)), fprintf('    %8.4f', Del(m)),fprintf('\n');
end
disp('-----------------------------');
disp('----------------------------------------');
disp('| STATCOM |  Vsh   |  Thst    |   Qsh  |');
disp('|   Bus   |   pu   |  Degree  |    pu  |');
disp('----------------------------------------');
for m = 1:np
    fprintf('  %4g',statb(m)), fprintf('   %8.4f', Vsh(m)), fprintf('    %8.4f', Thst(m)),fprintf('  %8.4f', Qsh(m)), fprintf('\n');
end
disp('----------------------------------------');