% Test sharedmatrix mex file.
%
% Copyright (c) 2010,2011 Joshua V Dillon
% All rights reserved. (See file header for details.)

%C = sparse(rand(10000,10000).*(rand(10000,10000)>.1)); % big matrix
C = sparse(rand(100,100).*(rand(100,100)>.1)); % small matrix

shmkey=12345;

try,sharedmatrix('free',shmkey);catch,end;

shmsiz=sharedmatrix('clone',shmkey,C);clear C;
%fprintf('[shmkey shmsiz]=deal(%d,%d);\n',shmkey,shmsiz);

if exist('x','var')==1
	sharedmatrix('detach',shmkey,x);
	clear x;
end

for i=1:100
	x=sharedmatrix('attach',shmkey);
	I=randperm(size(x,2));
	a=sum(x,1);
%	pause(.5);
	sharedmatrix('detach',shmkey,x);
%	clear x;
end

