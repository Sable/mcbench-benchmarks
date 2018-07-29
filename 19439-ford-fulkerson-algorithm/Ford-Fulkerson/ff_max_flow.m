function max_flow=ff_max_flow(source,sink,capacity,nodes_number)

current_flow=zeros(nodes_number,nodes_number);
max_flow=0;
augmentpath = bfs_augmentpath(source,sink,current_flow,capacity,nodes_number);
%bfs_augmentpath(2,6,current_flow,capacity,6)
while ~isempty(augmentpath)
    % if there exits a augment path, update teh current_flow    
    increment = inf;
    for i=1:length(augmentpath)-1
        increment=min(increment, capacity(augmentpath(i),augmentpath(i+1))-current_flow(augmentpath(i),augmentpath(i+1)));
    end
    %now increase the current_flow
    for i=1:length(augmentpath)-1
        current_flow(augmentpath(i),augmentpath(i+1))=current_flow(augmentpath(i),augmentpath(i+1))+increment;
        current_flow(augmentpath(i+1),augmentpath(i))=current_flow(augmentpath(i+1),augmentpath(i))-increment;
    end
    max_flow=max_flow+increment;
    augmentpath = bfs_augmentpath(source,sink,current_flow,capacity,nodes_number);% try to find new augment path    

end
