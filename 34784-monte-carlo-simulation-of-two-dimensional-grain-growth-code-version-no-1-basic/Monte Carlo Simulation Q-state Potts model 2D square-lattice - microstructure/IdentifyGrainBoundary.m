function [GrainBoundaryX,GrainBoundaryY]=IdentifyGrainBoundary(x,y,state)

count=1;
for i=1:size(x,1)-1
    for j=1:(size(x,1)-1)
        if state(i,j)~=state(i,j+1)
            GrainBoundaryX(1,count)=x(i,j);
            GrainBoundaryY(1,count)=y(i,j);
            count=count+1;
        end
        if state(i,j)~=state(i+1,j)
            GrainBoundaryX(1,count)=x(i,j);
            GrainBoundaryY(1,count)=y(i,j);
            count=count+1;
        end
    end
end