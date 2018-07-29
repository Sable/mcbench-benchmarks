function y = Fault_decision_b2_t2(u)
 global st3
 
 % Using model defined by the structure st3 to make decision about type2 fault in the pitch beta2

sker=st3.x2sup+(abs(u))'*abs(u)*ones(st3.Nlsup,1)-2*st3.xsup*abs(u);
y=(st3.w)'*exp(-sker./(2*(st3.sigma).^2))+st3.b;

if y>=0.9
    y=1;
else
    y=0;
end
end
