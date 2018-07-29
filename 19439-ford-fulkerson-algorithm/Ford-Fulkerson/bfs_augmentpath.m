%WHITE =0;
%GRAY=1;
%BLACK=2

function augmentpath=bfs_augmentpath(start,target,current_flow,capacity,n)
    WHITE =0;
    GRAY=1;
    BLACK=2;
    color(1:n)=WHITE;
    head=1;
    tail=1;
    q=[];
    augmentpath=[];
    
    %ENQUEUE
    q=[start q];
    color(start)=GRAY;
    
    pred(start) = -1;
    
    pred=zeros(1,n);
    while ~isempty (q) 
    %    [u,q]=dequeue(q);
            u=q(end);
            q(end)=[];
            color(u)=BLACK;
    %     dequeue end here
            
            for v=1:n
                if (color(v)==WHITE && capacity(u,v)>current_flow(u,v) )
    %enqueue(v,q)
                    q=[v q];
                    color(v)=GRAY;
    % enqueue end here
                    pred(v)=u;                        

                end
            end
    end
    if color(target)==BLACK       %if target is accessible
       temp=target;
       while pred(temp)~=start
        augmentpath = [pred(temp) augmentpath];     %augment path doesnt containt the start point AND target point
        temp=pred(temp);
       end
       augmentpath=[start augmentpath target];
    else
        augmentpath=[];         % default resulte is empty
    end
    
        


