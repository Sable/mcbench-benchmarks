function ObjVal = FoxHoles(x,mydata)

[A,B] = size(x);
Top=double(0);
Top1=double(0);
C=[-32,-16,0,16,32,-32,-16,0,16,32,-32,-16,0,16,32,-32,-16,0,16,32,-32,-16,0,16,32;
    -32,-32,-32,-32,-32,-16,-16,-16,-16,-16,0,0,0,0,0,16,16,16,16,16,32,32,32,32,32];

for i=1:A
    for k=1:25
        for j=1:B
          Top1=Top1+power((double(x(i,j))-double(C(j,k))),6);
        end;
        Top=double(Top+(1/(Top1+k)));
        Top1=0;
     end;
ObjVal(i)= double(1/(0.002+Top));
Top=0;
end
ObjVal=ObjVal';


function y=power(x,a)
y=double(x^a);
  return