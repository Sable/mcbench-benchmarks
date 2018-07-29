function [R]=codd(H)
%these function clear one by one array of a vector between stat and end
%these function give array with odd indices
q=1;
for g=1:length(H)
    if even(g)==0
        R(1,q)=H(1,g);
        q=q+1;
    end
end
        
