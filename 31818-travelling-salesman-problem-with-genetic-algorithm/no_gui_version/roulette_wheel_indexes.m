function ii=roulette_wheel_indexes(m,prn)
% return indxess ii 
% length(ii)=m
% ii(t) some from 1...n
% prn - probabilities normalized



cpr=cumsum(prn);

n=length(prn);

% i1=interp1([0 cpr'],1:psz,rand(1,npcr),'linear');
% ii=floor(i1); % random numbers from 1:psz-1 according probabilities

% make cpr - row-vector if neccessary:
sz=size(cpr);
if sz(1)>sz(2)
    cpr1=cpr';
else
    cpr1=cpr;
end

i1=interp1([0 cpr1],1:(n+1),rand(1,m),'linear');
ii=floor(i1); % random numbers from 1:n according probabilities