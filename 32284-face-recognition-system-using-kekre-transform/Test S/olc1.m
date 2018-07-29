function []=olc1()
n1=128;
K=zeros(n1);
for i=1:n1
    for j=i:n1
        K(i,j)=1;
    end
end
for i=2:n1
    K(i,i-1)=(-n1)+(i-1);
end

hgot=getappdata(0,'H_pass');
k1=char(hgot);
msgbox('Click on the folder saved by the name Test S');
pause(2);
TP = uigetdir('C:', 'Select path where Query image is to be searched');
%TP=char(TP);
l3=strcat(TP,'\',k1,'.pgm');
J=imread(l3);
J=imresize(J,[128 128]);
I=zeros(n1);
for i=1:n1
    L=J(:,i);
    L=double(L);
    M=K*L;
    I(:,i)=M;
end
A=K*I*K';
A=mat2gray(A,[0 63]);
%figure, imshow(A);
Y=reshape(A,n1*n1,1);
M=zeros(n1,1);
I1=zeros(n1);
nr=zeros(60,2);
msgbox('Click on the folder saved by the name S');
pause(2);
l32 = uigetdir('C:', 'Select path where Database image is to be searched');
for w=1:100
    w1=num2str(w);
    w2=strcat(l32,'\',w1,'.pgm');
S=imread(w2);
S=imresize(S,[128 128]);

for j=1:n1
    L1=S(:,j);
    L1=double(L1);
    M=K*L1;
    I1(:,j)=M;
end

B=K*I1*K';
B=mat2gray(B,[0 63]);
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
 figure;
 subplot(1,2,1); imshow(l3); title('Provided Image');
 
 for i7=1:m
    n12=i7;
    j=nr(i7,2);
    j=num2str(j);
    str=strcat(l32,'\',j,'.pgm');
    I=imread(str);
    %b1=num2str(i7);
    str1=strcat('Image recognized From Database');
    subplot(1,2,2);imshow(I);title(str1);% Displaays Similar images
    if (n12>1)
        break;
    end
 end
return

