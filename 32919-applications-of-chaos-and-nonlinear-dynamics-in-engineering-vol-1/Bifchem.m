% Bif_Chem - Autocatalytic Reaction.
% Bifurcation diagram using the second iterative method.
% Ensure that Chem.m is in the same directory as Bif_Chem.m.
% Copyright Springer 2013. Stephen Lynch.
clear
figure
global beta;
endt=1; % Time span between each iteration.
Max=300;step=0.01;interval=Max*step;a=0.99;
betaup=zeros(Max);betadown=zeros(Max);
start=1;final=4;
% Ramp the volumetric rate up.
for n=1:Max
    beta=start+step*n;
    [t,xa]=ode45('Chem',[0 endt],a);
    a=xa(size(xa,1));
    betaup(n)=xa(size(xa,1));
end
% Ramp the volumetric rate down.
for n=1:Max
    beta=final-step*n;
    [t,xa]=ode45('Chem',[0 endt],xa(size(xa,1)));
    a=xa(size(xa,1));
    betadown(n)=xa(size(xa,1));
end
hold on
rr=step+start:step:final;
plot(rr,betaup)
plot(final+start-rr,betadown)
hold off
fsize=15;
axis([start final 0 1])
set(gca,'xtick',1:1:4,'FontSize',fsize)
set(gca,'ytick',0:0.2:1,'FontSize',fsize)
xlabel('\beta','FontSize',fsize)
ylabel('\it x','FontSize',fsize)
% End of Program.