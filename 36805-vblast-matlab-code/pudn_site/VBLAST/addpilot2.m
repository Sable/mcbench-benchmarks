function y=addpilot2(x)
%produce pilotsignal at the first antenna
K=64;
for k=1:64
    pilotsignal(k)=exp(-i*1*2*pi*(k-1)/K);
end
pilotsignal=pilotsignal.';
y=[x;pilotsignal];