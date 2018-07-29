% example of using rmvnrnd
S = [ 1 0.9; 0.9 2 ];
m = [ 0 0 ];
% draw a sample of 10000 from the unrestricted MVN
X1 = rmvnrnd(m, S, 10000);
% Draw a sample of 100 from the distribution limited to the
% rectangle with corners (3,4) and (4,5).
X2 = rmvnrnd(m, S, 100, [-eye(2); eye(2)], [-3; -4; 4; 5]); 
% Draw a sample of 100 from the distribution restricted 
% by x > 2, y < -2
X3 = rmvnrnd(m, S, 100, [-1 0; 0 1], [-2; -2]); 
% Plot the points
clf
plot(X2(:,1),X2(:,2),'b.');
hold on
plot(X3(:,1),X3(:,2),'r.');
plot(X1(:,1),X1(:,2),'g.');
axis equal
