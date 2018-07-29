% Examples to test paretoset.m
% Modified from isParetoSetMember

% Example 1: Find the Pareto set of a circumference
% 
alpha = (0:.1:2*pi)';
x = cos(alpha);
y = sin(alpha);
membership = paretoset([x y]);

subplot(121)
hold on
plot(x,y);
plot(x( membership  ) , y( membership  ) , 'r');
hold off
grid on
xlabel('x');
ylabel('y');
title('Pareto set of a circumference');
%%
% 
% Example 2:  Find the Pareto set of a set of random points in 3D
X = rand(100,3);
membership = paretoset(X);

subplot(122)
hold on
plot3(X(:,1),X(:,2),X(:,3),'.');
plot3(X( membership , 1) , X( membership , 2) , X( membership , 3) , 'r.');
hold off
grid on
view(-37.5, 30)
xlabel('X_1');
ylabel('X_2');
zlabel('X_3');
title('Pareto set of a set of random points in 3D');
%%
% 
% Example 3: Find the Pareto set of a set of 1000000 random points in 4D
%            The machine performing the calculations was a 
%            Intel(R) Core(TM)2 CPU T2500 @ 2.0GHz, 2.0 GB of RAM
%            
X = rand(1000000,4);
t0 = cputime;
Y1=paretomember(X); %mex implementation without sorting.
t1=cputime - t0;
t0 = cputime;
Y2=paretoset(X);
t2=cputime - t0;
isequal(Y1,Y2)      %shoudl be 1
disp([t1 t2])       %1.7969    1.288276
