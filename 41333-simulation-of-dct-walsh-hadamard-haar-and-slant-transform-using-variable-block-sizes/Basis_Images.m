clc;
clear all;
close all;
display('***** Image Transforms *****');
display('1. DCT Transform');
display('2. DST Transform');
display('3. Walsh Transform');
display('4. Hadamard Transform');
display('5. Haar Transform');
display('6. Slant Transform');
ch=input('Enter choice of transform: ');
if ch==1
    a=dctmtx(4);   
elseif ch==2
    a=dstmtx(4);
elseif ch==3
    p=sqrt(2);
    a=walsh(4); 
elseif ch==4
    a=hadamard(4);
elseif ch==5
    a=haarmtx(4);  
elseif ch==6
    q=sqrt(5);
    a=[1 1 1 1;3/q 1/q -1/q -3/q;1 -1 -1 1;1/q -3/q 3/q -1/q]; 
else
    display('Invalid Choice entered');
    return;
end
[m n]=size(a);
t=a';
for i=1:m
    for j=1:n
        if i==1
            p(j,1)=t(j,i);
        elseif i==2
            p(j+4,1)=t(j,i);
        elseif i==3
            p(j+8,1)=t(j,i);
        elseif i==4
            p(j+12,1)=t(j,i);
        end
    end
end
q=p';
r=p*q;
c=m*n;
h=1;
for e=1:m:c
    for f=1:n:c
        for o=1:m
            for q=1:n
                g(o,q)=r(e+o-1,f+q-1);
            end
        end
        s=mat2gray(g);
        subplot(m,n,h);
        imshow(s)
        h=h+1;
    end
end