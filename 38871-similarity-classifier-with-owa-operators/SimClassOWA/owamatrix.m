function h=owa(A,w)
b=[];
for i=1:size(A,1)
    apu=A(i,:);
    h(i)=sum(sort(apu,2,'descend').*w);
end
