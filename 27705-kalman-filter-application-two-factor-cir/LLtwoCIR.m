function sumll=LLtwoCIR(para,Y, tau, nrow, ncol) 
% Initialize the parameters for CIR model
theta1=para(1); 
kappa1=para(2);
sigma1=para(3);
lambda1=para(4);
theta2=para(5); 
kappa2=para(6);
sigma2=para(7);
lambda2=para(8);
sigmai=para(9:end);

R=eye(ncol);
for i=1:ncol              
    R(i,i)=sigmai(i)^2;
end
dt=1/12;

% System Matrices Initialization
C=[theta1*(1-exp(-kappa1*dt));theta2*(1-exp(-kappa2*dt))];   % eqn b.3
F=[exp(-kappa1*dt),0 ; 0,exp(-kappa2*dt)];                   % eqn b.3
A=zeros(ncol,1);
H=zeros(ncol,2);

% Create A and B
for i=1:ncol % System Matrices are made for each tau
    % Factor 1
    AffineG11=sqrt((kappa1+lambda1)^2+2*sigma1^2); % eqn a.8 & a.9 & a.10
    AffineG12=kappa1+lambda1+AffineG11;
    AffineG13=2*kappa1*theta1/sigma1^2;
    AffineG14=2*AffineG11+AffineG12*(exp(AffineG11*tau(i))-1);
    AffineA1=((2*AffineG11*exp(AffineG12*tau(i)/2))/AffineG14)^AffineG13;
    A1=-log(AffineA1)/tau(i);
    AffineB1=2*(exp(AffineG11*tau(i))-1)/AffineG14;
    B1=AffineB1/tau(i);
    % Factor 2
    AffineG21=sqrt((kappa2+lambda2)^2+2*sigma2^2); % % eqn a.8 & a.9 & a.10
    AffineG22=kappa2+lambda2+AffineG21;
    AffineG23=2*kappa2*theta2/sigma2^2;
    AffineG24=2*AffineG21+AffineG22*(exp(AffineG21*tau(i))-1);
    AffineA2=((2*AffineG21*exp(AffineG22*tau(i)/2))/AffineG24)^AffineG23;
    A2=-log(AffineA2)/tau(i);
    AffineB2=2*(exp(AffineG21*tau(i))-1)/AffineG24;
    B2=AffineB2/tau(i);
    
    A(i,1)=A1+A2;       % eqn b.2
    H(i,1)=B1;          % eqn b.2
    H(i,2)=B2;          % eqn b.2
end

%% Kalman filter
% Step 1
initx=[theta1;theta2];                      % eqn c.1
initV=[(sigma1^2*theta1)/(2*kappa1),0;...
        0,(sigma2^2*theta2)/(2*kappa2)];    % eqn c.2
% Starting values    
AdjS=initx;
VarS=initV;
LL=zeros(nrow,1);          % log-likelihood vector initialization

for i=1:nrow
    PredS=C+F*AdjS;                 % eqn c.10
    Q=[(theta1*sigma1*sigma1*(1-exp(-kappa1*dt))^2/(2*kappa1)+sigma1*sigma1/kappa1*(exp(-kappa1*dt)-exp(-2*kappa1*dt)))*AdjS(1),0;...
        0,(theta2*sigma2*sigma2*(1-exp(-kappa2*dt))^2/(2*kappa2)+sigma2*sigma2/kappa2*(exp(-kappa2*dt)-exp(-2*kappa2*dt)))*AdjS(2)];    % eqn b.4
    VarS=F*VarS*F'+Q;               % eqn c.11
    % Step 2
    PredY=A+H*PredS;                    % eqn c.4
    VarY=H*VarS*H'+R;                   % eqn c.5
    % Step 3
    PredError=Y(i,:)'-PredY;            % eqn c.6
    InvVarY=inv(VarY);
    DetY=det(VarY);
    KalmanGain=VarS*H'*InvVarY;         % eqn c.8
    AdjS=PredS+KalmanGain*PredError;    % eqn c.7
    VarS=VarS*(1-KalmanGain*H);         % eqn c.9
    
    % Step 5
    LL(i)=-(ncol/2)*log(2*pi)-0.5*log(DetY)-0.5*PredError'*InvVarY*PredError; % eqn c.10
end
sumll=-sum(LL);
end