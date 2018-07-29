% Chapter 14 - Poincare Maps and Nonautonomous Systems in the Plane.
% Programs_14e - Phase portraits for Hamiltonian systems with two degrees of freedom.
% Copyright Birkhauser 2013. Stephen Lynch.

% Periodic behavior (Fig. 14.5 (a) and (b)).
% deq=inline('[-2*p(3);-2*p(4);2*p(1);2*p(2)]','t','p');

deq=@(t,p) [-2*p(3);-2*p(4);2*p(1);2*p(2)]
options=odeset('RelTol',1e-4,'AbsTol',1e-4);
[t,pp]=ode45(deq,[0 100],[.5,1.5,.5,0],options);

% A 3-dimensional projection.
subplot(2,1,1)
fsize=15;
plot3(pp(:,1),pp(:,2),pp(:,4))


% A 2-dimensional projection.
k=0;p1_0=zeros(1,10^6);q1_0=zeros(1,10^6);
for n=1:1000
    if abs(pp(n,4))<0.01
        k=k+1;
        p1_0(k)=pp(n,1);
        q1_0(k)=pp(n,3);       
    end
end

subplot(2,1,2)
hold on
axis([-1 1 -1 1])
set(gca,'XTick',-1:.5:1,'FontSize',fsize)
set(gca,'YTick',-1:.5:1,'FontSize',fsize)
xlabel('p_1','FontSize',fsize)
ylabel('q_1','FontSize',fsize)
plot(p1_0(1:k),q1_0(1:k),'+','MarkerSize',3)
hold off

% End of Programs_14e.