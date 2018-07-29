%This demonstrates "york_fit", showing ability to fit a line to data with
%errors in x and y (including different errors for each point)

%Copyright Travis Wiens 2010 travis.mlfx@nutaksas.com

N = 20;%number of points
X_range=[-1 1];%range of X values

sigma_X_max=0.1;%maximum std error in X
sigma_Y_max=0.1;%maximum std error in Y

r=0*ones(1,N);%correlation coefficient between errors in X and Y

a=randn;%"True Value" of a (Y=a+b*X)
b=randn;%"True Value" of b


sigma_X=sigma_X_max*rand(1,N);%error in X
sigma_Y=sigma_Y_max*rand(1,N);%error in Y
X_nf=X_range(1)+(X_range(2)-X_range(1))*rand(1,N);%select error-free X

Y_nf=a+b*X_nf;%calculate error-free Y

X=X_nf+sigma_X.*randn(1,N);%add error
Y=Y_nf+sigma_Y.*randn(1,N);%add error

[a_york, b_york, sigma_ayork, sigma_byork] =...
    york_fit(X,Y,sigma_X,sigma_Y, r);%estimate parameters

tmp=Y/[X; ones(1,N)];%find least squares line fit
b_lse=tmp(1);
a_lse=tmp(2);

N_plot=2;
X_plot=linspace(X_range(1),X_range(2),N_plot);
Y_plotlse=a_lse+b_lse*X_plot;
Y_plotnf=a+b*X_plot;
Y_plotyork=a_york+b_york*X_plot;

fprintf('a=%0.3f b=%0.3f\n\n',a,b);
fprintf('lse: a=%0.3f b=%0.3f\n',a_lse,b_lse);
fprintf('a-a_lse=%0.3f b-b_lse=%0.3f\n\n',a-a_lse,b-b_lse);

fprintf('york: a=%0.3f+/-%0.3f b=%0.3f+/-%0.3f\n',a_york,sigma_ayork,b_york,sigma_byork);
fprintf('a-a_york=%0.3f b-b_york=%0.3f\n',a-a_york,b-b_york);

figure(1)
h=zeros(3,1);
plot(X,Y,'k.')
hold on
%plot error ellipse for each point
for i=1:N
    [Xe Ye] = ellipse(X(i),Y(i),sigma_X(i),sigma_Y(i),32);
    plot(Xe,Ye,'color',[0.7 0.7 0.7])
end
h(1)=plot(X_plot,Y_plotnf,'b');
h(2)=plot(X_plot,Y_plotlse,'g');
h(3)=plot(X_plot,Y_plotyork,'r');
hold off
axis equal
legend(h,'true','lse','york')
xlabel('X')
ylabel('Y')


