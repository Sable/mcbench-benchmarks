% function to implement the Iterated Extended Kalman Filter (IEKF)
% Inputs:
%  OBSn - the observations (with noise)
%  xest - initial state space estimates
% Ouputs:
%  Xp - predicted states
function Xp = f_IEKF(OBSn,xest)

load avar % r1,r2, L, and T

tol = .1; % tolerance for iterations
diff = 1;
count = 0;

F = [1 T 0 0 0 0 0;
    0 1 0 0 0 0 0;
    0 0 1 T 0 0 0;
    0 0 0 1 0 0 0;
    0 0 0 0 1 0 T;
    0 0 0 0 0 1 T;
    0 0 0 0 0 0 1]; % state transition matrix

n = size(OBSn,2); % number of observations

Xp = zeros(7,n);  % make room

Pkp1 = 1e10*eye(7); %xest*xest'; %.1*ones(7,7);

%Pkp1 = xest*xest';
%Pkp1 = F*Pkp1*F';

%Pkp1 = (10*randn(7,1))*(10*randn(7,1)).';
%Pkp1 = F*Pkp1*F';

% for each observation
for i = 1:n;
    
    % if this is the first iteration the prior predicted estimate is xest
    % if this is not the first run the prior estimate is in Xp
    if i == 1
        xkm1 = xest;
    else
        xkm1 = Xp(:,i-1);
    end
    
    Pkm1 = Pkp1; % conditional covariance from last iteration
    
    % iterations are started with the predicted estimate from the last run
    xkn = xkm1;
    while ~(diff < tol || count > 9)
        
        count = count + 1; 
        
        H = [gradest(@(x)f_h1(x),xkn); gradest(@(x)f_h2(x),xkn)];
        
        R = (.01*randn(2,1))*(.01*randn(2,1)).';
        
        Rdiag = diag(R); R = diag(Rdiag);
        
        K = Pkm1*H'*(H*Pkm1*H'+R)^-1;
        
        xkn_temp = xkm1 + K*(OBSn(:,i)-f_h(xkn)-H*(xkm1-xkn));
        
        diff = norm(abs(xkn_temp-xkn));
        
        fprintf('diff = %g \n',diff)
        
        xkn = xkn_temp;
            
    end
    
    H = [gradest(@(x)f_h1(x),xkn); gradest(@(x)f_h2(x),xkn)];
    
    Pkk = (eye(7)-K*H)*Pkm1;
    
    Pkp1 = F*Pkk*F';
    
    Xp(:,i) = F*xkn;
    
    clc;
    
    fprintf('i = %g; Count is %g \n',i,count)
    
    count = 0;
    
    diff = 1;
    
end

 
 