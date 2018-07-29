


n1=64;
K=zeros(n1);
for i=1:n1
    for j=i:n1
        K(i,j)=1;
    end
end
for i=2:n1
    K(i,i-1)=(-n1)+(i-1);
end


for naga=1:40
    naga12=num2str(naga);
    naga1=strcat('s',naga12,'\','1.pgm');
    naga2=strcat('s',naga12);
J=imread(naga1);
J=imresize(J,[64 64]);
I=zeros(n1);
for i=1:n1
    L=J(:,i);
    L=double(L);
    M=K*L;
    I(:,i)=M;
end
A=K*I*K';
A=mat2gray(A,[0 255]);
figure, imshow(A);
Y=reshape(A,n1*n1,1);
M=zeros(n1,1);
I1=zeros(n1);
nr=zeros(10,2);
for w=1:10
    w1=num2str(w);
    w2=strcat(naga2,'\',w1,'.pgm');
S=imread(w2);
S=imresize(S,[64 64]);

for j=1:n1
    L1=S(:,j);
    L1=double(L1);
    M=K*L1;
    I1(:,j)=M;
end

B=K*I1*K';
B=mat2gray(B,[0 255]);
Z=reshape(B,n1*n1,1);
T=norm(Y-Z);

nr(w,1)=T;
nr(w,2)=w;
end
 [m q]=size(nr);
pa=m+1;
for i1=2:pa
    for i2=(pa-1):-1:i1
     if (nr(i2-1,1)>nr(i2,1))
         l1=nr(i2-1,1);
         l2=nr(i2-1,2);    
         nr(i2-1,1)=nr(i2,1);
         nr(i2-1,2)=nr(i2,2);
         nr(i2,1)=l1;
         nr(i2,2)=l2;
     end
    end
end

 subplot(3,3,1); imshow(J); title('Provided Image');
 
 for i7=1:m
    n12=i7;
    j=nr(i7,2);
    j=num2str(j);
    str=strcat(j,'.pgm');
    I=imread(str);
    b1=num2str(i7);
    str1=strcat('Similar',b1);
    subplot(3,3,i7+1);imshow(I);title(str1);% Displaays Similar images
    if (n12>7)
        break;
    end
 end
end

