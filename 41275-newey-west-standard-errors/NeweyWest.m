function nwse = NeweyWest(e,X,L)
% PURPOSE: computes Newey-West adjusted heteroscedastic-serial
%          consistent standard errors
%---------------------------------------------------
% where: e = T x 1 vector of model residuals
%        X = T x k matrix of independant variables
%        L = lag length to use (Default: Newey-West(1994) plug-in
%        procedure)
%
%        se = Newey-West standard errors
%---------------------------------------------------

indexxx = sum(isnan(X),2)==0;
X = X(indexxx,:);
e = e(indexxx,:);

[N,k] = size(X);
if k > 1
    k = k+1;
    X = [ones(N,1),X];
    
else
    X = ones(N,1);
    
end

if nargin < 3
% Newey-West (1994) plug-in procedure
L = floor(4*((N/100)^(2/9)));
end


Q = 0;
for l = 0:L
    w_l = 1-l/(L+1);
    for t = l+1:N
        if (l==0)   % This calculates the S_0 portion
            Q = Q  + e(t) ^2 * X(t, :)' * X(t,:);
        else        % This calculates the off-diagonal terms
            Q = Q + w_l * e(t) * e(t-l)* ...
                (X(t, :)' * X(t-l,:) + X(t-l, :)' * X(t,:));
        end
    end
end
Q = (1/(N-k)) .*Q;

nwse = sqrt(diag(N.*((X'*X)\Q/(X'*X))));

end
