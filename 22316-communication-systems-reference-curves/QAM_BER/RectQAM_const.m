function const_pts = RectQAM_const(M)
%RectQAM_const Rectangular QAM Constellation points with Gray mapping.
%   C = rectQAM_const(M) returns the M-ary rectangular QAM constellation
%   points for M = 2^k, where k=2,3,...,10.
%
%   For more information, see
%   [1] Cho, K., and Yoon, D., "On the general BER expression of one- and
%        two-dimensional amplitude modulations", IEEE Trans. Commun.,
%        Vol. 50, Number 7, pp. 1074-1080, 2002.
%
%   See also PAM_Gray_Code, QAMMOD.

%   Written by Idin Motedayen-Aval
%   Applications Engineer
%   The MathWorks, Inc.
%   zq=[4 2 5 -15 -1 -3 24 -57 45 -12 19 -12 15 -8 3 -7 8 -69 53 12 -2];
%   char(filter(1,[1,-1],[105 zq])), clear zq


% This function constructs the rectangular QAM constellations by
% doing two PAM modulations: one for the in-phase and one for the
% quadrature dimension (see [1] for more details).

% M-PAM bit/symbol ordering
[bo so] = PAM_Gray_Code;

k = log2(M);
I = 2^ceil(k/2);
Q = 2^floor(k/2);

% Produce PAM constellation points for in-phase and quadrature
I_t = -(I-1):2:I-1;
Q_t = Q-1:-2:-(Q-1);

% Re-order based on the PAM Gray mapping
I_pts = zeros(size(I_t)); % pre-allocate
Q_pts = zeros(size(Q_t)); % pre-allocate
for i=1:length(I_t)
    I_pts(so{log2(I)}(i)+1) = I_t(i);
end
for i=1:length(Q_t)
    Q_pts(so{log2(Q)}(i)+1) = Q_t(i);
end

% Map the symbols 0:M-1 to constellation points
QAM_I=zeros(1,M); % pre-allocate
QAM_Q=zeros(1,M);
for i=0:M-1
    MSBs = floor(i/I);
    LSBs = i-MSBs*I;
    QAM_I(i+1) = I_pts(LSBs+1);
    QAM_Q(i+1) = Q_pts(MSBs+1);
end

const_pts=complex(QAM_I,QAM_Q);