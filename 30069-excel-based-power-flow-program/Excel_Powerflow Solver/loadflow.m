% Program for Bus Power Injections, Line & Power flows (p.u)...

%function [Pi Qi Pg Qg Pl Ql] = loadflow(nb,V,del,BMva)
function [Load_Flow_M Line_Flow_M] = loadflow(nb,V,del,BMva,Line_Data,Bus_Data)

Y = ybusppg(nb,Line_Data);                % Calling Ybus program..
%lined = linedatas(nb);          % Get linedats.
lined = Line_Data;
busd = Bus_Data;
%busd = busdatas(nb);            % Get busdatas..

Vm = pol2rect(V,del);           % Converting polar to rectangular..
Del = 180/pi*del;               % Bus Voltage Angles in Degree...
fb = lined(:,1);                % From bus number...
tb = lined(:,2);                % To bus number...
nl = length(fb);                % No. of Branches..
Pl = busd(:,7);                 % PLi..
Ql = busd(:,8);                 % QLi..

Iij = zeros(nb,nb);
Sij = zeros(nb,nb);
Si = zeros(nb,1);

% Bus Current Injections..
 I = Y*Vm;
 Im = abs(I);
 Ia = angle(I);
 
%Line Current Flows..
for m = 1:nl
    p = fb(m); q = tb(m);
    Iij(p,q) = -(Vm(p) - Vm(q))*Y(p,q); % Y(m,n) = -y(m,n)..
    Iij(q,p) = -Iij(p,q);
end
Iij = sparse(Iij);
Iijm = abs(Iij);
Iija = angle(Iij);

% Line Power Flows..
for m = 1:nb
    for n = 1:nb
        if m ~= n
            Sij(m,n) = Vm(m)*conj(Iij(m,n))*BMva;
        end
    end
end
Sij = sparse(Sij);
Pij = real(Sij);
Qij = imag(Sij);
 
% Line Losses..
Lij = zeros(nl,1);
for m = 1:nl
    p = fb(m); q = tb(m);
    Lij(m) = Sij(p,q) + Sij(q,p);
end
Lpij = real(Lij);
Lqij = imag(Lij);

% Bus Power Injections..
for i = 1:nb
    for k = 1:nb
        Si(i) = Si(i) + conj(Vm(i))* Vm(k)*Y(i,k)*BMva;
    end
end
Pi = real(Si);
Qi = -imag(Si);
Pg = Pi+Pl;
Qg = Qi+Ql;

Load_Flow_M = zeros(nb+1,9);

for m = 1:nb
    Load_Flow_M(m,1) = m;
    Load_Flow_M(m,2) = V(m);
    Load_Flow_M(m,3) = Del(m);
    Load_Flow_M(m,4) = Pi(m); 
    Load_Flow_M(m,5) = Qi(m); 
    Load_Flow_M(m,6) = Pg(m);
    Load_Flow_M(m,7) = Qg(m); 
    Load_Flow_M(m,8) = Pl(m);
    Load_Flow_M(m,9) = Ql(m);
end
m = m + 1;
    Load_Flow_M(m,1) = NaN;
    Load_Flow_M(m,2) = NaN;
    Load_Flow_M(m,3) = NaN;
    Load_Flow_M(m,4) = sum(Pi); 
    Load_Flow_M(m,5) = sum(Qi); 
    Load_Flow_M(m,6) = sum(Pi+Pl);
    Load_Flow_M(m,7) = sum(Qi+Ql); 
    Load_Flow_M(m,8) = sum(Pl);
    Load_Flow_M(m,9) = sum(Ql);
    
Line_Flow_M = zeros(nl+1,10);

for m = 1:nl
    p = fb(m); q = tb(m);
    Line_Flow_M(m,1) = full(p); 
    Line_Flow_M(m,2) = full(q); 
    Line_Flow_M(m,3) = full(Pij(p,q));
    Line_Flow_M(m,4) = full(Qij(p,q));
    Line_Flow_M(m,5) = full(q);
    Line_Flow_M(m,6) = full(p);
    Line_Flow_M(m,7) = full(Pij(q,p));
    Line_Flow_M(m,8) = full(Qij(q,p));
    Line_Flow_M(m,9) = Lpij(m);
    Line_Flow_M(m,10) = Lqij(m);
end
m = m+1;
    Line_Flow_M(m,1) = NaN; 
    Line_Flow_M(m,2) = NaN; 
    Line_Flow_M(m,3) = NaN;
    Line_Flow_M(m,4) = NaN;
    Line_Flow_M(m,5) = NaN;
    Line_Flow_M(m,6) = NaN;
    Line_Flow_M(m,7) = NaN;
    Line_Flow_M(m,8) = NaN;
    Line_Flow_M(m,9) = sum(Lpij);
    Line_Flow_M(m,10) = sum(Lqij);
    
