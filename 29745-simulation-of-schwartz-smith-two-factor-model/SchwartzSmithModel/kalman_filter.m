function [y_cond,v,a,a_cond,P,P_cond,F,logl] = ...
                kalman_filter(y,Z,d,T,c,R,a0,P0,H,Q,timevar)
% Kalman_filter.m
% implements the Kalman filter for time invariant and time variant version
% follows the Gauss implementation of Thierry Roncalli.

nobs = size(y,1); % rows
n    = size(y,2); % cols
at   = a0; 
at_1 = a0; 
Pt   = P0; 
Pt_1 = P0; 
logl = zeros(nobs,1);

if timevar == 1
    m=size(Z,2)/n; 
    g=size(R,2)/m;
else
    m=size(Z,2); 
    g=size(R,2);
end

% placeholders
y_cond = zeros(nobs,n); 
v      = zeros(nobs,n); 
a_cond = zeros(nobs,m);
a      = zeros(nobs,m); 
P_cond = zeros(nobs,m*m); 
P      = zeros(nobs,m*m);
F      = zeros(nobs,n*n);

if timevar ~= 1 % constant matrices
    Zt=Z;
    dt=d;
    Ht=H;
    Tt=T;
    ct=c;
    Rt=R;
    Qt=Q;
end

for i=1:nobs

    yt=y(i,:)';                         % y(t) 

    if timevar == 1
      Zt=reshape(Z(i,:),n,m);           % Z(t) 
      dt=d(i,:)';                       % d(t) 
      Ht=reshape(H(i,:),n,n);           % H(t) 
      Tt=reshape(T(i,:),m,m);           % T(t) 
      ct=c(i,:)';                       % c(t) 
      Rt=reshape(R(i,:),m,g);           % R(t) 
      Qt=reshape(Q(i,:),g,g);           % Q(t) 
    end

    % Prediction Equations 

    at_1 = Tt*at + ct ;                  % a(t|t-1) formula(3.2.2a) 
    Pt_1 = Tt*Pt*Tt' + Rt*Qt*Rt';        % P(t|t-1) formula(3.2.2b) 

    % Innovations 

    yt_1 = Zt*at_1 + dt ;                % y(t|t-1) formula(3.2.18) 
    vt = yt-yt_1;                        % v(t)     formula(3.2.19) 

    % Updating Equations 

    Ft = Zt*Pt_1*Zt' + Ht;               % F(t)     formula(3.2.3c) 
    
    inv_Ft = Ft\eye(size(Ft,1));         % Inversion de Ft           
%    [s,f] = warning;
    
%     erreur=scalerr(inv_Ft);
%     if erreur;
%       if Ft == zeros(n,n);
%         inv_Ft = Ft;
%       else;
%         inv_Ft = pinv(Ft);               % Moore-Penrose Pseudo-inverse 
%       end;
%     end;

    at = at_1 + Pt_1*Zt'*inv_Ft*vt ;      % a(t)     formula(3.2.3a)   
    Pt = Pt_1 - Pt_1*Zt'*inv_Ft*Zt*Pt_1 ; % P(t)     formula(3.2.3b)   

    % Save results

    y_cond(i,:) = yt_1';
    v(i,:)      = vt';
    a(i,:)      = at';
    a_cond(i,:) = at_1';
    P(i,:)      = vecr(Pt)';
    P_cond(i,:) = vecr(Pt_1)';
    F(i,:)      = vecr(Ft)';
    
%     fprintf('y_cond(i,:) %12.4f\n',y_cond(i,:));
%     fprintf('v(i,:) %12.4f\n',v(i,:));
%     fprintf('a(i,:) %12.4f\n',a(i,:));
%     fprintf('a_cond(i,:) %12.4f\n',a_cond(i,:));
%     fprintf('P(i,:) %12.4f\n',P(i,:));
%     fprintf('P_cond(i,:) %12.4f\n',P_cond(i,:));
%     fprintf('F(i,:) %12.4f\n',F(i,:));

    % Likelihood   

    dFt=det(Ft);
    if dFt<=0
        dFt=1e-10;
    end
    logl(i)=-(n/2)*log(2*pi)-0.5*log(dFt)-0.5*vt'*inv_Ft*vt;
    
end
