pb=1e-6;
data=[];
while pb<0.5
    data=[data;[pb,geterror(pb)]];
    pb=pb*1.5;
end
plot(log(data(:,1))/log(10),log(data(:,2))/log(10));
