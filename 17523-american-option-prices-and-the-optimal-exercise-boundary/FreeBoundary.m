function Sf = FreeBoundary(S,t,V,K,type)

Sf = zeros(1,length(t));
eps_star = K*1e-5;

switch type
    case 'put'
        for j = 1:length(t)
            Sf(j) = S(find(abs(V(:,j)-K+S)< eps_star, 1, 'last'));
        end
    case 'call'
        for j = 1:length(t)
            Sf(j) = S(find(abs(V(:,j)+K-S)< eps_star, 1, 'first'));
        end
end

