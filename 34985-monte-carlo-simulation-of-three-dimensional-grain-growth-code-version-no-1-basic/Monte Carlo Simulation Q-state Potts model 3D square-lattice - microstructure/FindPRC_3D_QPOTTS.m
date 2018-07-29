function [ElementRnCnPn]=FindPRC_3D_QPOTTS(ElementNo,state)

e=ElementNo;
planes=size(state,3);
columns=size(state,2);
rows=size(state,1);
r=rows;
c=columns;



for k=1:planes
    if e<=(k*r*c) & e>((k-1)*r*c)
        pn=k;break
    end
end

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

ElementRnCnPn=[rn,cn,pn];