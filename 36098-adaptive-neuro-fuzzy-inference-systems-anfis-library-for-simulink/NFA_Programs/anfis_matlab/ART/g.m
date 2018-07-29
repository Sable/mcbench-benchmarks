function y = g(s,gamma);

rows = size(s,1);
columns = size(s,2);
y = zeros(rows,columns);
for i=1:rows
   for j=1:columns
        if s(i,j).*gamma>1
            y(i,j) = 1;
        elseif 0 <= s(i,j).*gamma && s(i,j).*gamma <= 1
            y(i,j) = s(i,j).*gamma;
        elseif s(i,j).*gamma<0
            y(i,j) = 0;
        end
    end
end

return 