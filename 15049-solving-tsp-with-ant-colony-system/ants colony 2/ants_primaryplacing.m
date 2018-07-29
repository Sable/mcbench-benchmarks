function [app]=ants_primaryplacing(m,n);
rand('state',sum(100*clock));
for i=1:m
    app(i,1)=fix(1+rand*(n-1));%ants primary placing.
end