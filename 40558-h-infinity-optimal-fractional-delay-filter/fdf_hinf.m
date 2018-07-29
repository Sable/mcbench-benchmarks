function K = fdf_hinf(F, D, T)

% FDF_HINF(F, D, T) computes the H-infinity optimal fractional delay filter
% 
% [INPUT]
% F: analog filter (TF object)
% D: fractional delay (positive real number)
% T: sampling period (positive real number)
%
% [OUTPUT]
% K: the optimal fractional delay filter (TF object)

%% Initial settings
% Delay D = mT + d; m: integer, 0<= d < T
m = floor(D/T);
d = mod(D, T);
% State space matrices of F(s)
[A,B,C,D]=ssdata(F);
if isempty(A)
    A=0; B=0; C=0;
end
eig_max = max(real(eig(A)));
if eig_max >=0
    disp('The filter F(s) must be stable !');
    K = [];
    return;
end
% Size of A
n=size(A,1);

%% H-inf Discretization
z = tf('z');
Delay_m = z^(-m);
[Am,Bm,Cm,Dm] = ssdata(ss(Delay_m));
Ad11 = expm(A*T);
Ad12 = zeros(n,1);
Ad13 = zeros(n,m);
Ad21 = C*expm(A*(T-d));
Ad22 = 0;
Ad23 = zeros(1,m);
Ad31 = zeros(m,n);
Ad32 = Bm;
Ad33 = Am;
Ad = [Ad11,Ad12,Ad13;Ad21,Ad22,Ad23;Ad31,Ad32,Ad33];

C1 = [zeros(1,n),0,Cm];
C2 = [C,0,zeros(1,m)];

Fh = expm([-A, B*B'; zeros(n,n),A']*T);
Fd = expm([-A, B*B'; zeros(n,n),A']*(T-d));

F12h = Fh(1:n,n+1:n+n);
F22h = Fh(n+1:n+n,n+1:n+n);

F12d = Fd(1:n,n+1:n+n);
F22d = Fd(n+1:n+n,n+1:n+n);

Mh = F22h'*F12h; % M(T)
Md = F22d'*F12d; % M(T-d)

BB11 = Mh;
BB12 = expm(A*d)*Md*C';
BB21 = BB12';
BB22 = C*Md*C';
BB = [BB11,BB12;BB21,BB22];

Bd = sqrtm(BB);

p=size(Bd,2);

%% H-infinity design
Gd = ss(Ad,[[Bd;zeros(m,p)],zeros(n+1+m,1)],[C1;C2],[zeros(1,p),-1;zeros(1,p),0],T);
K=hinfsyn(Gd,1,1, 'TOLGAM', 1e-6, 'METHOD', 'LMI');
