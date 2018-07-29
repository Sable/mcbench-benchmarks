function seq=huffadaptdecod(alpha,btag)
alpsz=length(alpha);
e=floor(log2(alpsz));
r=alpsz-2^e;

ndnm=2*alpsz-1;

tree(1).left=0;
tree(1).right=0;
tree(1).sym=0;
tree(1).wgt=0;
tree(1).nn=ndnm;
tree(1).parent=0;
ndnm=ndnm-1;

seq=[];
while ~isempty(btag)
    id=1;
    while(1)
        if (tree(id).left==0 & tree(id).right==0)
            break;
        end
        b=btag(1);
        btag(1)='';
        if b=='0';
            id=tree(id).left;
        else
            id=tree(id).right;
        end
    end
    
    if tree(id).wgt==0
        b=btag(1:e);
        p=bin2dec(b);
        if p<r
            b=btag(1:e+1);
            p=bin2dec(b)+1;
            btag(1:e+1)='';
        else
            p=r+p+1;
            btag(1:e)='';
        end
        al=alpha(p);
    else
        al=tree(id).sym;
    end
    seq=[seq al];
    [tree ndnm]=updatetree(tree,ndnm,al);
end
end