function [Af, Bf, Cf, Df, gamma] = lmi_opt(sys, M, n)

% LMI_OPT: Linear Matrix Inequality Optimization, used in the design of FIR
% filters F_i(z), as described in Section IV.B.
%
% Usage:    [Af, Bf, Cf, Df, gamma] = lmi_opt(sys, M, n)
%
% INPUTS:
%   sys: input system
%   M:   superresolution factor (integer)
%   n:   integer such that nM is the maximum length if FIR filters F_i(z)
%
% OUTPUTS:
%   Af, Bf, Cf, Df: state space matrices of system F
%   gamma: H infinity norm of the induced error system K
%
% See also: designFIR, getH, getW, getF

An = [zeros(1,n);   eye(n-1), zeros(n-1,1)];
Bn = [1; zeros(n-1, 1)];

Af = An;
Bf = Bn;

for i = 1:(M-1)
    Af = blkdiag(Af, An);
    Bf = blkdiag(Bf, Bn);
end

[Aw, Bw, Cw, Dw] = getW(sys, M);
[Ah, Bh, Ch, Dh] = getH(sys, M);

A = [   Aw,         zeros( size(Aw,1), size(Ah,2) + size(Af,2))  ;
        zeros( size(Ah,1), size(Aw,2) ),    Ah,     zeros(size(Ah,1), size(Af,2)) ;
        zeros( size(Af,1), size(Aw,2) ),     Bf*Ch,      Af];   
  
B = [Bw;    Bh;     Bf*Dh];

% C + Cf * Cc + Df * Dc is the C-matrix of system K, see (28)
C  = [Cw,    zeros( size(Cw,1), size(Ah,2)+size(Af,2) ) ];
Cc = [zeros( size(Af,2), size(Aw,2)+size(Ah,2) ),   - eye(size(Af,2))];
Dc = [zeros( size(Ch,1), size(Aw,2) ),  -Ch,    zeros( size(Ch,1), size(Af,2) )];

% D + Df*Dd is the D-matrix of system K in (28)
D  = [Dw,    zeros( size(Dw,1), size(Bh,2) )];
Dd = [ zeros( size(Dh,1), size(Dw,2) ),     -Dh];

% Describe the LMI 
eps = 0.001;
gmin = 0;
gmax = 0.25;
gamma = (gmax + gmin) / 2;
tmin = 1;

while ( (gmax - gmin > eps) || (tmin > 0) )
    % Set up the LMI
    setlmis([]) ;
    p  = lmivar(1, [size(A,1) 1]);
    cf = lmivar(2, [M  size(Af,2)]);
    df = lmivar(2, [M, size(Ch,1)]);

    % Specify entries of the LMI
    lmiterm([1 1 1 p],A',A);        % A'*P*A at block (1,1)
    lmiterm([1 1 1 p],-1,1);        % -P at block (1,1)
    
    lmiterm([1 1 2 p],A',B);        % A'*P*B at block (1,2)

    lmiterm([1 1 3 0], C');         % C' at block (1,3)
    lmiterm([1 1 3 -cf], Cc', 1);   % (Cf * Cc)' at block (1,3)
    lmiterm([1 1 3 -df], Dc', 1);   % (Df * Dc)' at block (1,3)

    lmiterm([1 2 2 p], B', B);      % B'*P*B at block (2,2)
    lmiterm([1 2 2 0], -gamma);     % -gamma * I at block (2,2)

    lmiterm([1 2 3 0], D');         % D' at block (2,3)
    lmiterm([1 1 3 -df], Dd', 1);   % (Df * Dd)' at block (2,3)

    lmiterm([1 3 3 0], -gamma);     % -gamma * I at block (3,3)

    % This is to make sure P > 0
    lmiterm([-2 1 1 p], 1, 1);      
    % lmiterm([-2 1 1 0], -eps);

    lmisys = getlmis;
    % lmiinfo(lmisys)

    [tmin, xfeas] = feasp(lmisys);
    
    if (tmin < 0)       % The LMI is feasible
        gmax = gamma;
        gamma = (gmax + gmin) / 2;
    else                % The LMI is not feasible
        gmin = gamma;
        gamma = (gmax + gmin) / 2;
    end
    
end

P = dec2mat(lmisys, xfeas, p);
Cf = dec2mat(lmisys, xfeas, cf);
% Df = zeros( size(Cf,1), size(Bf,2));
Df = dec2mat(lmisys, xfeas, df);


