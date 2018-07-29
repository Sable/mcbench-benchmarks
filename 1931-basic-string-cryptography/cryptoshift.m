function out = cryptoshift(in,shift)

numbers = double(lower(in))-96;
codednumbers = zeros(1,length(numbers));
for i = 1:length(numbers);
    if numbers(i) >= 1 & numbers(i) <= 26
        codednumbers(i) = mod(numbers(i)+shift-1,26)+1;
    else
        codednumbers(i) = numbers(i);
    end
end

out = char(codednumbers+96);