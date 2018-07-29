function [shortpath,flag]=ShortDist(S,D,Adj_Mat)
%Djikstra Algorithm for Shortest Distance
n=size(Adj_Mat,1);
Q(1:n) = 0;
dist(1:n) = inf;
pred(1:n) = 0;

dist(S)=0;
while sum(Q)~=n
    dis=[];
    for i=1:n
        if Q(i)==0
            dis=[dis dist(i)];
        else
            dis=[dis inf];
        end
    end
    [minu u]=min(dis);
    Q(u)=1;
    for v=1:n
        if u==v, continue; end
        if Adj_Mat(u,v)~=0,
            if dist(v)-dist(u)>Adj_Mat(u,v),
                dist(v)=dist(u)+Adj_Mat(u,v);
                pred(v)=u;
            end
        end
    end
end

shortpath = D;
while shortpath(1) ~= S
    if pred(shortpath(1))<=n
        shortpath=[pred(shortpath(1)) shortpath];
    end
end

flag=1;
if dist(D)==1e5, flag=0; end
% S,D,dist(D),shortpath