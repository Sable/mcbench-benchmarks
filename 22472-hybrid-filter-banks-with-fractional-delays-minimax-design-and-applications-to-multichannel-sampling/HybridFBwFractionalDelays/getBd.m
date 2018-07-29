function Bd = getBd(phi, h, d)

% getBd: get the B-matrix as in equation (16) and Lemma 2
%
% Usage:    Bd = getBd(phi, h, d)
%
% INPUTS:
%       phi: a cell containing all the systems Phi_i(s)
%       h: the fast sampling interval
%       d: the vector of fractional delays
%
% OUTPUT:
%       Bd: matrix Bd as in equation (16)
%
% SEE ALSO: getAd, getCd

N = length(d);

% Compute for the block not containing Q0 and R0
BB = [];

for i = 1:N
    Ai = phi{i+1}{1};
    Bi = phi{i+1}{2};
    Ci = phi{i+1}{3};
    
    % Column i of BB
    BBi = [];
    
    % Concatenate Delta_ij to get row i
    for j = 1:N
        if ( i <= j)
            Aj = phi{j+1}{1};
            Bj = phi{j+1}{2};
            Cj = phi{j+1}{3};

            QQ = MVL(Ai, Bi, Aj, Bj, h);
            QR =   expm(d(j)*Aj) * MVL(Ai, Bi, Aj, Bj, h-d(j)) * Cj' ;
            RQ = ( expm(d(i)*Ai) * MVL(Aj, Bj, Ai, Bi, h-d(i)) * Ci' )' ;   % Transpose of QR above

            if (d(i) < d(j))
                RR = Ci * expm( (d(j)-d(i)) * Ai) * MVL(Ai, Bi, Aj, Bj, h-d(j)) * Cj' ;
            else
                RR = Ci * MVL(Ai, Bi, Aj, Bj, h-d(i)) * expm( (d(i)-d(j)) * Ai') * Cj' ;
            end

            BBij = [QQ, QR;
                    RQ, RR];

            BBi = [BBi BBij];        
        else
            Aj = phi{j+1}{1};
            Bj = phi{j+1}{2};
            Cj = phi{j+1}{3};            
            
            % position of this block BBij
            sc = size(BBi, 2) + 1;          % Starting column
            wc = size(Aj,1) + size(Cj,1);   % Number of column in this block
            sr = size(BB, 1) + 1;           % Starting row
            wr = size(Ai,1) + size(Ci,1);   % Number of row in this block
            
            % To save computation, we use Delta_ji'
            BBi = [BBi BB(sc:(sc+wc-1), sr:(sr+wr-1))'];
        end
    end
    
    BB = [BB; BBi];
end

% column 0 of BB, except the first block Q0*Q0'
BB0 = [];

A0 = phi{1}{1};
B0 = phi{1}{2};
C0 = phi{1}{3};

for i = 1:N
    Ai = phi{i+1}{1};
    Bi = phi{i+1}{2};
    Ci = phi{i+1}{3};    
    
    QQ = MVL(A0, B0, Ai, Bi, h);
    QR = expm(d(i)*Ai) * MVL(A0, B0, Ai, Bi, h-d(i)) * Ci' ;
    
    BB0 = [BB0 QQ QR];
end

QQ0 = MVL(A0, B0, A0, B0, h);

BB = [QQ0   BB0;
      BB0'  BB];

Bd = real(sqrtm(BB));   

