clear
clc
[baseMVA, bus, gen, branch, areas, gencost] = c30 ;
n=length(bus(:,1));
m=length(gen(:,1));
PQ      = 1;
PV      = 2;
REF     = 3;
NONE    = 4;
i2e = bus(:, 1);
e2i = zeros(max(i2e), 1);
e2i(i2e) = [1:size(bus, 1)]';
bus(:, 1)               = e2i( bus(:, 1)            );
gen(:, 1)             = e2i( gen(:, 1)          );
branch(:, 1)            = e2i( branch(:, 1)         );
branch(:, 2)            = e2i( branch(:, 2)         );
nb = size(bus, 1);
ng = size(gen, 1);
Cg = sparse(gen(:, 1), [1:ng]', gen(:, 8) > 0, nb, ng);  %% gen connection matrix
                                        % element i, j is 1 if, generator j at bus i is ON
bus_gen_status = Cg * ones(ng, 1);      %% number of generators at each bus that are ON

%% form index lists for slack, PV, and PQ buses
ref = find(bus(:, 2) == REF & bus_gen_status);   %% reference bus index
pv  = find(bus(:, 2) == PV  & bus_gen_status);   %% PV bus indices
pq  = find(bus(:, 2) == PQ | ~bus_gen_status);   %% PQ bus indices

%% pick a new reference bus if for some reason there is none (may have been shut down)
if isempty(ref)
    ref = pv(1);                %% use the first PV bus
    pv = pv(2:length(pv));      %% take it off PV list
end
on = find(gen(:, 8) > 0);      %% which generators are on?
gbus = gen(on, 1);                %% what buses are they at?

%% form net complex bus power injection vector
nb = size(bus, 1);
ngon = size(on, 1);
Cg = sparse(gbus, [1:ngon]', ones(ngon, 1), nb, ngon);  %% connection matrix
                                                        %% element i, j is 1 if
                                                        %% gen on(j) at bus i is ON
Sbus =  ( Cg * (gen(on, 2) + j * gen(on, 3)) ...  %% power injected by generators
            - (bus(:, 3) + j * bus(:, 4)) ) / ... %% plus power injected by loads
        baseMVA;                                    %% converted to p.u.
Sbus=Sbus.';
nb = size(bus, 1);          %% number of buses
nl = size(branch, 1);       %% number of lines

%% define named indices into bus, branch matrices

%% check that bus numbers are equal to indices to bus (one set of bus numbers)
if any(bus(:, 1) ~= [1:nb]')
    error('buses must appear in order by bus number')
end

%% for each branch, compute the elements of the branch admittance matrix where
%%
%%      | If |   | Yff  Yft |   | Vf |
%%      |    | = |          | * |    |
%%      | It |   | Ytf  Ytt |   | Vt |
%%
stat = branch(:, 11);                    %% ones at in-service branches
Ys = stat ./ (branch(:, 3) + j * branch(:, 4));   %% series admittance
Bc = stat .* branch(:, 5);                           %% line charging susceptance
tap = ones(nl, 1);                              %% default tap ratio = 1
i = find(branch(:, 9));                       %% indices of non-zero tap ratios
tap(i) = branch(i, 9);                        %% assign non-zero tap ratios
tap = tap .* exp(-j*pi/180 * branch(:, 10)); %% add phase shifters
Ytt = Ys + j*Bc/2;
Yff = Ytt ./ (tap .* conj(tap));
Yft = - Ys ./ conj(tap);
Ytf = - Ys ./ tap;

%% compute shunt admittance
%% if Psh is the real power consumed by the shunt at V = 1.0 p.u.
%% and Qsh is the reactive power injected by the shunt at V = 1.0 p.u.
%% then Psh - j Qsh = V * conj(Ysh * V) = conj(Ysh) = Gs - j Bs,
%% i.e. Ysh = Psh + j Qsh, so ...
Ysh = (bus(:, 5) + j * bus(:, 6)) / baseMVA;  %% vector of shunt admittances

%% build Ybus
f = branch(:, 1);                           %% list of "from" buses
t = branch(:, 2);                           %% list of "to" buses
Cf = sparse(f, 1:nl, ones(nl, 1), nb, nl);      %% connection matrix for line & from buses
Ct = sparse(t, 1:nl, ones(nl, 1), nb, nl);      %% connection matrix for line & to buses
Ybus = spdiags(Ysh, 0, nb, nb) + ...            %% shunt admittance
    Cf * spdiags(Yff, 0, nl, nl) * Cf' + ...    %% Yff term of branch admittance
    Cf * spdiags(Yft, 0, nl, nl) * Ct' + ...    %% Yft term of branch admittance
    Ct * spdiags(Ytf, 0, nl, nl) * Cf' + ...    %% Ytf term of branch admittance
    Ct * spdiags(Ytt, 0, nl, nl) * Ct';         %% Ytt term of branch admittance

%% Build Yf and Yt such that Yf * V is the vector of complex branch currents injected
%% at each branch's "from" bus, and Yt is the same for the "to" bus end
if nargout > 1
    i = [[1:nl]'; [1:nl]'];     %% double set of row indices    
    Yf = sparse(i, [f; t], [Yff; Yft], nl, nb);
    Yt = sparse(i, [f; t], [Ytf; Ytt], nl, nb);
end
P=real(Sbus);
 Q=imag(Sbus);
 Qmin=gen(:,5);
  Qmax=gen(:,4);

V=ones(1,n);
e1=real(V);
f1=imag(V);
G=real(Ybus);
B=imag(Ybus);
B1=B;
G1=G;
ce=zeros(1,n-1);
cf=zeros(1,n-1);
 for iter=1:10
    ce1=[1.06 ce];
    cf1=[0 cf];
    e=e1(2:n);
    f=f1(2:n);
    e1=[0 e]+ce1;
    f1=[0 f]+cf1;
   cP=diag(e1)*(G*e1'-B*f1')+diag(f1)*(B*e1'+G*f1');
      cQ=-diag(e1)*(G1*f1'+B1*e1')+diag(f1)*(-B1*f1'+G1*e1');
      cQ1=cQ;
      J11 =diag(e1)*G+diag(f1)*B-diag(B*f1');;
     J12 =-diag(e1)*B+diag(f1)*G+diag(B*e1');
     J21 =diag(f1)*G1-diag(e1)*B1-diag(G*f1');
     J22 =-diag(e1)*G1-diag(f1)*B1+diag(G*e1');
      for i=2:m
          x=gen(i,1);
          if cQ1(x)<Qmin(i)
              Q(x)=Qmin(i);
              elseif cQ1(x)>Qmax(i)
              Q(x)=Qmax(i);  
          else
               Q(x)=gen(i,6)^2;
       cQ(x)=e1(x)^2+f1(x)^2;
       J21(x,:)=0;
      J22(x,:)=0;
      J21(x,x)=2*e1(x);
       J22(x,x)=2*f1(x);
      end
      end
  PQ=[P Q]';
cPQ=[cP' cQ'];
   chPQ=PQ-cPQ';
    c1=chPQ(2:n);
     c2=chPQ(n+2:2*n);
    C=[c1;c2];
     J=[J11(2:n,2:n) J12(2:n,2:n) ;J21(2:n,2:n) J22(2:n,2:n)];
  chV=inv(J)*C;
    ce=(chV(1:n-1))';
    cf=(chV(n:2*(n-1)))';
 end
  V=e1+j*f1;
for i=1:nl
    x=branch(i,1);
     y=branch(i,2);
     LF(i)=V(x)*conj(Ys(i)*(V(x)-V(y)));
        LF1(i)=V(y)*conj(Ys(i)*(V(x)-V(y)));
end
   
 [abs(V.') (180/pi)*angle(V.') baseMVA*cP baseMVA*cQ1]