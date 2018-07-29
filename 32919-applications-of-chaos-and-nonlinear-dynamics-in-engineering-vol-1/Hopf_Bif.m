
% Hopf_Bif - Animation of Hopf bifurcation of a limit cycle from the origin.
% NOTE: Hopf_System.m must be in the same directory as Hopf_Bif.m.
% Copyright Springer 2013.
clear
Max=120;global b;
for j = 1:Max 
    F(j) = getframe;
    b=j/40;   % mu goes from 0 to 4.
    options = odeset('RelTol',1e-4,'AbsTol',1e-4);
    x0=1;y0=1;
    [t,x]=ode45(@Hopf_System,[0 100],[x0 y0],options);  
    plot(x(:,1),x(:,2),'b');  
    axis([0 5 0 5])
    fsize=15;
    set(gca,'xtick',0:1:5,'FontSize',fsize)
    set(gca,'ytick',0:1:5,'FontSize',fsize)
    xlabel('x(t)','FontSize',fsize)
    ylabel('y(t)','FontSize',fsize)
    title('Hopf Bifurcation','FontSize',15);
    F(j) = getframe;
end
movie(F,5)
% End of Program.




