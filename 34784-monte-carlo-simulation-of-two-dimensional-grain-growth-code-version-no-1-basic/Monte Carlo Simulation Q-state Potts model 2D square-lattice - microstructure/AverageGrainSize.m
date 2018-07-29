function AGS = AverageGrainSize(state,x,y)
 
nl=2:1:(size(state,2)-2);
for n=1:size(nl,2)
    DMV=state(:,n);
    count=0;
    for row=1:size(DMV,1)
        count=count+1;
        if row~=size(DMV,1)
            if DMV(row,1)~=DMV(row+1,1)
                DMVI(count)=row;
            end
        else
            if DMV(row,1)~=DMV(row-1,1)
                DMVI(count)=row;
            end
        end
    end
    DMVIWZ = RemoveZerosNby1(DMVI);
    NumberOfIntercepts=prod(size(DMVIWZ));
    for count=1:NumberOfIntercepts
        if count==1
            Distances(count) = sqrt((x(1,1) - x(DMVIWZ(count),1))^2 + (y(1,1) - y(DMVIWZ(count),1))^2);
        elseif count==NumberOfIntercepts
            Distances(count) = sqrt((x(size(x,1),1) - x(DMVIWZ(count),1))^2 + (y(size(x,1),1) - y(DMVIWZ(count),1))^2);
        else
            Distances(count) = sqrt((x(DMVIWZ(count+1),1) - x(DMVIWZ(count),1))^2 + (y(DMVIWZ(count+1),1) - y(DMVIWZ(count),1))^2);
        end
    end
    AvgGrSz(n)=sum(sum(Distances))/NumberOfIntercepts;
end
AGS=sum(sum(AvgGrSz))/prod(size(AvgGrSz));