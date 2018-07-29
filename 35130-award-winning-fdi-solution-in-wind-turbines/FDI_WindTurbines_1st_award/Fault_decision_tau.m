function y = Fault_decision_tau(u)
global st13

% Using model defined by the structure st13 to make decision about fault in the couple tau

u(3)=1e-10*u(3).*(u(end).^6);u=u(1:3);
sker=st13.x2sup+(abs(u))'*abs(u)*ones(st13.Nlsup,1)-2*st13.xsup*abs(u);
y=(st13.w)'*exp(-sker./(2*(st13.sigma).^2))+st13.b;


if y>=0.8
    y=1;
else
    y=0;
end
end