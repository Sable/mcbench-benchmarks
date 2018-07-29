% generate DQPSK symbols
% in: input MPSK symbols
% out: DPSK symbols
function out=dpsk(in)
N=length(in);

out(1)=1;
for t=2:N+1
    out(t)=out(t-1)*in(t-1);
end

end