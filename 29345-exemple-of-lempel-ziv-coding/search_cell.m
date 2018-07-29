function j=search_cell(A,s)
%Search a var "s" into cell array "A"
%Return 0 if they aren't equal. The index into the array if they are equal.


j=0;

for i=1:length(A)                   %For each cell
    if length(A{i})==length(s)      %check the lengths
        if A{i}==s                  %check data
            j=i;
            return
        end
    end
end