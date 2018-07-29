function show_path(world,path)
%
% Display the path to the user
%
i=1;
for t = 1:size(path,3)
    for r = 1:size(world,1)
        for c = 1:size(world,2)
            if world(r,c,t)==1
                ox(i)=r;
                oy(i)=c;
                oz(i)=t;
                i = i + 1;
            end
        end
    end
end
plot3(ox,oy,oz,'MarkerSize',30,'Marker','.','LineStyle','none','Color',[1 0 0])
grid
hold on
i=1;
for t = 1:size(path,3)
    for r = 1:size(world,1)
        for c = 1:size(world,2)
            if world(r,c,t)==0
                gx(i)=r;
                gy(i)=c;
                gz(i)=t;
                i = i + 1;
            end
        end
    end
end
plot3(gx,gy,gz,'MarkerSize',30,'Marker','.','LineWidth',3,'Color',[0 1 0])
i=1;
for t = 1:size(path,3)
    for r = 1:size(path,1)
        for c = 1:size(path,2)
            if path(r,c,t)==1
                x(i)=r;
                y(i)=c;
                z(i)=t;
                i = i + 1;
            end
        end
    end
end
plot3(x,y,z,'MarkerSize',30,'Marker','.','LineWidth',3,'Color',[0 0 1])
axis([1,size(path,1),1,size(path,2),1,size(path,3)])
view(-16,4)
hold off
end