% Copyright 2009 - 2010 The MathWorks, Inc.
function y = kalman04(z) %#eml
% Initialize state transition matrix
A=fi([ 1 0 1 0 0 0;...
       0 1 0 1 0 0;...
       0 0 1 0 1 0;...
       0 0 0 1 0 1;...
       0 0 0 0 1 0;...
       0 0 0 0 0 1]);

% Measurement matrix
H = fi([ 1 0 0 0 0 0; 0 1 0 0 0 0 ]);
Q = fi(eye(6));
R = fi(1000 * eye(2));

% Initial conditions
persistent x_est p_est
if isempty(x_est)
    x_est = fi(zeros(6, 1), numerictype(z));
    p_est = sfi(zeros(6, 6), 32, 20);
end

% Predicted state and covariance
x_prd = A * x_est;
p_prd = A * p_est * A' + Q;

% Estimation
S = H * p_prd' * H' + R;
B = H * p_prd';
%klm_gain = (S \ B)';
klm_gain = compute_gain(S,B);

% Estimated state and covariance
x_est(:) = x_prd + klm_gain * (z - H * x_prd);
p_est(:) = p_prd - klm_gain * H * p_prd;

% Compute the estimated measurements
y = H * x_est;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function k=compute_gain(s,b)
s_inv=s;
eins=fi(1,numerictype(s));
s_inv(1,1)=divide(numerictype(s), eins,s(1,1));
s_inv(2,2)=divide(numerictype(s), eins,s(2,2));
k=(s_inv*b)';
end