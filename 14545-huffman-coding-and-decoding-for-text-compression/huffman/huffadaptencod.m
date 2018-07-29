function btag=huffadaptencod(alpha,seq)
alpsz=length(alpha);
ls=length(seq);
e=floor(log2(alpsz));
r=alpsz-2^e;
for k=1:2*r
    NYT(k)=cellstr(dec2bin(k-1,e+1));
end
for k=2*r+1:alpsz
    NYT(k)=cellstr(dec2bin(k-r-1,e));
end
ndnm=2*alpsz-1;

tree(1).left=0;
tree(1).right=0;
tree(1).sym=0;
tree(1).wgt=0;
tree(1).nn=ndnm;
tree(1).parent=0;
ndnm=ndnm-1;
btag=[];
for i=1:ls
    al=seq(i);
   apr=find([tree.sym]==al);
   if isempty(apr)
       code=[];
       flag=0;
       code=findnytcode(tree,1,code,flag);
       btag=strcat(btag,code);
       idx=find(al==alpha);
       btag=strcat(btag,cell2mat(NYT(idx)));
   else
       code=[];
       flag=0;
       code=findalcode(tree,1,al,code,flag);
       btag=strcat(btag,code);
   end
   [tree ndnm]=updatetree(tree,ndnm,al);
end
end

function [code flag]=findnytcode(tree,id,code,flag)
if id==0
    return;
elseif tree(id).wgt==0
        flag=1;
        return;
else
      [code flag]=findnytcode(tree,tree(id).left,code,flag);
      if flag==1
          code=strcat('0',code);
          return;
      end
      [code flag]=findnytcode(tree,tree(id).right,code,flag);
       if flag==1
          code=strcat('1',code);
          return;
      end
end
end

function [code flag]=findalcode(tree,id,al,code,flag)
if id==0
    return;
elseif tree(id).sym==al
        flag=1;
        return;
else
      [code flag]=findalcode(tree,tree(id).left,al,code,flag);
      if flag==1
          code=strcat('0',code);
          return;
      end
      [code flag]=findalcode(tree,tree(id).right,al,code,flag);
       if flag==1
          code=strcat('1',code);
          return;
      end
end
end

