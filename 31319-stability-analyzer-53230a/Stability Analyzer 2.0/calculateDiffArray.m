function Zd = calculateDiffArray(Z)
%creates an array of difference values from array Z. the difference array
%is Zd1 = Z2 - Z1 ..... = Zi+1 - Zi. Zd count will be one less than Z
%returns difference array Zd

N = length(Z); %get array count
Zd = zeros(1,(N-1)); %allocate difference array

for i = 1:(N-1)
    Zd(i) = Z(i+1) - Z(i);
end