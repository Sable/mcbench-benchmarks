function Gama = wilson (V,mwk,T,x,R)
% Wilson algorithm for activity coefficient calculation
%
%     Gama = wilson (V,mwk,T,x)
%         mwk - matrix of wilson constants (Ni x Ni x 2)
%               (:,:,1) = coefficient A
%               (:,:,2) = coefficient B (if not defined, itself set to zero)
%         T   - temperature [K]
%         V   - molar volumes
%         x   - molar fractions
%         R   - gas constant
%
%         Gama - activity coefficients

x    = x(:);
Ni   = length(V); %numver of compounds
bL   = zeros(Ni,Ni);
Gama = zeros(1,Ni);

if ndims(mwk) == 3
    koef = mwk(:,:,1) + mwk(:,:,2)*T;
else
    koef = mwk;
end

%cycle for big lambda computation
for i=1:1:Ni
    for j=1:1:Ni
        if i == j
            bL(i,j) = 1;
        else
            bL(i,j) = (V(j)/V(i)) * exp( -koef(i,j)/R/T );
        end
    end
end

for i=1:1:Ni
    clen = 0;
    for k=1:1:Ni
        clen = clen + x(k)*bL(k,i) / (bL(k,:)*x);
    end
    Gama(i) = exp( -log( bL(i,:)*x ) +1 -clen );
end
