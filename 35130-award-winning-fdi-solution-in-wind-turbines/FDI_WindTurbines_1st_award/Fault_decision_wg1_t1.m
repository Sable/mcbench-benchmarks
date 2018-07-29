function y = Fault_decision_wg1_t1(u)
global st9

% Using model defined by the structure st9 to make decision about type1 wg1 fault

sker=st9.x2sup+(abs(u))'*abs(u)*ones(st9.Nlsup,1)-2*st9.xsup*abs(u);
y=(st9.w)'*exp(-sker./(2*(st9.sigma).^2))+st9.b;
if y>=0
    y=1;
else
    y=0;
end
end