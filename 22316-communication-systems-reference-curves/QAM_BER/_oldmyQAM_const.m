function const_pts = rectQAM_const(M)
% 

% M-PAM bit/symbol ordering
[bo so] = PAM_Gray_Code;

k = log2(M);
I = 2^ceil(k/2);
Q = 2^floor(k/2);

% Produce PAM constellation points for in-phase and quadrature
I_t = -(I-1):2:I-1;
Q_t = Q-1:-2:-(Q-1);

% Re-order based on the PAM Gray mapping
for i=1:length(I_t)
    I_pts(so{log2(I)}(i)+1) = I_t(i);
end
for i=1:length(Q_t)
    Q_pts(so{log2(Q)}(i)+1) = Q_t(i);
end

for i=0:M-1
    MSBs = floor(i/I);
    LSBs = i-MSBs*I;
    QAM_I(i+1) = I_pts(LSBs+1);
    QAM_Q(i+1) = Q_pts(MSBs+1);
end

const_pts=complex(QAM_I,QAM_Q);