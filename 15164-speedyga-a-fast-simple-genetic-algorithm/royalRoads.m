% The royal roads function. The chromosome length (i.e. len) 
% should be a multiple of 8
function fitness=R1(pop)
[popSize len]=size(pop);
fitness=zeros(popSize,1);
for i=1:8:len
    temp=sum(pop(:,i:i+7),2);
    temp=double(temp==8);
    fitness=fitness+temp*8;
end
fitness=fitness';
