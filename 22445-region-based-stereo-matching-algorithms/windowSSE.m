function [ErrorEnergy]=windowSSE(Imr,Iml,windowSize,d)
% This function calcultes error energy for a window in rectancle defined by
%the vector windowSize.
% Imr: Right image RGB array
% Iml: Left image RGB array
% windowSize: [sizeRow sizeCol]
% d: disparity

[m n p]=size(Imr);
Rw=floor(windowSize(1)/2);
Cw=floor(windowSize(2)/2);

for j=Cw+1+d:n-Cw
    for i=Rw+1:m-Rw
        top=0;
        for k=i-Rw:i+Rw
            for l=j-Cw:j+Cw
                top=top+(Iml(k,l,1)-Imr(k,l-d,1))^2+(Iml(k,l,2)-Imr(k,l-d,2))^2+(Iml(k,l,3)-Imr(k,l-d,3))^2;  
            end
        end
        ErrorEnergy(k,l-d)=(top/(windowSize(1)*windowSize(2)));
    end
end