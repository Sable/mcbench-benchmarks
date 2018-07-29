function y = Fault_decision_wg2_t1(u)
global st10

% Using model defined by the structure st10 to make decision about type1 wg2 fault

sker=st10.x2sup+(abs(u))'*abs(u)*ones(st10.Nlsup,1)-2*st10.xsup*abs(u);
y=(st10.w)'*exp(-sker./(2*(st10.sigma).^2))+st10.b;
if y>=0
    y=1;
else
    y=0;
end
end