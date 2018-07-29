function [coded,key] = cryptosubcode(in)

[notused,key] = sort(rand(1,26));

numbers = double(lower(in)-96);
codednumbers = zeros(1,length(numbers));
for i = 1:length(numbers)
    if numbers(i) >= 1 & numbers(i) <= 26
        codednumbers(i) = key(numbers(i));
    else
        codednumbers(i) = numbers(i);
    end
end

coded = char(codednumbers+96);

