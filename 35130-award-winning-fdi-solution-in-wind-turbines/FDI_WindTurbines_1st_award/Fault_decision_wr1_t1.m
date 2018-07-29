function y = Fault_decision_wr1_t1(u)
global st5

% Using model defined by the structure st8 to make decision about type1 wr1 fault

sker=st5.x2sup+(abs(u))'*abs(u)*ones(st5.Nlsup,1)-2*st5.xsup*abs(u);
y=(st5.w)'*exp(-sker./(2*(st5.sigma).^2))+st5.b;

if y>=0
    y=1;
else
    y=0;
end
end