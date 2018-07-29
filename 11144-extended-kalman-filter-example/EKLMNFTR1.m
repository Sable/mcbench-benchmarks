function [YY,XX] = EKLMNFTR1(Ap,Xint_v,Uk,Qu,Vk,Qv,C,n,Wk,W,V);

Ap(2,:) = 0;

for ii = 1:1:length(Ap)-1
    Ap(ii+1,ii) = 1;
end

inx = 1;
UUk = [Uk(inx); 0; 0; 0; 0];
PPk = (Xint_v*Xint_v');
VVk = [Vk(inx); 0; 0; 0; 0];
Qv = V*V';

for ii = 1:1:length(Xint_v)

XKk(ii,1) = Xint_v(ii)^2;                                             % FIRST STEP

end

PPk = Ap*PPk*Ap';                                                   % SECOND STEP

Kk = PPk*C'*inv( (C*PPk*C') + (V*Qv*V') );                          % THIRD STEP

for ii = 1:1:length(Xint_v)

XUPK(ii,1) = XKk(ii)^2 + UUk(ii);                                     % UPPER EQUATIONS.

Zk(ii,1) = cos(XUPK(ii)) +  VVk(ii);                                  % UPPER EQUATIONS.

end

for ii = 1:1:length(XKk)

XBARk(ii,1) = XKk(ii) + Kk(ii)*(Zk(ii) - (cos(XKk(ii)))) ;            % FOURTH STEP

end

II = eye(5,5);

Pk = ( II -  Kk*C)*PPk;                                             % FIFTH STEP

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

for ii = 1:1:n

UUk = [Uk(ii+1); 0; 0; 0; 0];
PPk = XBARk*XBARk';
VVk = [Vk(ii+1); 0; 0; 0; 0];

XKk = exp(-XBARk);                                                % FIRST STEP

PPkM = Ap*PPk*Ap';                                                 % SECOND STEP

Kk = PPkM*C'*inv( (C*PPkM*C') + (V*Qv*V') );                      % THIRD STEP

for nn = 1:1:length(XBARk)

XUPK(nn) = exp(-XKk(nn)) + UUk(nn);                              % UPPER EQUATIONS.

Zk(nn) = cos(XUPK(nn)) +  VVk(nn);                               % UPPER EQUATIONS.

end

for in = 1:1:length(XUPK)

XNEW(in) = XBARk(in) + Kk(in)*(Zk(in) - cos(XBARk(in)));           % FOURTH STEP

end

II = eye(5,5);

Pk = (II -  Kk*C)*PPkM;                                            % FIFTH STEP

XBARk = XNEW;

OUTX(ii) = XBARk(1,1);
OUTY(ii) = Zk(1,1);

end

YY = OUTY;
XX = OUTX;

