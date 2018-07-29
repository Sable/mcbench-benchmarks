function [ElementRnCn]=FindRC_2D_QPOTTS(ElementNo,state)

e=ElementNo;
columns=size(state,2);
rows=size(state,1);
r=rows;
c=columns;

pn=1;

for j=1:columns
    if e<=((pn-1)*r*c+j*r) & e>((pn-1)*r*c+(j-1)*r)
        cn=j;break
    end
end

for i=1:rows    
    if e==(pn-1)*r*c+(cn-1)*r+i
        rn=i;break
    end
end

ElementRnCn=[rn,cn];