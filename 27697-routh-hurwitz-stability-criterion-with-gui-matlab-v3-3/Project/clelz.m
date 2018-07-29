function [W]=clelz(D)
%these function clear low zero from a vector array
for p=length(D):-1:1
    if D(p)~=0
        break;
    end
    D(p)=[];
end
W=D;