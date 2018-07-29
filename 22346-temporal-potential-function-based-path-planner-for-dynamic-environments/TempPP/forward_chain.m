function res = forward_chain(rows,cols,obs,goal,start,proplimit)
%
%forward chain to find shallowest goal
%
w = extend_world(rows,cols,obs,goal,proplimit);
t.r = start.r;
t.c = start.c;
t.l = 1;
q = qu_new;
q = qu_enqu(q,t);%initalize queue with start state
v(1:rows,1:cols,1:proplimit) = 0;
while qu_empty(q) ~= 1
    cu = qu_front(q);
    q = qu_dequ(q);%dequeue node
    v(cu.r,cu.c,cu.l) = 1;%mark node visited
    %if node is goal return depth
    if w(cu.r,cu.c,cu.l) == 0
        res = cu.l;
        q = qu_free(q); 
        clear q;
        return;
    end
    %if chaining has reached propogation limit return reload
    if cu.l == size(w,3)
        res = -1;
        q = qu_free(q); 
        clear q;
        return;
    end
    %enqueue non-obstacle sucessor nodes that have not been visited yet
    if w(cu.r,cu.c,cu.l) ~= 1 
        if v(cu.r,cu.c,cu.l+1) ~= 1
            t.r = cu.r;
            t.c = cu.c;
            t.l = cu.l + 1;
            q = qu_enqu(q,t);
            v(cu.r,cu.c,cu.l+1) = 1;
        end
        if (cu.r > 1)&&(v(cu.r-1,cu.c,cu.l+1) ~= 1)
            t.r = cu.r - 1;
            t.c = cu.c;
            t.l = cu.l + 1;
            q = qu_enqu(q,t);
            v(cu.r-1,cu.c,cu.l+1) = 1;
        end
        if (cu.c > 1)&&(v(cu.r,cu.c-1,cu.l+1) ~= 1)
            t.r = cu.r;
            t.c = cu.c - 1;
            t.l = cu.l + 1;
            q = qu_enqu(q,t);
            v(cu.r,cu.c-1,cu.l+1) = 1;
        end
        if (cu.r < size(w,1))&&(v(cu.r+1,cu.c,cu.l+1) ~= 1)
            t.r = cu.r + 1;
            t.c = cu.c;
            t.l = cu.l + 1;
            q = qu_enqu(q,t);
            v(cu.r+1,cu.c,cu.l+1) = 1;
        end
        if (cu.c < size(w,2))&&(v(cu.r,cu.c+1,cu.l+1) ~= 1)
            t.r = cu.r;
            t.c = cu.c + 1;
            t.l = cu.l + 1;
            q = qu_enqu(q,t);
            v(cu.r,cu.c+1,cu.l+1) = 1;
        end
    end    
end
%return reload if queue empty.
res = -1;
q = qu_free(q); 
clear q;
end