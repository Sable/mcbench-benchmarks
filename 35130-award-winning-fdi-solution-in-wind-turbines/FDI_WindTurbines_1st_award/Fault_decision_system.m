function y = Fault_decision_system(u)
global st14

% Using model defined by the structure st14 to make decision about system fault

u(3)=1e-10*u(3).*(u(end).^6);u=u(1:3);
sker=st14.x2sup+(abs(u))'*abs(u)*ones(st14.Nlsup,1)-2*st14.xsup*abs(u);
y=(st14.w)'*exp(-sker./(2*(st14.sigma).^2))+st14.b;

if y>=0.8
    y=1;
else
    y=0;
end
end