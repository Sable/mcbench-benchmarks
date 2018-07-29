function y = Fault_decision_b1m1_t1(u)
global st1

% Using model defined by the structure st1 to make decision about type1 fault in the pitch beta1m1

sker=st1.x2sup+(abs(u))'*abs(u)*ones(st1.Nlsup,1)-2*st1.xsup*abs(u);
y=(st1.w)'*exp(-sker./(2*(st1.sigma).^2))+st1.b;

if y>=0
    y=1;
else
    y=0;
end
end