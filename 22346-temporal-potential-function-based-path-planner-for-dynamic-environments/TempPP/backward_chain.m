function vn = backward_chain(w,tr,tc,la)
%
%Backward chain from goal of given world to find the initial states that
%are reachable
%
t.r = tr;
t.c = tc;
t.l = la;
q = qu_new;% start node queue
q = qu_enqu(q,t);% enqueue goal
v(1:size(w,1),1:size(w,2),1:la) = 0;
while qu_empty(q) ~= 1
    cu = qu_front(q);
    q = qu_dequ(q);% dequeue goal
    if (w(cu.r,cu.c,cu.l) ~= 1)&&(cu.l~=1)% check if obstacle or initial state
        if v(cu.r,cu.c,cu.l-1) ~= 1
            t.r = cu.r;
            t.c = cu.c;
            t.l = cu.l - 1;
            q = qu_enqu(q,t); % enqueue descendant
            v(cu.r,cu.c,cu.l-1) = 1;% mark descendant as visited
        end
        if (cu.r > 1)&&(v(cu.r-1,cu.c,cu.l-1) ~= 1)
            t.r = cu.r - 1;
            t.c = cu.c;
            t.l = cu.l - 1;
            q = qu_enqu(q,t);
            v(cu.r-1,cu.c,cu.l-1) = 1;
        end
        if (cu.c > 1)&&(v(cu.r,cu.c-1,cu.l-1) ~= 1)
            t.r = cu.r;
            t.c = cu.c - 1;
            t.l = cu.l - 1;
            q = qu_enqu(q,t);
            v(cu.r,cu.c-1,cu.l-1) = 1;
        end
        if (cu.r < size(w,1))&&(v(cu.r+1,cu.c,cu.l-1) ~= 1)
            t.r = cu.r + 1;
            t.c = cu.c;
            t.l = cu.l - 1;
            q = qu_enqu(q,t);
            v(cu.r+1,cu.c,cu.l-1) = 1;
        end
        if (cu.c < size(w,2))&&(v(cu.r,cu.c+1,cu.l-1) ~= 1)
            t.r = cu.r;
            t.c = cu.c + 1;
            t.l = cu.l - 1;
            q = qu_enqu(q,t);
            v(cu.r,cu.c+1,cu.l-1) = 1;
        end
    end    
end
q = qu_free(q);% free queue space
vn = v; % return values
end