function sumll=LLoneCIR(para,Y, tau, nrow, ncol) 
% initialize the parameters for CIR model
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
C=theta*(1-exp(-kappa*dt));           % eqn b.3
F=exp(-kappa*dt);                     % eqn b.3
A=zeros(1, ncol);                      
H=A;                                   

% Create A and B
for i=1:ncol % System matrices are made for each tau                    
    AffineG=sqrt((kappa+lambda)^2+2*sigma^2);                           % eqn a.10
    AffineB=2*(exp(AffineG*tau(i))-1)/((AffineG+kappa+lambda)...
        *(exp(AffineG*tau(i))-1)+2*AffineG);                            % eqn a.9
    AffineA=2*kappa*theta/(sigma^2)*log(2*AffineG*...
        exp((AffineG+kappa+lambda)*tau(i)/2)/((AffineG+kappa+lambda)*...
        (exp(AffineG*tau(i))-1)+2*AffineG));                            % eqn a.8
    A(i)=-AffineA/tau(i);       % eqn b.1
    H(i)=AffineB/tau(i);        % eqn b.1
end

%% Kalman Filter 
% Step 1 Initializing the state vector
initx=theta;                      % Unconditional mean eqn c.1  
initV=sigma^2*theta/(2*kappa);    % Unconditional variance eqn c.3
% Starting values
AdjS=initx;
VarS=initV;
LL=zeros(nrow,1);
for i=1:nrow
    PredS=C+F*AdjS;                              % eqn c.10
    Q=theta*sigma*sigma*(1-exp(-kappa*dt))^2/(2*kappa)+sigma*sigma/kappa...
        *(exp(-kappa*dt)-exp(-2*kappa*dt))*AdjS;    % eqn b.4
    VarS=F*VarS*F'+Q;                             % eqn c.11
    % Step 2 Forecasting the Measurement equation
    PredY=A+H*PredS;              % Conditional Forecast of the measurement equation eqn c.4
    VarY=H'*VarS*H+R;             % Associated Conditional Variance eqn c.5
    % Step 3 Updating the inference about the state vector
    PredError=Y(i,:)-PredY;                       % Prediction error on z eqn c.6
    KalmanGain=VarS*H*inv(VarY);                  % Kalman Gain Matrix eqn c.8
    AdjS=PredS+KalmanGain*PredError';             % Update inference about the unodserved transition system eqn c.7
    VarS=VarS*(1-KalmanGain*H');                  % Update conditional variance eqn c.9
    % Step 5 Construct the likelihood function
    DetY=det(VarY);
    LL(i)=-(ncol/2)*log(2*pi)-0.5*log(DetY)-0.5*PredError*inv(VarY)*PredError'; % eqn c.12
end
sumll=-sum(LL);
end