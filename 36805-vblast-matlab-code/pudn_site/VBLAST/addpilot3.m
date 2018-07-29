function y=addpilot3(x)
%produce pilotsignal at the first antenna
K=64;
for k=1:64
    pilotsignal(k)=exp(-i*2*pi*2*(k-1)/K);
end
pilotsignal=pilotsignal.';
y=[x;pilotsignal];