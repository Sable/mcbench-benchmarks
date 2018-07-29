function diff = gfdiff(polynomial)

%use: diff = gfdiff(polynomial)
%Differentiate polynomial with respect to x
l = length(polynomial);

if l == 1
    diff = -inf;
else
    for cc = 2:l
        %cc-1 represents the power of x
        if mod(cc-1,2) == 0 %all the even powers are zero because of GF(2)
            diff(cc-1) = -Inf; 
        else
            diff(cc-1) = polynomial(cc);
        end
    end
end