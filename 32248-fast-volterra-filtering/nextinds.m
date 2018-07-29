function inds=nextinds(inds,M)

n = length(inds);

for vc=1:n
    if inds(vc) < M-1
        inds(vc) = inds(vc)+1;
        inds(1:vc-1) = inds(vc);
        break;
    else
        if vc == n
            inds = [];
%             weight = 0;
            return;
        end;
    end;
end;

% dfs = diff(fliplr(inds))>0;
% dfs = cumsum([0 dfs]);
% count = (1:n)-dfs;
% if inds(n) == 0
%     count(1) = count(1)+1;
% end;
% facs = prod(factorial(count));
% weight = factorial(n+1)/facs;