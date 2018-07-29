function y=addpilot4(x)
%produce pilotsignal at the first antenna
K=64;
for k=1:64
    pilotsignal(k)=exp(-i*3*2*pi*(k-1)/K);
end
pilotsignal=pilotsignal.';
y=[x;pilotsignal];