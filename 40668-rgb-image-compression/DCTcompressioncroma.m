function [Ioutput]= DCTcompressioncroma(cb)
Q=[17 18 24 47 99 99 99 99;
   18 21 26 66 99 99 99 99;
   24 26 56 99 99 99 99 99;
   47 99 99 99 99 99 99 99;
   99 99 99 99 99 99 99 99;
   99 99 99 99 99 99 99 99;
   99 99 99 99 99 99 99 99;
   99 99 99 99 99 99 99 99];
[a b]= size(cb);
a1=0;b1=0;
sam=zeros([8 8]);
if ((mod(a,8)>0))
    a1= 8-mod(a,8);
end
if ((mod(b,8)>0))
    b1= 8-mod(b,8);
end
cb1=zeros([(a+a1) (b+b1)]);
cb1(1:a,1:b)=cb(1:a,1:b);
B=zeros([(a+a1) (b+b1)]);

for i=1:8:a
    for j=1:8:b
        sam(1:8,1:8)=cb1(i:i+7,j:j+7);
        sam1=dct2(sam);
        B(i:i+7,j:j+7)=sam1(1:8,1:8);
    end
end

[a b]= size(B);
B1=zeros([a b]);
B2=zeros([a b]);
fc=1;gc=1;
for i=1:a
    if (gc>8)
         gc=1;
    end
    for j=1:b
        if (fc>8)
            fc=1;
        end
        B1(i,j)=floor(B(i,j)/Q(gc,fc));
        B1(i,j)=B1(i,j)*Q(gc,fc);
        fc=fc+1;
    end
    gc=gc+1;
end
 
out=zigzag(B1);
[d,c]=runenc(out');
result=rl_dec(d,c);
resultfinal=invzigzag(result,a,b);
for i=1:8:a
    for j=1:8:b
        sam(1:8,1:8)=resultfinal(i:i+7,j:j+7);
        sam1=idct2(sam);
        B2(i:i+7,j:j+7)=sam1(1:8,1:8);
    end
end
[a b]= size(cb);

Ioutput=B2(1:a,1:b);

