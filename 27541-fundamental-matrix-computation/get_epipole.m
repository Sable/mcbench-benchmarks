%% function [e,eprime] = get_epipole(F)
function [e,eprime]= get_epipole(F)
[u,s,v] = svd(F);
e = v(:,end); % it's the right null vector of F_0
eprime = u(:,end);
end