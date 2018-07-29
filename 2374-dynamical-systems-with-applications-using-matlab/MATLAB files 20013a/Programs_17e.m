% Chapter 17 - Neural Networks.
% Programs_17e - Bifurcation Diagram for a Simple Bistable Neuromodule.
% Copyright Birkhauser 2013. Stephen Lynch.

% Bifurcation diagram for a two-neuron module. (See Figure 17.15).
% Vary bias b1.
clear all
format long;
halfN=1000;N=2*halfN+1;N1=1+halfN;Max=10;a=1;alpha=0.3;
x=zeros(1,N);y=zeros(1,N);
b2=3;w11=7;w12=-4;w21=5;start=-5;
x(1)=-10;y(1)=-3;

% Ramp the power up
for n=1:halfN
    b1=(start+n*Max/halfN);
    x(n+1)=b1+w11*(exp(a*x(n))-exp(-a*x(n)))/(exp(a*x(n))+exp(-a*x(n)))+w12*(exp(alpha*y(n))-exp(-alpha*y(n)))/(exp(alpha*y(n))+exp(-alpha*y(n)));
    y(n+1)=b2+w21*(exp(a*x(n))-exp(-a*x(n)))/(exp(a*x(n))+exp(-a*x(n)));
end

% Ramp the power down
for n=N1:N
    b1=(start+2*Max-n*Max/halfN);
    x(n+1)=b1+w11*(exp(a*x(n))-exp(-a*x(n)))/(exp(a*x(n))+exp(-a*x(n)))+w12*(exp(alpha*y(n))-exp(-alpha*y(n)))/(exp(alpha*y(n))+exp(-alpha*y(n)));
    y(n+1)=b2+w21*(exp(a*x(n))-exp(-a*x(n)))/(exp(a*x(n))+exp(-a*x(n)));
end

% Plot the bifurcation diagrams
fsize=14;
subplot(2,1,1)
hold on
set(gca,'XTick',0:halfN/2:N,'FontSize',fsize);
set(gca,'YTick',-Max:5:Max,'FontSize',fsize);
plot(x(1:N),'-','MarkerSize',1,'color','k')
xlabel('Number of Iterations','FontSize',fsize);
ylabel('x_n','FontSize',fsize);
hold off
x1=zeros(1,N);w=zeros(1,N);

for n=1:halfN
    x1(n)=x(N+1-n);
    w(n)=start+n*Max/halfN;
end

subplot(2,1,2)
hold on
set(gca,'XTick',start:5:start+Max,'FontSize',fsize);
set(gca,'YTick',-Max:5:Max,'FontSize',fsize);
plot(w(1:halfN),x(1:halfN),'-','MarkerSize',1,'color','k');
plot(w(1:halfN),x1(1:halfN),'-','MarkerSize',1,'color','k');
xlabel('b_1','FontSize',fsize);
ylabel('x_n','FontSize',fsize);
hold off

% End of Programs_17e.



