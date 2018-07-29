function y = Fault_decision_b2m1_t2(u)
 global st18
 
% Using model defined by the structure st18 to make decision about type2 fault in the pitch beta2m1

res=u(1);u=u(2:end);
if res>0.5
sker=st18.x2sup+(abs(u))'*abs(u)*ones(st18.Nlsup,1)-2*st18.xsup*abs(u);
y=(st18.w)'*exp(-sker./(2*(st18.sigma).^2))+st18.b;
else
    y=0;
end

if y>=0.5
    y=1;
else
    y=0;
end
end