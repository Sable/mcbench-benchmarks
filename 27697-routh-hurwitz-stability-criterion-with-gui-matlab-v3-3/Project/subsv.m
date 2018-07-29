function [D]=subsv(V,O,N)
%these function develop subs.m(one of the function of matlab) for a
%symbolic vector
%out=subsv(V,O,N)
%V is symbolic vector;
%O , N are replaceable symbolics
%these function replace Old symbolic of all array input symbolic vector
%with New symbolic
D=[];
for i=1:length(V)
    if iscell(V)
        D(i)=subs(V{i},O,N);
    else
    D(i)=subs(V(i),O,N);
    end
end
