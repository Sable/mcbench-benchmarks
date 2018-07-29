function Xrle=rle(XZv)
L=length(XZv);
j=1;
k=1;
i=1;
while i<2*L
    comp=1;
    for j=j:L
        if j==L 
            break
        end;  
         if XZv(j)==XZv(j+1)
            comp=comp+1;
        else
            break
        end;
    end;
        Xrle(k+1)=comp;
        Xrle(k)=XZv(j);
        if j==L & XZv(j-1)==XZv(j) 
            break
        end;  
        i=i+1;
        k=k+2;
        j=j+1;
        if j==L 
            if mod(L,2)==0 
            Xrle(k+1)=1;
            Xrle(k)=XZv(j);
            else
            Xrle(k+1)=1;    
            Xrle(k)=XZv(j);
                       end;
             break
        end;
    end;         