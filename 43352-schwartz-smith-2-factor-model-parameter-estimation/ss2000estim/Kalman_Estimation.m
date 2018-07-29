function log_L = Kalman_Estimation(y, psi, matur, dt, a0, P0, N, nobs, locked_parameters)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracting initial parameter values from initial psi 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = psi(1,1);
sigmax = psi(2,1);
lambdax = psi(3,1);
mu = psi(4,1);
sigmae = psi(5,1);
rnmu = psi(6,1);
pxe = psi(7,1);

if sum(locked_parameters) == 0
    k = psi(1,1);
    sigmax = psi(2,1);
    lambdax = psi(3,1);
    mu = psi(4,1);
    sigmae = psi(5,1);
    rnmu = psi(6,1);
    pxe = psi(7,1);
    
    s = zeros(1, size(psi,1)-7);
    for i = 1:size(s,2)
        s(1, i) = psi(i+7,1);
    end
end
    
if sum(locked_parameters) ~= 0 
    s = zeros(1, size(psi,1)-7+size(locked_parameters,1));
    j = 1;
    for i = 1:size(s,2)
        if all(abs(i-(locked_parameters))) == 1
             s(1, i) = psi(7+j,1);
             j = j+1;
        end
    end
end


    
% m = Number of state variables (number of rows in a0)
m = size(a0,1);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THE TRANSITION EQUATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S&S NOTATION: x(t)=c+G*x(t-1)+w(t)        w~N(0,W)    Equation (14)
% NEW NOTATION: a(t)=c+T*a(t-1)+R(t)*n(t)   n~N(0,Q)

% c is a {m x 1} Vector
% T is a {m x m} Matrix
c=[0;mu*dt];
T=[exp(-k*dt),0;0,1];

% Defining Q = var[n(t)] and R
xx=(1-exp(-2*k*dt))*(sigmax)^2/(2*k);
xy=(1-exp(-k*dt))*pxe*sigmax*sigmae/k;
yx=(1-exp(-k*dt))*pxe*sigmax*sigmae/k;
yy=(sigmae)^2*dt;
Q=[xx,xy;yx,yy];
R=eye(size(Q,1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THE MEASUREMENT EQUATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% S&S NOTATION: y(t)=d(t)+F(t)'x(t)+v(t)    v~N(0,V) Equation (15)
% NEW NOTATION: y(t)=d(t)+Z(t)a(t)+e(t)     e~N(0,H)

% d is a {N x 1} Vector
% Z is a {N x m} Matrix
    for i=1:N
        p1=(1-exp(-2*k*matur(i)))*(sigmax)^2/(2*k);
        p2=(sigmae)^2*matur(i);
        p3=2*(1-exp(-k*matur(i)))*pxe*sigmax*sigmae/k;
        d(i,1)=rnmu*matur(i)-(1-exp(-k*matur(i)))*lambdax/k+.5*(p1+p2+p3);
        Z(i,1)=exp(-k*matur(i));
        Z(i,2)=1;
    end

% Measurment errors Var-Cov Matrix: Cov[e(t)]=H
H=diag(s);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUNNING THE KALMAN FILTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating placeholder vectors/matrices for variables to be stored in
global save_vt save_att save_dFtt_1 save_vFv save_vtt save_Ptt_1 save_Ftt_1 save_Ptt

save_ytt_1 = zeros(nobs,N);
save_vtt = zeros(nobs,N);
save_vt    = zeros(nobs,N);
save_att_1 = zeros(nobs,m);
save_att   = zeros(nobs,m); 
save_Ptt_1 = zeros(nobs,m*m); 
save_Ptt   = zeros(nobs,m*m);
save_Ftt_1 = zeros(nobs,N*N);
save_dFtt_1 = zeros(nobs,1);
save_vFv    = zeros(nobs,1);
%save_log_Lt   = zeros(nobs,1);

Ptt = P0;
att = a0; 

% Running the kalman filter for t = 1,...,nobs
    for t = 1:nobs
        Ptt_1   = T*Ptt*T'+R*Q*R';
        Ftt_1   = Z*Ptt_1*Z'+H;
        dFtt_1  = det(Ftt_1);
        
        %Ptt_1_test = [Ptt_1(1,1) 0; 0 Ptt_1(2,2)];
        %Ftt_1_test   = Z*Ptt_1_test*Z'+H;
        %dFtt_1_test  = det(Ftt_1_test);
        
    
        att_1   = T*att + c;
        yt      = y(t,:)';
        ytt_1   = Z*att_1+d;
        vt      = yt-ytt_1;

        att = att_1 + Ptt_1*Z'*inv(Ftt_1)*(vt);
        Ptt = Ptt_1 - Ptt_1*Z'*inv(Ftt_1)*Z*Ptt_1;
        
        ytt = Z*att+d;
        vtt  = yt-ytt;

        % save_ytt_1(t,:) = ytt_1';
        save_vtt(t,:) = vtt';
        save_vt(t,:)    = (vt)';
        % save_att_1(t,:) = att_1';
        save_att(t,:)   = att';
        save_Ptt_1(t,:) = [Ptt_1(1,1), Ptt_1(1,2), Ptt_1(2,1), Ptt_1(2,2)]; 
        save_Ptt(t,:)   = [Ptt(1,1), Ptt(1,2), Ptt(2,1), Ptt(2,2)];
        % save_Ftt_1(t,:) = [Ftt_1(1,1), Ftt_1(1,2), Ftt_1(1,3), Ftt_1(1,4), Ftt_1(1,5), Ftt_1(2,1), Ftt_1(2,2), Ftt_1(2,3), Ftt_1(2,4), Ftt_1(2,5), Ftt_1(3,1), Ftt_1(3,2), Ftt_1(3,3), Ftt_1(3,4), Ftt_1(3,5), Ftt_1(4,1), Ftt_1(4,2), Ftt_1(4,3), Ftt_1(4,4), Ftt_1(5,5), Ftt_1(5,1), Ftt_1(5,2), Ftt_1(5,3), Ftt_1(5,4), Ftt_1(5,5)];
 
        %save_dFtt_1(t,:)= dFtt_1_test;
        %save_vFv(t,:)   = vt'*inv(Ftt_1_test)*vt;
        save_dFtt_1(t,:)= dFtt_1;
        save_vFv(t,:)   = vt'*inv(Ftt_1)*vt;
        
    end

    
logL = -(N*nobs/2)*log(2*pi)-0.5*sum(log(save_dFtt_1))-0.5*sum(save_vFv);
% logL = -(N*nobs/2)*log(2*pi)-0.5*sum(save_vFv);
% logL = sum(diag(save_vt'*save_vt));
log_L = -logL;


