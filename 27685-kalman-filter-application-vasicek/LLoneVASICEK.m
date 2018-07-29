function sumll=LLoneVASICEK(para,Y, tau, nrow, ncol)
% initialize the parameters for VASICEK model
theta=para(1);
kappa=para(2);
sigma=para(3);
lambda=para(4);
sigmai=para(5:end);

R=eye(ncol);
for i=1:ncol
    R(i,i)=sigmai(i)^2;
end
dt=1/12;

% System Matrices Initialization
C=theta*(1-exp(-kappa*dt));      % eqn
F = exp(-kappa*dt);              % eqn
A = zeros(1, ncol);
H = A;

% Create A and B
for i = 1:ncol % Make System Matrices for each tau
    AffineG=kappa^2*(theta-(sigma*lambda)/kappa)-sigma^2/2;     % eqn a.6
    AffineB=1/kappa*(1-exp(-kappa*tau(i)));                     % eqn a.5
    AffineA=AffineG*(AffineB-tau(i))/kappa^2-(sigma^2*AffineB^2)/(4*kappa);   % eqn a.4
    A(i)=-AffineA/tau(i);     % eqn b.2
    H(i)=AffineB/tau(i);      % eqn b.2
end

%% Kalman Filter
% Step 1
initx=theta;                      % eqn c.1
initV=sigma^2/(2*kappa);          % eqn c.2
% Starting values
AdjS=initx;
VarS=initV;
LL=zeros(nrow,1);          % log-likelihood vector initialization
for i=1:nrow
    PredS=C+F*AdjS;     % eqn c.10
    Q=theta*sigma*sigma*(1-exp(-kappa*dt))^2/(2*kappa)+sigma*sigma/kappa*(exp(-kappa*dt)-exp(-2*kappa*dt))*AdjS; % eqn b.4
    VarS=F*VarS*F'+Q;         % eqn c.11
    % Step 2
    PredY=A+H*PredS;          % eqn c.4
    VarY=H'*VarS*H+R;         % eqn c.5
    % Step 3
    PredError=Y(i,:)-PredY;   % eqn c.6
    KalmanGain=VarS*H*inv(VarY);          % eqn c.8
    AdjS=PredS+KalmanGain*PredError';     % eqn c.7
    VarS=VarS*(1-KalmanGain*H');          % eqn c.9
    % Step 5 Construct the likelihood function
    DetY=det(VarY);
    LL(i)=-(ncol/2)*log(2*pi)-0.5*log(DetY)-0.5*PredError*inv(VarY)*PredError'; % eqn c.12
end
sumll = -sum(LL);
end