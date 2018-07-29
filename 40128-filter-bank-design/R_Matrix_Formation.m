

function R=R_Matrix_Formation(w,N)

R=zeros(N,N);

for i=0:N-1
    temp(i+1)=cos(i*w);
end


R(1,:)=temp;


for i=2:N
    R(i,:)=circshift(R(i-1,:),[0 1]);
    R(i,1)=cos((i-1)*w);
end










