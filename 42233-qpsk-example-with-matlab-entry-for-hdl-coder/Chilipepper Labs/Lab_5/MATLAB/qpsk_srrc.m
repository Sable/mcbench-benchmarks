function [d_out] = qpsk_srrc(d_in)

persistent buf

OS_RATE = 8;
f = SRRC;

if isempty(buf)
    buf = complex(zeros(1,OS_RATE*2+1),zeros(1,OS_RATE*2+1));
end

buf = [buf(2:end) d_in]; 

d_out = buf*f;