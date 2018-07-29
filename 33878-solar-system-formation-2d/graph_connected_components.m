function [labels rts] = graph_connected_components(C)
% C - connection matrix
% labels =[1 1 1 2 2 3 3 ...]  lenght(labels)=L, label for each vertex
% labels(i) is order number of connected component, i is vertex number
% rts - roots, numbers of started vertex in each component

L=size(C,1); % number of vertex

% Breadth-first search:
labels=zeros(1,L); % all vertex unexplored at the begining
rts=[];
ccc=0; % connected components counter
while true
    ind=find(labels==0);
    if ~isempty(ind)
        fue=ind(1); % first unexplored vertex
        rts=[rts fue];
        list=[fue];
        ccc=ccc+1;
        labels(fue)=ccc;
        while true
            list_new=[];
            for lc=1:length(list)
                p=list(lc); % point
                cp=find(C(p,:)); % points connected to p
                cp1=cp(labels(cp)==0); % get only unexplored vertecies
                labels(cp1)=ccc;
                list_new=[list_new cp1];
            end
            list=list_new;
            if isempty(list)
                break;
            end
        end
    else
        break;
    end
end