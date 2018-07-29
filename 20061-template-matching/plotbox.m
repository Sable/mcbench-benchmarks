function result=plotbox(Target,Template,M);
%
%By Alaa Eleyan May,2008
%*********************************************************
[r1,c1]=size(Target);
[r2,c2]=size(Template);

[r,c]=max(M);
[r3,c3]=max(max(M));

i=c(c3);
j=c3;
result=Target;
for x=i:i+r2-1
   for y=j
       result(x,y)=255;
   end
end
for x=i:i+r2-1
   for y=j+c2-1
       result(x,y)=255;
   end
end
for x=i
   for y=j:j+c2-1
       result(x,y)=255;
   end
end
for x=i+r2-1
   for y=j:j+c2-1
       result(x,y)=255;
   end
end