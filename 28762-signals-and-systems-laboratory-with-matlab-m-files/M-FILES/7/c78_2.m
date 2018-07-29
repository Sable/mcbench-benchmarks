% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni


% relationship of linear convolution with circular convolution


% 4-point circular convolution 
x1=[1,2,3,4];
x2=[3,2,5,1];
N=length(x1);
for m=0:N-1
p(m+1)=mod(-m,N);
x2s(1+m)=x2(1+p(m+1));
end
x2s
for n=0:N-1
    x2sn=circshift(x2s',n);
    y2(n+1)=x1*x2sn;
end
y2


% 7-point circular convolution 
x11=[ x1 0 0 0];
x22=[x2 0 0 0];
N=length(x11);
for m=0:N-1
p(m+1)=mod(-m,N);
end
for m=0:N-1
x22s(1+m)=x22(1+p(m+1));
end
for n=0:N-1
    x22sn=circshift(x22s',n);
    y22(n+1)=x11*x22sn;
end
y22


%linear convolution 
y1=conv(x1,x2)
