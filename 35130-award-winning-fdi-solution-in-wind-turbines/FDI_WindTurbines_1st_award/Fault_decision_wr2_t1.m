function y = Fault_decision_wr2_t1(u)
global st6

% Using model defined by the structure st6 to make decision about type1 wr2 fault

sker=st6.x2sup+(abs(u))'*abs(u)*ones(st6.Nlsup,1)-2*st6.xsup*abs(u);
y=(st6.w)'*exp(-sker./(2*(st6.sigma).^2))+st6.b;

if y>=0
    y=1;
else
    y=0;
end
end