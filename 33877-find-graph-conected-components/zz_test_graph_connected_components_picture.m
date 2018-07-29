% triangle and square:
C=false(7,7);

% triangle
C(1,2)=true;
C(1,3)=true;
C(2,3)=true;

% square:
C(4,5)=true;
C(4,7)=true;
C(5,6)=true;
C(6,7)=true;

% coordinaties to show:
r=[0 1 2     2 3 3 2
   0 1 0     2 2 3 3];

% make C symmetricle:
for c1=1:7-1
    for c2=c1+1:7
        C(c2,c1)=C(c1,c2);
    end
end

[labels rts] = graph_connected_components(C);

% plot adges:
for n1=1:6
    for n2=n1+1:7
        if C(n1,n2)
            plot([r(1,n1) r(1,n2)],[r(2,n1) r(2,n2)],'k-');
            hold on
        end
    end
end

% plot vertecies with diferent color:
for c=1:max(labels)
    ind=find(labels==c);
    plot(r(1,ind),r(2,ind),'o','color',0.8*rand(1,3));
    hold on;
end

axis equal;