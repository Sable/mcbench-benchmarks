function sumll = loglik(para,Y, tau, nrow, ncol) %calculate log likelihood
% author: biao from www.mathfinance.cn

% initialize the parameter for CIR model
theta = para(1); kappa = para(2); sigma = para(3); lambda = para(4);
% sigmai = 0.005*ones(1,ncol);%volatility of measurement error
sigmai = para(5:end);
R = eye(ncol);
for i = 1:ncol
    R(i,i) = sigmai(i)^2;
end
dt = 1/12; %monthly data
initx = theta;
initV = sigma^2*theta/(2*kappa);

% parameter setting for transition equation
mu = theta*(1-exp(-kappa*dt));
F = exp(-kappa*dt);

% parameter setting for measurement equation
A = zeros(1, ncol);
H = A;
for i = 1:ncol
    AffineGamma = sqrt((kappa+lambda)^2+2*sigma^2);
    AffineBeta = 2*(exp(AffineGamma*tau(i))-1)/((AffineGamma+kappa+lambda)*(exp(AffineGamma*tau(i))-1)+2*AffineGamma);
    AffineAlpha = 2*kappa*theta/(sigma^2)*log(2*AffineGamma*exp((AffineGamma+kappa+lambda)*tau(i)/2)/((AffineGamma+kappa+lambda)*...
        (exp(AffineGamma*tau(i))-1)+2*AffineGamma));
    A(i) = -AffineAlpha/tau(i);
    H(i) = AffineBeta/tau(i);
end

%now recursive steps
AdjS = initx;
VarS = initV;
ll = zeros(nrow,1); %log-likelihood
for i = 1:nrow
    PredS = mu+F*AdjS; %predict values for S and Y
    Q = theta*sigma*sigma*(1-exp(-kappa*dt))^2/(2*kappa)+sigma*sigma/kappa*(exp(-kappa*dt)-exp(-2*kappa*dt))*AdjS;
    VarS = F*VarS*F'+Q;
    PredY = A+H*PredS;
    PredError = Y(i,:)-PredY;
    VarY = H'*VarS*H+R;
    InvVarY = inv(VarY);
    DetY = det(VarY);
    %updating
    KalmanGain = VarS*H*InvVarY;
    AdjS = PredS+KalmanGain*PredError';
    VarS = VarS*(1-KalmanGain*H');
    ll(i) = -(ncol/2)*log(2*pi)-0.5*log(DetY)-0.5*PredError*InvVarY*PredError';
end
sumll = -sum(ll);
end