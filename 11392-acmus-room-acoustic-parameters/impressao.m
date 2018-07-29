%% impressao.m
%%
%% [IACC] = impressao(ir_dir,ir_esq,t1,t2,Fs)
%%
%% Evaluates the "interaural cross correlation" (iacc) of a binaural
%% impulse response.
%% The inputs are the right ear impulse response (ir_dir), left ear impulse
%% response (ir_esq) and its sampling frequency Fs. t1 is the integration 
%% lower bound and t2 the integration upper bound.
%% The output is the IACC level.

function [IACC] = impressao(ir_dir,ir_esq,t1,t2,Fs)
ir_dir = ir_dir(:);
ir_esq = ir_esq(:);

i1 = floor(t1*Fs)+1;
i2 = floor(t2*Fs)+1;

if i1 >= i2
    error('O limite de integração i1 deve ser menor que i2')
end

if i2 < length(ir_dir)
    ir_dir = ir_dir(i1:i2);
else
    ir_dir = ir_dir(i1:end);
end

if i2 < length(ir_esq)
    ir_esq = ir_esq(i1:i2);
else
    ir_esq = ir_esq(i1:end);
end

p_dir = ir_dir.^2;
p_esq = ir_esq.^2;
D = (sum(p_dir)-(p_dir(1)+p_dir(end))/2)/Fs;
E = (sum(p_esq)-(p_dir(1)+p_esq(end))/2)/Fs;

%% Cálculo da correlaçao cruzada => X = xcorr(ir_dir,ir_esq); ou:
i = ceil(1e-3*Fs);
ir_dir_lag = [zeros(i,1); ir_dir; zeros(i,1)];
l = i2-i1;

for k = -i:i
    p = ir_esq.*ir_dir_lag(k+i+1:k+i+l+1);
    IACF(k+i+1) = (sum(p)-(p(1)+p(end))/2)/Fs;
end

IACC = max(IACF/sqrt(D*E));
