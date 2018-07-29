function [t]=ants_traceupdating(m,n,t,at,f,e);
for i=1:m
    for j=1:n
        dt=1/f(i);
        t(at(i,j),at(i,j+1))=(1-e)*t(at(i,j),at(i,j+1))+dt;%updating traces.
    end
end
