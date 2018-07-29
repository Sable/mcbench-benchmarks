%This verifies "york_fit" via a Monte Carlo Simulation. The pdf
%generated should approach the red curves as N_runs increases.

%Copyright Travis Wiens 2010 travis.mlfx@nutaksas.com

N_run=5000;%number of runs

N = 100;%number of points
X_range=[-1 1];%range of X values

sigma_X_max=0.1;%maximum std error in X
sigma_Y_max=0.1;%maximum std error in Y

r=0*ones(1,N);%correlation coefficient between errors in X and Y

a=5*randn(N_run,1);%"True Value" of a (Y=a+b*X)
b=5*randn(N_run,1);%"True Value" of b

a_york=zeros(N_run,1);%estimate of a
b_york=zeros(N_run,1);%estimate of b
sigma_ayork=zeros(N_run,1);%estimate of standard error in estimate of a
sigma_byork=zeros(N_run,1);%estimate of standard error in estimate of b


for i=1:N_run
    sigma_X=sigma_X_max*rand(1,N);%error in X
    sigma_Y=sigma_Y_max*rand(1,N);%error in Y
    X_nf=X_range(1)+(X_range(2)-X_range(1))*rand(1,N);%select error-free X

    Y_nf=a(i)+b(i)*X_nf;%calculate error-free Y

    X=X_nf+sigma_X.*randn(1,N);%add error
    Y=Y_nf+sigma_Y.*randn(1,N);%add error

    [a_york(i), b_york(i), sigma_ayork(i), sigma_byork(i)] =...
        york_fit(X,Y,sigma_X,sigma_Y, r);%estimate parameters
end

A=(a-a_york)./sigma_ayork;%normalize measured error to standard error
B=(b-b_york)./sigma_byork;

figure(1)
N_plot=100;
[N_h x_h]=hist(A,round(sqrt(N_run)));
x_plot=linspace(x_h(1),x_h(end),N_plot);
pdf=N_h/(N_run*(x_h(2)-x_h(1)));
pdf_plot=1/sqrt(2*pi)*exp(-x_plot.^2/2);
plot(x_h,pdf,'k.')
hold on
plot(x_plot,pdf_plot,'r')
hold off
ylabel('pdf')
xlabel('A=(a-a_{york})./\sigma_{ayork}')
legend('measured','theoretical')


figure(2)
N_plot=100;
[N_h x_h]=hist(B,round(sqrt(N_run)));
x_plot=linspace(x_h(1),x_h(end),N_plot);
pdf=N_h/(N_run*(x_h(2)-x_h(1)));
pdf_plot=1/sqrt(2*pi)*exp(-x_plot.^2/2);
plot(x_h,pdf,'k.')
hold on
plot(x_plot,pdf_plot,'r')
hold off
ylabel('pdf')
xlabel('B=(b-b_{york})./\sigma_{byork}')
legend('measured','theoretical')