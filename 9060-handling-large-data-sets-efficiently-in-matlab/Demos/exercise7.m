%% Parameters
m=1000;
x=randn(m,1);

%% Fully Vectorized
y=2*x;

%% De-vectorized to scalar operations (down columns)
y=randn(m,1);
for k=1:length(x)
    y(k)=2*x(k);
end
    
%% De-vectorized to block operations
y=randn(m,1);
b=100;       % Blocksize, ensure n is a muliple
for k=1:m/b  % Number of blocks
    y((1:b)+(k-1)*b)=2*x((1:b)+(k-1)*b);
end

%% 2D Vectorized
m=2000;
n=2000;
x=randn(m,n);

tic
y=2*x;
t(1)=toc;
clc;
fprintf('Vectorized: %f sec\n',t(1));

%% 2D De-vectorized to scalar operations (down columns)
y=zeros(m,n);
tic
for k=1:n  % For each column, process all the row elements (column vector)
    for l=1:m
        y(l,k)=2*x(l,k);
    end
end
t(2)=toc;
fprintf('De-vectorized to scalars down columns: %f sec\n',t(2));

%% 2D De-vectorized to scalar operations (down columns)
y=zeros(m,n);
tic
for l=1:m  % For each column, process all the row elements (column vector)
    for k=1:n
        y(l,k)=2*x(l,k);
    end
end
t(3)=toc;
fprintf('De-vectorized to scalars along row: %f sec\n',t(3));

%% 2D De-vectorized to columns operations (not rows)
y=zeros(m,n);
tic
for k=1:n  % For each column, process all the row elements (column vector)
    y(:,k)=2*x(:,k);
end
t(4)=toc;
fprintf('De-vectorized to columns: %f sec\n',t(4));

%% 2D De-vectorized to row operations (not rows)
y=zeros(m,n);
tic
for k=1:m  % For each row, process all the column elements (row vector)
    y(k,:)=2*x(k,:);
end
t(5)=toc;
fprintf('De-vectorized to rows: %f sec\n',t(5));

barh(t);
set(gca,'Ydir','Reverse');
set(gca,'Xgrid','on');
shg;

text(zeros(5,1),1:5,{'Fully Vectorized','Scalars ops. down columns','Scalar ops. along rows','De-vectorized to block (column) ops.','De-vectorized to block (row) ops.'},'color',[0 1 0])