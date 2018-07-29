function d=mutate1(pop,mutprop)%uniform mutation.
global  bound rng
[pops,numvar]=size(pop);
mut=round(mutprop*pops*numvar);
for i=1:mut
    x=ceil(rand*size(pop,1));
    y=ceil(rand*numvar);
    pop(x,y)=bound(y,1)+rand*rng(y);
    offs(i,:)=pop(x,:);
    pop(x,:)=[];
end
d=[offs;pop];
