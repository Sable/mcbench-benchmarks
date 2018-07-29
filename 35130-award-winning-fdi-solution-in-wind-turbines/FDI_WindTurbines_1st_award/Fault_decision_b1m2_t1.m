function y = Fault_decision_b1m2_t1(u)
 global st2

% Using model defined by the structure st2 to make decision about type1 fault in the pitch beta1m2
 
sker=st2.x2sup+(abs(u))'*abs(u)*ones(st2.Nlsup,1)-2*st2.xsup*abs(u);
y=(st2.w)'*exp(-sker./(2*(st2.sigma).^2))+st2.b;

if y>=0
    y=1;
else
    y=0;
end
end