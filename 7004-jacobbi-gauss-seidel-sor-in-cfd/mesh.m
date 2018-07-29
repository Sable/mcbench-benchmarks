function [x]=mesh
%------------------------------------------------
% GENERATE MATCHING DISTANCE X FOR DIFFERENT MESH
% -----------------------------------------------
global N L 
dx=L/N;
x(1)=0;
x(2)=dx/2;
for i=3:N+1
    x(i)=x(i-1)+dx;
end
x(N+2)=L;
