function [] = isParetoSetMember()
% isParetoSetMember returns the logical Pareto membership of a set of points.
% 
%       synopsis:   membership = isParetoSetMember(objectiveMatrix)
%
%
%   INPUT ARGUMENT
%
%       - objectiveMatrix           [ nPoints X nObjectives] array. The
%                                   element (i,j) is the j-th objective
%                                   value of the i-th point;
%
%
%   OUTPUT ARGUMENT
%
%       - membership                [ nPoints X 1 ] array. If the i-th
%                                   element is 1, then the i-point belongs
%                                   to the Pareto set.
%
% 
% Example 1: Find the Pareto set of a circumference
% 
% alpha = [0:.1:2*pi]';
% x = cos(alpha);
% y = sin(alpha);
% membership = isParetoSetMember([x y]);
% 
% hold on;
% plot(x,y);
% plot(x( find(membership)  ) , y( find(membership)  ) , 'r');
% hold off
% grid on
% xlabel('x');
% ylabel('y');
% title('Pareto set of a circumference');
% 
% Example 2:  Find the Pareto set of a set of random points in 3D
% X = rand(100,3);
% membership = isParetoSetMember(X);
% 
% hold on;
% plot3(X(:,1),X(:,2),X(:,3),'.');
% plot3(X( find(membership) , 1) , X( find(membership) , 2) , X( find(membership) , 3) , 'r.');
% hold off
% grid on
% view(-37.5, 30)
% xlabel('X_1');
% ylabel('X_2');
% zlabel('X_3');
% title('Pareto set of a set of random points in 3D');
% 
% 
% Example 3: Find the Pareto set of a set of 1000000 random points in 4D
%            The machine performing the calculations was a 
%            Intel(R) Core(TM)2 CPU T5500 @ 1.66GHz with1.67GHz, 0.99 GB of RAM
%            
% X = rand(1000000,4);
% t = cputime;
% isParetoSetMember(X);
% cputime - t
% 
% ans =
% 
%    56.3600



error('mex isParetoSetMember mex file absent, type mex isParetoSetMember.c to compile');