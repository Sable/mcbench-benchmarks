% Steady-state rigorous distillation model

% Thermodynamic calculations
HL = zeros(N,1); HV = HL; K = zeros(N,C);
for j = 1:N
    [~,~,phiL,~,~,HL(j),~,~] = prsrk(x(j,:),P(j)*1e5,T(j)+273.15,pc,Tc,w,k,cpig,DHf,DGf,'L',Thermo);
    [~,~,phiV,~,~,HV(j),~,~] = prsrk(y(j,:),P(j)*1e5,T(j)+273.15,pc,Tc,w,k,cpig,DHf,DGf,'V',Thermo);
    K(j,:) = phiL./phiV;
end

% Material balances (N*C)
j = 1;     M(j,:) = V(j+1)*y(j+1,:) + F(j)*z(j,:) - (L(j) +U(j))*x(j,:) - (V(j) + W(j))*y(j,:);
j = 2:N-1; M(j,:) = diag(L(j-1))*x(j-1,:) + diag(V(j+1))*y(j+1,:) + diag(F(j))*z(j,:) - diag((L(j) +U(j)))*x(j,:) - diag((V(j) + W(j)))*y(j,:);
j = N;     M(j,:) = L(j-1)*x(j-1,:) + F(j)*z(j,:) - (L(j) +U(j))*x(j,:) - (V(j) + W(j))*y(j,:);

% Equilibrium relations (N*C)
E = y - K.*x;

% Mole fraction summations (2*N)
Sx = sum(x,2) - 1;
Sy = sum(y,2) - 1;

% Energy balances (N)
j = 1;     H(j) = V(j+1)*HV(j+1) + F(j)*HF(j) - (L(j) +U(j))*HL(j) - (V(j) + W(j))*HV(j) - Q(j);
j = 2:N-1; H(j) = L(j-1).*HL(j-1) + V(j+1).*HV(j+1) + F(j).*HF(j) - (L(j) + U(j)).*HL(j) - (V(j) + W(j)).*HV(j) - Q(j);
j = N;     H(j) = L(j-1)*HL(j-1) + F(j)*HF(j) - (L(j) +U(j))*HL(j) - (V(j) + W(j))*HV(j) - Q(j);

