function [success path] = traverse_world(start,pot)
%
% traverse world
%
res(size(pot,1),size(pot,2))=0;
t = 1;
nr = start.r;
nc = start.c;
res(nr,nc,t)=1;
while((t<size(pot,3))&&(pot(nr,nc,t)~=0)&&(pot(nr,nc,t)~=1))
    if(nr ~= 1)
        n = pot(nr-1,nc,t+1);
    else
        n = Inf;
    end
    if(nc ~= size(pot,2))
        e = pot(nr,nc+1,t+1);
    else
        e = Inf;
    end
    if(nr ~= size(pot,1))
        s = pot(nr+1,nc,t+1);
    else
        s = Inf;
    end
    if(nc ~= 1)
        w = pot(nr,nc-1,t+1);
    else
        w = Inf;
    end
    st = pot(nr,nc,t+1);
    minv = min([n,e,s,w,st]);
    if (minv == st)
        %do nothing
    elseif((minv == n)&&(nr ~= 1))
        nr = nr - 1;
    elseif((minv == e)&&(nc ~= 10))
        nc = nc + 1;
    elseif((minv == s)&&(nr ~= 10))
        nr = nr + 1;
    elseif((minv == w)&&(nc ~= 1))
        nc = nc - 1;
    end
    t = t + 1;
    res(nr,nc,t)=1;
end
if(pot(nr,nc,t)==0)
    success = 1; %if goal reached
else
    success = 0; %if goal no longer reachable
end
path = res;
end