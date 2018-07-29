clear all
close all
clc

x=-5:5;
y=test_func(x);
figure; plot(x,y)

fprintf('test function is (x-2)^2\n');
[x val]=gradient_descent(@(x)test_func(x),100);
fprintf('optimal x value is %.2f, and f(x): %.2f\n',x,val);

%or if you want to see the changes in x:
fprintf('Press enter\n');
pause;

gamma=0.2;
iter=100;
thresh=1e-6;
display=1;
[x val]=gradient_descent(@(x)test_func(x),100,gamma,iter,thresh,display);
fprintf('optimal x value is %.2f, and f(x): %.2f\n',x,val);