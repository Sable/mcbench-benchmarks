function y = Fault_decision_wr_t2(u)
global st16

% Using model defined by the structure st16 to make decision about type2 wr fault

sker=st16.x2sup+(abs(u))'*abs(u)*ones(st16.Nlsup,1)-2*st16.xsup*abs(u);
y=(st16.w)'*exp(-sker./(2*(st16.sigma).^2))+st16.b;

if y>=-0.3
    y=1;
else
    y=0;
end
end