% triangle and square:
C=false(7,7);

C(1,2)=true;
C(1,3)=true;

C(2,3)=true;

C(4,5)=true;
C(4,7)=true;

C(4,5)=true;

C(5,6)=true;

C(6,7)=true;

for c1=1:7-1
    for c2=c1+1:7
        C(c2,c1)=C(c1,c2);
    end
end

[labels rts] = graph_connected_components(C);