%% Zero Padding Function
% Input data is the sequence s, Target length N
% output:
% zs :zero padded signal
% nozs = number of zeros
% [nozs zs] = zpp(s, N)
% 22/04/2011
function [nozs zs]=zpp(s, N)
L=length(s);
sz=zeros(N,1);
nozs=N-L;
sz(1:L/2)=s(1:L/2);

sz(end-L/2+1:end)=s(end-L/2+1:end);
zs=sz;


