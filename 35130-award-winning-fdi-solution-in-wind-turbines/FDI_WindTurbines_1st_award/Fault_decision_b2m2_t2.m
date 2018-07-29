function y =Fault_decision_b2m2_t2(u)
global st17

% Using model defined by the structure st17 to make decision about type2 fault in the pitch beta2m2

res=u(1);u=u(2:end);
if res>0.5
sker=st17.x2sup+(abs(u))'*abs(u)*ones(st17.Nlsup,1)-2*st17.xsup*abs(u);
y=(st17.w)'*exp(-sker./(2*(st17.sigma).^2))+st17.b;
else
    y=0;
end
if y>=0.5
    y=1;
else
    y=0;
end

end